#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

global_rules="$REPO_ROOT/global-rules/00-global.md"
l2_rules="$REPO_ROOT/templates/workflows/l2/RULES.md"
l3_rules="$REPO_ROOT/templates/workflows/l3/RULES.md"

failures=0

contains() {
  local file="$1"
  local pattern="$2"
  if command -v rg >/dev/null 2>&1; then
    rg -qF "$pattern" "$file"
  else
    grep -qF "$pattern" "$file"
  fi
}

require_global_only() {
  local marker="$1"

  if ! contains "$global_rules" "$marker"; then
    echo "Missing global marker in $global_rules"
    echo "  marker: $marker"
    failures=$((failures + 1))
  fi

  if contains "$l2_rules" "$marker"; then
    echo "Duplicated marker found in $l2_rules"
    echo "  marker: $marker"
    failures=$((failures + 1))
  fi

  if contains "$l3_rules" "$marker"; then
    echo "Duplicated marker found in $l3_rules"
    echo "  marker: $marker"
    failures=$((failures + 1))
  fi
}

while IFS= read -r marker; do
  [ -n "$marker" ] || continue
  require_global_only "$marker"
done <<'EOF'
Workflow initialization policy:
Command execution and verification policy:
Workflow auto-selection policy:
Default task execution mode:
Override mode (explicit user request only):
Validation policy (default round-based):
Documentation budget policy (soft constraint):
Code search policy:
EOF

if [ "$failures" -ne 0 ]; then
  echo "Rule duplication check failed with $failures issue(s)."
  exit 1
fi

echo "Rule duplication check passed."
