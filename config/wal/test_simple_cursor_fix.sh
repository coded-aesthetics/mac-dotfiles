#!/bin/bash

# Simple test to verify cursor is not black anymore

echo "🎯 Simple Cursor Fix Verification"
echo "================================="

# Check current colors
if [[ -f ~/.cache/wal/colors.json ]]; then
    echo "📊 Current Colors:"
    echo "==================="
    
    # Extract colors using Python
    python3 << 'EOF'
import json
import os

try:
    with open(os.path.expanduser('~/.cache/wal/colors.json'), 'r') as f:
        colors = json.load(f)
    
    bg_hex = colors['special']['background']
    fg_hex = colors['special']['foreground']
    cursor_hex = colors['special']['cursor']
    color0_hex = colors['colors']['color0']
    
    print(f"Background:      {bg_hex}")
    print(f"Foreground:      {fg_hex}")
    print(f"Cursor (pywal):  {cursor_hex}")
    print(f"Color0 (black):  {color0_hex}")
    print()
    
    # Check if cursor equals foreground (our fix)
    if cursor_hex == fg_hex:
        print("✅ FIXED: Cursor uses foreground color (visible)")
    elif cursor_hex == color0_hex:
        print("❌ PROBLEM: Cursor still uses color0 (potentially invisible)")
    else:
        print(f"⚠️  UNKNOWN: Cursor uses different color: {cursor_hex}")
    
    # Check if color0 equals background (invisible)
    if color0_hex == bg_hex:
        print("❌ WARNING: color0 same as background (invisible)")
    else:
        print("✅ OK: color0 differs from background")
        
except Exception as e:
    print(f"Error: {e}")
EOF

else
    echo "❌ No pywal colors found"
fi

echo ""
echo "🧪 Test Instructions:"
echo "===================="
echo "1. Run: walupdate"
echo "2. Open vim: vim ~/.zshrc"
echo "3. Cursor should be the same color as text (foreground)"
echo "4. NOT black (color0)"
echo ""
echo "Expected: Cursor = Foreground color (always visible)"
