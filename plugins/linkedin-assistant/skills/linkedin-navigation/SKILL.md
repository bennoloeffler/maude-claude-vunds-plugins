---
name: linkedin-navigation
description: This skill should be used when the user asks to "LinkedIn öffnen", "zum Posteingang gehen", "Mitteilungen anzeigen", "LinkedIn Profil aufrufen", "LinkedIn navigieren". Aktiviere für alle LinkedIn Browser-Aktionen.
version: 1.0.0
---

# LinkedIn Navigation

Du navigierst LinkedIn im Browser für den Benutzer.

## Verfügbare Tools

Nutze diese Claude-in-Chrome Tools für die Navigation:
- `mcp__claude-in-chrome__tabs_context_mcp` - Tab-Kontext holen
- `mcp__claude-in-chrome__tabs_create_mcp` - Neuen Tab erstellen
- `mcp__claude-in-chrome__navigate` - Zu URL navigieren
- `mcp__claude-in-chrome__read_page` - Seite lesen
- `mcp__claude-in-chrome__find` - Elemente finden
- `mcp__claude-in-chrome__click` - Elemente klicken
- `mcp__claude-in-chrome__form_input` - Formulare ausfüllen
- `mcp__claude-in-chrome__take_snapshot` - Screenshot machen

## Wichtige LinkedIn URLs

| Bereich | URL |
|---------|-----|
| Startseite | https://www.linkedin.com/feed/ |
| Posteingang | https://www.linkedin.com/messaging/ |
| Mitteilungen | https://www.linkedin.com/notifications/ |
| Netzwerk | https://www.linkedin.com/mynetwork/ |
| Eigenes Profil | https://www.linkedin.com/in/me/ |
| Suche | https://www.linkedin.com/search/results/all/?keywords= |

## Navigation-Workflow

### 1. Tab-Kontext prüfen
```
Zuerst: mcp__claude-in-chrome__tabs_context_mcp
- Prüfe ob bereits ein Tab existiert
- Falls nicht: neuen Tab erstellen
```

### 2. Zu LinkedIn navigieren
```
mcp__claude-in-chrome__navigate mit passender URL
Warte auf Laden der Seite
```

### 3. Login prüfen
```
mcp__claude-in-chrome__read_page
Suche nach Login-Elementen
Falls Login nötig: User informieren
```

### 4. Inhalt lesen
```
mcp__claude-in-chrome__read_page oder take_snapshot
Extrahiere relevante Informationen
```

## Login-Erkennung

LinkedIn zeigt Login-Screen wenn:
- URL enthält "/login" oder "/checkpoint"
- Seite zeigt "Einloggen" oder "Sign in" Buttons
- Keine Navigationsleiste sichtbar

**Bei Login-Bedarf:**
```
⚠️ LinkedIn Login erforderlich

Bitte logge dich manuell ein:
1. Öffne https://www.linkedin.com
2. Gib deine Zugangsdaten ein
3. Sage "fertig" wenn eingeloggt

Ich kann aus Sicherheitsgründen keine Passwörter eingeben.
```

## Seiten-Elemente finden

### Posteingang
- Nachrichten-Liste: Suche nach Konversations-Elementen
- Ungelesene: Markiert mit Badge oder bold

### Mitteilungen
- Notification-Items: Enthält Likes, Kommentare, Erwähnungen
- Aktions-Buttons: "Gefällt mir", "Kommentieren"

### Profile
- Name: Hauptüberschrift
- Position: Unter dem Namen
- Über mich: Zusammenfassungs-Sektion

## Wichtige Regeln

1. **IMMER** zuerst Tab-Kontext holen
2. **NIEMALS** Passwörter eingeben
3. **IMMER** nach Navigation Seite lesen
4. **WARTEN** auf vollständiges Laden
5. **FEHLER** dem User klar kommunizieren
