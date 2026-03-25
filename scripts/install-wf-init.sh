#!/usr/bin/env bash
set -euo pipefail

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

script_dir="$(resolve_script_dir)"
toolkit_root="$(cd "$script_dir/.." && pwd)"
source_script="$toolkit_root/scripts/wf-init.sh"
bin_dir="${1:-$HOME/.local/bin}"
target="$bin_dir/wf-init"

if [ ! -f "$source_script" ]; then
  echo "Missing source script: $source_script"
  exit 1
fi

mkdir -p "$bin_dir"
ln -sf "$source_script" "$target"
chmod +x "$source_script"

echo "Installed wf-init to: $target"
echo "If needed, add to PATH:"
echo "export PATH=\"$bin_dir:\$PATH\""
