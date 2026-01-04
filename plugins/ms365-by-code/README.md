# MS365-by-Code Plugin

**Microsoft 365 integration via MCP-by-Code pattern - NO MCP REGISTRATION!**

## ⚠️ WHY NOT REGISTER MCP?

```
BECAUSE IT FLOODS THE CONTEXT!

Traditional MCP:
  claude mcp add ms365 -- npx @softeria/ms-365-mcp-server
  → 87 tool definitions loaded = ~10,000 tokens WASTED
  → With 5 MCP servers = 50,000+ tokens GONE before you even start!
```

## ✅ MCP-by-Code Solution

**DO NOT register the MCP server with Claude Code!**

Instead:
1. Sub-agent uses `["Bash", "Read"]` tools (NOT `mcp__ms365__*`)
2. Agent calls `./scripts/ms365-call.sh <tool> --params`
3. Script starts MCP server, calls tool, returns result, exits
4. **Main context sees ZERO tool definitions!**

**Result:** 
- Traditional MCP: **67,300 tokens** wasted (33% of context)
- MCP-by-Code: **~1,000 tokens** per operation
- **Savings: ~98%**

## Prerequisites

1. **Node.js 20+** (recommended)
2. **Azure AD App Registration** with:
   - Application (client) ID
   - Tenant ID
   - Client Secret (optional for public apps)

## Setup

### 1. Set Environment Variables

```bash
# Required
export MS365_CLIENT_ID='your-azure-app-client-id'
export MS365_TENANT_ID='your-tenant-id'

# Optional
export MS365_CLIENT_SECRET='your-client-secret'
```

Or create a `.env` file in the plugin directory:

```bash
MS365_CLIENT_ID=your-azure-app-client-id
MS365_TENANT_ID=your-tenant-id
MS365_CLIENT_SECRET=your-client-secret
```

### 2. Authenticate

```bash
# Interactive login
./scripts/start-mcp-server.sh --login

# Follow the device code flow in browser
```

## Usage

### From Claude Code

The main agent spawns `ms365-agent` for MS365 tasks:

```
User: "Send an email to bob@example.com about our meeting"
Claude: [spawns ms365-agent]
ms365-agent: [uses send-mail tool via MCP server]
→ "Email sent to bob@example.com"
```

### Testing Scripts

```bash
cd ~/.claude/plugins/ms365-by-code

# Discover tools
./scripts/discover-tools.sh                    # Overview
./scripts/discover-tools.sh --category email   # Email tools
./scripts/discover-tools.sh --preset work      # Teams/SharePoint
./scripts/discover-tools.sh --tool send-mail   # Specific tool

# Start MCP server
./scripts/start-mcp-server.sh                  # Default
./scripts/start-mcp-server.sh --preset mail    # Only email tools
./scripts/start-mcp-server.sh --org-mode       # Include Teams/SharePoint
```

## Available Tools

### Personal Account (Default)

| Category | Tools | Examples |
|----------|-------|----------|
| **Email** | 8 | send-mail, list-mail-messages, get-mail-message |
| **Calendar** | 7 | create-calendar-event, get-calendar-view |
| **Files** | 7 | list-folder-files, upload-new-file |
| **Tasks** | 6 | create-todo-task, list-todo-tasks |
| **Contacts** | 5 | create-outlook-contact, list-outlook-contacts |
| **Excel** | 5 | get-excel-range, create-excel-chart |
| **OneNote** | 5 | create-onenote-page, list-onenote-notebooks |

### Organization (--org-mode)

| Category | Tools | Examples |
|----------|-------|----------|
| **Teams** | 15+ | send-chat-message, list-joined-teams |
| **SharePoint** | 12+ | search-sharepoint-sites, list-sharepoint-site-lists |
| **Users** | 1 | list-users |

## Server Options

```bash
# Personal mode (default)
./scripts/start-mcp-server.sh

# Organization mode (Teams, SharePoint)
./scripts/start-mcp-server.sh --org-mode

# Presets (reduce token usage)
./scripts/start-mcp-server.sh --preset mail
./scripts/start-mcp-server.sh --preset calendar
./scripts/start-mcp-server.sh --preset files

# Read-only mode
./scripts/start-mcp-server.sh --read-only

# TOON format (30-60% fewer tokens)
./scripts/start-mcp-server.sh --toon
```

## Structure

```
ms365-by-code/
├── agents/
│   └── ms365-agent.md        # Sub-agent definition
├── scripts/
│   ├── start-mcp-server.sh   # MCP server starter
│   └── discover-tools.sh     # Tool discovery
├── skills/
│   └── ms365/
│       └── SKILL.md          # API knowledge
├── commands/
│   └── ms365.md              # /ms365 command
└── README.md
```

## Azure AD Setup

1. Go to [Azure Portal](https://portal.azure.com)
2. Navigate to Azure Active Directory > App registrations
3. Click "New registration"
4. Set name: "MS365 MCP Server"
5. Under Authentication, add redirect URI for your platform
6. Copy the Application (client) ID
7. Go to Certificates & secrets > New client secret
8. Copy the secret value

## Troubleshooting

### "Missing required environment variables"

Set MS365_CLIENT_ID and MS365_TENANT_ID:
```bash
export MS365_CLIENT_ID='...'
export MS365_TENANT_ID='...'
```

### "Authorization_RequestDenied"

Your Azure app needs permissions. In Azure Portal:
1. Go to API permissions
2. Add: Mail.Send, Calendars.ReadWrite, Files.ReadWrite, etc.
3. Grant admin consent if required

### "InvalidAuthenticationToken"

Token expired. Re-authenticate:
```bash
./scripts/start-mcp-server.sh --login
```

## References

- [MS365 MCP Server](https://github.com/softeria/ms-365-mcp-server)
- [Microsoft Graph API](https://docs.microsoft.com/en-us/graph/)
- [MCP-by-Code Concept](docs/MCP-BY-CODE-CONCEPT.md)

## License

MIT

