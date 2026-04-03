#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  create-feature.sh <name>
  create-feature.sh <id> <name>

Examples:
  create-feature.sh payment-refactor
  create-feature.sh 010 payment-refactor
EOF
}

script_dir="$(cd "$(dirname "$0")" && pwd)"
workflow_root="$(cd "$script_dir/.." && pwd)"

if [ "$#" -eq 1 ]; then
  raw_name="$1"
  raw_id=""
elif [ "$#" -eq 2 ]; then
  raw_id="$1"
  raw_name="$2"
else
  usage
  exit 1
fi

slugify() {
  local s="$1"
  s="$(printf '%s' "$s" | tr '[:upper:]' '[:lower:]')"
  s="$(printf '%s' "$s" | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//; s/-{2,}/-/g')"
  printf '%s' "$s"
}

next_feature_id() {
  local max=0
  local d base n
  for d in "$workflow_root"/features/*; do
    [ -d "$d" ] || continue
    base="$(basename "$d")"
    n="${base%%-*}"
    if [[ "$n" =~ ^[0-9]{3}$ ]]; then
      n=$((10#$n))
      if [ "$n" -gt "$max" ]; then
        max="$n"
      fi
    fi
  done
  printf '%03d' $((max + 1))
}

if [ -n "$raw_id" ]; then
  if [[ "$raw_id" =~ ^[0-9]+$ ]]; then
    id="$(printf '%03d' "$raw_id")"
  else
    echo "Invalid id: $raw_id (must be numeric)"
    exit 1
  fi
else
  id="$(next_feature_id)"
fi

name="$(slugify "$raw_name")"
if [ -z "$name" ]; then
  echo "Invalid feature name after normalization: $raw_name"
  exit 1
fi

template_dir="$workflow_root/features/_template"
dir="$workflow_root/features/${id}-${name}"

if [ ! -d "$template_dir" ]; then
  echo "Missing template directory: $template_dir"
  exit 1
fi

if [ -e "$dir" ]; then
  echo "Feature already exists: $dir"
  exit 1
fi

mkdir -p "$dir"
copied=0

while IFS= read -r src; do
  dst="$dir/$(basename "$src")"
  cp "$src" "$dst"
  copied=$((copied + 1))
done < <(find "$template_dir" -maxdepth 1 -type f -name "*.md" | sort)

for f in "$dir"/*.md; do
  [ -f "$f" ] || continue
  tmp="$f.tmp"
  sed "s/<feature-name>/$name/g" "$f" > "$tmp"
  mv "$tmp" "$f"
done

echo "Feature created: $dir"
echo "Feature id: $id"
echo "Feature name: $name"
echo "Files copied: $copied"
