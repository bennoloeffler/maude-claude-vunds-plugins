#!/bin/bash
# ms365-call.sh - Call MS365 MCP tools via bash
#
# This is the KEY script for MCP-by-Code pattern:
# - Starts MCP server in stdio mode
# - Sends JSON-RPC tool call
# - Returns result
#
# NO MCP REGISTRATION NEEDED - Claude Code never sees the 87 tools!
#
# Usage:
#   ./ms365-call.sh <tool-name> [--param value ...]
#
# Examples:
#   ./ms365-call.sh verify-login
#   ./ms365-call.sh list-mail-messages --top 5
#   ./ms365-call.sh send-mail --to "x@y.com" --subject "Hi" --body "Hello"
#   ./ms365-call.sh get-calendar-view --start-date-time "2026-01-04T00:00:00Z" --end-date-time "2026-01-11T23:59:59Z"

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(dirname "$SCRIPT_DIR")"
ENV_FILE="$PLUGIN_DIR/.env"

# Load credentials
if [[ -f "$ENV_FILE" ]]; then
  set -a
  source "$ENV_FILE"
  set +a
fi

# Check credentials
if [[ -z "$MS365_CLIENT_ID" || -z "$MS365_TENANT_ID" ]]; then
  echo "Error: MS365 credentials not configured" >&2
  echo "Create .env file or set MS365_CLIENT_ID and MS365_TENANT_ID" >&2
  exit 1
fi

export MS365_MCP_CLIENT_ID="$MS365_CLIENT_ID"
export MS365_MCP_TENANT_ID="$MS365_TENANT_ID"
[[ -n "$MS365_CLIENT_SECRET" ]] && export MS365_MCP_CLIENT_SECRET="$MS365_CLIENT_SECRET"

# Parse tool name
if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <tool-name> [--param value ...]" >&2
  echo "" >&2
  echo "Tools: verify-login, login, logout, list-mail-messages, send-mail," >&2
  echo "       list-calendar-events, get-calendar-view, create-calendar-event, etc." >&2
  echo "" >&2
  echo "Use ./discover-tools.sh to see all available tools and parameters." >&2
  exit 1
fi

TOOL_NAME="$1"
shift

# Special handling for login/logout/verify (CLI commands, not MCP tools)
case "$TOOL_NAME" in
  login)
    exec npx -y @softeria/ms-365-mcp-server --login
    ;;
  logout)
    exec npx -y @softeria/ms-365-mcp-server --logout
    ;;
  verify-login)
    exec npx -y @softeria/ms-365-mcp-server --verify-login
    ;;
esac

# Parse arguments into JSON object
# Converts --param value to {"param": "value"}
build_args_json() {
  local args=()
  while [[ $# -gt 0 ]]; do
    case $1 in
      --*)
        local key="${1#--}"
        local value="$2"
        # Handle different value types
        if [[ "$value" =~ ^[0-9]+$ ]]; then
          args+=("\"$key\": $value")
        elif [[ "$value" == "true" || "$value" == "false" ]]; then
          args+=("\"$key\": $value")
        else
          # Escape quotes in string values
          value="${value//\"/\\\"}"
          args+=("\"$key\": \"$value\"")
        fi
        shift 2
        ;;
      *)
        shift
        ;;
    esac
  done
  
  # Join with commas
  local IFS=','
  echo "{${args[*]}}"
}

ARGS_JSON=$(build_args_json "$@")

# Build MCP JSON-RPC requests
INIT_REQUEST='{"jsonrpc":"2.0","id":0,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"ms365-call","version":"1.0"}}}'
CALL_REQUEST="{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"tools/call\",\"params\":{\"name\":\"$TOOL_NAME\",\"arguments\":$ARGS_JSON}}"

# Send requests to MCP server and capture response
# The server outputs one JSON response per line
RESPONSE=$(echo -e "$INIT_REQUEST\n$CALL_REQUEST" | timeout 60 npx -y @softeria/ms-365-mcp-server 2>/dev/null | tail -1)

# Check for errors
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  ERROR_MSG=$(echo "$RESPONSE" | jq -r '.error.message // .error // "Unknown error"')
  echo "Error: $ERROR_MSG" >&2
  exit 1
fi

# Extract and output the result
# MCP returns: {"result": {"content": [{"type": "text", "text": "..."}]}}
CONTENT=$(echo "$RESPONSE" | jq -r '.result.content[0].text // .result // empty' 2>/dev/null)

if [[ -n "$CONTENT" ]]; then
  # Try to pretty-print if it's JSON
  if echo "$CONTENT" | jq . > /dev/null 2>&1; then
    echo "$CONTENT" | jq .
  else
    echo "$CONTENT"
  fi
else
  echo "$RESPONSE" | jq .
fi

