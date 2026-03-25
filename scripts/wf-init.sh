#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: wf-init <l1|l2|l3> --confirm [target_dir]

Initializes repository with workflow template files.
Behavior is non-destructive: existing files are not overwritten.
Default target_dir is "$PWD/.workflow".
Writes/updates <target_dir>/.workflow-level.
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

if [ "$#" -eq 1 ] && { [ "$1" = "--help" ] || [ "$1" = "-h" ]; }; then
  usage
  exit 0
fi

if [ "$#" -lt 2 ]; then
  usage
  exit 1
fi

level="$1"
shift

confirm="false"
target_dir=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    --confirm)
      confirm="true"
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      if [ -z "$target_dir" ]; then
        target_dir="$1"
      else
        echo "Unexpected argument: $1"
        usage
        exit 1
      fi
      ;;
  esac
  shift
done

case "$level" in
  l1|l2|l3) ;;
  *)
    echo "Invalid workflow level: $level"
    usage
    exit 1
    ;;
esac

if [ "$confirm" != "true" ]; then
  echo "Missing required flag: --confirm"
  usage
  exit 1
fi

script_dir="$(resolve_script_dir)"
toolkit_root="$(cd "$script_dir/.." && pwd)"
template_dir="$toolkit_root/templates/workflows/$level"
repo_dir="$(pwd)"

if [ -z "$target_dir" ]; then
  target_dir="$repo_dir/.workflow"
fi

if [ ! -d "$template_dir" ]; then
  echo "Missing template directory: $template_dir"
  exit 1
fi

created=0
skipped=0

while IFS= read -r src; do
  rel="${src#"$template_dir"/}"
  dst="$target_dir/$rel"

  mkdir -p "$(dirname "$dst")"

  if [ -e "$dst" ]; then
    skipped=$((skipped + 1))
    continue
  fi

  cp "$src" "$dst"
  created=$((created + 1))
done < <(find "$template_dir" -type f)

printf '%s\n' "$level" > "$target_dir/.workflow-level"

echo "Workflow initialized: $level"
echo "Target directory: $target_dir"
echo "Created files: $created"
echo "Skipped existing files: $skipped"
echo ".workflow-level updated to: $level (in $target_dir)"
