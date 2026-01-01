<div align="center">

# VundS Claude Plugins

**A curated plugin marketplace for Claude Code**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Compatible-blueviolet)](https://claude.ai)
[![Plugins](https://img.shields.io/badge/Plugins-5-green)]()

*Tools, workflows, and a little romance for the VundS team*

</div>

---

## Quick Start

```bash
# 1. Add the marketplace
/plugin marketplace add bennoloeffler/maude-claude-vunds-plugins

# 2. Install a plugin
/plugin install love-letter@maude-claude-vunds-plugins

# 3. Use it!
/love-letter
```

---

## Available Plugins

| | Plugin | Description | Status |
|---|--------|-------------|--------|
| :briefcase: | **linkedin-assistant** | LinkedIn automation auf Deutsch | Ready |
| :love_letter: | **love-letter** | Romantic letters from Benno to Sabine | Ready |
| :bar_chart: | **crm-customer-analysis** | Customer insights & analysis | Coming Soon |
| :arrows_counterclockwise: | **epct-workflow** | Structured dev approach | Coming Soon |
| :hammer_and_wrench: | **vunds-tools** | Team productivity toolkit | Coming Soon |

---

## Plugin Details

### :briefcase: linkedin-assistant

> *LinkedIn-Assistent für Benno: Nachrichten, Mitteilungen und Networking auf Deutsch*

Full-featured LinkedIn automation with browser control via Claude-in-Chrome.

**Commands:**
| Command | Description |
|---------|-------------|
| `/linkedin:inbox` | Posteingang mit Antwortvorschlägen |
| `/linkedin:notifications` | Mitteilungen mit Reaktionen |
| `/linkedin:research [Name]` | Person/Firma recherchieren |
| `/linkedin:post [Thema]` | Post-Entwurf erstellen |
| `/linkedin:login` | Login-Hilfe |

**Agents:** `message-responder`, `notification-handler`, `profile-researcher`

**Skills:** `benno-style`, `linkedin-navigation`, `german-professional`

**Requires:** Claude-in-Chrome Extension

---

### :love_letter: love-letter

> *"Schreibe einen romantischen Brief von Benno an Sabine"*

Generates heartfelt, romantic love letters with German flair.

**Command:**
```bash
/love-letter
```

**Skill:** `love-letter` - Instruction set for letter writing style

---

### :bar_chart: crm-customer-analysis

Analyze VundS customer data with AI-powered insights.

**Command:**
```bash
/crm-analyse-customer <customer-name>
```

*Coming soon...*

---

### :arrows_counterclockwise: epct-workflow

Structured EPCT development methodology for complex tasks.

**Command:**
```bash
/epct "implement user authentication"
```

*Coming soon...*

---

### :hammer_and_wrench: vunds-tools

General productivity tools and skills for the VundS team.

*Coming soon...*

---

## Creating New Plugins

### Recommended: Use plugin-dev

The official Anthropic plugin development toolkit - a comprehensive suite for creating Claude Code plugins.

**Installation:**
```bash
/plugin marketplace add anthropics/claude-plugins-official
/plugin install plugin-dev@anthropics/claude-plugins-official
# Restart Claude Code to load
```

**What's included:**

| Type | Name | Purpose |
|------|------|---------|
| Command | `/plugin-dev:start` | Interactive wizard to choose creation path |
| Command | `/plugin-dev:create-plugin` | 8-phase guided plugin workflow |
| Command | `/plugin-dev:create-marketplace` | Create a new marketplace |
| Skill | `hook-development` | Create hooks for lifecycle events |
| Skill | `mcp-integration` | MCP server integration |
| Skill | `command-development` | Build slash commands |
| Skill | `skill-development` | Create skills with SKILL.md |
| Skill | `agent-development` | Build custom agents |
| Skill | `plugin-settings` | Configure plugin settings |
| Agent | `plugin-validator` | Validate plugin structure |
| Agent | `skill-reviewer` | Review skill quality |

**Usage:**
```bash
/plugin-dev:start              # Start here - choose your path
/plugin-dev:create-plugin      # Jump straight to plugin creation
```

### Manual Creation

1. Create folder structure:
   ```
   plugins/<name>/
   ├── .claude-plugin/
   │   └── plugin.json
   ├── commands/
   │   └── your-command.md
   └── skills/
       └── your-skill/
           └── SKILL.md
   ```

2. Add `plugin.json` manifest:
   ```json
   {
     "name": "your-plugin",
     "description": "What it does",
     "version": "1.0.0",
     "author": { "name": "Your Name" }
   }
   ```

3. Register in `.claude-plugin/marketplace.json`

4. Commit and push

---

## Testing Plugins Locally when Developing Plugins

**DO NOT** install via marketplace for testing. Use `--plugin-dir` instead:

```bash
# Single plugin
claude --plugin-dir ./plugins/linkedin-assistant

# Multiple plugins
claude --plugin-dir ./plugins/linkedin-assistant --plugin-dir ./plugins/love-letter

# With debug output (shows loading and errors)
claude --plugin-dir ./plugins/linkedin-assistant --debug
```

---

## Browser Automation Requirements

Some plugins (like `linkedin-assistant`) require browser automation. There are two options:

### Option 1: Claude in Chrome (Recommended)

Claude in Chrome is a Chrome extension that lets Claude Code control your browser directly.

**Features:**
- Navigate websites, fill forms, capture screenshots
- Record GIFs of browser interactions
- Debug with console logs and network requests
- Real-time browser control from Claude Code

**Installation:**

1. Install the Chrome extension from [Chrome Web Store](https://chromewebstore.google.com/detail/claude-in-chrome/...)
2. Open Chrome and enable the extension
3. In Claude Code, use `/chrome` to start browser control

**Usage:**
```bash
# Start Chrome session
/chrome

# Claude can now control Chrome:
# - Navigate to URLs
# - Click, type, scroll
# - Take screenshots
# - Read page content
```

### Option 2: Playwright MCP Server (Alternative)

If you can't install Chrome or prefer headless automation, use the Playwright MCP server.

**Installation:**
```bash
# Install via Claude Code MCP settings
claude mcp add playwright

# Or manually add to ~/.claude.json:
{
  "mcpServers": {
    "playwright": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-playwright"]
    }
  }
}
```

**Features:**
- Headless browser automation
- Works without Chrome extension
- Supports Chrome, Firefox, WebKit
- Good for CI/CD environments

**Comparison:**

| Feature | Claude in Chrome | Playwright MCP |
|---------|-----------------|----------------|
| Visual feedback | Yes (see browser) | No (headless) |
| Setup | Extension install | NPM package |
| CI/CD friendly | No | Yes |
| Session persistence | Yes | No |
| Works with Maude | Yes | Yes |

---

## Resources

- [Claude Code Plugins Documentation](https://docs.anthropic.com/en/docs/claude-code/plugins)
- [Official Plugin Repository](https://github.com/anthropics/claude-plugins-official)
- [Claude in Chrome Extension](https://chromewebstore.google.com)
- [Playwright MCP Server](https://github.com/anthropics/mcp-server-playwright)

---

<div align="center">

Made with :heart: by VundS · [benno@vunds.de](mailto:benno@vunds.de)

</div>
