# Global AI Rules

When working in a repository read documentation in this order:

1. .workflow/AGENTS.md
2. .workflow/RULES.md (if present)
3. .workflow/docs/PRD.md
4. .workflow/docs/ARCHITECTURE.md
5. .workflow/features/*/requirements.md (if present)
6. .workflow/features/*/design.md
7. .workflow/features/*/tasks.md

Rules:

Do not prepend any fixed verification phrase at session start.

Rule vs skill:

- Rules define non-negotiable boundaries.
- Skill docs define operational playbooks and prompt templates.
- When rules and skills conflict, rules win.

Workflow initialization policy:

- Workflow initialization is optional, not mandatory.
- Do not start workflow initialization during normal conversation.
- Only initialize when the user sends an explicit command.
- Valid forms:
  - wf-init l1 --confirm
  - wf-init l2 --confirm
  - wf-init l3 --confirm
- Do not map ambiguous inputs like "1", "2", "3", "l1", "l2",
  or "l3" alone to initialization.
- If command is ambiguous, continue normal conversation.
- Ask for an explicit `wf-init` command only if needed.

Command execution and verification policy:

- For shell commands requested by user (especially `wf-init ...`),
  execute the command first.
- Do not claim success before execution.
- Return the real command output or key output lines after execution.
- For `wf-init lX --confirm`, verify workflow marker exists and
  equals `lX` before declaring success.
- If verification fails, report failure and include the failing
  check output.
- Do not provide post-init template on failure.

wf-init operational details:

- Detailed command resolution and marker verification steps live in:
  - `methodology/skills/wf-init-skill.md`
- Keep this boundary in rules:
  - never replace `wf-init` with manual file writes.

Workflow auto-selection policy:

- If `$PWD/.workflow/.workflow-level` exists and value is `l1`,
  `l2`, or `l3`, use it as default workflow for implementation tasks.
- After successful `wf-init lX --confirm`, treat `lX` as active
  workflow immediately.
- Do not ask user to select again.
- Explicit `Workflow Selection: ...` from user overrides
  `.workflow/.workflow-level` for that request.
- For normal conversation, no workflow selection is required.

Post-init prompt templates:

- Template generation details live in:
  - `methodology/skills/post-init-template-skill.md`
- Rule boundary:
  - after successful init, provide concise next-step template immediately.

Default task execution mode:

- Implement only the next unfinished task.
- Complete one task per run, then stop.

Override mode (explicit user request only):

- If user explicitly requests "complete all tasks" for current
  feature, implement tasks sequentially in order.
- Continue until all tasks are done or blocked.
- In override mode, update task checkboxes continuously.
- Stop immediately on blocker or test failure.

If `.workflow/features/*/requirements.md` contains a `Raw Input`
section, extract it into structured requirement sections before
writing design/tasks.

Do not invent requirements not defined in:

- `.workflow/docs/PRD.md`
- `.workflow/docs/ARCHITECTURE.md`
- `.workflow/features/*/requirements.md`
- `.workflow/features/*/design.md`
