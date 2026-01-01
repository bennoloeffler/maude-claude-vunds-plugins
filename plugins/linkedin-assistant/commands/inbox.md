---
description: Zeigt LinkedIn Posteingang mit nummerierten Antwortvorschlägen (user)
---

# LinkedIn Posteingang

Öffne den LinkedIn Posteingang und zeige alle Nachrichten mit nummerierten Antwortvorschlägen.

## Workflow

1. **Browser vorbereiten**
   - Hole Tab-Kontext mit `mcp__claude-in-chrome__tabs_context_mcp`
   - Erstelle neuen Tab falls nötig

2. **Zu LinkedIn navigieren**
   - Öffne https://www.linkedin.com/messaging/
   - Warte auf vollständiges Laden

3. **Login prüfen**
   - Falls Login-Screen: Informiere User und warte

4. **Nachrichten lesen**
   - Nutze `mcp__claude-in-chrome__read_page` für Konversationsliste
   - Extrahiere: Absender, Zeitstempel, Vorschau

5. **Für jede Nachricht analysieren**
   - Prüfe gegen templates/no-gos.md
   - Prüfe gegen templates/conditions.md
   - Erstelle 3 Antwortvorschläge im Benno-Stil

## Filter (optional)

Falls $ARGUMENTS angegeben:
- "ungelesen" → Nur ungelesene Nachrichten
- "heute" → Nur Nachrichten von heute
- "[Name]" → Nur Nachrichten von dieser Person

## Output-Format

```
📬 LINKEDIN POSTEINGANG
━━━━━━━━━━━━━━━━━━━━━━

[1] 👤 Max Müller | Geschäftsführer bei TechCo
    📅 vor 2 Stunden
    💬 "Hallo Benno, ich interessiere mich für Ihre Expertise..."

    Vorgeschlagene Antworten:
    ┌─────────────────────────────────────────────────────────┐
    │ [1a] Vielen Dank für Ihre Nachricht! Gerne können wir  │
    │      uns zu einem kurzen Austausch verabreden.         │
    ├─────────────────────────────────────────────────────────┤
    │ [1b] Hallo Herr Müller, das Thema klingt interessant.  │
    │      Wie wäre es mit einem Call nächste Woche?         │
    ├─────────────────────────────────────────────────────────┤
    │ [1c] Danke für Ihr Interesse! Aktuell ist mein         │
    │      Kalender voll - ich melde mich in 2 Wochen.       │
    └─────────────────────────────────────────────────────────┘

[2] 👤 Anna Schmidt | HR Manager
    📅 vor 5 Stunden
    💬 "Könnten wir einen Termin für ein Gespräch..."

    Vorgeschlagene Antworten:
    ┌─────────────────────────────────────────────────────────┐
    │ [2a] Gerne! Buchen Sie direkt hier: [Calendly-Link]    │
    ├─────────────────────────────────────────────────────────┤
    │ [2b] Ja, sehr gerne. Wann passt es Ihnen am besten?    │
    ├─────────────────────────────────────────────────────────┤
    │ [2c] Danke für die Anfrage! Momentan leider keine      │
    │      Kapazität. Gerne später nochmal anfragen.         │
    └─────────────────────────────────────────────────────────┘

[3] ⚠️ SPAM ERKANNT
    👤 "Business Coach" | 💬 "VERDIENE 10.000€ PRO WOCHE..."
    → Empfehlung: IGNORIEREN (Spam-Pattern erkannt)

━━━━━━━━━━━━━━━━━━━━━━
💬 BEFEHLE:
• "Sende 1a" → Sendet Antwort 1a
• "Bearbeite 2b kürzer" → Antwort anpassen
• "Öffne 1" → Zeigt vollständige Konversation
• "Ignoriere 3" → Markiert als erledigt
━━━━━━━━━━━━━━━━━━━━━━
```

## Wichtige Regeln

1. **NIEMALS** automatisch senden - immer User-Bestätigung
2. **IMMER** Spam-Check durchführen
3. **IMMER** nummeriert für einfaches Referenzieren
4. **IMMER** im Benno-Stil antworten
5. **IMMER** Kontext der Konversation beachten
