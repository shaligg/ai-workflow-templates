# Workflow Rules (L2 Default)

L2 is the default workflow for normal feature work.

## Scope

- This file defines L2-specific deltas.
- Global rules remain source of truth for:
  - workflow init and selection
  - rule priority and doc read order
  - default one-task mode and explicit complete-all override

## L2-Specific Execution Rules

- If `.workflow/features/*/requirements.md` contains `Raw Input`,
  extract and rewrite it into structured sections before writing
  `design.md` and `tasks.md`.
- During extraction, do not invent requirements not present in the raw input or project docs.
- Task sizing target: each task modifies <= 4 files.
- Task sizing target: each task <= 400 lines of code.
- If a task exceeds target, split first; if cannot split, add a one-line reason in `tasks.md`.
- Keep task checkboxes in sync with completed work.
- Do not invent requirements not documented in project PRD, architecture, feature requirements, or feature design.

## Repository Layout

- Use current repository layout as source of truth.
- Do not force `src/` if project uses other directories.
- Use real file paths from current repository.

## Quality

- Follow project architecture.
- Keep changes small, simple, and readable.
- Add tests when task requires tests or behavior changes.
