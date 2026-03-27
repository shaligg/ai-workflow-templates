#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: bash scripts/preflight.sh [options]

Runs local checks aligned with CI quality jobs.

Options:
  --skip-markdown   Skip markdown lint
  --skip-shell      Skip shell lint
  --skip-gitleaks   Skip secrets scan
  -h, --help        Show help
EOF
}

resolve_script_dir() {
  local src="${BASH_SOURCE[0]}"
  while [ -h "$src" ]; do
    local dir
    dir="$(cd -P "$(dirname "$src")" && pwd)"
    src="$(readlink "$src")"
    if [[ "$src" != /* ]]; then
      src="$dir/$src"
    fi
  done
  cd -P "$(dirname "$src")" && pwd
}

skip_markdown=false
skip_shell=false
skip_gitleaks=false

while [ "$#" -gt 0 ]; do
  case "$1" in
    --skip-markdown)
      skip_markdown=true
      ;;
    --skip-shell)
      skip_shell=true
      ;;
    --skip-gitleaks)
      skip_gitleaks=true
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      usage
      exit 1
      ;;
  esac
  shift
done

script_dir="$(resolve_script_dir)"
repo_root="$(cd "$script_dir/.." && pwd)"
cd "$repo_root"

failures=0

step() {
  echo
  echo "==> $1"
}

fail() {
  local msg="$1"
  echo "[FAIL] $msg"
  failures=$((failures + 1))
}

pass() {
  local msg="$1"
  echo "[OK] $msg"
}

require_cmd() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    fail "Missing command: $cmd"
    return 1
  fi
  return 0
}

step "Rule adapter check"
if bash scripts/check-rule-adapters.sh; then
  pass "Rule adapter check passed"
else
  fail "Rule adapter check failed"
fi

if [ "$skip_shell" = false ]; then
  step "ShellCheck"
  if require_cmd shellcheck; then
    sh_files=()
    while IFS= read -r f; do
      sh_files+=("$f")
    done < <(find scripts templates/workflows/l2/scripts -type f -name "*.sh" | sort)

    if [ "${#sh_files[@]}" -eq 0 ]; then
      pass "No shell scripts found"
    elif shellcheck "${sh_files[@]}"; then
      pass "ShellCheck passed"
    else
      fail "ShellCheck failed"
    fi
  fi
else
  step "ShellCheck (skipped)"
  pass "Skipped by option"
fi

if [ "$skip_markdown" = false ]; then
  step "Markdown lint"
  if command -v markdownlint-cli2 >/dev/null 2>&1; then
    if markdownlint-cli2 "**/*.md"; then
      pass "markdownlint-cli2 passed"
    else
      fail "markdownlint-cli2 failed"
    fi
  elif command -v npx >/dev/null 2>&1; then
    if npx --yes markdownlint-cli2 "**/*.md"; then
      pass "npx markdownlint-cli2 passed"
    else
      fail "npx markdownlint-cli2 failed"
    fi
  else
    fail "Missing command: markdownlint-cli2 (or npx)"
  fi
else
  step "Markdown lint (skipped)"
  pass "Skipped by option"
fi

if [ "$skip_gitleaks" = false ]; then
  step "Gitleaks"
  if require_cmd gitleaks; then
    if gitleaks git --source . --config .gitleaks.toml --no-banner; then
      pass "Gitleaks passed"
    else
      fail "Gitleaks found issues"
    fi
  fi
else
  step "Gitleaks (skipped)"
  pass "Skipped by option"
fi

echo
if [ "$failures" -ne 0 ]; then
  echo "Preflight failed with $failures issue(s)."
  exit 1
fi

echo "Preflight passed."
