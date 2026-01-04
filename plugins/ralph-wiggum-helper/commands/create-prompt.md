---
description: Transform a simple prompt into a ralph-wiggum loop command with optional prompt improvement
allowed-arguments:
  - prompt
---

# CREATE-PROMPT - Ralph-Wiggum Loop Formatter

You help the user create a properly formatted prompt for the ralph-wiggum agentic loop.

## Input

The user provides a multiline prompt `<p>` describing their task.

## Process

### Step 1: Ask Three Questions

Before processing, ask these three questions ONE AT A TIME and wait for each answer:

**Question 1:**
> Should I rework the prompt by analyzing your docs/code first to make it more specific and actionable? (y/n)

**Question 2:**
> Should I look for good "definition of done" criteria and improve the acceptance criteria in your prompt? (y/n)

**Question 3:**
> Should I save the original and improved prompt to `./docs/00_prompts/prompt-<feature>-ISO-DATE--HH-MM-SS.md`? (y/n)

### Step 2: Process Based on Answers

**If all answers are `n/n/n`:**
- Take the user's prompt EXACTLY as provided
- Skip directly to output generation
- Do NOT analyze code, do NOT suggest improvements, do NOT save

**If any answer is `y`:**

For **Question 1 = y**: 
- Scan relevant docs (CLAUDE.md, docs/, README.md) and code structure
- Understand the project context
- Rewrite the prompt to be more specific, referencing actual file paths, patterns, and conventions found

For **Question 2 = y**:
- Analyze the prompt for clear completion criteria
- Add specific "definition of done" checkpoints
- Include measurable acceptance criteria
- Add verification steps (e.g., "build succeeds", "tests pass", "UI shows X")

For **Question 3 = y**:
- Create the directory if needed: `mkdir -p ./docs/00_prompts`
- Generate filename: `prompt-<feature-slug>-YYYY-MM-DD--HH-MM-SS.md`
- Save both the original and improved prompt with metadata

### Step 3: Generate Output

Format the final prompt (original or improved) as:

```
/ralph-wiggum:ralph-loop
 "<FINAL_PROMPT>

  When finished, say: <promise>TASK_COMPLETELY_DONE</promise>"
  --max-iterations 30
  --completion-promise TASK_COMPLETELY_DONE
```

**Important formatting rules:**
- The prompt text goes inside double quotes
- Add the completion promise instruction at the end of the prompt
- Keep the exact spacing and flag format shown above

## Output

1. If improvements were made, briefly summarize what changed
2. Display the ready-to-copy ralph-wiggum command in a code block
3. Tell user: "Copy the above command and paste it to start the ralph-wiggum loop"

## Example

**User input:**
```
Add dark mode to the settings view
```

**If n/n/n - Output:**
```
/ralph-wiggum:ralph-loop
 "Add dark mode to the settings view

  When finished, say: <promise>TASK_COMPLETELY_DONE</promise>"
  --max-iterations 30
  --completion-promise TASK_COMPLETELY_DONE
```

**If y/y/n - Output (after analysis):**
```
/ralph-wiggum:ralph-loop
 "Add dark mode support to SettingsView.swift:

  Requirements:
  - Add a toggle in the Settings section for dark/light mode
  - Store preference in SettingsStore (persist to ~/.maude/settings.json)
  - Apply theme change immediately without app restart
  - Follow existing UI patterns in the codebase

  Definition of Done:
  - [ ] Toggle appears in settings UI
  - [ ] Preference persists across app restarts
  - [ ] Theme changes apply immediately
  - [ ] Build succeeds with no warnings
  - [ ] Existing functionality unaffected

  When finished, say: <promise>TASK_COMPLETELY_DONE</promise>"
  --max-iterations 30
  --completion-promise TASK_COMPLETELY_DONE
```
