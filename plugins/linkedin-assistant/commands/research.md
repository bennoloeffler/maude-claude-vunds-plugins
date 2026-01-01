---
description: Recherchiert eine Person oder Firma auf LinkedIn (user)
---

# LinkedIn Recherche

Recherchiere "$ARGUMENTS" auf LinkedIn und erstelle ein kompaktes Profil-Summary.

## Workflow

1. **Eingabe parsen**
   - Name einer Person
   - Firmenname
   - LinkedIn URL

2. **Suche durchführen**
   - Bei Name: https://www.linkedin.com/search/results/all/?keywords=$ARGUMENTS
   - Bei URL: Direkt navigieren

3. **Profil analysieren**
   - Extrahiere relevante Informationen
   - Finde Gemeinsamkeiten mit Benno
   - Identifiziere Gesprächsanknüpfungspunkte

4. **Summary erstellen**
   - Kompakt und actionable
   - Mit Empfehlungen für Kontaktaufnahme

## Output-Format für Personen

```
🔍 PROFIL-RECHERCHE: [Name]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━

👤 BASISINFO
┌─────────────────────────────────────────────────────────┐
│ Name:      [Vollständiger Name]                         │
│ Position:  [Aktuelle Position]                          │
│ Firma:     [Aktueller Arbeitgeber]                      │
│ Standort:  [Stadt, Land]                                │
│ Vernetzt:  [Ja/Nein] [Gemeinsame Kontakte: X]           │
└─────────────────────────────────────────────────────────┘

📋 WERDEGANG (Kurzform)
• [Jahr]-heute: [Position] bei [Firma]
• [Jahr]-[Jahr]: [Position] bei [Firma]
• [Jahr]-[Jahr]: [Position] bei [Firma]

🎓 AUSBILDUNG
• [Abschluss] - [Institution] ([Jahr])

💡 ÜBER MICH (Zusammenfassung)
[Max. 3 Sätze aus dem "Über mich"-Bereich]

🔗 GEMEINSAMKEITEN MIT BENNO
• [Gemeinsame Kontakte]
• [Gemeinsame Interessen/Themen]
• [Gleiche Branche/Region]

💬 GESPRÄCHS-ANKNÜPFUNGSPUNKTE
1. [Thema basierend auf Posts/Aktivität]
2. [Thema basierend auf Werdegang]
3. [Aktuelles Projekt/Interesse]

📝 EMPFEHLUNG FÜR KONTAKTAUFNAHME
┌─────────────────────────────────────────────────────────┐
│ Relevanz für Benno: [Hoch/Mittel/Niedrig]               │
│                                                         │
│ Vorgeschlagene Nachricht:                               │
│ "Hallo [Vorname],                                       │
│                                                         │
│ [Personalisierte Ansprache basierend auf Recherche]     │
│                                                         │
│ Beste Grüße                                             │
│ Benno"                                                  │
└─────────────────────────────────────────────────────────┘

⚠️ HINWEISE
• [Eventuelle Warnungen oder Besonderheiten]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Output-Format für Firmen

```
🏢 FIRMEN-RECHERCHE: [Firmenname]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 BASISINFO
┌─────────────────────────────────────────────────────────┐
│ Name:       [Offizieller Firmenname]                    │
│ Branche:    [Branche]                                   │
│ Größe:      [Mitarbeiteranzahl]                         │
│ Standort:   [Hauptsitz]                                 │
│ Gegründet:  [Jahr]                                      │
│ Website:    [URL]                                       │
└─────────────────────────────────────────────────────────┘

📝 BESCHREIBUNG
[Kurze Zusammenfassung der Firmenbeschreibung]

👥 RELEVANTE KONTAKTE
• [Name] - [Position] [Gemeinsame Kontakte]
• [Name] - [Position] [Gemeinsame Kontakte]

📰 AKTUELLE POSTS
• [Datum]: [Post-Thema]
• [Datum]: [Post-Thema]

💡 ANKNÜPFUNGSPUNKTE
1. [Mögliches gemeinsames Interesse]
2. [Potenzielle Zusammenarbeit]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Parallel-Agent Hinweis

Dieser Command kann parallel mit `message-responder` laufen:
- Wenn Nachricht von Person X kommt
- Gleichzeitig Profil von Person X recherchieren
- Antwortvorschläge mit Kontext verbessern

## Wichtige Regeln

1. **IMMER** relevante Infos für Benno hervorheben
2. **NIEMALS** sensible Daten speichern
3. **IMMER** Gemeinsamkeiten suchen
4. **IMMER** actionable Empfehlungen geben
