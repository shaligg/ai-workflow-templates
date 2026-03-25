#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_DIR="$REPO_ROOT/global-rules"
TARGET_DIR="${1:-${CLAUDE_CONFIG_DIR:-$HOME/.claude}/rules}"

if [ ! -d "$SOURCE_DIR" ]; then
  echo "Missing source directory: $SOURCE_DIR"
  exit 1
fi

mkdir -p "$TARGET_DIR"

timestamp="$(date +%Y%m%d%H%M%S)"

for src in "$SOURCE_DIR"/*.md; do
  name="$(basename "$src")"
  dst="$TARGET_DIR/$name"

  if [ -f "$dst" ]; then
    cp "$dst" "$dst.bak.$timestamp"
  fi

  cp "$src" "$dst"
done

echo "Installed global rules to: $TARGET_DIR"
echo "Source: $SOURCE_DIR"
