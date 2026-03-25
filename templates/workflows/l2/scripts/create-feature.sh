#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <id> <name>"
  exit 1
fi

script_dir="$(cd "$(dirname "$0")" && pwd)"
workflow_root="$(cd "$script_dir/.." && pwd)"

id="$1"
name="$2"

template_dir="$workflow_root/features/_template"
dir="$workflow_root/features/${id}-${name}"

if [ ! -d "$template_dir" ]; then
  echo "Missing template directory: $template_dir"
  exit 1
fi

mkdir -p "$dir"
cp "$template_dir/requirements.md" "$dir/requirements.md"
cp "$template_dir/design.md" "$dir/design.md"
cp "$template_dir/tasks.md" "$dir/tasks.md"

echo "Feature created: $dir"
