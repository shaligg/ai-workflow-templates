#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: wf-init <l1|l2|l3> --confirm [target_dir]

Initializes repository with workflow template files.
Behavior is non-destructive: existing files are not overwritten.
Default target_dir is "$PWD/.workflow".
Writes/updates <target_dir>/.workflow-level.
If target_dir basename is ".workflow", creates project-root AGENTS.md
when missing (non-destructive).
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
project_agents_status="not-applicable"

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

if [ "$(basename "$target_dir")" = ".workflow" ]; then
  project_root="$(cd "$target_dir/.." && pwd)"
  project_agents_file="$project_root/AGENTS.md"
  if [ -e "$project_agents_file" ]; then
    project_agents_status="skipped-existing ($project_agents_file)"
  else
    cat > "$project_agents_file" <<'EOF'
# Project Agent Entry

Before implementation, read and follow:

1. `.workflow/AGENTS.md`
2. `.workflow/RULES.md`
3. `.workflow/docs/ARCHITECTURE.md`
EOF
    project_agents_status="created ($project_agents_file)"
  fi
fi

echo "Workflow initialized: $level"
echo "Target directory: $target_dir"
echo "Created files: $created"
echo "Skipped existing files: $skipped"
echo ".workflow-level updated to: $level (in $target_dir)"
echo "Project AGENTS.md: $project_agents_status"
