# Restart Prompt Skill

You have the prompt-for-restart plugin which helps preserve context when sessions need to end.

## When to Use

Use `/prompt-for-restart` when:
- Context is running low (you notice responses getting shorter or less detailed)
- User mentions they need to take a break
- A complex task won't finish in the current session
- You want to checkpoint progress on a long task
- Before switching to a very different task

## Proactive Usage

**Be proactive!** If you sense context pressure:
- Offer to create a restart prompt
- Don't wait for the user to ask
- Say: "I notice we're deep into this task. Should I create a restart prompt to preserve our progress?"

## What Gets Captured

The restart prompt captures:
1. **Task**: What we're working on (precise definition)
2. **Done criteria**: How to know when it's complete
3. **Progress**: What's been accomplished
4. **Next steps**: What remains, in order
5. **Insights**: Important discoveries that shouldn't be lost
6. **Files**: Which files are relevant (@-references)
7. **Docs**: External documentation consulted
8. **TODOs**: Pending items
9. **Testing**: How to verify the work

## Output

Creates `restart-prompt.md` in the project root with:
- All context needed for continuation
- A ready-to-paste prompt for the new session
- Checklist format for tracking

## Best Practices

When creating a restart prompt:
- **Be specific**: "Implement the save button" not "finish the feature"
- **Include paths**: `@src/components/Button.tsx` not "the button component"
- **Explain why**: Decisions made and their rationale
- **Prioritize**: Most important next step first
- **Test hints**: How to verify work is correct

## Example Usage

```
User: "I need to stop for today"

Claude: "Let me create a restart prompt to preserve our progress."
/prompt-for-restart

[Creates detailed restart-prompt.md]

"I've saved all context to restart-prompt.md. When you start a new session,
paste this:

'I'm continuing work on the MCP server integration. Read @restart-prompt.md
for full context. Start with reviewing the restart prompt, then proceed
with implementing the credential form.'

Don't forget to commit the restart prompt if you want to preserve it!"
```

## Context Warning Signs

Watch for these signs that context is getting low:
- Your responses are getting shorter
- You're losing track of earlier decisions
- File contents you read earlier feel fuzzy
- The todo list is getting hard to track
- User has asked many complex questions

When you notice these, proactively suggest `/prompt-for-restart`.
