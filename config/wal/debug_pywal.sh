#!/bin/bash

# Debug script to test pywal commands safely
# This will help identify what's causing the terminal to close

echo "🔍 Debugging Pywal Integration"
echo "============================="

# Test 1: Check if wal command exists and works
echo -n "✓ Testing wal command availability... "
if command -v "$HOME/Library/Python/3.9/bin/wal" >/dev/null 2>&1; then
    echo "✅ Available"
else
    echo "❌ Not found"
    exit 1
fi

# Test 2: Check if wal cache exists
echo -n "✓ Checking wal cache... "
if [[ -f ~/.cache/wal/colors.json ]]; then
    echo "✅ Cache exists"
else
    echo "⚠️  No cache found"
    echo "   Run this to create cache: setwal ~/Desktop/Screenshot\\ 2025-07-27\\ at\\ 08.46.32.png"
fi

# Test 3: Try wal -R safely
echo -n "✓ Testing 'wal -R -n' command... "
if "$HOME/Library/Python/3.9/bin/wal" -R -n >/dev/null 2>&1; then
    echo "✅ Success"
else
    echo "❌ Failed"
    echo "   This might be the issue causing terminal closure"
fi

# Test 4: Check iTerm2 script
echo -n "✓ Testing iTerm2 script... "
if [[ -f ~/.config/wal/scripts/iterm2.sh ]]; then
    if bash ~/.config/wal/scripts/iterm2.sh >/dev/null 2>&1; then
        echo "✅ Script works"
    else
        echo "⚠️  Script has issues"
    fi
else
    echo "❌ Script missing"
fi

# Test 5: Test individual components
echo ""
echo "🧪 Component Tests:"
echo "=================="

echo "Testing wal version:"
"$HOME/Library/Python/3.9/bin/wal" --version 2>/dev/null || echo "Version check failed"

echo ""
echo "Testing Python pywal script:"
if python3 ~/.config/wal/scripts/update_iterm2.py 2>/dev/null; then
    echo "✅ Python script works"
else
    echo "❌ Python script failed"
fi

echo ""
echo "📋 Safe Commands to Try:"
echo "========================"
echo "1. walupdate          # Update from current wallpaper"
echo "2. walcolors          # Show color palette"
echo "3. setwal <image>     # Set new wallpaper and colors"
echo ""
echo "❗ Avoid 'wal-refresh' until we fix the issue"
