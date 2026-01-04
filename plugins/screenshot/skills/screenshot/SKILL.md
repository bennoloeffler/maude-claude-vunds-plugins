# Screenshot Plugin Skill

You have the Screenshot plugin installed which allows you to capture visual context from the user's screen.

## When to Use Screenshots

Use the `/screenshot` command when:

| Situation | Example |
|-----------|---------|
| User asks you to look at something | "Can you see what's on my screen?" |
| Debugging visual output | "My CSS looks broken" |
| Verifying browser automation | After navigating, check the result |
| UI/design review | "Does this layout look right?" |
| Documenting issues | Capture error dialogs or bugs |

## Capture Methods

| Command | Interactive | Best For |
|---------|-------------|----------|
| `/screenshot` | Click on window | Single window focus |
| `/screenshot region` | Drag to select | Specific UI area |
| `/screenshot screen` | None | Full context |
| `/screenshot Safari` | None | Known app window |

## After Capturing

The screenshot is saved and the path is returned. You should:

1. Read the image using the Read tool to see its contents
2. Analyze the visual content based on user's question
3. Reference specific UI elements in your response

## Size Optimization

Default max size: **200KB**. Adjust with `--size`:

| Size | When to Use |
|------|-------------|
| `--size 100` | Fast loading, basic UI check |
| `--size 200` | Default, good balance |
| `--size 500` | More detail needed |

## Common Workflow Patterns

### Debug a Visual Bug

```
User: "Something looks wrong with my app"
You: /screenshot
[Read the image]
"I can see the issue - the modal dialog is positioned off-center and the overlay isn't covering the full screen..."
```

### Verify Browser Navigation

```
[After using browser tools to navigate]
You: /screenshot Safari
[Read the image]
"The login page has loaded successfully. I can see the username field, password field, and Sign In button..."
```

### Document an Error

```
User: "I keep getting this error"
You: /screenshot region
"Please drag to select the error message"
[Read the image]
"The error says 'ECONNREFUSED' which means..."
```

## Limitations

- **macOS only** - uses screencapture
- Interactive captures require user click/drag
- Cannot capture secure system dialogs
- Very large screens may still exceed size limits

## Script Location

The screenshot script is at:
```
${CLAUDE_PLUGIN_ROOT}/scripts/screenshot.sh
```

You can invoke it directly via Bash if the command isn't working:
```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/screenshot.sh" window --size 200
```
