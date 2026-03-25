# Workflow Rules (L3)

Workflow mode: L3 System Design.

## Required Artifacts Before Coding

1. `.workflow/docs/PRD.md` updated
2. `.workflow/docs/ARCHITECTURE.md` updated
3. `.workflow/features/*/design.md` created
4. `.workflow/features/*/tasks.md` created

## Execution Rules

- Confirm large-scope objective first.
- Default: implement only the next unfinished task.
- Default: implement one task per run, then stop.
- Override (explicit user request only): if user explicitly asks to complete all unfinished tasks, implement tasks sequentially in order until all tasks are done or blocked.
- Update task status after task completion.
- In override mode, update task status continuously and stop immediately on blocker or test failure.

## Repository Layout

- Use current repository layout as source of truth.
- Do not force `src/`.
- Use actual file paths from current repository.

## Quality and Risk

- Ensure architecture and PRD are consistent before implementation.
- Track migration and rollback risks in design/tasks where needed.
