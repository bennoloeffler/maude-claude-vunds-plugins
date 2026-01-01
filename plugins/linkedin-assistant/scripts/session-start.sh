#!/bin/bash
# session-start.sh - Welcome message and status check at session start

LOG_DIR="${HOME}/.claude/linkedin-assistant"
mkdir -p "$LOG_DIR"

# Log session start
echo "$(date '+%Y-%m-%d %H:%M:%S') SESSION_START" >> "$LOG_DIR/sessions.log"

# Output welcome message (will be shown to user)
cat << 'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔗 LINKEDIN ASSISTANT - Ready

Verfügbare Commands:
• /linkedin:inbox       - Nachrichten prüfen
• /linkedin:notifications - Mitteilungen
• /linkedin:research    - Profile recherchieren
• /linkedin:post        - Post erstellen
• /linkedin:status      - Plugin-Status

Tipp: Sage "LinkedIn öffnen" um zu starten.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

exit 0
