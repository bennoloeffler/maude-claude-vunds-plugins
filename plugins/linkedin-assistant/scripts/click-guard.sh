#!/bin/bash
# click-guard.sh - Safety check for LinkedIn send/submit actions
# Exit 0 = allow, Exit 2 = block

# Read tool input from stdin
INPUT=$(cat)

# Extract the element being clicked (if available)
ELEMENT=$(echo "$INPUT" | jq -r '.tool_input.uid // empty' 2>/dev/null)

# Log all click attempts
LOG_DIR="${HOME}/.claude/linkedin-assistant"
mkdir -p "$LOG_DIR"
echo "$(date '+%Y-%m-%d %H:%M:%S') CLICK: $ELEMENT" >> "$LOG_DIR/click-guard.log"

# List of dangerous button patterns to block without confirmation
DANGEROUS_PATTERNS=(
    "send"
    "senden"
    "post"
    "veröffentlichen"
    "publish"
    "submit"
    "delete"
    "löschen"
    "remove"
    "entfernen"
)

# Check if element matches dangerous patterns
for pattern in "${DANGEROUS_PATTERNS[@]}"; do
    if echo "$ELEMENT" | grep -iq "$pattern"; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') BLOCKED: $ELEMENT (matched: $pattern)" >> "$LOG_DIR/click-guard.log"
        # Output warning message
        echo "BLOCKED: Klick auf '$ELEMENT' erfordert Bestätigung. Sage 'ja, senden' um fortzufahren."
        exit 2  # Block the action
    fi
done

# Allow other clicks
exit 0
