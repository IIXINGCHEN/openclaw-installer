#!/bin/bash
set -e

# openclaw 一键卸载脚本
# 支持: Windows (Git Bash/WSL), macOS, Linux

# 默认配置
FORCE=false
DRY_RUN=false
REMOVE_CONFIG=false
REMOVE_CACHE=false
REMOVE_ALL=false

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_dry() { echo -e "${BLUE}[DRY-RUN]${NC} $1"; }

# 检测操作系统
detect_os() {
    case "$(uname -s)" in
        Linux*)     echo "linux";;
        Darwin*)    echo "macos";;
        CYGWIN*|MINGW*|MSYS*) echo "windows";;
        *)          echo "unknown";;
    esac
}

# 获取用户主目录
get_home_dir() {
    if [ -n "$HOME" ]; then
        echo "$HOME"
    elif [ -n "$USERPROFILE" ]; then
        echo "$USERPROFILE"
    else
        echo "$(eval echo ~)"
    fi
}

# 获取 npm 全局目录
get_npm_global_dir() {
    npm config get prefix 2>/dev/null || echo "/usr/local"
}

# 卸载 npm 包
uninstall_npm() {
    log_info "正在卸载 OpenClaw npm 包..."

    if $DRY_RUN; then
        log_dry "执行: npm uninstall -g openclaw"
        return 0
    fi

    if npm uninstall -g openclaw 2>/dev/null; then
        log_info "npm 包已卸载"
    else
        log_warn "npm 包卸载失败或未安装"
    fi
}

# 删除配置目录
remove_config_dir() {
    local home
    home=$(get_home_dir)
    local config_dir="${home}/.openclaw"

    if [ -d "$config_dir" ]; then
        log_info "删除配置目录: $config_dir"
        if $DRY_RUN; then
            log_dry "执行: rm -rf $config_dir"
        else
            rm -rf "$config_dir" && log_info "配置目录已删除" || log_error "删除失败"
        fi
    else
        log_info "配置目录不存在，跳过"
    fi
}

# 删除日志目录
remove_logs_dir() {
    local home
    home=$(get_home_dir)
    local logs_dir="${home}/.openclaw/logs"

    if [ -d "$logs_dir" ]; then
        log_info "删除日志目录: $logs_dir"
        if $DRY_RUN; then
            log_dry "执行: rm -rf $logs_dir"
        else
            rm -rf "$logs_dir" && log_info "日志目录已删除" || log_error "删除失败"
        fi
    fi
}

# 清理 npm cache
clean_npm_cache() {
    log_info "清理 npm cache..."

    if $DRY_RUN; then
        log_dry "执行: npm cache clean --force"
        return 0
    fi

    if npm cache clean --force 2>/dev/null; then
        log_info "npm cache 已清理"
    else
        log_warn "npm cache 清理失败"
    fi
}

# 确认卸载
confirm_uninstall() {
    if $FORCE; then
        return 0
    fi

    echo
    log_warn "即将卸载 OpenClaw"
    if $REMOVE_ALL; then
        log_warn "将执行完整卸载:"
        echo "  - 删除 npm 包"
        echo "  - 删除配置目录 (~/.openclaw)"
        echo "  - 删除日志目录"
        echo "  - 清理 npm cache"
    else
        log_info "将执行基本卸载:"
        echo "  - 删除 npm 包"
    fi
    echo

    read -p "确认卸载? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "卸载已取消"
        exit 0
    fi
}

# 显示帮助
show_help() {
    cat << EOF
OpenClaw 卸载脚本

用法: $(basename "$0") [选项]

选项:
    --all          执行完整卸载 (包括配置、缓存)
    --force        跳过确认直接卸载
    --dry-run      预览要删除的内容，不实际执行
    -h, --help     显示帮助信息

示例:
    $(basename "$0")              # 基本卸载
    $(basename "$0") --all        # 完整卸载
    $(basename "$0") --all --yes # 无需确认完整卸载
    $(basename "$0") --dry-run   # 预览卸载内容

EOF
}

# 解析参数
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --all)
                REMOVE_ALL=true
                REMOVE_CONFIG=true
                REMOVE_CACHE=true
                shift
                ;;
            --force)
                FORCE=true
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                log_error "未知参数: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

# 主函数
main() {
    parse_args "$@"

    log_info "OpenClaw 卸载脚本"
    log_info "操作系统: $(detect_os)"

    confirm_uninstall

    # 基本卸载 (始终执行)
    uninstall_npm

    # 完整卸载 (--all)
    if $REMOVE_ALL; then
        remove_config_dir
        remove_logs_dir
        clean_npm_cache
    fi

    echo
    if $DRY_RUN; then
        log_info "预览模式完成"
    else
        log_info "卸载完成!"
    fi
}

main "$@"
