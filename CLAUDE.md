# VundS Plugin Marketplace - Development Guide

This repository contains Claude Code plugins for the VundS team.

**Sources:** [Anthropic Plugin Docs](https://code.claude.com/docs/en/plugins) | [Agent Skills Guide](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills) | [Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)

---

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

```bash
# Single plugin
claude --plugin-dir ./plugins/linkedin-assistant

# Multiple plugins
claude --plugin-dir ./plugins/linkedin-assistant --plugin-dir ./plugins/love-letter

# With debug output (shows loading and errors)
claude --plugin-dir ./plugins/linkedin-assistant --debug
```

### What Happens on Load

1. **Manifest read** from `.claude-plugin/plugin.json`
2. **Components auto-registered:**
   - `commands/*.md` → `/plugin-name:command-name`
   - `agents/*.md` → Available as subagents
   - `skills/*/SKILL.md` → Auto-triggered on phrases
   - `hooks/hooks.json` → Event handlers activated
3. **Session-scoped** - Plugin active only for this session, no permanent install

---

## Plugin Structure

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json          # REQUIRED - manifest (ONLY this file here!)
├── commands/                # Optional - slash commands
│   └── my-command.md
├── agents/                  # Optional - subagents
│   └── my-agent.md
├── skills/                  # Optional - auto-triggered knowledge
│   └── my-skill/
│       ├── SKILL.md         # Main skill file
│       └── references/      # Optional - additional context
│           └── patterns.md
├── hooks/                   # Optional - event handlers
│   └── hooks.json
├── scripts/                 # Optional - hook scripts (chmod +x!)
│   └── my-script.sh
├── templates/               # Optional - reference data for skills/agents
│   └── examples.md
└── README.md
```

**CRITICAL:** Never put commands/, agents/, skills/, hooks/ inside .claude-plugin/. Only plugin.json goes there!

### plugin.json (Required)

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "What the plugin does",
  "author": {
    "name": "Your Name",
    "email": "you@example.com"
  },
  "keywords": ["keyword1", "keyword2"],
  "commands": "./commands/",
  "agents": "./agents/",
  "skills": "./skills/",
  "hooks": "./hooks/hooks.json"
}
```

---

## Commands - Detailed Example

Commands are user-invoked slash commands. The filename becomes the command name.

**File:** `commands/analyze.md` → `/my-plugin:analyze`

### Technical Requirements

| Requirement | Details |
|-------------|---------|
| Location | `commands/` directory at plugin root |
| Filename | `kebab-case.md` (becomes command name) |
| Frontmatter | YAML with `description` field |
| Namespace | Auto-prefixed with plugin name |

### Frontmatter Fields

```yaml
---
description: Short description shown in /help (user)
argument-hint: <optional-argument>   # Shown after command name
allowed-tools: Tool1, Tool2          # Restrict available tools (optional)
---
```

### Complete Example

```markdown
---
description: Analyze a customer profile and generate insights report (user)
argument-hint: <customer-name>
---

# Customer Analysis

Analyze the specified customer and generate a comprehensive report.

## Input

The customer name is provided via: $ARGUMENTS

If no customer specified, ask the user which customer to analyze.

## Workflow

1. **Gather Data**
   - Search for customer in CRM data (templates/customers.md)
   - Check interaction history
   - Review recent communications

2. **Analysis**
   - Identify customer segment
   - Calculate engagement score
   - Find cross-sell opportunities
   - Note any risk indicators

3. **Generate Report**
   - Use the format below
   - Be concise but comprehensive
   - Include actionable recommendations

## Output Format

```
📊 KUNDENANALYSE: [Name]
━━━━━━━━━━━━━━━━━━━━━━━━

📋 ÜBERSICHT
• Firma: [Company]
• Position: [Role]
• Segment: [A/B/C]
• Engagement: [Score]/10

💡 ERKENNTNISSE
• [Key insight 1]
• [Key insight 2]

🎯 EMPFEHLUNGEN
1. [Action item 1]
2. [Action item 2]

⚠️ RISIKEN
• [Risk if any, otherwise "Keine erkannt"]
```

## Important Rules

- ALWAYS use German for output
- NEVER share raw customer data
- ALWAYS include actionable next steps
- Reference templates/no-contact.md for blocked customers
```

### Stylistic Best Practices (from Anthropic)

1. **Write FOR Claude, not TO user** - Commands are instructions for Claude
2. **Use $ARGUMENTS** - Access user-provided parameters
3. **Define clear output format** - Structured output is more useful
4. **Include error handling** - What if input is missing?
5. **Reference other files** - Use templates/, skills/ for shared context
6. **Be specific** - Vague instructions produce vague results

---

## Skills - Detailed Example

Skills are auto-triggered knowledge that Claude loads when relevant. They follow the **Progressive Disclosure** principle.

**Directory:** `skills/my-skill/SKILL.md`

### Technical Requirements

| Requirement | Details |
|-------------|---------|
| Location | `skills/<skill-name>/SKILL.md` (subdirectory required!) |
| Frontmatter | YAML with `name`, `description`, `version` |
| Description | 3rd person, with CONCRETE trigger phrases |
| Body | Imperative form instructions |

### Progressive Disclosure (Core Principle)

Skills use a three-tier loading system to save context:

```
Level 1: name + description (always loaded ~50 tokens)
    ↓ triggers when relevant
Level 2: SKILL.md body (loaded on demand ~500-2000 tokens)
    ↓ references additional files
Level 3: references/, examples/, scripts/ (loaded as needed)
```

**Goal:** Effectively unbounded context, loaded progressively.

### Complete Example

**File:** `skills/german-business-writing/SKILL.md`

```markdown
---
name: german-business-writing
description: This skill should be used when the user asks to "write a professional email in German", "compose a business letter auf Deutsch", "formulate a formal German response", "draft German business correspondence", "create a professional German message". Activate for all formal German business communication tasks.
version: 1.0.0
---

# German Business Writing

You write professional German business correspondence following established conventions.

## Core Principles

- **Formal but not stiff** - Professional yet approachable
- **Clear structure** - Anrede, Einleitung, Hauptteil, Schluss, Grußformel
- **Appropriate register** - Match formality to relationship

## Formality Levels

| Level | When | Anrede | Grußformel |
|-------|------|--------|------------|
| Sehr formell | First contact, executives | Sehr geehrte/r | Mit freundlichen Grüßen |
| Standard | Business partners | Guten Tag / Hallo | Beste Grüße |
| Vertraut | Long-term contacts | Liebe/r | Viele Grüße |

## Structure Template

```
[Anrede],

[Einleitung - Bezug auf Anlass, max 1-2 Sätze]

[Hauptteil - Kernaussage, klar strukturiert]

[Schluss - Handlungsaufforderung oder Ausblick]

[Grußformel]
[Name]
```

## Common Patterns

For detailed templates, see: references/email-templates.md
For industry-specific terminology, see: references/business-terms.md

## What to AVOID

- Anglizismen where German alternatives exist
- Overly long sentences (max 20 words)
- Passive voice overuse
- "Ich würde mich freuen" (too submissive)
- Exclamation marks in formal context

## Quick Reference

| Situation | Opening |
|-----------|---------|
| Reply | Vielen Dank für Ihre Nachricht vom... |
| Request | Ich wende mich an Sie mit der Bitte... |
| Follow-up | Bezugnehmend auf unser Gespräch... |
| Cold contact | Ich erlaube mir, Sie zu kontaktieren... |
```

**Additional file:** `skills/german-business-writing/references/email-templates.md`

```markdown
# Email Templates

## Terminanfrage

Sehr geehrte/r [Name],

gerne würde ich mit Ihnen einen Termin zum Thema [X] vereinbaren.

Wären Sie in der kommenden Woche verfügbar? Ich bin flexibel und richte mich nach Ihrem Kalender.

Mit freundlichen Grüßen
[Name]

## Angebot nachfassen

Guten Tag [Name],

ich möchte kurz nachfragen, ob Sie Gelegenheit hatten, unser Angebot vom [Datum] zu prüfen.

Für Rückfragen stehe ich Ihnen gerne zur Verfügung.

Beste Grüße
[Name]
```

### Stylistic Best Practices (from Anthropic)

1. **Specific trigger phrases** - Claude uses description to decide relevance
2. **Third person description** - "This skill should be used when..."
3. **Imperative body** - "You write...", "Generate...", "Always..."
4. **Progressive disclosure** - Main file lean, details in references/
5. **Include examples** - Claude learns from concrete patterns
6. **Monitor and iterate** - Watch how skill triggers, refine description

### Common Mistakes

| Mistake | Wrong | Right |
|---------|-------|-------|
| Vague description | "Helps with emails" | "Use when user asks to 'write formal German email', 'compose business letter'" |
| First person | "I help you write..." | "This skill should be used when..." |
| Too much in SKILL.md | 5000 word file | 500 word file + references/ |
| No trigger phrases | "German writing skill" | Include 4-6 quoted trigger phrases |

---

## Agents - Detailed Example

Agents are specialized subprocesses that Claude spawns for specific tasks. They run in isolation with their own context.

**File:** `agents/my-agent.md`

### Technical Requirements

| Requirement | Details |
|-------------|---------|
| Location | `agents/` directory at plugin root |
| Filename | `kebab-case.md` |
| Frontmatter | name, description with examples, model, tools |
| Examples | `<example>` blocks are CRITICAL for triggering |

### Frontmatter Fields

```yaml
---
name: agent-identifier
description: |
  Use this agent when [specific conditions].

  <example>
  Context: [Situation description]
  user: "[Exact user message that should trigger]"
  assistant: "[How Claude announces using this agent]"
  <commentary>
  [Why this agent is appropriate]
  </commentary>
  </example>

model: inherit          # or: sonnet, opus, haiku
color: green            # Terminal color: blue, green, yellow, red, magenta, cyan
tools: ["Tool1", "Tool2"]
---
```

### Complete Example

**File:** `agents/code-reviewer.md`

```markdown
---
name: code-reviewer
description: |
  Use this agent for comprehensive code review focusing on quality, security, and maintainability. Best for reviewing pull requests, checking code before commits, or auditing existing code.

  <example>
  Context: User wants feedback on their code changes
  user: "Can you review my changes before I commit?"
  assistant: "I'll use the code-reviewer agent to thoroughly analyze your changes for quality, security, and best practices."
  <commentary>
  The user wants pre-commit review. This agent specializes in comprehensive code analysis and will check for issues the main Claude might miss.
  </commentary>
  </example>

  <example>
  Context: User is concerned about code quality
  user: "Check this function for potential bugs and improvements"
  assistant: "Let me spawn the code-reviewer agent to do a deep analysis of this function."
  <commentary>
  Targeted code review request. The agent will focus on the specific function with full attention.
  </commentary>
  </example>

  <example>
  Context: Security audit needed
  user: "Is this authentication code secure?"
  assistant: "I'll have the code-reviewer agent perform a security-focused review of your authentication implementation."
  <commentary>
  Security-specific review. The agent will prioritize OWASP patterns and auth best practices.
  </commentary>
  </example>

model: inherit
color: yellow
tools: ["Read", "Grep", "Glob", "Bash"]
---

You are a senior code reviewer with expertise in security, performance, and maintainability.

## Review Process

1. **Understand Context**
   - Read the changed files
   - Understand the purpose of changes
   - Check related files for context

2. **Security Analysis**
   - Check for injection vulnerabilities (SQL, command, XSS)
   - Validate input handling
   - Review authentication/authorization
   - Check for sensitive data exposure

3. **Code Quality**
   - Naming conventions
   - Function length and complexity
   - DRY violations
   - Error handling completeness

4. **Performance**
   - N+1 query patterns
   - Unnecessary computations
   - Memory leaks potential
   - Caching opportunities

## Output Format

```
## Code Review: [File/Feature]

### 🔴 Critical Issues
- [Issue with file:line reference]

### 🟡 Warnings
- [Potential problems]

### 🟢 Suggestions
- [Nice-to-have improvements]

### ✅ What's Good
- [Positive observations]

### Summary
[Overall assessment and recommended actions]
```

## Important Rules

- ALWAYS reference specific file:line numbers
- NEVER nitpick formatting if linter handles it
- PRIORITIZE security over style
- BE CONSTRUCTIVE - suggest fixes, not just problems
- ACKNOWLEDGE good patterns you find
```

### Stylistic Best Practices (from Anthropic)

1. **Multiple examples** - At least 2-3 `<example>` blocks for reliable triggering
2. **Specific context** - Don't just show user message, show situation
3. **Commentary required** - Explain WHY this agent fits
4. **Minimal tools** - Only grant tools the agent actually needs
5. **Clear output format** - Agents should produce structured results
6. **System prompt focus** - Body is the agent's personality/instructions

### When to Use Agents vs Skills

| Use Agent When | Use Skill When |
|----------------|----------------|
| Task needs isolation | Knowledge augmentation |
| Parallel execution helpful | Sequential in main context |
| Heavy computation | Quick reference lookup |
| Different model appropriate | Same model, more context |
| Prevent context pollution | Context sharing needed |

---

## Hooks - Detailed Example

Hooks intercept events in Claude Code's lifecycle to add automation.

**File:** `hooks/hooks.json`

### Technical Requirements

| Requirement | Details |
|-------------|---------|
| Location | `hooks/hooks.json` |
| Scripts | Must be executable (`chmod +x`) |
| Paths | Use `${CLAUDE_PLUGIN_ROOT}` for portability |
| Exit codes | 0=allow, 1=error(continue), 2=BLOCK |

### Hook Events

| Event | When Fired | Common Uses |
|-------|------------|-------------|
| `PreToolUse` | Before any tool call | Block dangerous commands, validate |
| `PostToolUse` | After tool completes | Log actions, transform output |
| `Stop` | Claude finishes turn | Sound notification, cleanup |
| `SubagentStop` | Agent completes | Agent-specific notification |
| `Notification` | User input needed | Desktop notification |
| `SessionStart` | Session begins | Inject context, setup |

### Complete Example

**File:** `hooks/hooks.json`

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/scripts/session-init.sh"
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/scripts/bash-guard.sh"
          }
        ]
      },
      {
        "matcher": "mcp__",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/scripts/mcp-logger.sh"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/scripts/file-written.sh"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "afplay /System/Library/Sounds/Glass.aiff"
          }
        ]
      }
    ],
    "SubagentStop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "afplay /System/Library/Sounds/Pop.aiff"
          }
        ]
      }
    ]
  }
}
```

### Script Examples

**File:** `scripts/bash-guard.sh` - Block dangerous commands

```bash
#!/bin/bash
# Block dangerous bash commands
# Exit 2 = BLOCK the action

# Read tool input from stdin
INPUT=$(cat)

# Extract command
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Dangerous patterns
DANGEROUS_PATTERNS=(
  "rm -rf /"
  "rm -rf ~"
  ":(){ :|:& };:"
  "> /dev/sda"
  "mkfs"
  "dd if=/dev/zero"
)

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
  if [[ "$COMMAND" == *"$pattern"* ]]; then
    echo "BLOCKED: Dangerous command detected: $pattern" >&2
    exit 2  # BLOCK
  fi
done

exit 0  # Allow
```

**File:** `scripts/mcp-logger.sh` - Log MCP tool usage

```bash
#!/bin/bash
# Log all MCP tool calls for debugging

INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '.tool_name // "unknown"')
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Create log directory
LOG_DIR="${HOME}/.claude/logs"
mkdir -p "$LOG_DIR"

# Log the call
echo "[$TIMESTAMP] $TOOL" >> "$LOG_DIR/mcp-usage.log"

exit 0  # Always allow, just logging
```

**File:** `scripts/file-written.sh` - Track written files

```bash
#!/bin/bash
# Track files written by Claude

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [ -n "$FILE_PATH" ]; then
  echo "$FILE_PATH" >> "${HOME}/.claude/written-files.log"
fi

exit 0
```

### Stylistic Best Practices

1. **Use ${CLAUDE_PLUGIN_ROOT}** - Makes plugin portable
2. **Always handle stdin** - Hook receives JSON input
3. **Exit codes matter** - 2 blocks, 0 allows, 1 logs error but continues
4. **Keep scripts fast** - Hooks run synchronously
5. **Log to ~/.claude/** - Consistent log location
6. **Make scripts executable** - `chmod +x scripts/*.sh`

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
3. Update README.md with plugin documentation
4. Commit and push

---

## Common Issues

| Problem | Cause | Solution |
|---------|-------|----------|
| Plugin not found | Missing plugin.json | Create `.claude-plugin/plugin.json` |
| Commands missing | Wrong path | Check `"commands": "./commands/"` |
| Hooks don't fire | Script not executable | `chmod +x scripts/*.sh` |
| Skills don't trigger | Vague description | Add concrete trigger phrases in quotes |
| Agents unavailable | Missing tools | Add `tools: [...]` array |
| Agents don't trigger | No examples | Add 2-3 `<example>` blocks |
| Components in wrong place | Inside .claude-plugin/ | Move to plugin root level |

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
# Structure correct
ls -la plugins/my-plugin/.claude-plugin/  # Only plugin.json
ls -la plugins/my-plugin/commands/        # .md files
ls -la plugins/my-plugin/skills/          # Subdirectories with SKILL.md

# Scripts executable
ls -la plugins/my-plugin/scripts/         # Should show 'x' permission

# JSON valid
cat plugins/my-plugin/.claude-plugin/plugin.json | jq .
cat plugins/my-plugin/hooks/hooks.json | jq .
```

---

## MCP Servers: Context Management & Programmatic Calling

### The Context Pollution Problem

MCP servers can consume massive amounts of context before you even start working:

| Problem | Impact |
|---------|--------|
| Tool definitions loaded upfront | 66,000+ tokens consumed at session start |
| Verbose tool descriptions | Single server can use 14,000+ tokens |
| Multiple servers compound | 1/3 of context window gone before starting |

**Source:** [Optimising MCP Server Context Usage](https://scottspence.com/posts/optimising-mcp-server-context-usage-in-claude-code)

### Solution 1: Selective Server Loading

Use `/context` command to identify token-heavy servers, then selectively enable only needed servers.

Tools like [McPick](https://github.com/spences10/mcpick) let you toggle MCP servers on/off before sessions.

### Solution 2: Code Execution with MCP (Anthropic's Approach)

Instead of loading all tools into context, **call MCP tools programmatically from code**.

**Source:** [Anthropic - Code Execution with MCP](https://www.anthropic.com/engineering/code-execution-with-mcp)

#### How It Works

Traditional approach (context heavy):
```
Claude context ← [All tool definitions loaded]
Claude context ← [Tool 1 result]
Claude context ← [Tool 2 result]
... context fills up fast
```

Code execution approach (context efficient):
```
Claude writes code → Code calls MCP tools → Code filters/processes → Small result returns
```

**Result:** 98.7% token savings in some cases (150,000 → 2,000 tokens)

#### Implementation Pattern

Organize MCP servers as a filesystem that code can access:

```
servers/
├── google-drive/
│   ├── getDocument.ts
│   └── index.ts
└── salesforce/
    ├── updateRecord.ts
    └── index.ts
```

Then Claude writes code like:

```typescript
// Load only what's needed
const transcript = (await gdrive.getDocument({
  documentId: 'abc123'
})).content;

// Process in code, not in Claude's context
const summary = transcript.slice(0, 500);

// Only return what Claude needs
await salesforce.updateRecord({
  objectType: 'SalesMeeting',
  recordId: '00Q5f000001abcXYZ',
  data: { Notes: summary }  // Filtered data
});
```

#### Key Benefits

| Benefit | Description |
|---------|-------------|
| **On-demand loading** | Tools read only when needed, not upfront |
| **In-environment filtering** | Large data processed in code, not context |
| **Privacy preservation** | Sensitive data stays in execution environment |
| **Reusable skills** | Code can be saved as skills for future use |

### Solution 3: For Plugin Developers

If you're building plugins that use MCP:

#### Option A: Don't Include in .mcp.json

Instead of auto-loading via `.mcp.json`, have your skill/command invoke MCP programmatically:

```markdown
# In your SKILL.md or command

When you need data from the API:

1. Use Bash to call the MCP server directly:
   ```bash
   # Call MCP tool via CLI
   npx @your-org/mcp-server query "SELECT * FROM data LIMIT 10"
   ```

2. Parse the result in your response

This avoids loading 50+ tool definitions into every session.
```

#### Option B: Use Subagent Isolation

Create an agent that loads the MCP server, keeping the main context clean:

```markdown
---
name: data-fetcher
description: Use this agent when you need to fetch large datasets...
model: haiku  # Cheaper model for data fetching
tools: ["mcp__heavy-server__query", "mcp__heavy-server__list"]
---

You fetch and filter data, returning only relevant summaries.

## Process
1. Query the data source
2. Filter to relevant records
3. Summarize key findings
4. Return ONLY the summary (not raw data)
```

The MCP tools load only in the agent's isolated context.

### Caution: Experimental Territory

The "Code Execution with MCP" pattern is relatively new. If implementing:

1. **Start simple** - Test with one MCP server first
2. **Monitor token usage** - Use `/context` to verify savings
3. **Have fallback** - Keep traditional approach available
4. **Watch for updates** - Anthropic is actively developing this area

### Further Reading

- [Anthropic: Code Execution with MCP](https://www.anthropic.com/engineering/code-execution-with-mcp)
- [Scott Spence: Optimising MCP Context](https://scottspence.com/posts/optimising-mcp-server-context-usage-in-claude-code)
- [MCP Documentation](https://modelcontextprotocol.io/docs/develop/build-client)
- [Claude Code MCP Docs](https://code.claude.com/docs/en/mcp)
