# OpenClaw CLI

AI Development Tools - Command Line Interface

## Installation

### One-line Installation

```bash
# Linux/macOS
curl -sSL https://openclaw.ai/install | bash

# Windows (Git Bash or WSL)
bash <(curl -sSL https://openclaw.ai/install)
```

### Manual Installation

```bash
npm install -g openclaw
```

## Usage

```bash
openclaw --help
```

## Uninstallation

### CLI Command

```bash
# Basic uninstall
openclaw uninstall

# Full uninstall (includes config and cache)
openclaw uninstall --all --yes
```

### Shell Script

```bash
# Basic uninstall
./scripts/uninstall.sh

# Full uninstall
./scripts/uninstall.sh --all --force

# Dry-run mode
./scripts/uninstall.sh --all --dry-run
```

## Supported Platforms

- Linux
- macOS
- Windows (Git Bash / WSL)
