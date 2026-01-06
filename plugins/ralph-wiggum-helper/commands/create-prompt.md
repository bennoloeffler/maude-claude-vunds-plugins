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

Before processing, ask these three questions. The user can answer individually OR use shortcuts:
- **"go"** or **Enter** = y/y/y (default - do everything)
- **"n/n/n"** = skip all improvements, just format as-is

**Question 1:**
> Should I rework the prompt by analyzing your docs/code first to make it more specific and actionable? (Y/n)

**Question 2:**
> Should I look for good "definition of done" criteria and improve the acceptance criteria in your prompt? (Y/n)

**Question 3:**
> Should I save the original and improved prompt to `./docs/00_prompts/prompt-<feature>-ISO-DATE--HH-MM-SS.md`? (Y/n)

**Default is YES for all questions.** Empty answer or "go" means yes.

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

### Step 3: Add Standard Instructions

Every generated prompt MUST include these standard instructions (add them after the user's requirements but before the "Definition of Done"):

```
Instructions:
- Use command /feature-dev:feature-dev whenever useful
- Create general sub-agents when reading files, analysing files, creating code, running code, run tests, etc.
- Whenever you want to see results on monitor and find no other way: use command /screenshot in a general agent and get results back to work on them
```

### Step 4: Generate TWO Outputs

You MUST output the prompt in TWO formats:

---

**FORMAT 1: Human-Readable (for review)**

Display the prompt nicely formatted with real line breaks, indentation, and structure.
This is for the user to READ and UNDERSTAND what the task is.

```
📋 PROMPT (Human-Readable):
════════════════════════════════════════════════════════════

Add dark mode support to SettingsView.swift

Requirements:
- Add a toggle in Settings for dark/light mode
- Store preference in SettingsStore (persist to ~/.maude/settings.json)
- Apply theme change immediately without app restart
- Follow existing UI patterns

Instructions:
- Use command /feature-dev:feature-dev whenever useful
- Create general sub-agents when reading files, analysing files, creating code, running code, run tests, etc.
- Whenever you want to see results on monitor and find no other way: use command /screenshot in a general agent and get results back to work on them

Definition of Done:
- [ ] Toggle appears in settings UI
- [ ] Preference persists across restarts
- [ ] Theme changes apply immediately
- [ ] Build succeeds with no warnings

When finished, say: <promise>TASK_COMPLETELY_DONE</promise>

════════════════════════════════════════════════════════════
```

---

**FORMAT 2: Copy-Paste Command (single line with \n)**

Convert ALL newlines to literal `\n` escape sequences.
This creates ONE LONG LINE that can be copied and pasted.

```
📋 COPY THIS COMMAND:
```

```
/ralph-wiggum:ralph-loop "Add dark mode support to SettingsView.swift\n\nRequirements:\n- Add a toggle in Settings for dark/light mode\n- Store preference in SettingsStore (persist to ~/.maude/settings.json)\n- Apply theme change immediately without app restart\n- Follow existing UI patterns\n\nInstructions:\n- Use command /feature-dev:feature-dev whenever useful\n- Create general sub-agents when reading files, analysing files, creating code, running code, run tests, etc.\n- Whenever you want to see results on monitor and find no other way: use command /screenshot in a general agent and get results back to work on them\n\nDefinition of Done:\n- [ ] Toggle appears in settings UI\n- [ ] Preference persists across restarts\n- [ ] Theme changes apply immediately\n- [ ] Build succeeds with no warnings\n\nWhen finished, say: <promise>TASK_COMPLETELY_DONE</promise>" --max-iterations 30 --completion-promise TASK_COMPLETELY_DONE
```

---

**CRITICAL formatting rules for Format 2:**
- The ENTIRE command must be on ONE LINE (no actual line breaks)
- Replace every newline with literal `\n`
- Replace blank lines with `\n\n`
- The prompt text goes inside double quotes
- If the prompt contains quotes, escape them with backslash: `\"`
- All flags come after the closing quote on the same line

## Output

1. If improvements were made, briefly summarize what changed
2. Display **Format 1** (human-readable) so user can review
3. Display **Format 2** (copy-paste command) in a code block
4. Tell user: "Copy the command above and paste it to start the ralph-wiggum loop"

## Example

**User input:**
```
Add dark mode to the settings view
```

**If n/n/n - Output:**

📋 PROMPT (Human-Readable):
```
Add dark mode to the settings view.

Instructions:
- Use command /feature-dev:feature-dev whenever useful
- Create general sub-agents when reading files, analysing files, creating code, running code, run tests, etc.
- Whenever you want to see results on monitor and find no other way: use command /screenshot in a general agent and get results back to work on them

When finished, say: <promise>TASK_COMPLETELY_DONE</promise>
```

📋 COPY THIS COMMAND:
```
/ralph-wiggum:ralph-loop "Add dark mode to the settings view.\n\nInstructions:\n- Use command /feature-dev:feature-dev whenever useful\n- Create general sub-agents when reading files, analysing files, creating code, running code, run tests, etc.\n- Whenever you want to see results on monitor and find no other way: use command /screenshot in a general agent and get results back to work on them\n\nWhen finished, say: <promise>TASK_COMPLETELY_DONE</promise>" --max-iterations 30 --completion-promise TASK_COMPLETELY_DONE
```

**If y/y/n - Output (after analysis):**

📋 PROMPT (Human-Readable):
```
Add dark mode support to SettingsView.swift

Requirements:
- Add a toggle in Settings for dark/light mode
- Store preference in SettingsStore (persist to ~/.maude/settings.json)
- Apply theme change immediately without app restart
- Follow existing UI patterns

Instructions:
- Use command /feature-dev:feature-dev whenever useful
- Create general sub-agents when reading files, analysing files, creating code, running code, run tests, etc.
- Whenever you want to see results on monitor and find no other way: use command /screenshot in a general agent and get results back to work on them

Definition of Done:
- [ ] Toggle appears in settings UI
- [ ] Preference persists across restarts
- [ ] Theme changes apply immediately
- [ ] Build succeeds with no warnings

When finished, say: <promise>TASK_COMPLETELY_DONE</promise>
```

📋 COPY THIS COMMAND:
```
/ralph-wiggum:ralph-loop "Add dark mode support to SettingsView.swift\n\nRequirements:\n- Add a toggle in Settings for dark/light mode\n- Store preference in SettingsStore (persist to ~/.maude/settings.json)\n- Apply theme change immediately without app restart\n- Follow existing UI patterns\n\nInstructions:\n- Use command /feature-dev:feature-dev whenever useful\n- Create general sub-agents when reading files, analysing files, creating code, running code, run tests, etc.\n- Whenever you want to see results on monitor and find no other way: use command /screenshot in a general agent and get results back to work on them\n\nDefinition of Done:\n- [ ] Toggle appears in settings UI\n- [ ] Preference persists across restarts\n- [ ] Theme changes apply immediately\n- [ ] Build succeeds with no warnings\n\nWhen finished, say: <promise>TASK_COMPLETELY_DONE</promise>" --max-iterations 30 --completion-promise TASK_COMPLETELY_DONE
```
