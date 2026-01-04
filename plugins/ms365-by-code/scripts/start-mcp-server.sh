#!/bin/bash
# start-mcp-server.sh - Start the MS365 MCP server
#
# This script starts the @softeria/ms-365-mcp-server MCP server.
# 
# REQUIRED: Set these environment variables before running:
#   MS365_CLIENT_ID     - Azure AD Application (client) ID
#   MS365_TENANT_ID     - Azure AD Tenant ID
#   MS365_CLIENT_SECRET - Azure AD Client Secret (optional for public apps)
#
# Usage:
#   ./start-mcp-server.sh              # Start with default settings
#   ./start-mcp-server.sh --org-mode   # Include Teams, SharePoint, etc.
#   ./start-mcp-server.sh --preset mail # Only email tools
#   ./start-mcp-server.sh --http 3000  # Start HTTP server on port 3000

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(dirname "$SCRIPT_DIR")"

# Check for required environment variables
check_env() {
  local missing=()
  
  if [[ -z "$MS365_CLIENT_ID" ]]; then
    missing+=("MS365_CLIENT_ID")
  fi
  if [[ -z "$MS365_TENANT_ID" ]]; then
    missing+=("MS365_TENANT_ID")
  fi
  
  if [[ ${#missing[@]} -gt 0 ]]; then
    echo "❌ Error: Missing required environment variables:"
    for var in "${missing[@]}"; do
      echo "   - $var"
    done
    echo ""
    echo "Please set these in your environment or in a .env file:"
    echo ""
    echo "   export MS365_CLIENT_ID='your-azure-app-client-id'"
    echo "   export MS365_TENANT_ID='your-tenant-id'"
    echo "   export MS365_CLIENT_SECRET='your-client-secret'  # Optional for public apps"
    echo ""
    echo "Then run this script again."
    exit 1
  fi
}

# Help text
show_help() {
  cat << 'EOF'
MS365 MCP Server Starter

Usage: ./start-mcp-server.sh [OPTIONS]

Options:
  --org-mode        Enable organization/work mode (Teams, SharePoint, etc.)
  --preset <name>   Use preset tool categories:
                    mail, calendar, files, personal, work, excel,
                    contacts, tasks, onenote, search, users, all
  --http [port]     Start HTTP server (default port: 3000)
  --toon            Enable TOON output format (30-60% token reduction)
  --read-only       Disable write operations
  --login           Interactive login via device code
  --logout          Clear saved credentials
  --verify-login    Verify login status
  -h, --help        Show this help message

Environment Variables:
  MS365_CLIENT_ID      Required. Azure AD Application (client) ID
  MS365_TENANT_ID      Required. Azure AD Tenant ID  
  MS365_CLIENT_SECRET  Optional. Client secret for confidential apps

Examples:
  # Start with all personal tools
  ./start-mcp-server.sh
  
  # Start with only email tools
  ./start-mcp-server.sh --preset mail
  
  # Start with work features (Teams, SharePoint)
  ./start-mcp-server.sh --org-mode
  
  # Start HTTP server on port 8080
  ./start-mcp-server.sh --http 8080

For more info: https://github.com/softeria/ms-365-mcp-server
EOF
  exit 0
}

# Parse arguments for help
for arg in "$@"; do
  case $arg in
    -h|--help) show_help;;
  esac
done

# Load .env file if it exists
if [[ -f "$PLUGIN_DIR/.env" ]]; then
  set -a
  source "$PLUGIN_DIR/.env"
  set +a
fi

# Check environment
check_env

# Export variables for the MCP server
export MS365_MCP_CLIENT_ID="$MS365_CLIENT_ID"
export MS365_MCP_TENANT_ID="$MS365_TENANT_ID"
if [[ -n "$MS365_CLIENT_SECRET" ]]; then
  export MS365_MCP_CLIENT_SECRET="$MS365_CLIENT_SECRET"
fi

echo "🚀 Starting MS365 MCP Server..."
echo "   Client ID: ${MS365_CLIENT_ID:0:8}..."
echo "   Tenant ID: ${MS365_TENANT_ID:0:8}..."
echo ""

# Start the MCP server
exec npx -y @softeria/ms-365-mcp-server "$@"

