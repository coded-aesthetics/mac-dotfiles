#!/bin/bash

# Test the improved walupdate function

echo "🧪 Testing Improved walupdate Function"
echo "======================================"

# Test 1: Check if pywal cache exists
echo -n "✓ Checking pywal cache... "
if [[ -f ~/.cache/wal/wal ]]; then
    cached_wallpaper=$(cat ~/.cache/wal/wal 2>/dev/null)
    if [[ -n "$cached_wallpaper" && -f "$cached_wallpaper" ]]; then
        echo "✅ Valid cache: $(basename "$cached_wallpaper")"
    else
        echo "⚠️ Invalid cache"
    fi
else
    echo "❌ No cache found"
fi

# Test 2: Test System Events detection
echo -n "✓ Testing System Events detection... "
if wallpaper=$(osascript -e 'tell application "System Events" to tell every desktop to get picture' 2>/dev/null); then
    wallpaper=$(echo "$wallpaper" | sed 's/^"//' | sed 's/"$//' | head -1)
    echo "✅ Detected: $(basename "$wallpaper")"
else
    echo "❌ Failed"
fi

# Test 3: Test manual specification
echo -n "✓ Testing manual specification... "
if [[ -f ~/Desktop/Screenshot\ 2025-07-27\ at\ 08.46.32.png ]]; then
    echo "✅ Test image available"
else
    echo "❌ Test image not found"
fi

echo ""
echo "🎯 How to use the improved walupdate:"
echo "===================================="
echo ""
echo "1. Auto-detect (tries pywal cache, then system wallpaper):"
echo "   walupdate"
echo ""
echo "2. Manual specification:"
echo "   walupdate ~/Desktop/Screenshot\\ 2025-07-27\\ at\\ 08.46.32.png"
echo ""
echo "3. With any image:"
echo "   walupdate ~/path/to/your/image.jpg"
echo ""
echo "💡 The function now tries multiple detection methods and gives clear feedback!"
