# AI Engineering Standard

## 1. Overview

This guide defines a practical AI-native workflow for Claude Code and Codex.

Goals:

- keep changes incremental
- reduce requirement hallucination
- make execution predictable
- keep review and rollback simple

Collaboration model:

- Claude Code: design and review
- Codex: implementation
- Claude Code: final review

---

## 2. Workflow Levels

Use one of three workflow levels per task.

| Level | Use Case | Design Required | Tasks Required |
|---|---|---|---|
| L1 Quick Task | bug fix, small patch, parameter change | No | No |
| L2 Feature Task (default) | new API, new feature, new module | Yes | Yes |
| L3 System Design | large subsystem, architecture refactor, new service | Yes (detailed) | Yes (detailed) |

Recommended selection rules:

- if change is a small localized patch, use L1
- if change is a normal feature, use L2
- if change affects architecture or many modules, use L3

Optional sizing heuristic:

- likely < 1 file: L1
- likely < 500 LOC net change: L2
- likely > 500 LOC or cross-domain impact: L3

---

## 3. Start-of-Task Guidance

Workflow selection is optional.

For actual implementation requests, selecting and stating workflow first is recommended.

Example:

```text
Workflow Selection: L2
Reason: add new export feature with API + service updates
```

For normal chat or exploratory discussion, workflow selection is not required.

---

## 4. L1 Quick Task

Use for:

- bug fixes
- tiny behavior changes
- logging or small parameter updates

Flow:

Request -> Codex implement -> Claude review

L1 deliverables:

- minimal code change
- tests when behavior changes
- short risk and verification summary

No `design.md` or `tasks.md` required by default.

---

## 5. L2 Feature Task (Default)

Use for:

- new feature
- new endpoint
- new module

Flow:

Feature request -> requirements.md -> design.md -> tasks.md -> implement one task at a time -> review

L2 rules:

- target: each task modifies <= 4 files
- target: each task <= 400 lines of code
- if a task exceeds target, split first; if cannot split, add a one-line reason in tasks.md
- default: implement only next unfinished task
- default: mark one task done and stop
- override (explicit user request): complete all unfinished tasks sequentially until done or blocked

---

## 6. L3 System Design

Use for:

- large scope with architecture impact
- service split or major refactor

Flow:

PRD update -> architecture update -> detailed design -> detailed tasks -> incremental implementation -> review

L3 rules:

- define migration and rollback strategy
- include risk tracking
- default: implement one task per run
- override (explicit user request): complete all unfinished tasks sequentially until done or blocked

---

## 7. Workflow Switch Mid-Task

Switch workflow explicitly when scope changes.

Example:

```text
Workflow Switch: from L2 to L1
Reason: reduced to one bugfix
Effective now. Re-plan from current state.
```

Switch procedure:

1. stop current implementation
2. state impact of switch
3. add or remove required artifacts for new level
4. continue execution

---

## 8. Follow-up Changes Based on Old Tasks

For changes based on an already completed feature, do not overwrite old feature docs.

Recommended approach:

- create a new feature folder (for example `.workflow/features/004-payment-adjustment`)
- reference prior feature in new design
- generate new tasks for the delta only

Always keep old `tasks.md` as immutable history.

---

## 9. Repository Structure

Recommended structure:

```text
repo/
  .workflow/
    AGENTS.md
    CLAUDE.md
    RULES.md
    .claude/rules/
    .ai/rules.md
    docs/
      PRD.md
      ARCHITECTURE.md
    features/
      001-xxx/
        requirements.md
        design.md
        tasks.md
  src/
  tests/
```

Directory layout rule:

- treat the current repository layout as source of truth
- do not force `src/` when project uses other paths (for example `faab/` or `app/`)
- all task file paths must match real paths in current repository

---

## 10. Rule Hierarchy

Effective priority:

1. global rules (tool-level)
2. user preferences (tool-level)
3. project rules (`.workflow/RULES.md`, `.workflow/AGENTS.md`, `.workflow/CLAUDE.md`, `.workflow/.claude/rules/*`, `.workflow/.ai/rules.md`)
4. feature requirements (`.workflow/features/*/requirements.md`)
5. feature design (`.workflow/features/*/design.md`)
6. feature tasks (`.workflow/features/*/tasks.md`)

Read order inside project:

1. `.workflow/AGENTS.md`
2. `.workflow/RULES.md` (if present)
3. `.workflow/docs/PRD.md`
4. `.workflow/docs/ARCHITECTURE.md`
5. `.workflow/features/*/requirements.md`
6. `.workflow/features/*/design.md`
7. `.workflow/features/*/tasks.md`

---

## 11. Safe Workflow Initialization

Workflow initialization is optional.

Only initialize when explicitly requested by user command:

- `wf-init l1 --confirm`
- `wf-init l2 --confirm`
- `wf-init l3 --confirm`

Safety rules:

- do not map ambiguous input (`1`, `2`, `3`, `l1`) to init
- do not auto-init during normal conversation
- keep initialization non-destructive (do not overwrite existing files)

Auto-selection after init:

- `wf-init lX --confirm` writes `.workflow/.workflow-level` with `lX`
- for implementation tasks, use `.workflow/.workflow-level` as default workflow automatically
- no second workflow input is required unless user wants to override

---

## 12. Prompt Templates

L1 prompt:

```text
Workflow Selection: L1
Task: <small fix>
Constraints: minimal changes, no refactor
```

L2 prompt:

```text
Workflow Selection: L2
Feature: <name>
Step 1: put raw requirement text into .workflow/features/<id>/requirements.md (Raw Input)
Step 2: extract structured .workflow/features/<id>/requirements.md
Step 3: generate .workflow/features/<id>/design.md
Step 4: generate .workflow/features/<id>/tasks.md
Step 5: implement next unfinished task only
```

L3 prompt:

```text
Workflow Selection: L3
Goal: <system-level objective>
Update PRD and architecture first, then generate detailed design/tasks.
Implement one task and stop.
```

---

## 13. Definition of Done

L1 done when:

- requested fix implemented
- validation completed
- risk summary provided

L2 done when:

- requirements, design and tasks exist
- all tasks complete
- tests and review pass

L3 done when:

- PRD and architecture updated
- detailed tasks complete
- migration risk addressed
- review passes
