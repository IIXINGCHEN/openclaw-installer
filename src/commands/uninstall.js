const { execSync } = require('child_process');
const path = require('path');
const os = require('os');

/**
 * 获取平台信息
 */
function getPlatform() {
  const platform = os.platform();
  if (platform === 'win32') return 'windows';
  if (platform === 'darwin') return 'macos';
  return 'linux';
}

/**
 * 获取用户主目录
 */
function getHomeDir() {
  return os.homedir();
}

/**
 * 日志输出
 */
function log(level, message) {
  const colors = {
    info: '\x1b[32m',
    warn: '\x1b[33m',
    error: '\x1b[31m',
    reset: '\x1b[0m'
  };
  console.log(`${colors[level]}[${level.toUpperCase()}]${colors.reset} ${message}`);
}

/**
 * 执行命令
 */
function exec(command, options = {}) {
  try {
    if (options.dryRun) {
      log('info', `[DRY-RUN] ${command}`);
      return true;
    }
    execSync(command, { stdio: 'inherit', ...options });
    return true;
  } catch (error) {
    if (!options.force) {
      log('error', `执行失败: ${command}`);
      return false;
    }
    log('warn', `执行失败 (已忽略): ${command}`);
    return true;
  }
}

/**
 * 卸载 npm 包
 */
function uninstallNpmPackage(options) {
  log('info', '正在卸载 OpenClaw npm 包...');
  return exec('npm uninstall -g openclaw', options);
}

/**
 * 删除配置目录
 */
function removeConfigDir(options) {
  const homeDir = getHomeDir();
  const configDir = path.join(homeDir, '.openclaw');

  const fs = require('fs');
  if (fs.existsSync(configDir)) {
    log('info', `删除配置目录: ${configDir}`);
    if (!options.dryRun) {
      try {
        fs.rmSync(configDir, { recursive: true, force: true });
        log('info', '配置目录已删除');
      } catch (error) {
        log('error', `删除配置目录失败: ${error.message}`);
        return false;
      }
    }
  } else {
    log('info', '配置目录不存在，跳过');
  }
  return true;
}

/**
 * 清理 npm cache
 */
function cleanNpmCache(options) {
  log('info', '清理 npm cache...');
  return exec('npm cache clean --force', options);
}

/**
 * 主卸载函数
 */
function uninstall(options) {
  const platform = getPlatform();
  console.log(`OpenClaw 卸载 (平台: ${platform})`);
  console.log('');

  // 显示卸载内容
  if (options.dryRun) {
    log('info', '=== 预览模式 ===');
  }

  if (options.all) {
    console.log('将执行完整卸载:');
    console.log('  - 删除 npm 包');
    console.log('  - 删除配置目录 (~/.openclaw)');
    console.log('  - 清理 npm cache');
  } else {
    console.log('将执行基本卸载:');
    console.log('  - 删除 npm 包');
  }
  console.log('');

  // 确认卸载
  if (!options.yes && !options.force && !options.dryRun) {
    const readline = require('readline');
    const rl = readline.createInterface({
      input: process.stdin,
      output: process.stdout
    });

    rl.question('确认卸载? [y/N] ', (answer) => {
      rl.close();
      if (!answer.toLowerCase().startsWith('y')) {
        log('info', '卸载已取消');
        process.exit(0);
      }
      doUninstall(options);
    });
  } else {
    doUninstall(options);
  }
}

function doUninstall(options) {
  // 1. 卸载 npm 包
  uninstallNpmPackage(options);

  // 2. 完整卸载
  if (options.all) {
    removeConfigDir(options);
    cleanNpmCache(options);
  }

  console.log('');
  if (options.dryRun) {
    log('info', '预览模式完成');
  } else {
    log('info', '卸载完成!');
  }
}

module.exports = uninstall;
