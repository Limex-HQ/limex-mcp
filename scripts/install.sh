#!/usr/bin/env bash
set -euo pipefail

api_base_url="${LIMEX_API_BASE_URL:-https://api.getlimex.com}"

echo "Limex MCP setup"
echo
echo "1. Create a Limex account and generate a Claude Code key:"
echo "   https://getlimex.com/account"
echo

if ! command -v uvx >/dev/null 2>&1; then
  echo "uvx is required to run limex-mcp without a manual install."
  echo "Install uv first, then re-run this script:"
  echo "  curl -LsSf https://astral.sh/uv/install.sh | sh"
  exit 1
fi

if [[ ! -r /dev/tty ]]; then
  echo "This installer needs an interactive terminal so it can read your Limex key."
  echo "Download scripts/install.sh and run it from a terminal."
  exit 1
fi

read -r -s -p "Paste your Limex Claude Code key: " limex_api_key < /dev/tty
echo

if [[ -z "${limex_api_key}" ]]; then
  echo "No key provided. Create a key at https://getlimex.com/account and re-run this script."
  exit 1
fi

mcp_json=$(cat <<JSON
{
  "command": "uvx",
  "args": ["limex-mcp"],
  "env": {
    "LIMEX_API_KEY": "${limex_api_key}",
    "LIMEX_API_BASE_URL": "${api_base_url}"
  }
}
JSON
)

if command -v claude >/dev/null 2>&1; then
  claude mcp remove limex >/dev/null 2>&1 || true
  claude mcp add-json limex "${mcp_json}"
  echo
  echo "Limex MCP installed in Claude Code."
  echo "Restart Claude Code if it is already running, then ask:"
  echo "  Use Limex to research Sierra AI with a \$10 budget."
  exit 0
fi

config_path="${HOME}/.config/claude-code/limex-mcp.json"
mkdir -p "$(dirname "${config_path}")"
cat > "${config_path}" <<JSON
{
  "mcpServers": {
    "limex": ${mcp_json}
  }
}
JSON

echo
echo "Claude Code CLI was not found, so I wrote a config snippet here:"
echo "  ${config_path}"
echo
echo "Add that MCP server config to Claude Code, then restart Claude Code."
