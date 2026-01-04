#!/bin/bash
# test-plugin.sh - Test MS365-by-Code plugin
#
# This script tests:
# 1. Environment setup (.env loading)
# 2. discover-tools.sh functionality
# 3. MCP server startup and login verification
#
# Usage:
#   ./scripts/test-plugin.sh           # Run all tests
#   ./scripts/test-plugin.sh --quick   # Skip MCP server test

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(dirname "$SCRIPT_DIR")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

QUICK_MODE=false
PASSED=0
FAILED=0

# Parse arguments
for arg in "$@"; do
  case $arg in
    --quick) QUICK_MODE=true;;
  esac
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  MS365-by-Code Plugin Test Suite"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

pass() {
  echo -e "${GREEN}✓${NC} $1"
  ((PASSED++))
}

fail() {
  echo -e "${RED}✗${NC} $1"
  ((FAILED++))
}

warn() {
  echo -e "${YELLOW}⚠${NC} $1"
}

# Test 1: Check .env file exists
echo "Test 1: Environment Setup"
echo "─────────────────────────"
if [[ -f "$PLUGIN_DIR/.env" ]]; then
  pass ".env file exists"
  
  # Source and verify variables
  set -a
  source "$PLUGIN_DIR/.env"
  set +a
  
  if [[ -n "$MS365_CLIENT_ID" ]]; then
    pass "MS365_CLIENT_ID is set (${MS365_CLIENT_ID:0:8}...)"
  else
    fail "MS365_CLIENT_ID is not set"
  fi
  
  if [[ -n "$MS365_TENANT_ID" ]]; then
    pass "MS365_TENANT_ID is set (${MS365_TENANT_ID:0:8}...)"
  else
    fail "MS365_TENANT_ID is not set"
  fi
  
  if [[ -n "$MS365_CLIENT_SECRET" ]]; then
    pass "MS365_CLIENT_SECRET is set"
  else
    warn "MS365_CLIENT_SECRET is not set (optional)"
  fi
else
  fail ".env file not found"
  echo "   Create .env from .env.example with your Azure AD credentials"
fi
echo ""

# Test 2: discover-tools.sh
echo "Test 2: Tool Discovery"
echo "──────────────────────"

# Test basic discovery
if OUTPUT=$("$SCRIPT_DIR/discover-tools.sh" 2>&1); then
  if echo "$OUTPUT" | jq -e '.service == "MS365"' > /dev/null 2>&1; then
    pass "discover-tools.sh returns valid JSON"
    TOOL_COUNT=$(echo "$OUTPUT" | jq '[.categories[].tool_count] | add')
    pass "Found $TOOL_COUNT tools across categories"
  else
    fail "discover-tools.sh JSON invalid"
  fi
else
  fail "discover-tools.sh failed to execute"
fi

# Test category filter
if OUTPUT=$("$SCRIPT_DIR/discover-tools.sh" --category email 2>&1); then
  if echo "$OUTPUT" | jq -e '.category.tools | length > 0' > /dev/null 2>&1; then
    EMAIL_TOOLS=$(echo "$OUTPUT" | jq '.category.tools | length')
    pass "--category email returns $EMAIL_TOOLS email tools"
  else
    fail "--category email filter failed"
  fi
else
  fail "--category email failed to execute"
fi

# Test tool lookup
if OUTPUT=$("$SCRIPT_DIR/discover-tools.sh" --tool send-mail 2>&1); then
  if echo "$OUTPUT" | jq -e '.name == "send-mail"' > /dev/null 2>&1; then
    pass "--tool send-mail returns correct tool"
  else
    fail "--tool send-mail lookup failed"
  fi
else
  fail "--tool send-mail failed to execute"
fi

# Test preset
if OUTPUT=$("$SCRIPT_DIR/discover-tools.sh" --preset work 2>&1); then
  if echo "$OUTPUT" | jq -e '.preset == "work"' > /dev/null 2>&1; then
    pass "--preset work returns org-mode tools"
  else
    fail "--preset work failed"
  fi
else
  fail "--preset work failed to execute"
fi
echo ""

# Test 3: start-mcp-server.sh
echo "Test 3: MCP Server Script"
echo "─────────────────────────"

# Test help works
if "$SCRIPT_DIR/start-mcp-server.sh" --help > /dev/null 2>&1; then
  pass "start-mcp-server.sh --help works"
else
  fail "start-mcp-server.sh --help failed"
fi

# Check npm/npx available
if command -v npx &> /dev/null; then
  pass "npx is available"
else
  fail "npx not found - install Node.js"
fi
echo ""

# Test 4: MCP Server Connection (optional)
if [[ "$QUICK_MODE" == "false" ]]; then
  echo "Test 4: MCP Server Connection"
  echo "──────────────────────────────"
  
  if [[ -z "$MS365_CLIENT_ID" || -z "$MS365_TENANT_ID" ]]; then
    warn "Skipping server test - credentials not set"
  else
    echo "   Testing login verification (this may take a few seconds)..."
    
    # Export for the server
    export MS365_MCP_CLIENT_ID="$MS365_CLIENT_ID"
    export MS365_MCP_TENANT_ID="$MS365_TENANT_ID"
    if [[ -n "$MS365_CLIENT_SECRET" ]]; then
      export MS365_MCP_CLIENT_SECRET="$MS365_CLIENT_SECRET"
    fi
    
    # Try to verify login status
    if timeout 30 npx -y @softeria/ms-365-mcp-server --verify-login 2>&1 | grep -q -i "logged in\|authenticated\|token"; then
      pass "MCP server can verify authentication"
    else
      warn "Not logged in yet - run: ./scripts/start-mcp-server.sh --login"
    fi
  fi
  echo ""
fi

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Test Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "  ${GREEN}Passed:${NC} $PASSED"
echo -e "  ${RED}Failed:${NC} $FAILED"
echo ""

if [[ $FAILED -eq 0 ]]; then
  echo -e "${GREEN}All tests passed!${NC}"
  exit 0
else
  echo -e "${RED}Some tests failed.${NC}"
  exit 1
fi

