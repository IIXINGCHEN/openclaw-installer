#!/bin/bash
set -e

# openclaw 一键安装脚本
# 支持: Windows (Git Bash/WSL), macOS, Linux

OPENCLAW_VERSION="${OPENCLAW_VERSION:-latest}"
INSTALL_DIR="${HOME}/.openclaw"
NPM_REGISTRY="${NPM_REGISTRY:-https://registry.npmjs.org}"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 检测操作系统
detect_os() {
    case "$(uname -s)" in
        Linux*)     echo "linux";;
        Darwin*)    echo "macos";;
        CYGWIN*|MINGW*|MSYS*) echo "windows";;
        *)          echo "unknown";;
    esac
}

# 检测是否已安装
check_installed() {
    if command -v openclaw &> /dev/null; then
        local version
        version=$(openclaw --version 2>/dev/null || echo "unknown")
        log_warn "OpenClaw 已安装 (版本: $version)"
        read -p "是否继续安装? [y/N] " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "安装已取消"
            exit 0
        fi
    fi
}

# 检测 Node.js
check_nodejs() {
    if ! command -v node &> /dev/null; then
        log_error "Node.js 未安装，请先安装 Node.js: https://nodejs.org"
        exit 1
    fi
    log_info "Node.js 已安装: $(node --version)"
}

# 安装 OpenClaw
install_openclaw() {
    log_info "正在安装 OpenClaw..."

    if npm install -g openclaw --registry="$NPM_REGISTRY"; then
        log_info "OpenClaw 安装成功!"
    else
        log_error "安装失败，请检查网络连接"
        exit 1
    fi
}

# 验证安装
verify_install() {
    if command -v openclaw &> /dev/null; then
        log_info "安装验证: $(openclaw --version 2>/dev/null || 'unknown version')"
    else
        log_error "安装验证失败"
        exit 1
    fi
}

# 主函数
main() {
    log_info "OpenClaw 安装脚本"
    log_info "操作系统: $(detect_os)"

    check_installed
    check_nodejs

    local os
    os=$(detect_os)
    if [ "$os" = "unknown" ]; then
        log_error "不支持的操作系统"
        exit 1
    fi

    install_openclaw
    verify_install

    log_info "安装完成! 运行 'openclaw --help' 开始使用"
}

main "$@"
