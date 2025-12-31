# VundS Claude Plugins

A plugin marketplace for Claude Code containing VundS team tools and workflows.

## Installation

```bash
# Add this marketplace
/plugin marketplace add bennoloeffler/maude-claude-vunds-plugins

# Install plugins
/plugin install love-letter@maude-claude-vunds-plugins
```

## Available Plugins

| Plugin | Description | Category | Status |
|--------|-------------|----------|--------|
| **love-letter** | Write romantic love letters from Benno to Sabine | Productivity | Ready |
| crm-customer-analysis | CRM customer analysis workflow | Productivity | Placeholder |
| epct-workflow | Structured EPCT development approach | Development | Placeholder |
| vunds-tools | General VundS productivity tools | Productivity | Placeholder |

## Plugin Details

### love-letter

Write romantic love letters from Benno to Sabine.

**Commands:**
- `/love-letter` - Generate a romantic love letter

**Skills:**
- `love-letter` - Instruction set for letter writing

### crm-customer-analysis

CRM Customer Analysis Command for VundS - analyze customer data and provide insights.

**Commands:**
- `/crm-analyse-customer` - Run customer analysis

### epct-workflow

Structured development approach using the EPCT methodology.

**Commands:**
- `/epct <task>` - Follow structured development approach for a task

### vunds-tools

General productivity tools and skills for the VundS team.

## Creating New Plugins

1. Create folder: `plugins/<name>/.claude-plugin/`
2. Add `plugin.json` manifest
3. Add commands in `commands/` or skills in `skills/`
4. Update `.claude-plugin/marketplace.json`
5. Commit and push

See the existing plugins for examples.

## License

MIT
