#!/bin/bash
# LinkedIn Assistant - Fertig-Sound
# Spielt einen Benachrichtigungston wenn Claude fertig ist

# macOS System-Sound (sanfter Glas-Ton)
afplay /System/Library/Sounds/Glass.aiff 2>/dev/null &

# Fallback für Linux
# paplay /usr/share/sounds/freedesktop/stereo/complete.oga 2>/dev/null &

exit 0
