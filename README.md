# OpenClaw Installer

OpenClaw 一键安装和卸载工具，支持 Windows、macOS、Linux 全平台。

## 功能特性

- 一键安装脚本，自动检测系统环境
- 完整卸载支持，可选择清理配置和缓存
- 跨平台兼容：Windows (Git Bash/WSL)、macOS、Linux
- CLI 内置卸载命令：`openclaw uninstall`
- 预览模式：支持 `--dry-run` 预览操作

## 系统要求

- Node.js >= 18.0.0
- npm >= 8.0.0

## 安装

### 方式一：一键安装（推荐）

```bash
# Linux/macOS
curl -sSL https://openclaw.ai/install | bash

# Windows (Git Bash 或 WSL)
bash <(curl -sSL https://openclaw.ai/install)
```

### 方式二：本地脚本安装

```bash
# 克隆仓库
git clone https://github.com/IIXINGCHEN/openclaw-installer.git
cd openclaw-installer

# 运行安装脚本
bash scripts/install.sh
```

### 方式三：npm 全局安装

```bash
npm install -g openclaw
```

## 使用

### 基本命令

```bash
# 查看帮助
openclaw --help

# 查看版本
openclaw --version
```

## 卸载

### 方式一：CLI 命令卸载（推荐）

```bash
# 基本卸载（仅删除 npm 包）
openclaw uninstall

# 完整卸载（删除 npm 包 + 配置 + 缓存）
openclaw uninstall --all --yes
```

### 方式二：脚本卸载

```bash
# 基本卸载
bash scripts/uninstall.sh

# 完整卸载（跳过确认）
bash scripts/uninstall.sh --all --force

# 预览模式（查看将执行的操作，不实际执行）
bash scripts/uninstall.sh --all --dry-run
```

### 卸载选项说明

| 选项 | 说明 |
|------|------|
| `--all` | 完整卸载，包括配置目录和 npm 缓存 |
| `--yes` / `--force` | 跳过确认提示，直接执行 |
| `--dry-run` | 预览模式，显示将要执行的操作 |
| `--help` | 显示帮助信息 |

### 完整卸载清理内容

执行 `--all` 时会清理以下内容：

1. npm 全局包：`openclaw`
2. 配置目录：`~/.openclaw`
3. 日志目录：`~/.openclaw/logs`
4. npm 缓存

## 各平台配置路径

| 平台 | 配置目录 | npm 全局目录 |
|------|---------|-------------|
| Linux | `~/.openclaw` | `/usr/lib/node_modules` |
| macOS | `~/.openclaw` | `/usr/local/lib/node_modules` |
| Windows | `%USERPROFILE%\.openclaw` | `%APPDATA%\npm\node_modules` |

## 开发

```bash
# 安装依赖
npm install

# 本地测试
npm link
openclaw --help
openclaw uninstall --help

# 链接后测试卸载
openclaw uninstall --all --yes
```

## 目录结构

```
openclaw-installer/
├── package.json           # 项目配置
├── README.md              # 说明文档
├── bin/
│   └── openclaw.js        # CLI 入口
├── src/
│   └── commands/
│       └── uninstall.js  # 卸载命令实现
└── scripts/
    ├── install.sh        # 安装脚本
    └── uninstall.sh     # 卸载脚本
```

## 许可证

MIT License
