# Workflow Rules (L3)

Workflow mode: L3 System Design.

## Scope

- This file defines L3-specific deltas.
- Global rules remain source of truth for:
  - workflow init and selection
  - rule priority and doc read order
  - default one-task mode and explicit complete-all override
  - round-based validation policy
  - documentation budget (soft constraint)
  - code search policy

## Required Artifacts Before Coding

1. `.workflow/docs/PRD.md` updated
2. `.workflow/docs/ARCHITECTURE.md` updated
3. `.workflow/features/*/design.md` created
4. `.workflow/features/*/tasks.md` created

## L3-Specific Execution Rules

- Confirm large-scope objective first.
- Keep task status in sync with completed work.
- If `Reference code paths` are provided, treat them as first search scope.

## Repository Layout

- Use current repository layout as source of truth.
- Do not force `src/`.
- Use actual file paths from current repository.

## Quality and Risk

- Ensure architecture and PRD are consistent before implementation.
- Add comments only where needed: explain business rules, edge cases, and non-obvious decisions; avoid trivial comments.
- Track migration and rollback risks in design/tasks where needed.
