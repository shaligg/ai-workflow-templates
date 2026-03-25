# AI 开发环境配置指南（macOS）

本文档说明如何在 macOS 上搭建 Claude Code + Codex 的协作环境。

---

## 一、推荐环境

- macOS
- Claude Code CLI
- Codex App 或 Codex CLI
- IDE（如 PyCharm / VS Code）

角色分工：

- Claude Code：规划、设计、评审
- Codex：代码实现
- IDE：本地检查与调试

---

## 二、安装 Claude Code

```bash
npm install -g @anthropic-ai/claude-code
claude --version
```

---

## 三、配置目录模式

Claude Code 有两种常见配置模式。

默认模式：

- 配置目录：`~/.claude`
- 规则目录：`~/.claude/rules/`

自定义封装模式（你当前使用 `claude-codex`，推荐）：

- 在封装脚本中导出 `CLAUDE_CONFIG_DIR`
- 例如：`CLAUDE_CONFIG_DIR=$HOME/claude-model/.claude-codex`
- 规则目录：`$CLAUDE_CONFIG_DIR/rules/`

重要说明：

- `GLOBAL_RULES.md`、`USER_PREFERENCES.md` 这类文件名不会被 Claude Code 自动读取。
- 规则应放到 `rules/*.md`。

---

## 四、封装脚本示例（`claude-codex`）

```bash
#!/usr/bin/env bash
CLAUDE_BIN="$HOME/claude-model/node_modules/.bin/claude"
export CLAUDE_CONFIG_DIR="$HOME/claude-model/.claude-codex"
exec "$CLAUDE_BIN" "$@"
```

安全建议：

- 不要在脚本中明文写 API Key
- 从 shell 环境变量读取密钥

---

## 五、全局规则目录结构

示例：

```text
$CLAUDE_CONFIG_DIR/
  rules/
    00-global.md
    01-user-preferences.md
```

推荐把规则源文件放在仓库中进行版本管理：

```text
ai-dev/global-rules/00-global.md
ai-dev/global-rules/01-user-preferences.md
```

`00-global.md` 推荐包含：

- 文档读取顺序（`.workflow/AGENTS.md`、`PRD`、`ARCHITECTURE`、Feature 文档）
- 工作流初始化策略（仅显式命令）
- 单次只实现一个任务

---

## 六、项目级规则

每个仓库建议包含：

```text
.workflow/AGENTS.md
.workflow/CLAUDE.md
.workflow/RULES.md
.workflow/.claude/rules/
.workflow/.ai/rules.md
.workflow/docs/PRD.md
.workflow/docs/ARCHITECTURE.md
.workflow/features/*/design.md
.workflow/features/*/tasks.md
```

`README.md` 给人看，AI 规则应写在 `.workflow/AGENTS.md` 和规则文件中。

---

## 七、工作流模板与初始化命令

准备模板目录：

```text
~/ai-dev/templates/workflows/l1
~/ai-dev/templates/workflows/l2
~/ai-dev/templates/workflows/l3
```

先安装一次 `wf-init` 命令：

```bash
cd ~/ai-dev
./scripts/install-wf-init.sh
```

如果 `~/.local/bin` 不在 PATH 中：

```bash
export PATH="$HOME/.local/bin:$PATH"
```

使用显式初始化命令：

```bash
wf-init l1 --confirm
wf-init l2 --confirm
wf-init l3 --confirm
```

安全语义：

- 初始化是可选动作
- 普通对话不自动初始化
- 不把 `1/2/3` 视为初始化命令
- 执行 `wf-init lX --confirm` 后会写入 `.workflow/.workflow-level=lX`，实现任务默认自动采用该级别

---

## 八、日常使用流程

1. `cd` 到目标仓库
2. 启动 `claude-codex`
3. 如需初始化，执行 `wf-init lX --confirm`
4. 实现任务时可选声明 `Workflow Selection: L1/L2/L3`（建议）
5. 增量执行与评审

---

## 九、配置验收

检查封装脚本：

```bash
which claude-codex
cat ~/claude-model/bin/claude-codex
```

检查规则目录：

```bash
ls -la ~/claude-model/.claude-codex/rules
```

检查初始化工具：

```bash
wf-init --help
```

---

## 十、常见问题

如果规则看起来没生效：

- 检查封装脚本里的 `CLAUDE_CONFIG_DIR`
- 确认规则文件在 `rules/*.md`
- 重启 `claude-codex`

如果初始化不生效：

- 必须使用显式命令并加 `--confirm`
- 确认模板目录存在：`~/ai-dev/templates/workflows/`
- 执行 `./scripts/install-wf-init.sh` 并确认 `wf-init` 已在 PATH 中
