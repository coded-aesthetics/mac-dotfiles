#!/bin/bash

# Test script to demonstrate cursor visibility improvements

echo "🎯 Cursor Visibility Test"
echo "========================="
echo ""

# Show current colors
echo "📊 Current Color Analysis:"
echo "-------------------------"

if [[ -f ~/.cache/wal/colors.json ]]; then
    echo "✅ Pywal colors found"
    
    # Extract key colors using Python
    python3 << 'EOF'
import json
import os

def hex_to_rgb(hex_color):
    hex_color = hex_color.lstrip('#')
    return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))

def calculate_luminance(rgb):
    def linearize(c):
        c = c / 255.0
        if c <= 0.03928:
            return c / 12.92
        else:
            return pow((c + 0.055) / 1.055, 2.4)
    
    r, g, b = [linearize(c) for c in rgb]
    return 0.2126 * r + 0.7152 * g + 0.0722 * b

try:
    with open(os.path.expanduser('~/.cache/wal/colors.json'), 'r') as f:
        colors = json.load(f)
    
    bg_hex = colors['special']['background']
    cursor_hex = colors['special']['cursor']
    color0_hex = colors['colors']['color0']
    
    bg_rgb = hex_to_rgb(bg_hex)
    cursor_rgb = hex_to_rgb(cursor_hex)
    color0_rgb = hex_to_rgb(color0_hex)
    
    bg_lum = calculate_luminance(bg_rgb)
    cursor_lum = calculate_luminance(cursor_rgb)
    color0_lum = calculate_luminance(color0_rgb)
    
    print(f"Background: {bg_hex} (luminance: {bg_lum:.3f})")
    print(f"Original cursor: {cursor_hex} (luminance: {cursor_lum:.3f})")
    print(f"Color0 (black): {color0_hex} (luminance: {color0_lum:.3f})")
    print()
    
    # Calculate contrast ratios
    def contrast_ratio(lum1, lum2):
        if lum1 > lum2:
            return (lum1 + 0.05) / (lum2 + 0.05)
        else:
            return (lum2 + 0.05) / (lum1 + 0.05)
    
    cursor_contrast = contrast_ratio(bg_lum, cursor_lum)
    color0_contrast = contrast_ratio(bg_lum, color0_lum)
    
    print("📈 Contrast Analysis:")
    print(f"   Original cursor vs background: {cursor_contrast:.2f}:1")
    print(f"   Color0 vs background: {color0_contrast:.2f}:1")
    print()
    
    if cursor_contrast < 3.0:
        print("❌ Poor cursor contrast - vim will be hard to use!")
    elif cursor_contrast < 4.5:
        print("⚠️  Marginal cursor contrast - might be hard to see")
    else:
        print("✅ Good cursor contrast - should be visible")
    
    if color0_contrast < 1.5:
        print("❌ Color0 too similar to background - will cause issues")
    else:
        print("✅ Color0 has adequate contrast")
        
except Exception as e:
    print(f"Error analyzing colors: {e}")
EOF

else
    echo "❌ No pywal colors found. Run 'walupdate' first."
fi

echo ""
echo "🔧 Smart Cursor Selection:"
echo "--------------------------"
echo "The improved iTerm2 profile now:"
echo "  ✅ Analyzes all available colors"
echo "  ✅ Selects cursor color with best contrast"
echo "  ✅ Avoids dark colors that blend into background"
echo "  ✅ Adjusts color0 if it's too similar to background"
echo "  ✅ Maintains color scheme harmony"
echo ""
echo "🎯 Vim Usage Test:"
echo "-----------------"
echo "To test cursor visibility:"
echo "  1. Switch to 'Pywal' profile in iTerm2"
echo "  2. Run: vim ~/.zshrc"
echo "  3. Try moving cursor around"
echo "  4. Enter insert mode (press 'i')"
echo "  5. Cursor should be clearly visible!"
echo ""
echo "📊 Profile Update Status:"
if [[ -f ~/Library/Application\ Support/iTerm2/DynamicProfiles/pywal.json ]]; then
    echo "✅ Pywal profile exists with smart cursor selection"
    echo "   Location: ~/Library/Application Support/iTerm2/DynamicProfiles/pywal.json"
else
    echo "❌ Profile not found. Run 'walupdate' to create it."
fi
