# LinkedIn Assistant Plugin - Architektur & Dokumentation

## Plugin-Struktur (Offiziell von Context7)

### Verzeichnis-Layout
```
linkedin-assistant/
├── .claude-plugin/
│   └── plugin.json          # NUR plugin.json hier! (REQUIRED)
├── commands/                 # Slash Commands
│   ├── inbox.md
│   ├── notifications.md
│   ├── research.md
│   └── post.md
├── agents/                   # Subagent Definitionen
│   ├── message-responder.md
│   ├── notification-handler.md
│   └── profile-researcher.md
├── skills/                   # Agent Skills (Unterverzeichnisse!)
│   ├── benno-style/
│   │   └── SKILL.md
│   ├── linkedin-navigation/
│   │   └── SKILL.md
│   └── german-professional/
│       └── SKILL.md
├── hooks/
│   └── hooks.json
├── templates/
│   ├── reaktionen.md
│   ├── no-gos.md
│   ├── giveaways.md
│   └── conditions.md
├── scripts/
│   ├── notification-sound.sh
│   └── action-logger.sh
└── README.md
```

**KRITISCH:** Alle Komponenten-Verzeichnisse (commands/, agents/, skills/, hooks/) MÜSSEN auf Plugin-Root-Ebene sein, NICHT in .claude-plugin/ verschachtelt!

---

## SKILL.md Struktur (Korrekt)

### Frontmatter Format
```yaml
---
name: skill-identifier
description: This skill should be used when the user asks to "specific phrase 1", "specific phrase 2". Include exact trigger phrases!
version: 0.1.0
---
```

### Typische SKILL.md Fehler

| Fehler | Falsch | Richtig |
|--------|--------|---------|
| Vage Description | `description: Helps with messages` | `description: Use when user asks to "LinkedIn Nachricht beantworten", "Posteingang prüfen", "auf Mitteilung reagieren"` |
| Fehlende Trigger | `description: Handles LinkedIn` | `description: Aktiviere bei "Inbox zeigen", "neue Nachrichten", "Benno-Stil antworten"` |
| Falsches Format | `description: Ich helfe bei...` | `description: This skill should be used when...` (3. Person!) |

### Vollständiges SKILL.md Beispiel
```markdown
---
name: benno-style
description: This skill should be used when the user asks to "im Benno-Stil antworten", "professionell auf Deutsch formulieren", "LinkedIn Nachricht schreiben", "geschäftliche Antwort verfassen". Aktiviere bei deutscher Business-Kommunikation.
version: 1.0.0
---

# Benno-Stil Kommunikation

## Stil-Merkmale
- Persönlich aber professionell
- Direkt und lösungsorientiert
- Freundlich ohne übertrieben zu sein
- Immer auf Deutsch

## Format
[Anrede],

[Inhalt - kurz und prägnant]

[Freundlicher Abschluss]
[Benno]
```

---

## Agent Struktur (Korrekt)

### Agent Frontmatter
```yaml
---
name: agent-identifier
description: Use this agent when [triggering conditions]...
model: inherit
color: blue
tools: ["Read", "Write", "Grep", "Bash"]
---
```

### Vollständiges Agent-Beispiel
```markdown
---
name: message-responder
description: Use this agent when analyzing LinkedIn messages and generating numbered reply suggestions. Examples:

<example>
Context: User wants to check LinkedIn inbox
user: "Zeig mir meine LinkedIn Nachrichten"
assistant: "Ich nutze den message-responder Agent um die Nachrichten zu analysieren und Antwortvorschläge zu erstellen."
<commentary>
Agent wird gebraucht um Nachrichten zu lesen und nummerierte Antworten vorzuschlagen.
</commentary>
</example>

model: inherit
color: green
tools: ["mcp__claude-in-chrome__read_page", "mcp__claude-in-chrome__navigate"]
---

Du bist ein LinkedIn-Nachrichten-Analyst.

**Aufgaben:**
1. Nachrichten lesen und verstehen
2. Kontext der Konversation erfassen
3. 3 nummerierte Antwortvorschläge im Benno-Stil erstellen

**Output-Format:**
[1] Kurze formelle Antwort
[2] Ausführlichere freundliche Antwort
[3] IGNORIEREN (falls Spam) oder alternative Antwort
```

### Typische Agent-Fehler

| Fehler | Problem | Lösung |
|--------|---------|--------|
| Keine Examples | Claude weiß nicht wann triggern | Mindestens 2 `<example>` Blöcke |
| Fehlende Tools | Agent kann nichts tun | `tools: [...]` Array definieren |
| Vages Ziel | Unklare Ergebnisse | **Output-Format:** klar definieren |
| Kein model | Undefined behavior | `model: inherit` oder spezifisch |

---

## Command (Slash Command) Struktur

### Frontmatter Format
```yaml
---
description: Kurze Beschreibung was der Command tut
---
```

### Vollständiges Command-Beispiel
```markdown
---
description: Zeigt LinkedIn Posteingang mit nummerierten Antwortvorschlägen
---

# LinkedIn Inbox

Öffne LinkedIn und zeige den Posteingang.

Für jede Nachricht:
1. Zeige Absender und Vorschau
2. Erstelle 3 nummerierte Antwortvorschläge
3. Markiere Spam/No-Go Nachrichten

Nutze $ARGUMENTS falls ein Filter angegeben wurde (z.B. "ungelesen").

## Output-Format
```
📬 POSTEINGANG

[1] Max Müller (vor 2h)
    "Nachrichtenvorschau..."

    [1a] Antwort-Option 1
    [1b] Antwort-Option 2
    [1c] IGNORIEREN (Spam)
```
```

### Typische Command-Fehler

| Fehler | Falsch | Richtig |
|--------|--------|---------|
| Fehlende description | `---\n---` | `---\ndescription: Beschreibung\n---` |
| $ARGUMENTS vergessen | Statischer Command | `Nutze $ARGUMENTS für...` |
| Kein Output-Format | Unvorhersehbare Ausgabe | Output-Format dokumentieren |

---

## Hooks Struktur (Korrekt)

### hooks.json Format
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "mcp__claude-in-chrome__",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/scripts/action-logger.sh"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "afplay /System/Library/Sounds/Glass.aiff"
          }
        ]
      }
    ]
  }
}
```

### Hook Events
| Event | Wann | Nutzen |
|-------|------|--------|
| `PreToolUse` | Vor Tool-Aufruf | Blockieren, Validieren |
| `PostToolUse` | Nach Tool-Aufruf | Logging, Formatieren |
| `Stop` | Claude fertig | Sound abspielen |
| `Notification` | User-Input nötig | Desktop-Notification |

### Exit Codes
- **0** = Erlauben/Fortfahren
- **1** = Fehler (loggen, fortfahren)
- **2** = BLOCKIEREN (bei PreToolUse)

### Typische Hook-Fehler

| Fehler | Problem | Lösung |
|--------|---------|--------|
| Script nicht ausführbar | Hook tut nichts | `chmod +x script.sh` |
| Fehlender Shebang | Script läuft nicht | `#!/bin/bash` am Anfang |
| Falscher Pfad | Script nicht gefunden | `${CLAUDE_PLUGIN_ROOT}/...` nutzen |
| Falscher Exit-Code | Blockiert nicht | Exit 2 für Blockieren |

### Logging Hook (Beispiel)
```json
{
  "PreToolUse": [
    {
      "matcher": "Bash",
      "hooks": [
        {
          "type": "command",
          "command": "jq -r '\"\(.tool_input.command) - \(.tool_input.description // \"No description\")\"' >> ~/.claude/bash-command-log.txt"
        }
      ]
    }
  ]
}
```

---

## LinkedIn Assistant - Komponenten

### Skills
1. **benno-style** - Deutsche Business-Kommunikation
2. **linkedin-navigation** - Browser-Steuerung für LinkedIn
3. **german-professional** - Professionelles Deutsch

### Slash Commands
| Command | Funktion |
|---------|----------|
| `/linkedin:inbox` | Nachrichten mit Antwortvorschlägen |
| `/linkedin:notifications` | Mitteilungen mit Reaktionsvorschlägen |
| `/linkedin:research [Name]` | Person/Firma recherchieren |
| `/linkedin:post [Thema]` | Post-Entwurf erstellen |
| `/linkedin:login` | Login-Hilfe |

### Agents
1. **message-responder** - Analysiert Nachrichten, erstellt Antworten
2. **notification-handler** - Prüft Mitteilungen gegen no-gos
3. **profile-researcher** - Recherchiert Profile

### Parallel-Agents
Wann parallel ausführen:
- `message-responder` + `profile-researcher` → Nachrichten MIT Kontext
- Mehrere `notification-handler` → Alle Mitteilungen gleichzeitig

Wann NICHT parallel:
- `login` → Browser-Interaktion sequentiell
- Nach User-Bestätigung → Sequentiell senden

---

## Nummerierung für Review

```
📬 POSTEINGANG (3 neue)

[1] Max Müller (vor 2h)
    "Interessiere mich für..."

    [1a] Danke für Ihre Nachricht! Gerne...
    [1b] Vielen Dank! Lassen Sie uns...
    [1c] IGNORIEREN (Spam-Pattern)

[2] Anna Schmidt (vor 5h)
    "Termin vereinbaren?"

    [2a] Gerne! Wie wäre...
    [2b] Buchen Sie hier: [Link]
    [2c] Aktuell voll, aber...

💬 Sage: "Sende 1a" oder "Bearbeite 2b kürzer"
```

---

## Wichtige Regeln

1. **IMMER** Deutsch
2. **NIEMALS** automatisch senden
3. **IMMER** nummerierte Vorschläge
4. **IMMER** no-gos.md prüfen
5. **IMMER** Logging aktivieren
6. **Sound** bei Fertigstellung
