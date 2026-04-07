#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

failures=0

check_file() {
  local file="$1"
  local dir link target

  dir="$(cd "$(dirname "$file")" && pwd)"

  while IFS= read -r link; do
    target="$(printf '%s' "$link" | sed -E 's/^\[[^]]+\]\(([^)]+)\)$/\1/')"
    target="${target%%#*}"
    target="${target%%\?*}"

    if [[ "$target" =~ ^https?:// ]] || [[ "$target" =~ ^mailto: ]]; then
      continue
    fi
    if [[ "$target" == "#"* ]] || [ -z "$target" ]; then
      continue
    fi

    if [[ "$target" == /* ]]; then
      if [ ! -e "$target" ]; then
        echo "Broken link in $file"
        echo "  target: $target"
        failures=$((failures + 1))
      fi
      continue
    fi

    if [ ! -e "$dir/$target" ]; then
      echo "Broken link in $file"
      echo "  target: $target"
      failures=$((failures + 1))
    fi
  done < <(rg -o --pcre2 '\[[^\]]+\]\([^)]+\)' "$file" || true)
}

while IFS= read -r md; do
  check_file "$md"
done < <(
  {
    printf '%s\n' "README.md"
    printf '%s\n' "README.zh-CN.md"
    find templates/workflows global-rules methodology scripts -type f -name "*.md"
  } | sort -u
)

if [ "$failures" -ne 0 ]; then
  echo "Doc link check failed with $failures issue(s)."
  exit 1
fi

echo "Doc link check passed."
