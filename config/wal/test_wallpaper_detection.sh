#!/bin/bash

# Improved wallpaper detection script
# Tests multiple methods to find the current wallpaper

echo "🔍 Testing wallpaper detection methods..."

# Method 1: Finder AppleScript
echo -n "Method 1 (Finder): "
if wallpaper1=$(osascript -e 'tell application "Finder" to get POSIX path of (get desktop picture as alias)' 2>/dev/null); then
    echo "✅ $wallpaper1"
else
    echo "❌ Failed"
fi

# Method 2: System Events AppleScript
echo -n "Method 2 (System Events): "
if wallpaper2=$(osascript -e 'tell application "System Events" to tell every desktop to get picture' 2>/dev/null); then
    echo "✅ $wallpaper2"
else
    echo "❌ Failed"
fi

# Method 3: Desktop Picture database
echo -n "Method 3 (Database): "
if wallpaper3=$(sqlite3 ~/Library/Application\ Support/Dock/desktoppicture.db "SELECT * FROM data ORDER BY rowid DESC LIMIT 1;" 2>/dev/null); then
    echo "✅ Found database entry"
else
    echo "❌ Database access failed"
fi

# Method 4: Wallpaper preferences
echo -n "Method 4 (Preferences): "
if wallpaper4=$(defaults read com.apple.desktop Background 2>/dev/null); then
    echo "✅ Found preferences"
else
    echo "❌ Preferences failed"
fi

# Method 5: Recent pywal cache
echo -n "Method 5 (Pywal cache): "
if [[ -f ~/.cache/wal/wal ]]; then
    cached_wallpaper=$(cat ~/.cache/wal/wal 2>/dev/null)
    if [[ -n "$cached_wallpaper" && -f "$cached_wallpaper" ]]; then
        echo "✅ $cached_wallpaper"
    else
        echo "❌ Cache invalid"
    fi
else
    echo "❌ No cache"
fi

echo ""
echo "💡 Recommendations:"
echo "=================="
echo "If detection fails, you can:"
echo "1. Specify image manually: walupdate ~/path/to/image.jpg"
echo "2. Use setwal instead: setwal ~/path/to/image.jpg"
echo "3. Use the test image: walupdate ~/Desktop/Screenshot\\ 2025-07-27\\ at\\ 08.46.32.png"
