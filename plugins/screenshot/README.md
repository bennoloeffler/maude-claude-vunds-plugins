# Screenshot Plugin

Capture screenshots for Claude's visual context. Take screenshots of windows, regions, or the full screen with automatic compression.

## Installation

```bash
/plugin marketplace add bennoloeffler/maude-claude-vunds-plugins
/plugin install screenshot@maude-claude-vunds-plugins
```

## Usage

```bash
# Interactive window capture (click on window)
/screenshot

# Capture specific application
/screenshot Safari
/screenshot "Google Chrome"

# Capture region (drag to select)
/screenshot region

# Full screen
/screenshot screen

# Custom size limit
/screenshot --size 500

# Custom output path
/screenshot --output ./debug/state.png
```

## Features

- **Window capture** - Click on any window to capture it
- **Region capture** - Drag to select a rectangular area
- **Screen capture** - Capture entire display
- **App capture** - Capture by application name
- **Auto-compression** - Reduces to target size (default 200KB)
- **Claude integration** - Returns path for Claude to read

## Compression

Screenshots are automatically compressed to stay under the size limit:

1. **pngquant** (if installed) - Best compression, ~75% reduction
2. **sips** (built-in) - Resize to reduce file size

Install pngquant for better compression:
```bash
brew install pngquant
```

## Requirements

- macOS (uses built-in `screencapture` and `sips`)
- Optional: `pngquant` for better compression

## Output

Screenshots are saved to `./screenshots/` with timestamp:
```
./screenshots/screenshot-2026-01-04--15.30.45.png
```

## Use Cases

| Scenario | Command |
|----------|---------|
| Debug web page | `/screenshot Chrome` |
| Verify UI state | `/screenshot` |
| Document bug | `/screenshot region` |
| Full context | `/screenshot screen` |
