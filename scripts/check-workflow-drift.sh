#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
failures=0

require_file() {
  local file="$1"
  if [ ! -f "$file" ]; then
    echo "Missing required file: $file"
    failures=$((failures + 1))
  fi
}

contains_text() {
  local file="$1"
  local pattern="$2"
  if command -v rg >/dev/null 2>&1; then
    rg -qF "$pattern" "$file"
  else
    grep -qF "$pattern" "$file"
  fi
}

require_contains() {
  local file="$1"
  local pattern="$2"
  if ! contains_text "$file" "$pattern"; then
    echo "Missing expected text in $file"
    echo "Expected: $pattern"
    failures=$((failures + 1))
  fi
}

forbid_contains() {
  local file="$1"
  local pattern="$2"
  if contains_text "$file" "$pattern"; then
    echo "Found forbidden text in $file"
    echo "Forbidden: $pattern"
    failures=$((failures + 1))
  fi
}

check_level_rules() {
  local level="$1"
  local rules_file="$REPO_ROOT/templates/workflows/$level/RULES.md"
  local expected_delta=""

  if [ "$level" = "l2" ]; then
    expected_delta="This file defines L2-specific deltas."
  else
    expected_delta="This file defines L3-specific deltas."
  fi

  require_contains "$rules_file" "$expected_delta"
  require_contains "$rules_file" "Global rules remain source of truth for:"

  while IFS= read -r forbidden; do
    if [ -n "$forbidden" ]; then
      forbid_contains "$rules_file" "$forbidden"
    fi
  done <<'EOF'
Workflow initialization policy:
Command execution and verification policy:
Workflow auto-selection policy:
Validation policy (default round-based):
Documentation budget policy (soft constraint):
Code search policy:
EOF
}

check_templates() {
  local l2_design="$REPO_ROOT/templates/workflows/l2/features/_template/design.md"
  local l3_design="$REPO_ROOT/templates/workflows/l3/features/_template/design.md"
  local l2_tasks="$REPO_ROOT/templates/workflows/l2/features/_template/tasks.md"
  local l3_tasks="$REPO_ROOT/templates/workflows/l3/features/_template/tasks.md"
  local agent_context_line="Read and follow: .workflow/AGENTS.md, .workflow/RULES.md, .workflow/docs/ARCHITECTURE.md."

  require_contains "$l2_design" "$agent_context_line"
  require_contains "$l3_design" "$agent_context_line"

  require_contains "$l2_tasks" "files:"
  require_contains "$l2_tasks" "tests:"
  require_contains "$l3_tasks" "files:"
  require_contains "$l3_tasks" "tests:"
}

check_wf_init_contract() {
  local wf_init_file="$REPO_ROOT/scripts/wf-init.sh"
  require_contains "$wf_init_file" "Project AGENTS.md"
  require_contains "$wf_init_file" ".workflow/docs/ARCHITECTURE.md"
}

check_required_layout() {
  require_file "$REPO_ROOT/templates/workflows/l1/README.md"
  require_file "$REPO_ROOT/templates/workflows/l2/README.md"
  require_file "$REPO_ROOT/templates/workflows/l3/README.md"

  require_file "$REPO_ROOT/templates/workflows/l2/docs/PRD.md"
  require_file "$REPO_ROOT/templates/workflows/l2/docs/ARCHITECTURE.md"
  require_file "$REPO_ROOT/templates/workflows/l3/docs/PRD.md"
  require_file "$REPO_ROOT/templates/workflows/l3/docs/ARCHITECTURE.md"

  require_file "$REPO_ROOT/templates/workflows/l2/features/_template/requirements.md"
  require_file "$REPO_ROOT/templates/workflows/l2/features/_template/design.md"
  require_file "$REPO_ROOT/templates/workflows/l2/features/_template/tasks.md"
  require_file "$REPO_ROOT/templates/workflows/l3/features/_template/design.md"
  require_file "$REPO_ROOT/templates/workflows/l3/features/_template/tasks.md"

  require_file "$REPO_ROOT/templates/workflows/l2/scripts/create-feature.sh"
  require_file "$REPO_ROOT/templates/workflows/l3/scripts/create-feature.sh"
}

check_level_rules "l2"
check_level_rules "l3"
check_templates
check_wf_init_contract
check_required_layout

if [ "$failures" -ne 0 ]; then
  echo "Workflow drift check failed with $failures issue(s)."
  exit 1
fi

echo "Workflow drift check passed."
