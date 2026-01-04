#!/usr/bin/env bash
set -euo pipefail

# Screenshot Plugin for Claude Code
# Captures screenshots and compresses for Claude's visual context
#
# Usage: screenshot.sh [target] [--size KB] [--output PATH]
#   target: window (default), region, screen, or app name
#   --size: max file size in KB (default: 200)
#   --output: custom output path

# Defaults
TARGET="window"
MAX_SIZE_KB=200
OUTPUT=""
SCREENSHOTS_DIR="${PWD}/screenshots"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --size)
            MAX_SIZE_KB="$2"
            shift 2
            ;;
        --output)
            OUTPUT="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: screenshot.sh [target] [--size KB] [--output PATH]"
            echo ""
            echo "Targets:"
            echo "  window   - Interactive: click on a window (default)"
            echo "  region   - Interactive: drag to select area"
            echo "  screen   - Capture entire main display"
            echo "  <name>   - Capture named application's window"
            echo ""
            echo "Options:"
            echo "  --size KB      Maximum file size (default: 200)"
            echo "  --output PATH  Custom save path"
            exit 0
            ;;
        -*)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
        *)
            TARGET="$1"
            shift
            ;;
    esac
done

# Create output directory
mkdir -p "${SCREENSHOTS_DIR}"

# Generate output filename if not specified
if [[ -z "${OUTPUT}" ]]; then
    TIMESTAMP=$(date '+%Y-%m-%d--%H.%M.%S')
    OUTPUT="${SCREENSHOTS_DIR}/screenshot-${TIMESTAMP}.png"
fi

# Ensure output directory exists
mkdir -p "$(dirname "${OUTPUT}")"

echo "Capturing ${TARGET}..." >&2

# Capture based on target
case "${TARGET}" in
    window)
        # Interactive window capture
        screencapture -iW "${OUTPUT}"
        ;;
    region)
        # Interactive region capture
        screencapture -is "${OUTPUT}"
        ;;
    screen)
        # Full screen capture (main display)
        screencapture -m "${OUTPUT}"
        ;;
    *)
        # Capture specific application window by name
        APP_NAME="${TARGET}"

        # Try to bring app to front
        if osascript -e "tell application \"${APP_NAME}\" to activate" 2>/dev/null; then
            sleep 0.5
            # Try to capture by window ID
            WINDOW_ID=$(osascript -e 'tell application "System Events" to get id of first window of (first process whose frontmost is true)' 2>/dev/null || echo "")
            if [[ -n "${WINDOW_ID}" ]]; then
                screencapture -l "${WINDOW_ID}" "${OUTPUT}" 2>/dev/null || screencapture -iW "${OUTPUT}"
            else
                # Fallback to interactive
                screencapture -iW "${OUTPUT}"
            fi
        else
            echo "Could not find application '${APP_NAME}', using interactive capture" >&2
            screencapture -iW "${OUTPUT}"
        fi
        ;;
esac

# Check if capture was cancelled or failed
if [[ ! -f "${OUTPUT}" ]]; then
    echo "Screenshot cancelled or failed" >&2
    exit 1
fi

# Get current file size
get_size() {
    if [[ "$(uname)" == "Darwin" ]]; then
        stat -f%z "$1" 2>/dev/null || echo "0"
    else
        stat --printf="%s" "$1" 2>/dev/null || echo "0"
    fi
}

CURRENT_SIZE=$(get_size "${OUTPUT}")
MAX_SIZE_BYTES=$((MAX_SIZE_KB * 1024))

# Compress if needed
if [[ "${CURRENT_SIZE}" -gt "${MAX_SIZE_BYTES}" ]]; then
    echo "Compressing (${CURRENT_SIZE} bytes > ${MAX_SIZE_BYTES} limit)..." >&2

    # Try pngquant first (best compression)
    if command -v pngquant &>/dev/null; then
        pngquant --quality=65-80 --force --output "${OUTPUT}" "${OUTPUT}" 2>/dev/null || true
        CURRENT_SIZE=$(get_size "${OUTPUT}")
    fi

    # If still too large, resize with sips
    if [[ "${CURRENT_SIZE}" -gt "${MAX_SIZE_BYTES}" ]]; then
        # Calculate approximate resize ratio
        RATIO=$(echo "scale=2; sqrt(${MAX_SIZE_BYTES} / ${CURRENT_SIZE})" | bc 2>/dev/null || echo "0.7")

        # Get current width
        CURRENT_WIDTH=$(sips -g pixelWidth "${OUTPUT}" 2>/dev/null | tail -1 | awk '{print $2}')
        if [[ -n "${CURRENT_WIDTH}" && "${CURRENT_WIDTH}" =~ ^[0-9]+$ ]]; then
            NEW_WIDTH=$(echo "${CURRENT_WIDTH} * ${RATIO}" | bc 2>/dev/null | cut -d. -f1 || echo "800")

            # Minimum width 400px
            [[ "${NEW_WIDTH}" -lt 400 ]] && NEW_WIDTH=400

            sips -Z "${NEW_WIDTH}" "${OUTPUT}" --out "${OUTPUT}" 2>/dev/null || true
        fi
    fi

    FINAL_SIZE=$(get_size "${OUTPUT}")
    FINAL_KB=$((FINAL_SIZE / 1024))
    echo "Compressed to ${FINAL_KB}KB: ${OUTPUT}" >&2
else
    SIZE_KB=$((CURRENT_SIZE / 1024))
    echo "Saved (${SIZE_KB}KB): ${OUTPUT}" >&2
fi

# Output the path for Claude to read
echo "${OUTPUT}"
