# Post-Init Template Skill

Use this skill after successful `wf-init lX --confirm`.

## Goal

Provide a concise, level-matched next-input template immediately.

## Output Rules

- Do not wait for user to ask.
- Keep template concise.
- Match user language:
  - Chinese user -> Chinese template
  - English user -> English template

## Templates

### L1

- Reason: [why this is a quick task]
- Project layout: use current repository layout only
- Task: [small change]

### L2

- Reason: [why this is a feature task]
- Project layout: use current repository layout only
- Task: [new feature name]
- Acceptance criteria: [1-3 checks]
- Reference code paths:
  - Directories: [dir1], [dir2]
  - Files: [file1], [file2]

### L3

- Reason: [why this is system-level]
- Project layout: use current repository layout only
- Goal: [system objective]
- Scope and constraints: [key boundaries]
