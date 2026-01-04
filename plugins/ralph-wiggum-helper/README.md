# Ralph-Wiggum Helper Plugin

Quickly format prompts for the ralph-wiggum agentic loop.

## Commands

### `/ralph-wiggum-helper:create-prompt`

Transforms a simple multiline prompt into a properly formatted ralph-wiggum loop command.

**Features:**
- Optional prompt improvement by analyzing your codebase
- Optional "definition of done" enhancement
- Optional saving to `./docs/00_prompts/` for documentation

**Quick mode (n/n/n):** Just formats your prompt as-is - no analysis, no changes.

**Example:**

```
/ralph-wiggum-helper:create-prompt
Add user authentication to the app
```

**Output:**
```
/ralph-wiggum:ralph-loop
 "Add user authentication to the app

  When finished, say: <promise>TASK_COMPLETELY_DONE</promise>"
  --max-iterations 30
  --completion-promise TASK_COMPLETELY_DONE
```
