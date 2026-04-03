# wf-init Skill

Use this skill when the user asks to run workflow initialization.

## Goal

Execute `wf-init` reliably and verify activation marker correctly.

## Inputs

- Level: `l1`, `l2`, or `l3`
- Optional target directory

## Execution Playbook

1. Resolve command path:
   - prefer `command -v wf-init`
   - fallback: `~/claude-model/bin/wf-init`
2. Execute:
   - with target: `<wf-init-bin> lX --confirm <target_dir>`
   - without target: `<wf-init-bin> lX --confirm`
3. Never emulate init by manual file write (for example `echo > .workflow-level`).

## Verification Playbook

- If explicit target is provided:
  - marker path: `<target_dir>/.workflow-level`
- Otherwise:
  - marker path: `$PWD/.workflow/.workflow-level`
- Verify marker exists and content equals requested level (`l1/l2/l3`).
- If target basename is `.workflow`, also verify project-root `AGENTS.md` exists.

## Failure Handling

- If execution fails, report command output and stop.
- If marker verification fails, report failing check output and stop.
- Do not claim init success until marker verification passes.
