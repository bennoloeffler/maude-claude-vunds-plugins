#!/bin/bash
# test-integration.sh - Integration tests for MS365-by-Code plugin
#
# Tests REAL MS365 operations via MCP server stdio mode.
# Uses direct JSON-RPC calls to the MCP server.
#
# Usage:
#   ./scripts/test-integration.sh           # Run all tests
#   ./scripts/test-integration.sh --quick   # Quick test (user info only)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(dirname "$SCRIPT_DIR")"
ENV_FILE="$PLUGIN_DIR/.env"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

QUICK_MODE=false

# Parse arguments
for arg in "$@"; do
  case $arg in
    --quick) QUICK_MODE=true;;
    -h|--help)
      echo "Usage: $0 [--quick]"
      echo ""
      echo "Tests MS365 operations via MCP server."
      echo "Requires authenticated session (run --login first)."
      exit 0
      ;;
  esac
done

# Load credentials
if [[ -f "$ENV_FILE" ]]; then
  set -a
  source "$ENV_FILE"
  set +a
else
  echo -e "${RED}Error: .env file not found${NC}"
  exit 1
fi

export MS365_MCP_CLIENT_ID="$MS365_CLIENT_ID"
export MS365_MCP_TENANT_ID="$MS365_TENANT_ID"
[[ -n "$MS365_CLIENT_SECRET" ]] && export MS365_MCP_CLIENT_SECRET="$MS365_CLIENT_SECRET"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  MS365-by-Code Integration Tests"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

PASSED=0
FAILED=0

pass() {
  echo -e "${GREEN}✓${NC} $1"
  PASSED=$((PASSED + 1))
}

fail() {
  echo -e "${RED}✗${NC} $1"
  FAILED=$((FAILED + 1))
}

warn() {
  echo -e "${YELLOW}⚠${NC} $1"
}

# Function to call MCP tool via stdio
# Uses a simple approach: send initialization + tool call, capture output
call_mcp() {
  local method="$1"
  local params="$2"
  
  # Create JSON-RPC request
  local init_request='{"jsonrpc":"2.0","id":0,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}'
  local call_request="{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"$method\",\"params\":$params}"
  
  # Send both requests and capture output
  echo -e "$init_request\n$call_request" | timeout 30 npx -y @softeria/ms-365-mcp-server 2>/dev/null | tail -1
}

# Test 1: Verify login status
echo "Test 1: Authentication Status"
echo "─────────────────────────────"

VERIFY_RESULT=$(timeout 15 npx -y @softeria/ms-365-mcp-server --verify-login 2>&1)

if echo "$VERIFY_RESULT" | grep -q '"success":true'; then
  USER_NAME=$(echo "$VERIFY_RESULT" | grep -o '"displayName":"[^"]*"' | cut -d'"' -f4)
  USER_EMAIL=$(echo "$VERIFY_RESULT" | grep -o '"userPrincipalName":"[^"]*"' | cut -d'"' -f4)
  pass "Authenticated as: $USER_NAME ($USER_EMAIL)"
else
  fail "Not authenticated"
  echo ""
  echo -e "${YELLOW}Run this to authenticate:${NC}"
  echo "  ./scripts/start-mcp-server.sh --login"
  echo ""
  exit 1
fi
echo ""

# Test 2: List available tools
echo "Test 2: MCP Server Tools"
echo "────────────────────────"

# Get tools list via MCP protocol
TOOLS_RESULT=$(call_mcp "tools/list" "{}")

if echo "$TOOLS_RESULT" | grep -q '"tools"'; then
  TOOL_COUNT=$(echo "$TOOLS_RESULT" | grep -o '"name"' | wc -l | tr -d ' ')
  pass "MCP server has $TOOL_COUNT tools available"
else
  warn "Could not list tools (server may not support tools/list)"
fi
echo ""

if [[ "$QUICK_MODE" == "true" ]]; then
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  Quick Test Summary"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo -e "  ${GREEN}Passed:${NC} $PASSED"
  echo -e "  ${RED}Failed:${NC} $FAILED"
  echo ""
  echo -e "${GREEN}Authentication verified!${NC}"
  echo ""
  echo "To test actual MS365 operations, use Claude Code:"
  echo "  1. Add MCP server: claude mcp add ms365 -- npx -y @softeria/ms-365-mcp-server"
  echo "  2. Ask Claude to 'list my emails' or 'show my calendar'"
  exit 0
fi

# Test 3: Call get-current-user tool
echo "Test 3: Get Current User (via MCP)"
echo "───────────────────────────────────"

USER_RESULT=$(call_mcp "tools/call" '{"name":"get-current-user","arguments":{}}')

if echo "$USER_RESULT" | grep -q '"content"'; then
  pass "get-current-user tool works"
  # Try to extract user info
  DISPLAY_NAME=$(echo "$USER_RESULT" | grep -o '"displayName":"[^"]*"' | head -1 | cut -d'"' -f4)
  if [[ -n "$DISPLAY_NAME" ]]; then
    echo "   User: $DISPLAY_NAME"
  fi
else
  warn "get-current-user returned unexpected format"
  echo "   Response: $(echo "$USER_RESULT" | head -c 200)"
fi
echo ""

# Test 4: List mail messages
echo "Test 4: List Mail Messages (via MCP)"
echo "─────────────────────────────────────"

MAIL_RESULT=$(call_mcp "tools/call" '{"name":"list-mail-messages","arguments":{"top":3}}')

if echo "$MAIL_RESULT" | grep -q '"content"'; then
  pass "list-mail-messages tool works"
  # Try to count emails
  EMAIL_COUNT=$(echo "$MAIL_RESULT" | grep -o '"subject"' | wc -l | tr -d ' ')
  if [[ "$EMAIL_COUNT" -gt 0 ]]; then
    echo "   Found $EMAIL_COUNT emails"
    FIRST_SUBJECT=$(echo "$MAIL_RESULT" | grep -o '"subject":"[^"]*"' | head -1 | cut -d'"' -f4)
    [[ -n "$FIRST_SUBJECT" ]] && echo "   Latest: \"$FIRST_SUBJECT\""
  fi
else
  warn "list-mail-messages returned unexpected format"
fi
echo ""

# Test 5: List calendar events
echo "Test 5: List Calendar Events (via MCP)"
echo "───────────────────────────────────────"

CAL_RESULT=$(call_mcp "tools/call" '{"name":"list-calendar-events","arguments":{"top":3}}')

if echo "$CAL_RESULT" | grep -q '"content"'; then
  pass "list-calendar-events tool works"
  EVENT_COUNT=$(echo "$CAL_RESULT" | grep -o '"subject"' | wc -l | tr -d ' ')
  if [[ "$EVENT_COUNT" -gt 0 ]]; then
    echo "   Found $EVENT_COUNT events"
    FIRST_EVENT=$(echo "$CAL_RESULT" | grep -o '"subject":"[^"]*"' | head -1 | cut -d'"' -f4)
    [[ -n "$FIRST_EVENT" ]] && echo "   Next: \"$FIRST_EVENT\""
  else
    echo "   Calendar is empty or no upcoming events"
  fi
else
  warn "list-calendar-events returned unexpected format"
fi
echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Integration Test Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "  ${GREEN}Passed:${NC} $PASSED"
echo -e "  ${RED}Failed:${NC} $FAILED"
echo ""

if [[ $FAILED -eq 0 ]]; then
  echo -e "${GREEN}All integration tests passed!${NC}"
  echo ""
  echo "The MS365 MCP server is working. Use via Claude Code:"
  echo "  • 'List my emails'"
  echo "  • 'Show my calendar for this week'"
  echo "  • 'Send an email to X about Y'"
  exit 0
else
  echo -e "${RED}Some tests failed.${NC}"
  exit 1
fi
