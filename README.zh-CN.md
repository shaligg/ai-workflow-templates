# AI 开发工具包

[English](README.md)

本仓库包含：

- `templates/`：工作流模板
- `methodology/`：环境配置与操作指南（中英双语）
- `global-rules/`：可版本化的全局 Claude 规则
- `scripts/`：辅助脚本

脚本总览：

- `scripts/README.md`

## 文档导航

- Standard（工作流原则）: `methodology/standards.md`
- SOP（日常执行）: `methodology/sop.md`
- Setup（macOS 环境）: `methodology/setup-macos.md`
- 中文文档：`methodology/standards-zh.md`、`methodology/sop-zh.md`、`methodology/setup-macos-zh.md`

## 模板主路径

以下路径是模板真源：

- `templates/workflows/l1/`
- `templates/workflows/l2/`
- `templates/workflows/l3/`

## 工作流规则单一真源

对于每个工作流模板（`l1/l2/l3`）：

- `RULES.md` 是工作流规则的单一真源。
- `AGENTS.md`、`CLAUDE.md`、`.ai/rules.md`、`.claude/rules/10-project-workflow.md` 为指向 `RULES.md` 的适配文件。

一致性检查：

```bash
bash ./scripts/check-rule-adapters.sh
```

## 文档列表

- `methodology/standards.md`
- `methodology/standards-zh.md`
- `methodology/sop.md`
- `methodology/sop-zh.md`
- `methodology/setup-macos.md`
- `methodology/setup-macos-zh.md`
- `methodology/metrics-template.md`

## 新电脑同步全局规则

默认目标（`~/.claude/rules`）：

```bash
./scripts/install-global-rules.sh
```

自定义目标（封装模式）：

```bash
CLAUDE_CONFIG_DIR="$HOME/claude-model/.claude-codex" ./scripts/install-global-rules.sh
```

## 安装 `wf-init` 命令

首次安装（默认安装到 `~/.local/bin/wf-init`）：

```bash
./scripts/install-wf-init.sh
```

安装到自定义目录：

```bash
./scripts/install-wf-init.sh "$HOME/bin"
```

## 安装 `claude-codex` 封装命令

```bash
bash ./scripts/install-claude-codex.sh
```

不要用 `sh` 执行该脚本。
