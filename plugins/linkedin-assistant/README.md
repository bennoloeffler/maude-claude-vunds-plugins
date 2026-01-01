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
- Claude-in-Chrome Extension (für Browser-Automation)
- macOS (für Sound-Benachrichtigungen)

## Slash Commands

| Command | Beschreibung |
|---------|--------------|
| `/linkedin:inbox` | Zeigt Posteingang mit Antwortvorschlägen |
| `/linkedin:notifications` | Zeigt Mitteilungen mit Reaktionsvorschlägen |
| `/linkedin:research [Name]` | Recherchiert Person oder Firma |
| `/linkedin:post [Thema]` | Erstellt Post-Entwurf |
| `/linkedin:login` | Hilft beim Login-Prozess |

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

| Skill | Trigger |
|-------|---------|
| `benno-style` | "professionell antworten", "Benno-Stil" |
| `linkedin-navigation` | "LinkedIn öffnen", "zum Posteingang" |
| `german-professional` | "auf Deutsch formulieren", "Business-Deutsch" |

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

- **Sound bei Fertigstellung** - Glas-Ton wenn Claude fertig ist
- **Agent-Sound** - Pop-Ton wenn ein Agent fertig ist
- **Action-Logging** - Protokolliert Browser-Aktionen

Logs finden sich in: `~/.claude/linkedin-assistant/actions.log`

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
│   └── login.md
├── agents/
│   ├── message-responder.md
│   ├── notification-handler.md
│   └── profile-researcher.md
├── skills/
│   ├── benno-style/
│   ├── linkedin-navigation/
│   └── german-professional/
├── hooks/
│   └── hooks.json
├── templates/
│   ├── reaktionen.md
│   ├── no-gos.md
│   ├── conditions.md
│   └── giveaways.md
├── scripts/
│   ├── notification-sound.sh
│   ├── agent-complete-sound.sh
│   └── action-logger.sh
├── CLAUDE.md
└── README.md
```

## Lizenz

MIT

## Autor

Benno
