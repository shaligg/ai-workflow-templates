# Workflow Rules (L2 Default)

L2 is the default workflow for normal feature work.

## Workflow Selection

- Workflow selection is optional.
- For implementation tasks, selecting and stating workflow level is recommended.
- Available levels:
  - L1 Quick Task: bug fixes and small changes.
  - L2 Feature Task (default): new feature, API, or module.
  - L3 System Design: architecture-impacting or large subsystem changes.

## Initialization Policy

- Workflow initialization is optional.
- Initialize only on explicit command:
  - `wf-init l1 --confirm`
  - `wf-init l2 --confirm`
  - `wf-init l3 --confirm`
- Do not treat ambiguous inputs like `1/2/3/l1/l2/l3` alone as init commands.

## Rule Priority

1. Global rules (tool-level)
2. User preferences (tool-level)
3. Project rules
4. Feature requirements (`.workflow/features/*/requirements.md`)
5. Feature design (`.workflow/features/*/design.md`)
6. Feature tasks (`.workflow/features/*/tasks.md`)

## Documentation Order

1. `.workflow/AGENTS.md`
2. `.workflow/RULES.md` (this file)
3. `.workflow/docs/PRD.md`
4. `.workflow/docs/ARCHITECTURE.md`
5. `.workflow/features/*/requirements.md` (if present)
6. `.workflow/features/*/design.md`
7. `.workflow/features/*/tasks.md`

## Execution Rules

- If `.workflow/features/*/requirements.md` contains `Raw Input`,
  extract and rewrite it into structured sections before writing
  `design.md` and `tasks.md`.
- During extraction, do not invent requirements not present in the raw input or project docs.
- Task sizing target: each task modifies <= 4 files.
- Task sizing target: each task <= 400 lines of code.
- If a task exceeds target, split first; if cannot split, add a one-line reason in `tasks.md`.
- Default: implement only the next unfinished task.
- Default: implement one task per run, then stop.
- Override (explicit user request only): if user explicitly asks to
  complete all unfinished tasks, implement tasks sequentially in order
  until all tasks are done or blocked.
- Update task checkbox after finishing one task.
- In override mode, update task checkboxes continuously and stop immediately on blocker or test failure.
- Do not invent requirements not documented in project PRD, architecture, feature requirements, or feature design.

## Repository Layout

- Use current repository layout as source of truth.
- Do not force `src/` if project uses other directories.
- Use real file paths from current repository.

## Quality

- Follow project architecture.
- Keep changes small, simple, and readable.
- Add tests when task requires tests or behavior changes.
