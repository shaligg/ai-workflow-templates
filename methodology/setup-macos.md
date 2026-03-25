# AI Development Setup (macOS)

This guide describes a practical setup for Claude Code + Codex workflows on macOS.

---

## 1. Recommended Environment

- macOS
- Claude Code CLI
- Codex App or Codex CLI
- IDE (for example PyCharm or VS Code)

Role split:

- Claude Code: planning, design, review
- Codex: implementation
- IDE: local inspection and debugging

---

## 2. Install Claude Code

```bash
npm install -g @anthropic-ai/claude-code
claude --version
```

---

## 3. Config Directory Modes

Claude Code can use two config modes.

Default mode:

- config dir: `~/.claude`
- rules dir: `~/.claude/rules/`

Custom wrapper mode (recommended if you use `claude-codex`):

- wrapper exports `CLAUDE_CONFIG_DIR`
- example: `CLAUDE_CONFIG_DIR=$HOME/claude-model/.claude-codex`
- rules dir: `$CLAUDE_CONFIG_DIR/rules/`

Important:

- `GLOBAL_RULES.md` and `USER_PREFERENCES.md` filenames are not auto-loaded by Claude Code.
- Put rule files in `rules/*.md`.

---

## 4. Example Wrapper (`claude-codex`)

```bash
#!/usr/bin/env bash
CLAUDE_BIN="$HOME/claude-model/node_modules/.bin/claude"
export CLAUDE_CONFIG_DIR="$HOME/claude-model/.claude-codex"
exec "$CLAUDE_BIN" "$@"
```

Security recommendation:

- do not hardcode API keys in wrapper scripts
- load keys from shell environment

---

## 5. Global Rules Layout

Example files:

```text
$CLAUDE_CONFIG_DIR/
  rules/
    00-global.md
    01-user-preferences.md
```

Repository-managed source (recommended):

```text
ai-dev/global-rules/00-global.md
ai-dev/global-rules/01-user-preferences.md
```

Recommended content in `00-global.md`:

- read order (`.workflow/AGENTS.md`, `PRD`, `ARCHITECTURE`, feature design/tasks)
- workflow init policy (explicit commands only)
- one-task-at-a-time rule

---

## 6. Project-Level Rules

In each repository, include:

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

`README.md` is for humans; AI rules belong in `.workflow/AGENTS.md` and rule files.

---

## 7. Workflow Templates and Init Command

Prepare workflow templates under:

```text
~/ai-dev/templates/workflows/l1
~/ai-dev/templates/workflows/l2
~/ai-dev/templates/workflows/l3
```

Install `wf-init` command once:

```bash
cd ~/ai-dev
./scripts/install-wf-init.sh
```

If `~/.local/bin` is not in PATH:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Use explicit init command:

```bash
wf-init l1 --confirm
wf-init l2 --confirm
wf-init l3 --confirm
```

Safety semantics:

- workflow init is optional
- never auto-init during normal chat
- do not treat `1/2/3` as init commands
- after `wf-init lX --confirm`, `.workflow/.workflow-level` is set
  to `lX` and used as default workflow automatically for
  implementation tasks

---

## 8. Daily Run Pattern

1. `cd` into target repo
2. run `claude-codex`
3. if needed, run `wf-init lX --confirm`
4. for implementation tasks, optionally add `Workflow Selection: L1/L2/L3` (recommended)
5. execute and review incrementally

---

## 9. Verify Your Setup

Check wrapper:

```bash
which claude-codex
cat ~/claude-model/bin/claude-codex
```

Check rule path:

```bash
ls -la ~/claude-model/.claude-codex/rules
```

Check init tool:

```bash
wf-init --help
```

---

## 10. Troubleshooting

If rules seem ignored:

- confirm `CLAUDE_CONFIG_DIR` value in wrapper
- confirm files are in `rules/*.md`
- restart `claude-codex`

If workflow init does nothing:

- use explicit form with `--confirm`
- confirm source templates exist in `~/ai-dev/templates/workflows/`
- run `./scripts/install-wf-init.sh` and ensure `wf-init` is in PATH
