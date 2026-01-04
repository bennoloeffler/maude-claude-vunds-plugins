#!/bin/bash
# cleanup-mcp.sh - Kill MS365 MCP server on Claude session end
#
# This hook is called by Claude Code when the session stops.
# It ensures the MCP server doesn't keep running after Claude exits.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(dirname "$SCRIPT_DIR")"
SESSION_DIR="$PLUGIN_DIR/.session"
PID_FILE="$SESSION_DIR/mcp-server.pid"

# Kill the MCP server if running
if [[ -f "$PID_FILE" ]]; then
  PID=$(cat "$PID_FILE")
  if kill -0 "$PID" 2>/dev/null; then
    echo "Stopping MS365 MCP server (PID: $PID)..."
    kill "$PID" 2>/dev/null || true
    sleep 1
    kill -9 "$PID" 2>/dev/null || true
    echo "MS365 MCP server stopped."
  fi
  rm -f "$PID_FILE"
fi

# Cleanup session files
rm -f "$SESSION_DIR/mcp-in.fifo" "$SESSION_DIR/mcp-out.fifo" 2>/dev/null || true

