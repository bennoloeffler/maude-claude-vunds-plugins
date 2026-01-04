# Microsoft 365 Operations (MCP-by-Code)

Knowledge base for MS365 operations using the @softeria/ms-365-mcp-server.

## Server Information

| Property | Value |
|----------|-------|
| Package | `@softeria/ms-365-mcp-server` |
| Version | 0.29.0 |
| GitHub | https://github.com/softeria/ms-365-mcp-server |
| Transport | stdio (default), HTTP (optional) |

## Authentication Methods

### 1. Device Code Flow (Default)

Interactive authentication for personal use:

```bash
# Via CLI
npx @softeria/ms-365-mcp-server --login

# Via MCP tool
Use the `login` tool, then `verify-login`
```

### 2. Azure AD App Registration

For production/automated use, create an Azure AD app:

1. Go to Azure Portal > Azure AD > App registrations
2. Create new registration
3. Set redirect URI for your app type
4. Get Client ID and (optionally) Client Secret
5. Set environment variables:

```bash
export MS365_CLIENT_ID='your-client-id'
export MS365_TENANT_ID='your-tenant-id'
export MS365_CLIENT_SECRET='your-secret'  # Optional
```

### 3. Bring Your Own Token (BYOT)

For systems with external OAuth management:

```bash
MS365_MCP_OAUTH_TOKEN='your-token' npx @softeria/ms-365-mcp-server
```

## Tool Categories

### Personal Account Tools (Default)

| Category | Tools | Description |
|----------|-------|-------------|
| Email | 8 tools | Send, read, delete, move emails |
| Calendar | 7 tools | List, create, update, delete events |
| Files | 7 tools | OneDrive operations |
| Excel | 5 tools | Spreadsheet operations |
| OneNote | 5 tools | Notebook operations |
| Tasks | 6 tools | To Do list management |
| Planner | 5 tools | Planner task management |
| Contacts | 5 tools | Outlook contacts |
| Search | 1 tool | Microsoft Search |
| User | 1 tool | Get current user |

### Organization Tools (--org-mode)

| Category | Tools | Description |
|----------|-------|-------------|
| Teams | 15+ tools | Chats, channels, messages |
| SharePoint | 12+ tools | Sites, lists, documents |
| Shared Mailboxes | 4 tools | Shared inbox access |
| Users | 1 tool | Organization user directory |

## Common Operations

### Send Email

```
Tool: send-mail
Parameters:
  - to: "recipient@example.com" (required, comma-separated for multiple)
  - subject: "Subject line" (required)
  - body: "Email content" (required)
  - content-type: "text" or "html" (optional)
  - cc: "cc@example.com" (optional)
  - bcc: "bcc@example.com" (optional)
```

### List Inbox

```
Tool: list-mail-messages
Parameters:
  - top: 10 (optional, number of messages)
  - filter: "isRead eq false" (optional, OData filter)
```

### Create Calendar Event

```
Tool: create-calendar-event
Parameters:
  - subject: "Meeting Title" (required)
  - start: "2026-01-05T14:00:00" (required, ISO 8601)
  - end: "2026-01-05T15:00:00" (required, ISO 8601)
  - body: "Description" (optional)
  - location: "Conference Room A" (optional)
  - attendees: "person@example.com" (optional, comma-separated)
```

### Get Calendar View

```
Tool: get-calendar-view
Parameters:
  - start-date-time: "2026-01-04T00:00:00Z" (required)
  - end-date-time: "2026-01-11T23:59:59Z" (required)
```

### Upload File to OneDrive

```
Tool: upload-new-file
Parameters:
  - filename: "document.txt" (required)
  - content: "File content" (required)
  - folder-id: "folder-id" (optional, defaults to root)
```

## OData Filters

Common filters for list operations:

| Filter | Description |
|--------|-------------|
| `isRead eq false` | Unread emails |
| `from/emailAddress/address eq 'x@y.com'` | Emails from specific sender |
| `receivedDateTime ge 2026-01-01T00:00:00Z` | Emails after date |
| `subject eq 'test'` | Exact subject match |
| `contains(subject, 'meeting')` | Subject contains |

## Server Options

### Presets (Reduce Token Usage)

```bash
npx @softeria/ms-365-mcp-server --preset mail      # Only email
npx @softeria/ms-365-mcp-server --preset calendar  # Only calendar
npx @softeria/ms-365-mcp-server --preset files     # Only OneDrive
npx @softeria/ms-365-mcp-server --preset personal  # All personal (no Teams)
npx @softeria/ms-365-mcp-server --preset work      # Teams, SharePoint only
```

### Read-Only Mode

```bash
npx @softeria/ms-365-mcp-server --read-only
# Disables: send-mail, delete-*, create-*, update-*
```

### TOON Format (Token Reduction)

```bash
npx @softeria/ms-365-mcp-server --toon
# 30-60% fewer tokens in responses
```

### Discovery Mode (Minimal)

```bash
npx @softeria/ms-365-mcp-server --discovery
# Only 2 tools: search-tools, execute-tool
```

## Error Codes

| Error | Cause | Solution |
|-------|-------|----------|
| `Authorization_RequestDenied` | Missing permissions | Check app permissions in Azure |
| `InvalidAuthenticationToken` | Token expired | Re-authenticate with `login` |
| `ResourceNotFound` | Item doesn't exist | Verify ID is correct |
| `AccessDenied` | No access to resource | Check sharing permissions |

## Graph API Endpoints

Reference for understanding tool behavior:

| Tool | Graph API |
|------|-----------|
| send-mail | POST /me/sendMail |
| list-mail-messages | GET /me/messages |
| list-calendar-events | GET /me/events |
| create-calendar-event | POST /me/events |
| list-folder-files | GET /me/drive/root/children |
| upload-new-file | PUT /me/drive/root:/{filename}:/content |

## Required Permissions

### Personal (Delegated)

- Mail.Read, Mail.Send
- Calendars.ReadWrite
- Files.ReadWrite
- Tasks.ReadWrite
- Contacts.ReadWrite

### Organization (Delegated)

- Team.ReadBasic.All
- Chat.ReadWrite
- Sites.Read.All
- User.Read.All (for list-users)

## References

- [MS Graph API Documentation](https://docs.microsoft.com/en-us/graph/)
- [MCP Server GitHub](https://github.com/softeria/ms-365-mcp-server)
- [Azure AD App Registration](https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app)

