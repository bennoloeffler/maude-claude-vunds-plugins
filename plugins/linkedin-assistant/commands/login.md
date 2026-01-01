---
description: Hilft beim LinkedIn Login-Prozess (user)
---

# LinkedIn Login

Hilf dem Benutzer beim LinkedIn Login-Prozess.

## Workflow

1. **Browser vorbereiten**
   - Hole Tab-Kontext
   - Erstelle neuen Tab falls nötig

2. **LinkedIn öffnen**
   - Navigiere zu https://www.linkedin.com/

3. **Status prüfen**
   - Bereits eingeloggt? → Bestätigen und fertig
   - Login-Screen? → User anleiten

4. **Login begleiten**
   - User zur Eingabe auffordern
   - Auf Erfolg warten
   - Bestätigen wenn eingeloggt

## Output bei Login-Screen

```
🔐 LINKEDIN LOGIN
━━━━━━━━━━━━━━━━━

LinkedIn Login-Seite ist geöffnet.

⚠️ SICHERHEITSHINWEIS
Aus Sicherheitsgründen gebe ich KEINE Passwörter ein.
Du musst dich selbst einloggen.

📝 SCHRITTE:
1. Gib deine E-Mail-Adresse ein
2. Gib dein Passwort ein
3. Klicke auf "Einloggen"
4. Falls 2FA aktiv: Gib den Code ein

💬 Sage "fertig" wenn du eingeloggt bist.

━━━━━━━━━━━━━━━━━
```

## Output bei bereits eingeloggt

```
✅ LINKEDIN STATUS
━━━━━━━━━━━━━━━━━

Du bist bereits bei LinkedIn eingeloggt!

👤 Eingeloggt als: [Name wenn erkennbar]

💬 Was möchtest du tun?
• /linkedin:inbox → Nachrichten anzeigen
• /linkedin:notifications → Mitteilungen anzeigen
• /linkedin:research [Name] → Person recherchieren

━━━━━━━━━━━━━━━━━
```

## 2FA Erkennung

Falls 2FA-Screen erkannt:

```
🔐 ZWEI-FAKTOR-AUTHENTIFIZIERUNG
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

LinkedIn fordert einen Bestätigungscode.

📱 Prüfe deine:
• SMS
• Authenticator-App
• E-Mail

Gib den Code auf der Seite ein.

💬 Sage "fertig" wenn du eingeloggt bist.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Fehlerbehandlung

Falls Login fehlschlägt:

```
⚠️ LOGIN-PROBLEM
━━━━━━━━━━━━━━━━

Es scheint ein Problem beim Login zu geben.

🔧 MÖGLICHE LÖSUNGEN:
1. Prüfe E-Mail-Adresse auf Tippfehler
2. Prüfe Passwort (Caps-Lock?)
3. Nutze "Passwort vergessen" falls nötig
4. Prüfe ob Account gesperrt ist

💬 Versuche es erneut und sage "fertig" bei Erfolg.

━━━━━━━━━━━━━━━━
```

## Wichtige Regeln

1. **NIEMALS** Passwörter eingeben oder speichern
2. **NIEMALS** 2FA-Codes eingeben
3. **IMMER** auf User-Bestätigung warten
4. **IMMER** Sicherheitshinweise geben
5. **GEDULDIG** bei Login-Problemen bleiben
