#!/bin/bash

# Safe wal-refresh replacement
# This script refreshes pywal colors without risking terminal closure

echo "🔄 Safe Pywal Refresh"
echo "==================="

# Set error handling
set -e
trap 'echo "❌ An error occurred. Terminal should remain open."; exit 1' ERR

# Check for cache
if [[ ! -f ~/.cache/wal/colors.json ]]; then
    echo "❌ No pywal cache found."
    echo "💡 Run: setwal <image_path>"
    exit 1
fi

echo "✅ Cache found, proceeding..."

# Method 1: Try to reload sequences directly
if [[ -f ~/.cache/wal/sequences ]]; then
    echo "🎨 Applying cached colors..."
    
    # Apply smart cursor fix first
    if [[ -f ~/.config/wal/fix_cursor_sequences.py ]]; then
        python3 ~/.config/wal/fix_cursor_sequences.py >/dev/null 2>&1
        echo "🎯 Fixed cursor visibility"
    fi
    
    # Apply sequences with fixed cursor
    cat ~/.cache/wal/sequences
    echo "✅ Colors applied from cache"
else
    echo "⚠️  No sequences file found"
fi

# Method 2: Update iTerm2 profile
if [[ -f ~/.config/wal/scripts/update_iterm2.py ]]; then
    echo "🖥️  Updating iTerm2 profile..."
    if python3 ~/.config/wal/scripts/update_iterm2.py; then
        echo "✅ iTerm2 profile updated"
    else
        echo "⚠️  iTerm2 update had issues (but terminal stays open)"
    fi
else
    echo "⚠️  iTerm2 script not found"
fi

echo "🎉 Refresh complete! Terminal colors should be updated."
echo "💡 If colors don't look right, try: walupdate"
