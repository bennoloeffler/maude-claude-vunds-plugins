# Prompt for Restart Plugin

Prepare a comprehensive restart prompt when context runs low - captures all insights, references, and task state for seamless continuation in a new Claude Code session.

## Problem Solved

Long coding sessions can exhaust Claude's context window. When this happens, valuable insights, decisions, and progress can be lost. This plugin creates a detailed handoff document that allows a new session to continue exactly where the old one left off.

## Installation

```bash
/plugin marketplace add bennoloeffler/maude-claude-vunds-plugins
/plugin install prompt-for-restart@maude-claude-vunds-plugins
```

## Usage

### When Context is Low

```
/prompt-for-restart
```

This creates `restart-prompt.md` in your project root with:
- Precise task definition
- Job-done acceptance criteria
- Current progress and next steps
- Key insights discovered
- File and documentation references
- Pending TODOs
- Testing hints
- Ready-to-paste prompt for new session

### Starting a New Session

Copy the prompt from the end of `restart-prompt.md`:

```
I'm continuing work on [TASK].

Read @restart-prompt.md for full context including:
- Task definition and acceptance criteria
- Current progress and next steps
- Key insights and file references

The immediate next action is: [SPECIFIC ACTION]

Start by reviewing the restart prompt, then proceed with the next step.
```

## When to Use

- Context is running low (responses getting shorter/less detailed)
- Before taking a break from a complex task
- Checkpointing progress on long-running work
- Before switching to a very different task
- Any time you want to preserve session knowledge

## What Gets Captured

| Section | Purpose |
|---------|---------|
| Task Definition | Precise description of what's being done |
| Job-Done Definition | Clear acceptance criteria |
| Current Progress | What's been accomplished |
| Next Steps | Remaining work in priority order |
| Key Insights | Important discoveries |
| File References | Relevant files with @-references |
| Documentation | External docs consulted |
| TODOs | Pending items |
| Testing Hints | How to verify the work |

## Best Practices

1. **Be Proactive**: Don't wait until context is exhausted
2. **Commit the File**: `git add restart-prompt.md && git commit -m "Checkpoint: task progress"`
3. **Review Before New Session**: Skim the file to refresh your memory too
4. **Update as Needed**: The restart prompt can be edited if things change

## Note on Hooks

Currently, Claude Code doesn't expose context percentage to hooks, so automatic detection isn't possible. Watch for these manual signs:
- Responses getting shorter
- Claude losing track of earlier decisions
- "I don't recall" type responses
- Todo list becoming hard to track

When you notice these, run `/prompt-for-restart`.

## License

MIT
