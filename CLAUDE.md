# VundS Plugin Marketplace - Development Guide

This repository contains Claude Code plugins for the VundS team.

## Creating New Plugins

### Recommended: Use plugin-dev

Install the official Anthropic plugin development toolkit:

```bash
# Install from official marketplace
/plugin marketplace add anthropics/claude-plugins-official
/plugin install plugin-dev@anthropics/claude-plugins-official
# Restart Claude Code
```

Then use the interactive wizard:

```bash
/plugin-dev:start              # Choose between plugin or marketplace
/plugin-dev:create-plugin      # 8-phase guided plugin workflow
```

### plugin-dev Contents

| Type | Name | Purpose |
|------|------|---------|
| Command | `/plugin-dev:start` | Interactive wizard |
| Command | `/plugin-dev:create-plugin` | Guided plugin creation |
| Command | `/plugin-dev:create-marketplace` | Create marketplace |
| Skill | `hook-development` | Create lifecycle hooks |
| Skill | `mcp-integration` | MCP server integration |
| Skill | `command-development` | Build slash commands |
| Skill | `skill-development` | Create SKILL.md files |
| Skill | `agent-development` | Build custom agents |
| Skill | `plugin-settings` | Configure plugin settings |
| Agent | `plugin-validator` | Validate plugin structure |
| Agent | `skill-reviewer` | Review skill quality |

---

## Testing Plugins Locally

**DO NOT** install via marketplace for testing. Use `--plugin-dir` instead:

### Load Single Plugin

```bash
claude --plugin-dir ./plugins/linkedin-assistant
```

### Load Multiple Plugins

```bash
claude --plugin-dir ./plugins/linkedin-assistant --plugin-dir ./plugins/love-letter
```

### Debug Mode

```bash
claude --plugin-dir ./plugins/linkedin-assistant --debug
```

Shows what gets loaded and any errors.

### What Happens

1. **Manifest loaded** from `.claude-plugin/plugin.json`
2. **Components auto-registered:**
   - `commands/` → `/plugin-name:command-name`
   - `agents/` → Available as subagents
   - `skills/` → Auto-triggered on phrases
   - `hooks/hooks.json` → Event handlers activated
3. **Session-scoped** - Plugin active only for this session

---

## Plugin Structure

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json          # REQUIRED - manifest
├── commands/                # Optional - slash commands
│   └── my-command.md
├── agents/                  # Optional - subagents
│   └── my-agent.md
├── skills/                  # Optional - auto-triggered knowledge
│   └── my-skill/
│       └── SKILL.md
├── hooks/                   # Optional - event handlers
│   └── hooks.json
├── scripts/                 # Optional - hook scripts (chmod +x!)
│   └── my-script.sh
├── templates/               # Optional - reference data
│   └── patterns.md
└── README.md
```

### plugin.json (Required)

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "What the plugin does",
  "author": {
    "name": "Your Name"
  },
  "commands": "./commands/",
  "agents": "./agents/",
  "skills": "./skills/",
  "hooks": "./hooks/hooks.json"
}
```

---

## Component Formats

### Command (commands/my-command.md)

```markdown
---
description: What this command does (user)
---

# Command Title

Instructions for Claude when this command is invoked.

Use $ARGUMENTS for any parameters passed by the user.

## Output Format

Define expected output structure here.
```

### Skill (skills/my-skill/SKILL.md)

```markdown
---
name: my-skill
description: This skill should be used when the user asks to "trigger phrase 1", "trigger phrase 2", "trigger phrase 3". Include specific phrases!
version: 1.0.0
---

# Skill Title

Knowledge and instructions for Claude.

## Key Information

Content that Claude should know when this skill triggers.
```

**Important:** Description must be in 3rd person with concrete trigger phrases!

### Agent (agents/my-agent.md)

```markdown
---
name: my-agent
description: Use this agent when [condition]. Examples:

<example>
Context: When this agent should trigger
user: "Example user message"
assistant: "I'll use my-agent to handle this."
<commentary>
Why this agent is appropriate here.
</commentary>
</example>

model: inherit
color: blue
tools: ["Read", "Write", "Grep", "Bash"]
---

System prompt for the agent.

## Tasks

What the agent should do.

## Output Format

How results should be formatted.
```

### Hooks (hooks/hooks.json)

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/scripts/notification.sh"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "mcp__claude-in-chrome__",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/scripts/logger.sh"
          }
        ]
      }
    ]
  }
}
```

**Hook Events:**
| Event | When | Use Case |
|-------|------|----------|
| `PreToolUse` | Before tool call | Block, validate |
| `PostToolUse` | After tool call | Log, transform |
| `Stop` | Claude finished | Sound notification |
| `SubagentStop` | Agent finished | Sound notification |
| `Notification` | User input needed | Desktop notification |

**Exit Codes:** 0 = allow, 1 = error (continue), 2 = BLOCK

---

## Adding to This Marketplace

1. Create plugin in `plugins/your-plugin/`
2. Add to `.claude-plugin/marketplace.json`:
   ```json
   {
     "name": "your-plugin",
     "description": "What it does",
     "source": "./plugins/your-plugin",
     "category": "productivity",
     "version": "1.0.0",
     "author": { "name": "Your Name" },
     "keywords": ["keyword1", "keyword2"]
   }
   ```
3. Update README.md
4. Commit and push

---

## Common Issues

| Problem | Cause | Solution |
|---------|-------|----------|
| Plugin not found | Missing plugin.json | Create `.claude-plugin/plugin.json` |
| Commands missing | Wrong path | Check `"commands": "./commands/"` |
| Hooks don't fire | Script not executable | `chmod +x scripts/*.sh` |
| Skills don't trigger | Vague description | Add concrete trigger phrases |
| Agents unavailable | Missing tools | Add `tools: [...]` array |

---

## Quick Test Workflow

```bash
# 1. Load plugin temporarily
claude --plugin-dir ./plugins/my-plugin

# 2. Test command
/my-plugin:command-name

# 3. Test skill trigger
# Say something matching the skill's trigger phrases

# 4. Check hooks are working
# Perform action that should trigger hook
```

---

## Validation

Use plugin-dev's validators:

```bash
# In Claude Code with plugin-dev installed
# Ask: "Validate the plugin at ./plugins/my-plugin"
# → Uses plugin-validator agent
```

Or manually check:
```bash
# plugin.json exists
ls -la plugins/my-plugin/.claude-plugin/

# Scripts executable
ls -la plugins/my-plugin/scripts/

# JSON valid
cat plugins/my-plugin/.claude-plugin/plugin.json | jq .
```
