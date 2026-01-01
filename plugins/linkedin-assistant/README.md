# LinkedIn Assistant Plugin

Ein umfassendes Claude Code Plugin zur LinkedIn-Automatisierung auf Deutsch.

## Features

- **Posteingang verwalten** - Nachrichten mit nummerierten Antwortvorschlägen
- **Mitteilungen bearbeiten** - Likes, Kommentare, Erwähnungen mit Reaktionsvorschlägen
- **Profile recherchieren** - Schnelle Zusammenfassungen mit Networking-Tipps
- **Posts erstellen** - Entwürfe im professionellen Benno-Stil
- **Browser-Automation** - Nutzt Claude-in-Chrome für echte LinkedIn-Interaktion

## Installation

```bash
# Plugin aktivieren
claude --plugin-dir ./plugins/linkedin-assistant
```

## Voraussetzungen

- Claude Code CLI
- **Browser-Automation** (eine der folgenden Optionen)
- macOS (für Sound-Benachrichtigungen)

---

## Browser-Automation einrichten

Dieses Plugin benötigt Browser-Automatisierung. Es gibt zwei Optionen:

### Option 1: Claude in Chrome (Empfohlen)

Claude in Chrome ist eine Chrome-Erweiterung, die Claude Code ermöglicht, deinen Browser direkt zu steuern.

**Features:**
- Websites navigieren, Formulare ausfüllen, Screenshots machen
- GIFs von Browser-Interaktionen aufnehmen
- Debugging mit Console-Logs und Network-Requests
- Echtzeit-Browsersteuerung aus Claude Code

**Installation:**

1. Chrome-Erweiterung aus dem [Chrome Web Store](https://chromewebstore.google.com/detail/claude-in-chrome/...) installieren
2. Chrome öffnen und Erweiterung aktivieren
3. In Claude Code `/chrome` eingeben um Browser-Kontrolle zu starten

**Verwendung:**
```bash
# Chrome-Session starten
/chrome

# Claude kann jetzt Chrome steuern:
# - Zu URLs navigieren
# - Klicken, tippen, scrollen
# - Screenshots machen
# - Seiteninhalte lesen
```

### Option 2: Playwright MCP Server (Alternative)

Falls du Chrome nicht installieren kannst oder headless-Automation bevorzugst:

**Installation:**
```bash
# Via Claude Code MCP Einstellungen
claude mcp add playwright

# Oder manuell in ~/.claude.json:
{
  "mcpServers": {
    "playwright": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-playwright"]
    }
  }
}
```

**Vergleich:**

| Feature | Claude in Chrome | Playwright MCP |
|---------|-----------------|----------------|
| Visuelles Feedback | Ja (Browser sichtbar) | Nein (headless) |
| Setup | Extension installieren | NPM Paket |
| CI/CD geeignet | Nein | Ja |
| Session-Persistenz | Ja | Nein |

---

## Slash Commands

| Command | Beschreibung | Argument-Hint |
|---------|--------------|---------------|
| `/linkedin:inbox` | Zeigt Posteingang mit Antwortvorschlägen | `<ungelesen\|heute\|name>` |
| `/linkedin:notifications` | Zeigt Mitteilungen mit Reaktionsvorschlägen | `<kommentare\|erwähnungen\|anfragen>` |
| `/linkedin:research` | Recherchiert Person oder Firma | `<name\|firma\|url>` |
| `/linkedin:post` | Erstellt Post-Entwurf | `<thema>` |
| `/linkedin:login` | Hilft beim Login-Prozess | - |
| `/linkedin:status` | Zeigt Plugin-Status und Konfiguration | - |

## Verwendung

### Nachrichten bearbeiten

```
/linkedin:inbox

# Output:
📬 POSTEINGANG (3 neue)

[1] Max Müller (vor 2h)
    "Interessiere mich für..."

    [1a] Danke für Ihre Nachricht...
    [1b] Vielen Dank! Lassen Sie uns...
    [1c] IGNORIEREN (Spam)

💬 Sage: "Sende 1a" oder "Bearbeite 1b kürzer"
```

### Mitteilungen verwalten

```
/linkedin:notifications

# Output:
🔔 MITTEILUNGEN

[1] 💬 Thomas kommentierte: "Sehr interessant..."
    [1a] 💬 "Danke für den Input!"
    [1b] 👍 Nur Like
    [1c] 🚫 Ignorieren
```

### Profile recherchieren

```
/linkedin:research Max Müller

# Output:
🔍 PROFIL: Max Müller
• Position: CEO bei TechCo
• Relevanz: HOCH
• Gemeinsamkeiten: Digitalisierung, Berlin

💬 Empfohlene Ansprache: "Hallo Herr Müller..."
```

### Posts erstellen

```
/linkedin:post KI im Mittelstand

# Output:
✏️ POST-ENTWURF

[1] Storytelling-Variante
[2] Listen-Format
[3] Kontroverse Meinung

💬 Sage: "Nimm 2" oder "Mix 1 und 3"
```

## Agents

Das Plugin nutzt spezialisierte Agents die parallel laufen können:

| Agent | Aufgabe |
|-------|---------|
| `message-responder` | Analysiert Nachrichten, erstellt Antworten |
| `notification-handler` | Prüft Mitteilungen, schlägt Reaktionen vor |
| `profile-researcher` | Recherchiert Profile, findet Gemeinsamkeiten |

### Parallel-Ausführung

```
# Diese Agents können gleichzeitig laufen:
message-responder + profile-researcher → Nachrichten MIT Kontext

# Beschleunigt die Verarbeitung erheblich
```

## Skills (automatisch aktiviert)

| Skill | Trigger | Struktur |
|-------|---------|----------|
| `benno-style` | "professionell antworten", "Benno-Stil" | V&S-Kontext, Kommunikationsstil |
| `linkedin-navigation` | "LinkedIn öffnen", "zum Posteingang" | Browser-Navigation |
| `german-professional` | "auf Deutsch formulieren", "Business-Deutsch" | Mit `references/` für Details |

### Progressive Disclosure (german-professional)

```
skills/german-professional/
├── SKILL.md                    # Kernprinzipien (~50 Zeilen)
└── references/
    ├── anrede-formeln.md       # Vollständige Anrede-/Grußformeln
    ├── haeufige-fehler.md      # Typische Fehler vermeiden
    └── linkedin-templates.md   # LinkedIn-spezifische Vorlagen
```

## Templates

Das Plugin nutzt Vorlagen für konsistente Kommunikation:

| Template | Zweck |
|----------|-------|
| `reaktionen.md` | Typische Antwortmuster |
| `no-gos.md` | Spam-Erkennung, was ignorieren |
| `conditions.md` | Wann nicht reagieren |
| `giveaways.md` | Ressourcen zum Teilen |

## Hooks

Automatische Aktionen:

| Hook | Beschreibung |
|------|--------------|
| **SessionStart** | Zeigt Begrüßung und verfügbare Commands |
| **PreToolUse (click)** | Sicherheitscheck - blockiert Send/Post ohne Bestätigung |
| **PostToolUse** | Protokolliert alle Browser-Aktionen |
| **Stop** | Glas-Ton wenn Claude fertig ist |
| **SubagentStop** | Pop-Ton wenn ein Agent fertig ist |

### Sicherheits-Hook

Der `click-guard.sh` blockiert Klicks auf gefährliche Buttons:
- "Send" / "Senden"
- "Post" / "Veröffentlichen"
- "Delete" / "Löschen"

Erfordert explizite Bestätigung: "ja, senden"

Logs finden sich in: `~/.claude/linkedin-assistant/`

## Sicherheit

- **Niemals** werden Passwörter eingegeben
- **Niemals** wird automatisch gesendet ohne Bestätigung
- **Immer** nummerierte Vorschläge für User-Review
- **Immer** Spam-Check vor Antwortvorschlägen

## Konfiguration

### Sound deaktivieren

In `hooks/hooks.json` den `Stop` Hook entfernen oder auskommentieren.

### Logging deaktivieren

In `hooks/hooks.json` den `PostToolUse` Hook entfernen.

### Templates anpassen

Die Vorlagen in `templates/` können frei angepasst werden:
- `reaktionen.md` - Antwort-Bausteine
- `no-gos.md` - Spam-Patterns
- `giveaways.md` - Ressourcen zum Teilen

## Troubleshooting

### Plugin wird nicht erkannt
```bash
# Prüfe Struktur
ls -la plugins/linkedin-assistant/.claude-plugin/
# Sollte plugin.json zeigen
```

### Hooks funktionieren nicht
```bash
# Scripts ausführbar machen
chmod +x plugins/linkedin-assistant/scripts/*.sh
```

### Kein Sound auf macOS
```bash
# Test Sound
afplay /System/Library/Sounds/Glass.aiff
```

### Browser-Automation funktioniert nicht
- Prüfe ob Claude-in-Chrome Extension aktiv ist
- Prüfe ob Tab-Kontext geholt wird
- Versuche `/linkedin:login` zuerst

## Verzeichnisstruktur

```
linkedin-assistant/
├── .claude-plugin/
│   └── plugin.json
├── commands/
│   ├── inbox.md
│   ├── notifications.md
│   ├── research.md
│   ├── post.md
│   ├── login.md
│   └── status.md              # NEU: Diagnose-Command
├── agents/
│   ├── message-responder.md   # 3 Beispiele
│   ├── notification-handler.md
│   └── profile-researcher.md
├── skills/
│   ├── benno-style/
│   │   └── SKILL.md           # Mit V&S-Kontext
│   ├── linkedin-navigation/
│   │   └── SKILL.md
│   └── german-professional/
│       ├── SKILL.md           # Schlank, nur Kernprinzipien
│       └── references/        # NEU: Progressive Disclosure
│           ├── anrede-formeln.md
│           ├── haeufige-fehler.md
│           └── linkedin-templates.md
├── hooks/
│   └── hooks.json             # Mit SessionStart + PreToolUse
├── templates/
│   ├── reaktionen.md
│   ├── no-gos.md
│   ├── conditions.md
│   └── giveaways.md
├── scripts/
│   ├── notification-sound.sh
│   ├── agent-complete-sound.sh
│   ├── action-logger.sh
│   ├── click-guard.sh        # NEU: Sicherheits-Check
│   └── session-start.sh      # NEU: Begrüßung
├── CLAUDE.md
└── README.md
```

## Lizenz

MIT

## Autor

Benno
