#!/bin/bash

# Test the fixed pywal integration

echo "🔧 Testing Fixed Pywal Integration"
echo "=================================="

# Test 1: Test wal-refresh without errors
echo -n "✓ Testing wal-refresh (should be error-free)... "
if output=$(zsh -c 'source ~/.zshrc >/dev/null 2>&1 && wal-refresh 2>&1'); then
    if echo "$output" | grep -q "Error: unable to open database" || echo "$output" | grep -q "syntax error"; then
        echo "❌ Still has errors"
        echo "Output: $output"
    else
        echo "✅ Working cleanly"
    fi
else
    echo "❌ Command failed"
fi

# Test 2: Test iTerm2 integration
echo -n "✓ Testing iTerm2 profile creation... "
if python3 ~/.config/wal/scripts/update_iterm2.py >/dev/null 2>&1; then
    if [[ -f ~/Library/Application\ Support/iTerm2/DynamicProfiles/pywal.json ]]; then
        echo "✅ Profile created successfully"
    else
        echo "❌ Profile file not found"
    fi
else
    echo "❌ Script failed"
fi

# Test 3: Test color generation without wallpaper setting
echo -n "✓ Testing color generation (no wallpaper errors)... "
if output=$(/Users/jan/Library/Python/3.9/bin/wal --backend colorz -i ~/Desktop/Screenshot\ 2025-07-27\ at\ 08.46.32.png -n 2>&1); then
    if echo "$output" | grep -q "Error: unable to open database"; then
        echo "❌ Still has database error"
    else
        echo "✅ No database errors"
    fi
else
    echo "❌ Color generation failed"
fi

# Test 4: Check if new functions are available
echo -n "✓ Testing new walupdate function... "
if zsh -c 'source ~/.zshrc >/dev/null 2>&1 && type walupdate >/dev/null 2>&1'; then
    echo "✅ walupdate function available"
else
    echo "❌ walupdate function not found"
fi

echo ""
echo "🎯 Summary of Fixes:"
echo "==================="
echo "✅ Fixed: Database errors (added -n flag to skip wallpaper setting)"
echo "✅ Fixed: AppleScript syntax errors (improved error handling)"
echo "✅ Fixed: Powerlevel10k conflicts (deferred loading)"
echo "✅ Added: walupdate function (update colors from current wallpaper)"
echo "✅ Added: Better error handling for iTerm2 reload"
echo ""
echo "📋 Available Commands:"
echo "  wal-refresh     - Refresh colors (no wallpaper change)"
echo "  setwal <image>  - Set wallpaper and colors"  
echo "  walupdate       - Update colors from current wallpaper"
echo "  walcolors       - Show color palette"
echo "  wal-image       - Generate colors only (no wallpaper)"
echo ""
echo "🔄 To test: Open a new terminal and run 'wal-refresh'"
