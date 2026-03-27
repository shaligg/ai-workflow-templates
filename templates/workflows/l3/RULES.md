# Workflow Rules (L3)

Workflow mode: L3 System Design.

## Scope

- This file defines L3-specific deltas.
- Global rules remain source of truth for:
  - workflow init and selection
  - rule priority and doc read order
  - default one-task mode and explicit complete-all override

## Required Artifacts Before Coding

1. `.workflow/docs/PRD.md` updated
2. `.workflow/docs/ARCHITECTURE.md` updated
3. `.workflow/features/*/design.md` created
4. `.workflow/features/*/tasks.md` created

## L3-Specific Execution Rules

- Confirm large-scope objective first.
- Keep task status in sync with completed work.

## Repository Layout

- Use current repository layout as source of truth.
- Do not force `src/`.
- Use actual file paths from current repository.

## Quality and Risk

- Ensure architecture and PRD are consistent before implementation.
- Track migration and rollback risks in design/tasks where needed.
