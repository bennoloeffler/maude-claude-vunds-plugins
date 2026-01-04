---
description: Capture a screenshot for Claude to analyze visually
---

Take a screenshot that Claude can use for visual analysis. The image is automatically compressed for efficient context usage.

## Usage

```
/screenshot [target] [--size SIZE] [--output PATH]
```

## Arguments

| Argument | Values | Default | Description |
|----------|--------|---------|-------------|
| `target` | `window`, `region`, `screen`, `<app-name>` | `window` | What to capture |
| `--size` | Number (KB) | `200` | Maximum file size in KB |
| `--output` | File path | auto-generated | Custom output path |

## Examples

```bash
# Interactive window capture (click on window)
/screenshot

# Capture specific application window
/screenshot Safari
/screenshot "Google Chrome"

# Capture region (drag to select)
/screenshot region

# Full screen capture
/screenshot screen

# Custom size limit (500KB for more detail)
/screenshot --size 500

# Custom output path
/screenshot --output ./debug/current-state.png

# Combined options
/screenshot Safari --size 100 --output ./browser.png
```

## What Happens

1. The screenshot script runs based on your target selection
2. For `window` or no target: cursor becomes camera - click on desired window
3. For `region`: cursor becomes crosshair - drag to select area
4. For `screen`: captures entire main display
5. For app name: activates that app and captures its window
6. Image is auto-compressed if larger than size limit
7. File path is returned so Claude can read the image

## After Capture

Claude will automatically read the captured image and can:
- Analyze UI layouts and designs
- Identify visual bugs or issues
- Describe what's shown on screen
- Compare against expected appearance

## Notes

- **macOS only** - uses built-in screencapture
- Interactive captures (window/region) require user action
- Screenshots saved to `./screenshots/` by default
- Compression uses sips (built-in) or pngquant if available
