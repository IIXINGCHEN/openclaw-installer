#!/usr/bin/env node

const { Command } = require('commander');
const uninstall = require('../src/commands/uninstall');

const program = new Command();

program
  .name('openclaw')
  .description('OpenClaw CLI - AI Development Tools')
  .version('1.0.0');

program
  .command('uninstall')
  .description('卸载 OpenClaw')
  .option('-a, --all', '完整卸载 (包括配置和缓存)')
  .option('-y, --yes', '跳过确认直接卸载')
  .option('--dry-run', '预览要删除的内容')
  .option('--force', '强制执行，忽略错误')
  .action(uninstall);

program.parse(process.argv);
