#!/bin/bash
# LinkedIn Assistant - Action Logger
# Protokolliert alle Browser-Aktionen für Dokumentation

LOG_DIR="$HOME/.claude/linkedin-assistant"
LOG_FILE="$LOG_DIR/actions.log"

# Log-Verzeichnis erstellen falls nicht vorhanden
mkdir -p "$LOG_DIR"

# Timestamp erstellen
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Tool-Input aus stdin lesen (JSON)
INPUT=$(cat)

# Tool-Name extrahieren (falls vorhanden)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // "unknown"' 2>/dev/null)

# Beschreibung extrahieren (falls vorhanden)
DESCRIPTION=$(echo "$INPUT" | jq -r '.tool_input.description // .tool_input.url // "no description"' 2>/dev/null)

# Log-Eintrag schreiben
echo "[$TIMESTAMP] $TOOL_NAME: $DESCRIPTION" >> "$LOG_FILE"

# Erfolg
exit 0
