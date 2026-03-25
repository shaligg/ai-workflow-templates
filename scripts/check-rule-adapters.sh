#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
failures=0

check_file_exists() {
  local file="$1"
  if [ ! -f "$file" ]; then
    echo "Missing file: $file"
    failures=$((failures + 1))
  fi
}

check_contains() {
  local file="$1"
  local pattern="$2"
  if command -v rg >/dev/null 2>&1; then
    if rg -qF "$pattern" "$file"; then
      return 0
    fi
  else
    if grep -qF "$pattern" "$file"; then
      return 0
    fi
  fi

  echo "Missing expected text in $file"
  echo "Expected: $pattern"
  failures=$((failures + 1))
}

for level in l1 l2 l3; do
  base="$REPO_ROOT/templates/workflows/$level"

  rules_file="$base/RULES.md"
  agents_file="$base/AGENTS.md"
  claude_file="$base/CLAUDE.md"
  ai_rules_file="$base/.ai/rules.md"
  claude_rules_file="$base/.claude/rules/10-project-workflow.md"

  check_file_exists "$rules_file"
  check_file_exists "$agents_file"
  check_file_exists "$claude_file"
  check_file_exists "$ai_rules_file"
  check_file_exists "$claude_rules_file"

  if [ -f "$rules_file" ]; then
    check_contains "$rules_file" "# Workflow Rules"
  fi
  if [ -f "$agents_file" ]; then
    check_contains "$agents_file" "Single source of truth: [RULES.md](RULES.md)"
  fi
  if [ -f "$claude_file" ]; then
    check_contains "$claude_file" "Single source of truth: [RULES.md](RULES.md)"
  fi
  if [ -f "$ai_rules_file" ]; then
    check_contains "$ai_rules_file" "Single source of truth: [../RULES.md](../RULES.md)"
  fi
  if [ -f "$claude_rules_file" ]; then
    check_contains "$claude_rules_file" "Single source of truth: [../../RULES.md](../../RULES.md)"
  fi
done

if [ "$failures" -ne 0 ]; then
  echo "Rule adapter check failed with $failures issue(s)."
  exit 1
fi

echo "Rule adapter check passed."
