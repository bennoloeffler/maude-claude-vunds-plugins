#!/bin/bash
# start-mcp-server.sh - Start the MS365 MCP server
#
# Credential Resolution Order:
#   1. .env file in plugin directory (if exists)
#   2. Shell environment variables (if set)
#   3. Error with clear instructions
#
# Usage:
#   ./start-mcp-server.sh              # Start with default settings
#   ./start-mcp-server.sh --org-mode   # Include Teams, SharePoint, etc.
#   ./start-mcp-server.sh --preset mail # Only email tools
#   ./start-mcp-server.sh --login      # Interactive login

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(dirname "$SCRIPT_DIR")"
ENV_FILE="$PLUGIN_DIR/.env"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

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

Credential Setup:
  Option 1: Create .env file in plugin directory
  Option 2: Set shell environment variables

Examples:
  ./start-mcp-server.sh                  # Start with all personal tools
  ./start-mcp-server.sh --preset mail    # Only email tools
  ./start-mcp-server.sh --org-mode       # Include Teams/SharePoint
  ./start-mcp-server.sh --login          # Interactive login first

For more info: https://github.com/softeria/ms-365-mcp-server
EOF
  exit 0
}

# Show setup instructions when credentials are missing
show_setup_instructions() {
  echo ""
  echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${RED}  ERROR: Microsoft 365 credentials not configured${NC}"
  echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  echo -e "${YELLOW}Missing required credentials:${NC}"
  [[ -z "$MS365_CLIENT_ID" ]] && echo "  • MS365_CLIENT_ID"
  [[ -z "$MS365_TENANT_ID" ]] && echo "  • MS365_TENANT_ID"
  echo ""
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${CYAN}  OPTION 1: Create .env file (recommended)${NC}"
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  echo "  Create file: $ENV_FILE"
  echo ""
  echo -e "${GREEN}  # Contents of .env:${NC}"
  echo "  MS365_CLIENT_ID=your-azure-app-client-id"
  echo "  MS365_TENANT_ID=your-azure-tenant-id"
  echo "  MS365_CLIENT_SECRET=your-client-secret  # Optional"
  echo ""
  echo "  Quick command to create from template:"
  echo -e "  ${GREEN}cp $PLUGIN_DIR/.env.example $ENV_FILE${NC}"
  echo "  Then edit .env with your credentials."
  echo ""
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${CYAN}  OPTION 2: Set shell environment variables${NC}"
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  echo "  Add to your ~/.zshrc or ~/.bashrc:"
  echo ""
  echo -e "${GREEN}  export MS365_CLIENT_ID='your-azure-app-client-id'${NC}"
  echo -e "${GREEN}  export MS365_TENANT_ID='your-azure-tenant-id'${NC}"
  echo -e "${GREEN}  export MS365_CLIENT_SECRET='your-client-secret'${NC}  # Optional"
  echo ""
  echo "  Then run: source ~/.zshrc"
  echo ""
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${CYAN}  HOW TO GET AZURE CREDENTIALS${NC}"
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  echo "  1. Go to: https://portal.azure.com"
  echo "  2. Navigate to: Azure Active Directory → App registrations"
  echo "  3. Click: 'New registration'"
  echo "  4. Set name: 'MS365 MCP Server'"
  echo "  5. Copy the 'Application (client) ID' → MS365_CLIENT_ID"
  echo "  6. Copy the 'Directory (tenant) ID' → MS365_TENANT_ID"
  echo "  7. Go to: Certificates & secrets → New client secret"
  echo "  8. Copy the secret value → MS365_CLIENT_SECRET"
  echo ""
  echo "  Required API Permissions:"
  echo "  • Mail.Send, Mail.Read"
  echo "  • Calendars.ReadWrite"
  echo "  • Files.ReadWrite"
  echo "  • (Add more as needed)"
  echo ""
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  exit 1
}

# Parse arguments for help first
for arg in "$@"; do
  case $arg in
    -h|--help) show_help;;
  esac
done

# Step 1: Try to load .env file from plugin directory
if [[ -f "$ENV_FILE" ]]; then
  echo -e "${GREEN}📁 Loading credentials from .env file${NC}"
  set -a
  source "$ENV_FILE"
  set +a
else
  echo -e "${YELLOW}ℹ️  No .env file found at $ENV_FILE${NC}"
  echo "   Checking shell environment variables..."
fi

# Step 2: Check if required variables are now set (from .env or shell)
MISSING_VARS=()

if [[ -z "$MS365_CLIENT_ID" ]]; then
  MISSING_VARS+=("MS365_CLIENT_ID")
fi

if [[ -z "$MS365_TENANT_ID" ]]; then
  MISSING_VARS+=("MS365_TENANT_ID")
fi

# Step 3: If any required vars missing, show helpful instructions
if [[ ${#MISSING_VARS[@]} -gt 0 ]]; then
  show_setup_instructions
fi

# All good - show what we're using
echo ""
echo -e "${GREEN}✓ Credentials loaded successfully${NC}"
echo "  Client ID: ${MS365_CLIENT_ID:0:8}...${MS365_CLIENT_ID: -4}"
echo "  Tenant ID: ${MS365_TENANT_ID:0:8}...${MS365_TENANT_ID: -4}"
if [[ -n "$MS365_CLIENT_SECRET" ]]; then
  echo "  Secret:    ****${MS365_CLIENT_SECRET: -4}"
fi
if [[ -n "$MS365_USER" ]]; then
  echo "  User:      $MS365_USER"
fi
echo ""

# Export variables for the MCP server (with MCP naming convention)
export MS365_MCP_CLIENT_ID="$MS365_CLIENT_ID"
export MS365_MCP_TENANT_ID="$MS365_TENANT_ID"
if [[ -n "$MS365_CLIENT_SECRET" ]]; then
  export MS365_MCP_CLIENT_SECRET="$MS365_CLIENT_SECRET"
fi

# Start the server
echo -e "${GREEN}🚀 Starting MS365 MCP Server...${NC}"
echo "   Package: @softeria/ms-365-mcp-server"
if [[ $# -gt 0 ]]; then
  echo "   Options: $*"
fi
echo ""

exec npx -y @softeria/ms-365-mcp-server "$@"
