# AI Dev Toolkit

[中文说明](README.zh-CN.md)

This repository contains:

- `templates/`: workflow templates
- `methodology/`: setup and best-practice docs (EN + ZH)
- `global-rules/`: versioned global Claude rules
- `scripts/`: helper scripts

Script index:

- `scripts/README.md`

## Documentation

- Standard (workflow principles): `methodology/standards.md`
- SOP (daily execution): `methodology/sop.md`
- Setup (macOS environment): `methodology/setup-macos.md`
- Chinese docs: `methodology/standards-zh.md`, `methodology/sop-zh.md`, `methodology/setup-macos-zh.md`

## Canonical Template Paths

Use these paths as source of truth:

- `templates/workflows/l1/`
- `templates/workflows/l2/`
- `templates/workflows/l3/`

## Workflow Rule Source of Truth

For each workflow template (`l1/l2/l3`):

- `RULES.md` is the single source of truth for workflow rules.
- `AGENTS.md`, `CLAUDE.md`, `.ai/rules.md`, and `.claude/rules/10-project-workflow.md` are adapter files that point to `RULES.md`.

Consistency check:

```bash
bash ./scripts/check-rule-adapters.sh
```

## Methodology Docs

- `methodology/standards.md` (canonical)
- `methodology/standards-zh.md` (canonical)
- `methodology/sop.md` (canonical)
- `methodology/sop-zh.md` (canonical)
- `methodology/setup-macos.md` (canonical)
- `methodology/setup-macos-zh.md` (canonical)
- `methodology/metrics-template.md`

## Sync Global Rules on New Machine

Default target (`~/.claude/rules`):

```bash
./scripts/install-global-rules.sh
```

Custom target (for wrapper mode):

```bash
CLAUDE_CONFIG_DIR="$HOME/claude-model/.claude-codex" ./scripts/install-global-rules.sh
```

## Install `wf-init` Command

Install once (default target: `~/.local/bin/wf-init`):

```bash
./scripts/install-wf-init.sh
```

Install to custom bin directory:

```bash
./scripts/install-wf-init.sh "$HOME/bin"
```

## Install `claude-codex` Wrapper

```bash
bash ./scripts/install-claude-codex.sh
```

Do not use `sh` to run this script.
