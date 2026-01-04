---
description: Prepare a restart prompt when context is running low - captures everything needed to continue in a new session
---

# Context Running Low - Prepare Restart Prompt

You are running low on context. Before the session ends, you MUST capture everything needed to continue this work in a new Claude Code session.

## Your Task

Create a comprehensive restart prompt file at `restart-prompt.md` in the project root that contains ALL information needed to seamlessly continue this work.

## Required Sections

### 1. TASK DEFINITION
Write a precise, unambiguous description of the current task:
- What is being built/fixed/improved?
- What triggered this work? (user request, bug, feature)
- Any constraints or requirements mentioned

### 2. JOB-DONE DEFINITION
Define clear acceptance criteria:
- What does "done" look like?
- What must work for this to be complete?
- Any specific test cases that must pass?

### 3. CURRENT PROGRESS
Document what has been accomplished:
- Files created or modified (list paths)
- Key decisions made and why
- What's working now that wasn't before

### 4. NEXT STEPS
List remaining work in priority order:
- Immediate next action (be specific)
- Subsequent steps
- Any blocked items and what unblocks them

### 5. KEY INSIGHTS
Capture important discoveries:
- Technical insights about the codebase
- Patterns observed
- Gotchas or pitfalls discovered
- "Aha moments" that shouldn't be lost

### 6. FILE REFERENCES
List all relevant files:
```
@path/to/file1.swift - why it's relevant
@path/to/file2.ts - why it's relevant
```

### 7. DOCUMENTATION REFERENCES
External docs that were helpful:
- URLs to documentation consulted
- Relevant sections of CLAUDE.md
- Any specification documents

### 8. TODOS
Extract all pending items:
- From conversation
- From code comments added
- From mental notes

### 9. TESTING HINTS
How to verify the work:
- Commands to run
- What to look for
- Known edge cases

### 10. CONTEXT FOR NEW SESSION
The prompt to paste into a new session:
```
I'm continuing work on [TASK].

Please read @restart-prompt.md for full context.

The immediate next step is: [SPECIFIC ACTION]
```

## Output Format

Write to `restart-prompt.md` using this template:

```markdown
# Restart Prompt: [Brief Task Title]

Generated: [timestamp]
Session context: ~[X]% remaining when saved

---

## Task Definition

[Precise description]

## Job-Done Definition

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Current Progress

### Completed
- [x] Item 1
- [x] Item 2

### Files Modified
- `path/to/file.swift` - [what changed]

## Next Steps

1. **IMMEDIATE**: [Very specific next action]
2. [Step 2]
3. [Step 3]

## Key Insights

- **Insight 1**: [Description]
- **Insight 2**: [Description]

## File References

Read these files for context:
- @path/to/key/file1
- @path/to/key/file2

## Documentation References

- [Doc Name](url) - why relevant
- @docs/relevant-doc.md

## TODOs

- [ ] TODO 1
- [ ] TODO 2

## Testing Hints

```bash
# How to test
./run-tests.sh
```

Expected behavior: [description]

---

## Prompt for New Session

Copy this to start the new session:

```
I'm continuing work on [TASK].

Read @restart-prompt.md for full context including:
- Task definition and acceptance criteria
- Current progress and next steps
- Key insights and file references

The immediate next action is: [SPECIFIC ACTION]

Start by reviewing the restart prompt, then proceed with the next step.
```
```

## Important

- Be THOROUGH - the new session has ZERO context
- Be SPECIFIC - vague descriptions waste the new session's context
- Include PATHS - exact file paths, not just names
- Capture DECISIONS - why things were done a certain way
- Note BLOCKERS - anything that needs resolution

After creating the file, tell the user:
1. The restart prompt has been saved
2. How to use it in a new session
3. Remind them to commit it if they want to preserve it
