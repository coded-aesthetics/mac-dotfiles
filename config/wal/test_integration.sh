#!/bin/bash

# Quick test script to verify pywal integration is working

echo "🧪 Testing Pywal Integration"
echo "============================="

# Test 1: Check if pywal is accessible
echo -n "✓ Checking pywal installation... "
if command -v "$HOME/Library/Python/3.9/bin/wal" >/dev/null 2>&1; then
    echo "✅ Found"
else
    echo "❌ Not found"
    exit 1
fi

# Test 2: Check if zsh functions are defined (in a zsh context)
echo -n "✓ Testing zsh integration... "
if zsh -c 'type setwal >/dev/null 2>&1'; then
    echo "✅ setwal function available"
else
    echo "❌ setwal function not found"
fi

# Test 3: Check if pywal cache exists
echo -n "✓ Checking pywal cache... "
if [[ -f ~/.cache/wal/sequences ]]; then
    echo "✅ Cache exists"
else
    echo "⚠️  No cache (run 'setwal <image>' to generate)"
fi

# Test 4: Check if iTerm2 integration script exists
echo -n "✓ Checking iTerm2 integration... "
if [[ -f ~/.config/wal/scripts/update_iterm2.py ]]; then
    echo "✅ Script ready"
else
    echo "❌ Script missing"
fi

# Test 5: Quick color generation test
echo -n "✓ Testing color generation... "
if [[ -f ~/Desktop/Screenshot\ 2025-07-27\ at\ 08.46.32.png ]]; then
    if "$HOME/Library/Python/3.9/bin/wal" --backend colorz -i ~/Desktop/Screenshot\ 2025-07-27\ at\ 08.46.32.png -n >/dev/null 2>&1; then
        echo "✅ Working"
    else
        echo "❌ Failed"
    fi
else
    echo "⚠️  Test image not found"
fi

echo ""
echo "🎯 Quick Start:"
echo "1. Open a new terminal (to load the fixed .zshrc)"
echo "2. Run: setwal ~/Desktop/Screenshot\\ 2025-07-27\\ at\\ 08.46.32.png"
echo "3. In iTerm2: Go to Preferences > Profiles and select 'Pywal'"
echo ""
echo "📚 Available commands:"
echo "  setwal <image>  - Set colors from image"
echo "  setwal random   - Random wallpaper"
echo "  walcolors       - Show color palette"
echo "  wal-refresh     - Refresh colors"
