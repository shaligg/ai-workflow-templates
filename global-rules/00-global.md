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

wf-init execution policy:

- Never replace `wf-init ...` with manual file writes
  (for example `echo > .workflow-level`).
- Resolve command path using `command -v wf-init`.
- If not found, fallback to `~/claude-model/bin/wf-init`.
- If user does not provide `target_dir`, use default target `$PWD/.workflow`.
- Preferred execution form: `[wf-init-bin] lX --confirm`.
- Verification after execution:
  - If command includes explicit `target_dir`,
    marker must exist at `[target_dir]/.workflow-level`.
  - Primary marker: `$PWD/.workflow/.workflow-level`.
  - Marker file content must equal `lX`.
- Only after verification passes, report initialization success.
- Then provide post-init template.

Workflow auto-selection policy:

- If `$PWD/.workflow/.workflow-level` exists and value is `l1`,
  `l2`, or `l3`, use it as default workflow for implementation tasks.
- After successful `wf-init lX --confirm`, treat `lX` as active
  workflow immediately.
- Do not ask user to select again.
- Explicit `Workflow Selection: ...` from user overrides
  `.workflow/.workflow-level` for that request.
- For normal conversation, no workflow selection is required.

Post-init guidance policy:

- After successful `wf-init lX --confirm`,
  immediately provide a concise "next input template".
- Do not wait for user to ask what to input next.
- Language must follow user language:
  - if user uses Chinese, return Chinese template
  - if user uses English, return English template
- The template must match initialized level:
  - L1 template:
    - Reason: [why this is a quick task]
    - Project layout: use current repository layout only
    - Task: [small change]
  - L2 template:
    - Reason: [why this is a feature task]
    - Project layout: use current repository layout only
    - Task: [new feature name]
    - Acceptance criteria: [1-3 checks]
    - Reference code paths:
      - Directories: [dir1], [dir2]
      - Files: [file1], [file2]
  - L3 template:
    - Reason: [why this is system-level]
    - Project layout: use current repository layout only
    - Goal: [system objective]
    - Scope and constraints: [key boundaries]

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
