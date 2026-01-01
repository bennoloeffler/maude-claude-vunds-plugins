# Claude Code Plugin Debugging Guide

## Plugin laden mit `--plugin-dir`

```bash
claude --plugin-dir ./plugins/linkedin-assistant
```

## Was passiert GENAU?

### Schritt 1: Manifest suchen
```
./plugins/linkedin-assistant/.claude-plugin/plugin.json
```
→ Liest Name, Version, Pfade zu Komponenten

### Schritt 2: Komponenten automatisch laden
```
commands/     → /linkedin-assistant:inbox, :notifications, etc.
agents/       → message-responder, notification-handler, etc.
skills/       → benno-style, linkedin-navigation (auto-trigger)
hooks/        → hooks.json wird aktiviert
scripts/      → Werden von hooks aufgerufen
templates/    → Werden von skills/agents gelesen
```

### Schritt 3: Namespace registrieren
- Alle Commands werden prefixed: `/linkedin-assistant:inbox`
- Skills werden bei Trigger-Phrasen aktiviert
- Agents sind für Claude aufrufbar

### Schritt 4: Session-Scope
- **NUR für diese Session aktiv**
- Beim Beenden von Claude → Plugin weg
- Kein permanentes Installieren

---

## Verfügbare Commands nach Laden

| Plugin | Command | Aufruf |
|--------|---------|--------|
| linkedin-assistant | inbox | `/linkedin-assistant:inbox` |
| linkedin-assistant | notifications | `/linkedin-assistant:notifications` |
| linkedin-assistant | research | `/linkedin-assistant:research [Name]` |
| linkedin-assistant | post | `/linkedin-assistant:post [Thema]` |
| linkedin-assistant | login | `/linkedin-assistant:login` |

---

## Debugging

### Mit Debug-Flag starten
```bash
claude --plugin-dir ./plugins/linkedin-assistant --debug
```
→ Zeigt was geladen wird und eventuelle Fehler

### Mehrere Plugins laden
```bash
claude --plugin-dir ./plugins/linkedin-assistant --plugin-dir ./plugins/love-letter
```

### Plugin-Struktur prüfen
```bash
# Muss plugin.json enthalten
ls -la plugins/linkedin-assistant/.claude-plugin/

# Scripts müssen ausführbar sein
ls -la plugins/linkedin-assistant/scripts/
```

---

## Häufige Fehler

| Problem | Ursache | Lösung |
|---------|---------|--------|
| Plugin nicht erkannt | Kein plugin.json | `.claude-plugin/plugin.json` erstellen |
| Commands fehlen | Falscher Pfad | In plugin.json: `"commands": "./commands/"` |
| Hooks tun nichts | Script nicht ausführbar | `chmod +x scripts/*.sh` |
| Skills triggern nicht | Vage description | Konkrete Trigger-Phrasen in SKILL.md |
| Agents nicht verfügbar | Fehlende tools | `tools: [...]` in Agent-Frontmatter |

---

## Plugin-Struktur Checkliste

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json          ✓ REQUIRED
├── commands/                 ✓ Optional - Slash Commands
│   └── *.md
├── agents/                   ✓ Optional - Subagents
│   └── *.md
├── skills/                   ✓ Optional - Auto-triggered
│   └── skill-name/
│       └── SKILL.md
├── hooks/                    ✓ Optional - Event Handlers
│   └── hooks.json
├── scripts/                  ✓ Optional - Hook Scripts
│   └── *.sh (chmod +x!)
└── README.md
```

---

## Schnelltest

```bash
# 1. Plugin laden
claude --plugin-dir ./plugins/linkedin-assistant

# 2. In Claude Code testen
/linkedin-assistant:inbox

# 3. Skill-Trigger testen
# Sage: "Schreib eine professionelle Nachricht im Benno-Stil"
```

---

## Log-Dateien

Nach Nutzung des linkedin-assistant Plugins:
```bash
# Action Log (Browser-Aktionen)
cat ~/.claude/linkedin-assistant/actions.log
```
