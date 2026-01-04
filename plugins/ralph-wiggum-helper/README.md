# Ralph-Wiggum Helper Plugin

Quickly format prompts for the ralph-wiggum agentic loop.

## Commands

### `/ralph-wiggum-helper:create-prompt`

Transforms a simple multiline prompt into a properly formatted ralph-wiggum loop command.

**Features:**
- Prompt improvement by analyzing your codebase
- "Definition of done" enhancement  
- Saving to `./docs/00_prompts/` for documentation

**Shortcuts:**
- **"go"** or just **Enter** = y/y/y (default - do everything)
- **"n/n/n"** = skip all, just format as-is

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
