# AI Dev Quick Reference (One Page)

Use this page for daily execution.

## 0. One-Time Setup (`wf-init`)

```bash
cd ~/ai-dev
./scripts/install-wf-init.sh
```

If needed, add `~/.local/bin` to PATH first.

## 1. Start Session

```bash
cd <target-repo>
claude-codex
```

Notes:

- Normal chat does not require workflow selection.
- For implementation tasks, selecting workflow first is recommended.

## 2. Optional Workflow Init

Initialize only when current directory is not prepared.

```bash
wf-init l1 --confirm
wf-init l2 --confirm
wf-init l3 --confirm
```

Safety:

- `wf-init` is optional.
- `1/2/3` must not trigger init.
- Never run init without `--confirm`.
- After init, `.workflow/.workflow-level` becomes the default workflow automatically.
- You do not need to input workflow level again unless overriding.

## 3. Choose Workflow

- `L1`: bug fix, tiny patch, parameter/logging change.
- `L2` (default): normal feature, API, module.
- `L3`: architecture-impacting or large subsystem work.

Use this first message for implementation:

```text
Workflow Selection: L2
Reason: add new feature with API + service changes
```

## 4. Execution Pattern

Layout rule (all levels):

- Use current project layout as-is.
- Do not force `src/`.
- Write task file paths using real repository paths.

### L1

1. Clarify task scope.
2. Implement minimal change.
3. Add tests if behavior changed.
4. Summarize risk and verification.

### L2

1. Paste raw requirement text into `.workflow/features/<id>/requirements.md` (`Raw Input`).
2. Extract and normalize `.workflow/features/<id>/requirements.md`.
3. Generate `.workflow/features/<id>/design.md`.
4. Generate `.workflow/features/<id>/tasks.md`.
5. Default: implement next unfinished task only.
6. Default: mark one task done and stop.
7. If user explicitly requests "complete all tasks", execute tasks sequentially until done or blocked.
8. Review.

### L3

1. Update `.workflow/docs/PRD.md`.
2. Update `.workflow/docs/ARCHITECTURE.md`.
3. Create detailed design/tasks.
4. Default: implement one task and stop.
5. If user explicitly requests "complete all tasks", execute tasks sequentially until done or blocked.
6. Track migration/rollback risk.

## 5. Workflow Switch Mid-Task

When scope changes:

```text
Workflow Switch: from L2 to L1
Reason: reduced to one bugfix
Effective now. Re-plan from current state.
```

Then:

1. Stop current implementation.
2. State impact.
3. Add/remove required artifacts.
4. Continue under new level.

## 6. Follow-up Change on Old Feature

Do not overwrite old completed feature docs.

Recommended:

1. Create a new feature folder (for example `.workflow/features/004-...`).
2. Reference prior feature in new design.
3. Create delta tasks only.

## 7. Done Checklist

### L1 done

- fix implemented
- validation done
- risk summary provided

### L2 done

- `requirements.md`, `design.md` and `tasks.md` exist
- all tasks checked
- tests/review passed

### L3 done

- PRD + architecture updated
- detailed tasks completed
- migration risk addressed

## 8. Fast Troubleshooting

- Rules not applied: check `$CLAUDE_CONFIG_DIR/rules/*.md`.
- Wrong directory: ensure `.workflow/AGENTS.md` exists in current repo.
- Init failed: use explicit `wf-init lX --confirm`.
