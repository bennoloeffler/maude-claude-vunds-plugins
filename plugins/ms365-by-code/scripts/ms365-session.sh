#!/bin/bash
# ms365-session.sh - Manage MS365 MCP server session lifecycle
#
# The MCP server runs in the background. We track its PID to:
# 1. Reuse the running server for multiple calls
# 2. Kill it when done (manually or via hook)
#
# Usage:
#   ./ms365-session.sh start     # Start server, write PID
#   ./ms365-session.sh stop      # Stop server, remove PID
#   ./ms365-session.sh status    # Check if running
#   ./ms365-session.sh restart   # Stop + Start
#   ./ms365-session.sh call <tool> [args]  # Call tool on running server

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(dirname "$SCRIPT_DIR")"
ENV_FILE="$PLUGIN_DIR/.env"

# Session files
SESSION_DIR="$PLUGIN_DIR/.session"
PID_FILE="$SESSION_DIR/mcp-server.pid"
FIFO_IN="$SESSION_DIR/mcp-in.fifo"
FIFO_OUT="$SESSION_DIR/mcp-out.fifo"
LOG_FILE="$SESSION_DIR/mcp-server.log"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Load credentials
load_credentials() {
  if [[ -f "$ENV_FILE" ]]; then
    set -a
    source "$ENV_FILE"
    set +a
  fi
  
  if [[ -z "$MS365_CLIENT_ID" || -z "$MS365_TENANT_ID" ]]; then
    echo -e "${RED}Error: MS365 credentials not configured${NC}" >&2
    exit 1
  fi
  
  export MS365_MCP_CLIENT_ID="$MS365_CLIENT_ID"
  export MS365_MCP_TENANT_ID="$MS365_TENANT_ID"
  [[ -n "$MS365_CLIENT_SECRET" ]] && export MS365_MCP_CLIENT_SECRET="$MS365_CLIENT_SECRET"
}

# Check if server is running
is_running() {
  if [[ -f "$PID_FILE" ]]; then
    local pid=$(cat "$PID_FILE")
    if kill -0 "$pid" 2>/dev/null; then
      return 0
    fi
  fi
  return 1
}

# Start the MCP server
start_server() {
  if is_running; then
    echo -e "${YELLOW}Server already running (PID: $(cat $PID_FILE))${NC}"
    return 0
  fi
  
  load_credentials
  
  # Create session directory
  mkdir -p "$SESSION_DIR"
  
  # Create named pipes for communication
  [[ -p "$FIFO_IN" ]] || mkfifo "$FIFO_IN"
  [[ -p "$FIFO_OUT" ]] || mkfifo "$FIFO_OUT"
  
  echo -e "${GREEN}Starting MS365 MCP server...${NC}"
  
  # Start server with stdin/stdout connected to FIFOs
  # The server reads from FIFO_IN and writes to FIFO_OUT
  (
    exec npx -y @softeria/ms-365-mcp-server < "$FIFO_IN" > "$FIFO_OUT" 2>> "$LOG_FILE"
  ) &
  local server_pid=$!
  
  # Save PID
  echo "$server_pid" > "$PID_FILE"
  
  # Open write end of input FIFO (keeps it open)
  exec 3>"$FIFO_IN"
  
  # Give server time to start
  sleep 2
  
  if is_running; then
    echo -e "${GREEN}Server started (PID: $server_pid)${NC}"
    echo "Session files: $SESSION_DIR"
    
    # Send initialization
    local init_request='{"jsonrpc":"2.0","id":0,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"ms365-session","version":"1.0"}}}'
    echo "$init_request" >&3
    
    # Read init response
    timeout 5 head -1 "$FIFO_OUT" > /dev/null 2>&1 || true
    
    echo -e "${GREEN}Server ready${NC}"
  else
    echo -e "${RED}Server failed to start. Check log: $LOG_FILE${NC}"
    cat "$LOG_FILE" | tail -10
    return 1
  fi
}

# Stop the MCP server
stop_server() {
  if [[ -f "$PID_FILE" ]]; then
    local pid=$(cat "$PID_FILE")
    if kill -0 "$pid" 2>/dev/null; then
      echo -e "${YELLOW}Stopping server (PID: $pid)...${NC}"
      kill "$pid" 2>/dev/null || true
      sleep 1
      # Force kill if still running
      kill -9 "$pid" 2>/dev/null || true
    fi
    rm -f "$PID_FILE"
  fi
  
  # Cleanup FIFOs
  rm -f "$FIFO_IN" "$FIFO_OUT"
  
  # Close file descriptor
  exec 3>&- 2>/dev/null || true
  
  echo -e "${GREEN}Server stopped${NC}"
}

# Get server status
server_status() {
  if is_running; then
    local pid=$(cat "$PID_FILE")
    echo -e "${GREEN}Server running (PID: $pid)${NC}"
    echo "Session: $SESSION_DIR"
    return 0
  else
    echo -e "${YELLOW}Server not running${NC}"
    return 1
  fi
}

# Call a tool on the running server
call_tool() {
  if ! is_running; then
    echo -e "${YELLOW}Server not running, starting...${NC}"
    start_server
  fi
  
  local tool_name="$1"
  shift
  
  # Build arguments JSON
  local args=()
  while [[ $# -gt 0 ]]; do
    case $1 in
      --*)
        local key="${1#--}"
        local value="$2"
        if [[ "$value" =~ ^[0-9]+$ ]]; then
          args+=("\"$key\": $value")
        elif [[ "$value" == "true" || "$value" == "false" ]]; then
          args+=("\"$key\": $value")
        else
          value="${value//\"/\\\"}"
          args+=("\"$key\": \"$value\"")
        fi
        shift 2
        ;;
      *) shift ;;
    esac
  done
  
  local IFS=','
  local args_json="{${args[*]}}"
  
  # Build request
  local request="{\"jsonrpc\":\"2.0\",\"id\":$RANDOM,\"method\":\"tools/call\",\"params\":{\"name\":\"$tool_name\",\"arguments\":$args_json}}"
  
  # Send request
  echo "$request" > "$FIFO_IN"
  
  # Read response (with timeout)
  local response
  response=$(timeout 30 head -1 "$FIFO_OUT" 2>/dev/null)
  
  # Extract result
  if echo "$response" | jq -e '.error' > /dev/null 2>&1; then
    echo "$response" | jq -r '.error.message // .error' >&2
    return 1
  fi
  
  echo "$response" | jq -r '.result.content[0].text // .result // empty' 2>/dev/null | jq . 2>/dev/null || echo "$response"
}

# Main
case "${1:-}" in
  start)
    start_server
    ;;
  stop)
    stop_server
    ;;
  status)
    server_status
    ;;
  restart)
    stop_server
    start_server
    ;;
  call)
    shift
    call_tool "$@"
    ;;
  *)
    echo "Usage: $0 {start|stop|status|restart|call <tool> [--arg value ...]}"
    echo ""
    echo "Examples:"
    echo "  $0 start                           # Start server"
    echo "  $0 call list-mail-messages --top 5 # Call tool"
    echo "  $0 stop                            # Stop server"
    exit 1
    ;;
esac

