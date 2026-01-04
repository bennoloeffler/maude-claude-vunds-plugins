#!/bin/bash
# discover-tools.sh - List available MS365 tools (MCP-by-Code pattern)
#
# This script returns available tools from the @softeria/ms-365-mcp-server
# in JSON format, enabling progressive disclosure and lazy loading.
#
# Usage:
#   ./discover-tools.sh                    # List all tools
#   ./discover-tools.sh --category email   # Filter by category
#   ./discover-tools.sh --tool send-mail   # Get details for specific tool
#   ./discover-tools.sh --preset mail      # Show tools from a preset

set -e

# Parse arguments
CATEGORY=""
TOOL=""
PRESET=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --category) CATEGORY="$2"; shift 2;;
    --tool) TOOL="$2"; shift 2;;
    --preset) PRESET="$2"; shift 2;;
    -h|--help)
      echo "Usage: $0 [--category <category>] [--tool <tool-name>] [--preset <preset>]"
      echo ""
      echo "Categories: email, calendar, files, excel, onenote, tasks, planner, contacts, search, teams, sharepoint, users"
      echo "Presets: mail, calendar, files, personal, work, excel, contacts, tasks, onenote, search, users, all"
      exit 0
      ;;
    *) shift;;
  esac
done

# Complete tool catalog based on @softeria/ms-365-mcp-server v0.29.0
TOOLS_JSON=$(cat << 'EOF'
{
  "service": "MS365",
  "version": "0.29.0",
  "server": "@softeria/ms-365-mcp-server",
  "description": "Microsoft 365 operations via Graph API (MCP-by-Code pattern)",
  "documentation": "https://github.com/softeria/ms-365-mcp-server",
  "note": "Uses real MS365 MCP server. Requires MS365_CLIENT_ID and MS365_TENANT_ID environment variables.",
  "presets": {
    "mail": "Email tools only",
    "calendar": "Calendar tools only",
    "files": "OneDrive file tools",
    "personal": "All personal account tools",
    "work": "Teams, SharePoint, shared mailboxes",
    "excel": "Excel operations",
    "contacts": "Outlook contacts",
    "tasks": "To Do and Planner tasks",
    "onenote": "OneNote notebooks",
    "search": "Search functionality",
    "users": "User management (org mode)",
    "all": "All available tools"
  },
  "categories": {
    "email": {
      "description": "Email (Outlook) operations",
      "requires_org_mode": false,
      "tools": [
        {
          "name": "list-mail-messages",
          "description": "List email messages from inbox",
          "parameters": {
            "top": {"type": "integer", "required": false, "description": "Number of messages to return"},
            "filter": {"type": "string", "required": false, "description": "OData filter query"}
          }
        },
        {
          "name": "list-mail-folders",
          "description": "List all mail folders",
          "parameters": {}
        },
        {
          "name": "list-mail-folder-messages",
          "description": "List messages from a specific folder",
          "parameters": {
            "folder-id": {"type": "string", "required": true, "description": "Folder ID or well-known name (inbox, drafts, sent)"}
          }
        },
        {
          "name": "get-mail-message",
          "description": "Get a specific email message by ID",
          "parameters": {
            "message-id": {"type": "string", "required": true, "description": "Message ID"}
          }
        },
        {
          "name": "send-mail",
          "description": "Send an email message",
          "parameters": {
            "to": {"type": "string", "required": true, "description": "Recipient email address(es), comma-separated"},
            "subject": {"type": "string", "required": true, "description": "Email subject"},
            "body": {"type": "string", "required": true, "description": "Email body content"},
            "content-type": {"type": "string", "required": false, "description": "text or html (default: text)"},
            "cc": {"type": "string", "required": false, "description": "CC recipients"},
            "bcc": {"type": "string", "required": false, "description": "BCC recipients"}
          }
        },
        {
          "name": "delete-mail-message",
          "description": "Delete an email message",
          "parameters": {
            "message-id": {"type": "string", "required": true, "description": "Message ID to delete"}
          }
        },
        {
          "name": "create-draft-email",
          "description": "Create a draft email",
          "parameters": {
            "to": {"type": "string", "required": true, "description": "Recipient email"},
            "subject": {"type": "string", "required": true, "description": "Subject line"},
            "body": {"type": "string", "required": true, "description": "Email body"}
          }
        },
        {
          "name": "move-mail-message",
          "description": "Move email to a different folder",
          "parameters": {
            "message-id": {"type": "string", "required": true, "description": "Message ID"},
            "destination-folder-id": {"type": "string", "required": true, "description": "Target folder ID"}
          }
        }
      ]
    },
    "calendar": {
      "description": "Calendar operations",
      "requires_org_mode": false,
      "tools": [
        {
          "name": "list-calendars",
          "description": "List all calendars",
          "parameters": {}
        },
        {
          "name": "list-calendar-events",
          "description": "List calendar events",
          "parameters": {
            "calendar-id": {"type": "string", "required": false, "description": "Calendar ID (default: primary)"},
            "top": {"type": "integer", "required": false, "description": "Number of events to return"}
          }
        },
        {
          "name": "get-calendar-event",
          "description": "Get a specific calendar event",
          "parameters": {
            "event-id": {"type": "string", "required": true, "description": "Event ID"}
          }
        },
        {
          "name": "get-calendar-view",
          "description": "Get calendar view for a date range",
          "parameters": {
            "start-date-time": {"type": "string", "required": true, "description": "Start datetime (ISO 8601)"},
            "end-date-time": {"type": "string", "required": true, "description": "End datetime (ISO 8601)"}
          }
        },
        {
          "name": "create-calendar-event",
          "description": "Create a new calendar event",
          "parameters": {
            "subject": {"type": "string", "required": true, "description": "Event title"},
            "start": {"type": "string", "required": true, "description": "Start datetime (ISO 8601)"},
            "end": {"type": "string", "required": true, "description": "End datetime (ISO 8601)"},
            "body": {"type": "string", "required": false, "description": "Event description"},
            "location": {"type": "string", "required": false, "description": "Event location"},
            "attendees": {"type": "string", "required": false, "description": "Comma-separated attendee emails"}
          }
        },
        {
          "name": "update-calendar-event",
          "description": "Update an existing calendar event",
          "parameters": {
            "event-id": {"type": "string", "required": true, "description": "Event ID"},
            "subject": {"type": "string", "required": false, "description": "New title"},
            "start": {"type": "string", "required": false, "description": "New start datetime"},
            "end": {"type": "string", "required": false, "description": "New end datetime"}
          }
        },
        {
          "name": "delete-calendar-event",
          "description": "Delete a calendar event",
          "parameters": {
            "event-id": {"type": "string", "required": true, "description": "Event ID to delete"}
          }
        }
      ]
    },
    "files": {
      "description": "OneDrive file operations",
      "requires_org_mode": false,
      "tools": [
        {
          "name": "list-drives",
          "description": "List available drives",
          "parameters": {}
        },
        {
          "name": "get-drive-root-item",
          "description": "Get the root folder of a drive",
          "parameters": {
            "drive-id": {"type": "string", "required": false, "description": "Drive ID (default: user's drive)"}
          }
        },
        {
          "name": "list-folder-files",
          "description": "List files in a folder",
          "parameters": {
            "folder-id": {"type": "string", "required": false, "description": "Folder ID (default: root)"},
            "path": {"type": "string", "required": false, "description": "Folder path"}
          }
        },
        {
          "name": "download-onedrive-file-content",
          "description": "Download file content",
          "parameters": {
            "item-id": {"type": "string", "required": true, "description": "File item ID"}
          }
        },
        {
          "name": "upload-file-content",
          "description": "Upload/update file content",
          "parameters": {
            "item-id": {"type": "string", "required": true, "description": "File item ID"},
            "content": {"type": "string", "required": true, "description": "File content"}
          }
        },
        {
          "name": "upload-new-file",
          "description": "Upload a new file",
          "parameters": {
            "filename": {"type": "string", "required": true, "description": "File name"},
            "content": {"type": "string", "required": true, "description": "File content"},
            "folder-id": {"type": "string", "required": false, "description": "Parent folder ID"}
          }
        },
        {
          "name": "delete-onedrive-file",
          "description": "Delete a file",
          "parameters": {
            "item-id": {"type": "string", "required": true, "description": "File item ID to delete"}
          }
        }
      ]
    },
    "excel": {
      "description": "Excel operations",
      "requires_org_mode": false,
      "tools": [
        {
          "name": "list-excel-worksheets",
          "description": "List worksheets in an Excel file",
          "parameters": {
            "item-id": {"type": "string", "required": true, "description": "Excel file item ID"}
          }
        },
        {
          "name": "get-excel-range",
          "description": "Get data from a range",
          "parameters": {
            "item-id": {"type": "string", "required": true, "description": "Excel file item ID"},
            "worksheet-name": {"type": "string", "required": true, "description": "Worksheet name"},
            "address": {"type": "string", "required": true, "description": "Range address (e.g., A1:D10)"}
          }
        },
        {
          "name": "create-excel-chart",
          "description": "Create a chart",
          "parameters": {
            "item-id": {"type": "string", "required": true, "description": "Excel file item ID"},
            "worksheet-name": {"type": "string", "required": true, "description": "Worksheet name"},
            "type": {"type": "string", "required": true, "description": "Chart type"},
            "source-data": {"type": "string", "required": true, "description": "Source data range"}
          }
        },
        {
          "name": "format-excel-range",
          "description": "Format a range",
          "parameters": {
            "item-id": {"type": "string", "required": true, "description": "Excel file item ID"},
            "worksheet-name": {"type": "string", "required": true, "description": "Worksheet name"},
            "address": {"type": "string", "required": true, "description": "Range address"}
          }
        },
        {
          "name": "sort-excel-range",
          "description": "Sort a range",
          "parameters": {
            "item-id": {"type": "string", "required": true, "description": "Excel file item ID"},
            "worksheet-name": {"type": "string", "required": true, "description": "Worksheet name"},
            "address": {"type": "string", "required": true, "description": "Range address"}
          }
        }
      ]
    },
    "onenote": {
      "description": "OneNote operations",
      "requires_org_mode": false,
      "tools": [
        {
          "name": "list-onenote-notebooks",
          "description": "List OneNote notebooks",
          "parameters": {}
        },
        {
          "name": "list-onenote-notebook-sections",
          "description": "List sections in a notebook",
          "parameters": {
            "notebook-id": {"type": "string", "required": true, "description": "Notebook ID"}
          }
        },
        {
          "name": "list-onenote-section-pages",
          "description": "List pages in a section",
          "parameters": {
            "section-id": {"type": "string", "required": true, "description": "Section ID"}
          }
        },
        {
          "name": "get-onenote-page-content",
          "description": "Get page content",
          "parameters": {
            "page-id": {"type": "string", "required": true, "description": "Page ID"}
          }
        },
        {
          "name": "create-onenote-page",
          "description": "Create a new page",
          "parameters": {
            "section-id": {"type": "string", "required": true, "description": "Section ID"},
            "title": {"type": "string", "required": true, "description": "Page title"},
            "content": {"type": "string", "required": true, "description": "HTML content"}
          }
        }
      ]
    },
    "tasks": {
      "description": "To Do tasks",
      "requires_org_mode": false,
      "tools": [
        {
          "name": "list-todo-task-lists",
          "description": "List To Do task lists",
          "parameters": {}
        },
        {
          "name": "list-todo-tasks",
          "description": "List tasks in a list",
          "parameters": {
            "task-list-id": {"type": "string", "required": true, "description": "Task list ID"}
          }
        },
        {
          "name": "get-todo-task",
          "description": "Get a specific task",
          "parameters": {
            "task-list-id": {"type": "string", "required": true, "description": "Task list ID"},
            "task-id": {"type": "string", "required": true, "description": "Task ID"}
          }
        },
        {
          "name": "create-todo-task",
          "description": "Create a new task",
          "parameters": {
            "task-list-id": {"type": "string", "required": true, "description": "Task list ID"},
            "title": {"type": "string", "required": true, "description": "Task title"},
            "body": {"type": "string", "required": false, "description": "Task notes"}
          }
        },
        {
          "name": "update-todo-task",
          "description": "Update a task",
          "parameters": {
            "task-list-id": {"type": "string", "required": true, "description": "Task list ID"},
            "task-id": {"type": "string", "required": true, "description": "Task ID"},
            "title": {"type": "string", "required": false, "description": "New title"},
            "status": {"type": "string", "required": false, "description": "notStarted, inProgress, completed"}
          }
        },
        {
          "name": "delete-todo-task",
          "description": "Delete a task",
          "parameters": {
            "task-list-id": {"type": "string", "required": true, "description": "Task list ID"},
            "task-id": {"type": "string", "required": true, "description": "Task ID"}
          }
        }
      ]
    },
    "planner": {
      "description": "Planner tasks",
      "requires_org_mode": false,
      "tools": [
        {
          "name": "list-planner-tasks",
          "description": "List all Planner tasks assigned to user",
          "parameters": {}
        },
        {
          "name": "get-planner-plan",
          "description": "Get a Planner plan",
          "parameters": {
            "plan-id": {"type": "string", "required": true, "description": "Plan ID"}
          }
        },
        {
          "name": "list-plan-tasks",
          "description": "List tasks in a plan",
          "parameters": {
            "plan-id": {"type": "string", "required": true, "description": "Plan ID"}
          }
        },
        {
          "name": "get-planner-task",
          "description": "Get a specific Planner task",
          "parameters": {
            "task-id": {"type": "string", "required": true, "description": "Task ID"}
          }
        },
        {
          "name": "create-planner-task",
          "description": "Create a Planner task",
          "parameters": {
            "plan-id": {"type": "string", "required": true, "description": "Plan ID"},
            "title": {"type": "string", "required": true, "description": "Task title"},
            "bucket-id": {"type": "string", "required": false, "description": "Bucket ID"}
          }
        }
      ]
    },
    "contacts": {
      "description": "Outlook contacts",
      "requires_org_mode": false,
      "tools": [
        {
          "name": "list-outlook-contacts",
          "description": "List Outlook contacts",
          "parameters": {
            "top": {"type": "integer", "required": false, "description": "Number of contacts to return"}
          }
        },
        {
          "name": "get-outlook-contact",
          "description": "Get a specific contact",
          "parameters": {
            "contact-id": {"type": "string", "required": true, "description": "Contact ID"}
          }
        },
        {
          "name": "create-outlook-contact",
          "description": "Create a new contact",
          "parameters": {
            "given-name": {"type": "string", "required": true, "description": "First name"},
            "surname": {"type": "string", "required": false, "description": "Last name"},
            "email": {"type": "string", "required": false, "description": "Email address"},
            "phone": {"type": "string", "required": false, "description": "Phone number"}
          }
        },
        {
          "name": "update-outlook-contact",
          "description": "Update a contact",
          "parameters": {
            "contact-id": {"type": "string", "required": true, "description": "Contact ID"}
          }
        },
        {
          "name": "delete-outlook-contact",
          "description": "Delete a contact",
          "parameters": {
            "contact-id": {"type": "string", "required": true, "description": "Contact ID"}
          }
        }
      ]
    },
    "search": {
      "description": "Microsoft Search",
      "requires_org_mode": false,
      "tools": [
        {
          "name": "search-query",
          "description": "Search across Microsoft 365",
          "parameters": {
            "query": {"type": "string", "required": true, "description": "Search query"},
            "entity-types": {"type": "string", "required": false, "description": "message, driveItem, site, list, etc."}
          }
        }
      ]
    },
    "user": {
      "description": "User profile",
      "requires_org_mode": false,
      "tools": [
        {
          "name": "get-current-user",
          "description": "Get current user profile",
          "parameters": {}
        }
      ]
    },
    "teams": {
      "description": "Teams & Chats (requires --org-mode)",
      "requires_org_mode": true,
      "tools": [
        {
          "name": "list-chats",
          "description": "List all chats",
          "parameters": {}
        },
        {
          "name": "get-chat",
          "description": "Get a specific chat",
          "parameters": {
            "chat-id": {"type": "string", "required": true, "description": "Chat ID"}
          }
        },
        {
          "name": "list-chat-messages",
          "description": "List messages in a chat",
          "parameters": {
            "chat-id": {"type": "string", "required": true, "description": "Chat ID"}
          }
        },
        {
          "name": "send-chat-message",
          "description": "Send a message to a chat",
          "parameters": {
            "chat-id": {"type": "string", "required": true, "description": "Chat ID"},
            "content": {"type": "string", "required": true, "description": "Message content"}
          }
        },
        {
          "name": "list-joined-teams",
          "description": "List teams user has joined",
          "parameters": {}
        },
        {
          "name": "list-team-channels",
          "description": "List channels in a team",
          "parameters": {
            "team-id": {"type": "string", "required": true, "description": "Team ID"}
          }
        },
        {
          "name": "send-channel-message",
          "description": "Send message to a channel",
          "parameters": {
            "team-id": {"type": "string", "required": true, "description": "Team ID"},
            "channel-id": {"type": "string", "required": true, "description": "Channel ID"},
            "content": {"type": "string", "required": true, "description": "Message content"}
          }
        }
      ]
    },
    "sharepoint": {
      "description": "SharePoint Sites (requires --org-mode)",
      "requires_org_mode": true,
      "tools": [
        {
          "name": "search-sharepoint-sites",
          "description": "Search SharePoint sites",
          "parameters": {
            "query": {"type": "string", "required": true, "description": "Search query"}
          }
        },
        {
          "name": "get-sharepoint-site",
          "description": "Get a SharePoint site",
          "parameters": {
            "site-id": {"type": "string", "required": true, "description": "Site ID"}
          }
        },
        {
          "name": "list-sharepoint-site-drives",
          "description": "List document libraries",
          "parameters": {
            "site-id": {"type": "string", "required": true, "description": "Site ID"}
          }
        },
        {
          "name": "list-sharepoint-site-lists",
          "description": "List SharePoint lists",
          "parameters": {
            "site-id": {"type": "string", "required": true, "description": "Site ID"}
          }
        }
      ]
    },
    "users": {
      "description": "User management (requires --org-mode)",
      "requires_org_mode": true,
      "tools": [
        {
          "name": "list-users",
          "description": "List users in organization",
          "parameters": {
            "top": {"type": "integer", "required": false, "description": "Number of users to return"},
            "filter": {"type": "string", "required": false, "description": "OData filter"}
          }
        }
      ]
    }
  }
}
EOF
)

# Filter by tool name if specified
if [[ -n "$TOOL" ]]; then
  RESULT=$(echo "$TOOLS_JSON" | jq --arg tool "$TOOL" '
    [.categories | to_entries[] | .value.tools[] | select(.name == $tool)] | first
  ')
  if [[ "$RESULT" == "null" ]]; then
    echo "Tool not found: $TOOL" >&2
    exit 1
  fi
  echo "$RESULT"
  exit 0
fi

# Filter by preset if specified
if [[ -n "$PRESET" ]]; then
  case "$PRESET" in
    mail) CATEGORY="email";;
    calendar) CATEGORY="calendar";;
    files) CATEGORY="files";;
    excel) CATEGORY="excel";;
    contacts) CATEGORY="contacts";;
    tasks) CATEGORY="tasks";;
    onenote) CATEGORY="onenote";;
    search) CATEGORY="search";;
    users) CATEGORY="users";;
    personal)
      echo "$TOOLS_JSON" | jq '{
        service: .service,
        version: .version,
        preset: "personal",
        categories: (.categories | to_entries | map(select(.value.requires_org_mode == false)) | from_entries)
      }'
      exit 0
      ;;
    work)
      echo "$TOOLS_JSON" | jq '{
        service: .service,
        version: .version,
        preset: "work",
        note: "Requires --org-mode flag",
        categories: (.categories | to_entries | map(select(.value.requires_org_mode == true)) | from_entries)
      }'
      exit 0
      ;;
    all)
      echo "$TOOLS_JSON"
      exit 0
      ;;
    *)
      echo "Unknown preset: $PRESET" >&2
      exit 1
      ;;
  esac
fi

# Filter by category if specified
if [[ -n "$CATEGORY" ]]; then
  echo "$TOOLS_JSON" | jq --arg cat "$CATEGORY" '{
    service: .service,
    version: .version,
    filtered_by: ("category: " + $cat),
    category: .categories[$cat]
  }'
  exit 0
fi

# Return summary (not full catalog - that would be too long)
echo "$TOOLS_JSON" | jq '{
  service: .service,
  version: .version,
  description: .description,
  server: .server,
  presets: .presets,
  categories: (.categories | to_entries | map({(.key): {description: .value.description, requires_org_mode: .value.requires_org_mode, tool_count: (.value.tools | length)}}) | add)
}'

