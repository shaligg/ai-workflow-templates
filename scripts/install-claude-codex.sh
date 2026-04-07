#!/usr/bin/env bash
set -euo pipefail

echo "=== 一键安装 Claude Code + claude-codex 封装脚本（gpt-5.1-codex）==="

BASE_DIR="${BASE_DIR:-$HOME/claude-model}"
BIN_DIR="$BASE_DIR/bin"
CONFIG_DIR="$BASE_DIR/.claude-codex"
CLAUDE_SCRIPT="$BIN_DIR/claude-codex"

echo "[1/4] 创建目录: $BASE_DIR, $BIN_DIR, $CONFIG_DIR ..."
mkdir -p "$BIN_DIR" "$CONFIG_DIR"

echo "[2/4] 安装 @anthropic-ai/claude-code ..."
cd "$BASE_DIR"
if [ ! -f package.json ]; then
  npm init -y >/dev/null 2>&1
fi
npm install @anthropic-ai/claude-code

echo "[3/4] 创建 claude-codex 命令封装脚本: $CLAUDE_SCRIPT ..."

cat >"$CLAUDE_SCRIPT" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

CLAUDE_BIN="$HOME/claude-model/node_modules/.bin/claude"
if [ ! -x "$CLAUDE_BIN" ]; then
  echo "Claude binary not found: $CLAUDE_BIN"
  echo "Run installer again: bash ~/ai-dev/scripts/install-claude-codex.sh"
  exit 1
fi

# Prefer existing ANTHROPIC_* vars; fall back to CODEX_* aliases.
export ANTHROPIC_AUTH_TOKEN="${ANTHROPIC_AUTH_TOKEN:-${CODEX_API_KEY:-}}"
export ANTHROPIC_BASE_URL="${ANTHROPIC_BASE_URL:-${CODEX_BASE_URL:-}}"
export ANTHROPIC_MODEL="${ANTHROPIC_MODEL:-gpt-5.1-codex}"
export API_TIMEOUT_MS="${API_TIMEOUT_MS:-3000000}"
export DISABLE_PROMPT_CACHING="${DISABLE_PROMPT_CACHING:-1}"
export CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS="${CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS:-1}"
export CLAUDE_CONFIG_DIR="${CLAUDE_CONFIG_DIR:-$HOME/claude-model/.claude-codex}"

if [ -z "${ANTHROPIC_AUTH_TOKEN:-}" ]; then
  echo "Missing API key: set ANTHROPIC_AUTH_TOKEN or CODEX_API_KEY"
  exit 1
fi

if [ -z "${ANTHROPIC_BASE_URL:-}" ]; then
  echo "Missing base URL: set ANTHROPIC_BASE_URL or CODEX_BASE_URL"
  exit 1
fi

exec "$CLAUDE_BIN" "$@"
EOF

chmod +x "$CLAUDE_SCRIPT"

echo "[4/4] 写入 PATH 到 shell 配置文件 ..."

SHELL_NAME="$(basename "${SHELL:-bash}")"
PROFILE="$HOME/.bashrc"
if [[ "$SHELL_NAME" == "zsh" ]]; then
  PROFILE="$HOME/.zshrc"
elif [[ "$SHELL_NAME" == "fish" ]]; then
  PROFILE="$HOME/.config/fish/config.fish"
  mkdir -p "$(dirname "$PROFILE")"
fi

if [ ! -f "$PROFILE" ]; then
  touch "$PROFILE"
fi

if ! grep -q 'claude-model/bin' "$PROFILE"; then
  if [[ "$SHELL_NAME" == "fish" ]]; then
    echo 'set -gx PATH $HOME/claude-model/bin $PATH' >>"$PROFILE"
  else
    echo 'export PATH="$HOME/claude-model/bin:$PATH"' >>"$PROFILE"
  fi
  echo "已将 \$HOME/claude-model/bin 添加到 PATH ($PROFILE)."
else
  echo "PATH 中已包含 \$HOME/claude-model/bin, 跳过."
fi

echo
echo "=== 安装完成 ==="
echo "1) 在 shell 配置中设置变量（示例）："
echo "   export CODEX_API_KEY='your_key'"
echo "   export CODEX_BASE_URL='https://your-gateway.example.com'"
echo
echo "2) 重新打开终端（或执行: source $PROFILE）"
echo
echo "3) 测试命令："
echo "   claude-codex --version"
echo
echo "注意：请用 bash 执行本脚本，不要用 sh。"
