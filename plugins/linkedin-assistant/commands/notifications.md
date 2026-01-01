---
description: Zeigt LinkedIn Mitteilungen (Likes, Kommentare, Erwähnungen) mit Reaktionsvorschlägen (user)
---

# LinkedIn Mitteilungen

Öffne LinkedIn Mitteilungen und zeige alle mit nummerierten Reaktionsvorschlägen.

## Workflow

1. **Browser vorbereiten**
   - Hole Tab-Kontext
   - Erstelle Tab falls nötig

2. **Zu LinkedIn navigieren**
   - Öffne https://www.linkedin.com/notifications/
   - Warte auf Laden

3. **Login prüfen**
   - Falls nötig: User informieren

4. **Mitteilungen lesen**
   - Kategorisiere: Like, Kommentar, Erwähnung, Verbindung, Sonstiges
   - Prüfe Relevanz

5. **Für jede Mitteilung**
   - Prüfe gegen templates/no-gos.md
   - Prüfe gegen templates/conditions.md
   - Erstelle Reaktionsvorschlag oder "IGNORIEREN"

## Mitteilungs-Typen

| Typ | Icon | Typische Reaktion |
|-----|------|-------------------|
| Like auf Post | 👍 | Meist ignorieren |
| Kommentar | 💬 | Antwort vorschlagen |
| Erwähnung | 📢 | Prüfen und reagieren |
| Verbindungsanfrage | 🔗 | Annehmen/Ablehnen |
| Profilbesuch | 👁️ | Meist ignorieren |
| Job-Empfehlung | 💼 | Nach Interesse |
| Geburtstag | 🎂 | Glückwunsch senden |

## Output-Format

```
🔔 LINKEDIN MITTEILUNGEN
━━━━━━━━━━━━━━━━━━━━━━━━

📊 ZUSAMMENFASSUNG
• 5 Kommentare auf deine Posts
• 12 Likes (werden ignoriert)
• 2 Erwähnungen
• 3 Verbindungsanfragen

━━━━━━━━━━━━━━━━━━━━━━━━
💬 KOMMENTARE (Reaktion empfohlen)

[1] 💬 Thomas Meier kommentierte deinen Post über KI
    "Sehr interessanter Punkt! Wie siehst du die Entwicklung..."

    Vorgeschlagene Reaktionen:
    ┌─────────────────────────────────────────────────────────┐
    │ [1a] 👍 Gefällt mir (schnell, minimal)                  │
    ├─────────────────────────────────────────────────────────┤
    │ [1b] 💬 "Danke Thomas! Ich denke, dass..."              │
    ├─────────────────────────────────────────────────────────┤
    │ [1c] 🚫 IGNORIEREN (kein Mehrwert durch Antwort)        │
    └─────────────────────────────────────────────────────────┘

[2] 💬 Sarah Koch fragt in Kommentar
    "Könntest du dazu mehr Details teilen?"

    Vorgeschlagene Reaktionen:
    ┌─────────────────────────────────────────────────────────┐
    │ [2a] 💬 "Gerne! Der Kernpunkt ist..."                   │
    ├─────────────────────────────────────────────────────────┤
    │ [2b] 💬 "Guter Punkt! Ich plane dazu einen Post..."     │
    ├─────────────────────────────────────────────────────────┤
    │ [2c] 💬 "Schreib mir gerne eine DM für Details"         │
    └─────────────────────────────────────────────────────────┘

━━━━━━━━━━━━━━━━━━━━━━━━
📢 ERWÄHNUNGEN

[3] 📢 Max Mustermann hat dich erwähnt
    "...wie @Benno kürzlich sagte, ist das Thema..."

    → Empfehlung: 👍 Like + kurzer Dank-Kommentar

━━━━━━━━━━━━━━━━━━━━━━━━
🔗 VERBINDUNGSANFRAGEN

[4] 🔗 Dr. Lisa Weber | CTO bei Innovation GmbH
    📝 "Hallo Benno, Ihr Beitrag zu..."

    Vorgeschlagene Reaktionen:
    ┌─────────────────────────────────────────────────────────┐
    │ [4a] ✅ Annehmen + Willkommensnachricht                 │
    ├─────────────────────────────────────────────────────────┤
    │ [4b] ✅ Annehmen (ohne Nachricht)                       │
    ├─────────────────────────────────────────────────────────┤
    │ [4c] ❌ Ablehnen (kein relevanter Kontext)              │
    └─────────────────────────────────────────────────────────┘

[5] ⚠️ SPAM-VERDACHT
    🔗 "Growth Hacker Pro" | Keine Nachricht
    → Empfehlung: ❌ ABLEHNEN (typisches Spam-Profil)

━━━━━━━━━━━━━━━━━━━━━━━━
👍 AUTO-IGNORIERT (12 Items)
Likes ohne Kommentar werden nicht einzeln gelistet.

━━━━━━━━━━━━━━━━━━━━━━━━
💬 BEFEHLE:
• "Reagiere 1b" → Führt Reaktion aus
• "Annehmen 4a" → Verbindung + Nachricht
• "Zeig Likes" → Listet ignorierte Likes
• "Alle Anfragen annehmen" → Bestätigung erforderlich
━━━━━━━━━━━━━━━━━━━━━━━━
```

## Wichtige Regeln

1. **NIEMALS** automatisch reagieren ohne Bestätigung
2. **IMMER** Spam-Check vor Vorschlägen
3. **Likes ohne Kommentar** meist ignorieren
4. **Kommentare mit Fragen** immer beantworten
5. **Verbindungsanfragen** individuell prüfen
