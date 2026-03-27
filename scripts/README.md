# Scripts Index

This file is the centralized index for scripts under `scripts/`.

## Usage Summary

| Script | Purpose | When to Use | Recommended |
|---|---|---|---|
| `preflight.sh` | Run local quality checks aligned with CI (`rule adapters`, `shell`, `markdown`, `gitleaks`). | Before commit/push to avoid CI red checks. | Yes |
| `check-rule-adapters.sh` | Verify `templates/workflows/l1~l3` rule adapter files still point to `RULES.md` and required files exist. | Before commit/PR, or in CI. | Yes |
| `install-global-rules.sh` | Sync repository `global-rules/*.md` into Claude rules directory, with timestamp backup of existing target files. | New machine setup or after rule updates. | Yes |
| `install-claude-codex.sh` | Bootstrap Claude Code install and generate `~/claude-model/bin/claude-codex` wrapper. | First-time setup only. | Conditional: only if you do not already manage `claude-codex` wrapper manually. |
| `install-wf-init.sh` | Install repo-local `wf-init.sh` as a `wf-init` command under custom bin dir (default `~/.local/bin`). | Only when you choose to use the repo-local wf-init implementation. | Usually No on this machine (you already have `~/claude-model/bin/wf-init`). |
| `wf-init.sh` | Repo-local workflow initializer: copy `templates/workflows/<level>` into target dir (default `$PWD/.workflow`) and write workflow marker. | Direct use (`bash scripts/wf-init.sh l2 --confirm`) or via `install-wf-init.sh`. | Usually No on this machine; prefer `wf-init` from `~/claude-model/bin/wf-init`. |

## Current Machine Recommendation

On this machine, prefer the already-installed command:

```bash
/Users/bigfish/claude-model/bin/wf-init
```

or simply:

```bash
wf-init
```

because `/Users/bigfish/claude-model/bin` is already in `PATH`.

## Quick Preflight

Run all local checks:

```bash
bash scripts/preflight.sh
```

Skip selected checks if needed:

```bash
bash scripts/preflight.sh --skip-gitleaks
```
