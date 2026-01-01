---
description: Zeigt Plugin-Status, Konfiguration und letzte Aktionen (user)
---

# LinkedIn Assistant Status

Zeige den aktuellen Status des LinkedIn Assistant Plugins.

## Workflow

1. **Plugin-Info anzeigen**
   - Version und geladene Komponenten
   - Verfügbare Skills
   - Verfügbare Agents

2. **Konfiguration prüfen**
   - Prüfe ob `.claude/linkedin-assistant.local.md` existiert
   - Zeige persönliche Einstellungen wenn vorhanden

3. **Browser-Status prüfen**
   - Hole Tab-Kontext
   - Prüfe ob LinkedIn-Tab offen ist
   - Zeige Login-Status wenn möglich

4. **Letzte Aktionen**
   - Lese aus `~/.claude/linkedin-assistant/actions.log`
   - Zeige letzte 5 Aktionen

## Output-Format

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔗 LINKEDIN ASSISTANT STATUS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📦 PLUGIN
• Version: 1.0.0
• Autor: Benno

📋 KOMPONENTEN
• Commands: inbox, notifications, research, post, login, status
• Agents: message-responder, notification-handler, profile-researcher
• Skills: benno-style, german-professional, linkedin-navigation

⚙️ KONFIGURATION
• Lokale Einstellungen: [Ja/Nein]
• Calendly-Link: [falls konfiguriert]

🌐 BROWSER-STATUS
• Tab-Kontext: [Verbunden/Nicht verbunden]
• LinkedIn-Tab: [Offen/Nicht offen]
• Login-Status: [Eingeloggt/Nicht eingeloggt/Unbekannt]

📊 LETZTE AKTIONEN
• [Zeitstempel] [Aktion]
• [Zeitstempel] [Aktion]
• [Zeitstempel] [Aktion]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💬 Sage "/linkedin:login" falls nicht eingeloggt.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Lokale Einstellungen

Falls `~/.claude/linkedin-assistant.local.md` existiert, lese:
- Calendly-Link für Terminbuchungen
- Bevorzugte Signatur
- Sonstige persönliche Präferenzen

## Aktions-Log lesen

```bash
# Letzte 5 Einträge
tail -5 ~/.claude/linkedin-assistant/actions.log
```

## Wichtige Regeln

1. **IMMER** Browser-Verbindung prüfen
2. **IMMER** hilfreiche nächste Schritte vorschlagen
3. **NIEMALS** sensible Daten anzeigen (Passwörter etc.)
