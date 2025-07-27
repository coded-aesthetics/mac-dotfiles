#!/usr/bin/env python3

# Fix pywal cursor sequences for better visibility
# This script patches the sequences file to use smart cursor selection

import json
import os
import re

def hex_to_rgb(hex_color):
    """Convert hex color to RGB tuple"""
    hex_color = hex_color.lstrip('#')
    return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))

def calculate_luminance(rgb):
    """Calculate the relative luminance of a color"""
    def linearize(c):
        c = c / 255.0
        if c <= 0.03928:
            return c / 12.92
        else:
            return pow((c + 0.055) / 1.055, 2.4)
    
    r, g, b = [linearize(c) for c in rgb]
    return 0.2126 * r + 0.7152 * g + 0.0722 * b

def find_best_cursor_color(colors, background_hex):
    """Find the best cursor color that contrasts well with background"""
    bg_rgb = hex_to_rgb(background_hex)
    bg_luminance = calculate_luminance(bg_rgb)
    best_color = None
    best_contrast = 0
    best_hex = None
    
    # Check all available colors for best contrast
    candidates = []
    
    # Add foreground color as primary candidate
    if 'foreground' in colors['special']:
        candidates.append(('foreground', colors['special']['foreground']))
    
    # Add bright colors (usually better for cursor)
    for i in range(8, 16):
        color_key = f'color{i}'
        if color_key in colors['colors']:
            candidates.append((color_key, colors['colors'][color_key]))
    
    # Add regular colors but skip very dark ones
    for i in range(1, 8):  # Skip color0 (often black)
        color_key = f'color{i}'
        if color_key in colors['colors']:
            color_hex = colors['colors'][color_key]
            color_rgb = hex_to_rgb(color_hex)
            color_luminance = calculate_luminance(color_rgb)
            # Only consider colors that aren't too dark
            if color_luminance > 0.1:
                candidates.append((color_key, color_hex))
    
    # Find color with best contrast
    for name, hex_color in candidates:
        rgb = hex_to_rgb(hex_color)
        luminance = calculate_luminance(rgb)
        
        # Calculate contrast ratio
        if bg_luminance > luminance:
            contrast = (bg_luminance + 0.05) / (luminance + 0.05)
        else:
            contrast = (luminance + 0.05) / (bg_luminance + 0.05)
        
        if contrast > best_contrast:
            best_contrast = contrast
            best_color = rgb
            best_hex = hex_color
    
    # Fallback to foreground color if no good contrast found
    if best_hex is None and 'foreground' in colors['special']:
        best_hex = colors['special']['foreground']
    
    # Ultimate fallback to white
    if best_hex is None:
        best_hex = '#ffffff'
    
    return best_hex, best_contrast

def fix_cursor_sequences():
    """Fix the pywal sequences file to use smart cursor color"""
    
    # Read pywal colors
    colors_file = os.path.expanduser("~/.cache/wal/colors.json")
    sequences_file = os.path.expanduser("~/.cache/wal/sequences")
    
    if not os.path.exists(colors_file):
        print("❌ No pywal colors found. Run 'walupdate' first.")
        return False
    
    if not os.path.exists(sequences_file):
        print("❌ No sequences file found. Run 'walupdate' first.")
        return False
    
    # Load colors
    with open(colors_file, 'r') as f:
        colors = json.load(f)
    
    # Simple fix: just use foreground color for cursor (never black)
    background_hex = colors['special']['background']
    foreground_hex = colors['special']['foreground']
    original_cursor_hex = colors['special']['cursor']
    
    # Use foreground color as cursor (it's always visible against background)
    smart_cursor_hex = foreground_hex
    
    print(f"🔍 Background color: {background_hex}")
    print(f"❌ Original cursor: {original_cursor_hex}")
    print(f"✅ New cursor: {smart_cursor_hex} (using foreground color)")
    
    # Read current sequences
    with open(sequences_file, 'r') as f:
        sequences = f.read()
    
    # Convert hex colors to the format used in sequences
    def hex_to_term_format(hex_color):
        return hex_color.lstrip('#').lower()
    
    original_term = hex_to_term_format(original_cursor_hex)
    smart_term = hex_to_term_format(smart_cursor_hex)
    bg_term = hex_to_term_format(background_hex)
    
    # Replace cursor color references in sequences
    # Replace cursor color (]Pg)
    sequences = sequences.replace(f']Pg{original_term}\\', f']Pg{smart_term}\\')
    
    # Replace cursor text color with background (]Pl)
    sequences = sequences.replace(f']Pl{original_term}\\', f']Pl{bg_term}\\')
    
    # Replace extended color 256 if it matches cursor
    sequences = sequences.replace(f']4;256;{original_cursor_hex}\\', f']4;256;{smart_cursor_hex}\\')
    
    # Write fixed sequences
    with open(sequences_file, 'w') as f:
        f.write(sequences)
    
    print(f"✅ Fixed cursor sequences in {sequences_file}")
    print(f"🎨 Applying new cursor color...")
    
    # Apply the sequences immediately
    os.system(f"cat {sequences_file}")
    
    return True

if __name__ == "__main__":
    print("🎯 Fixing Pywal Cursor Sequences")
    print("================================")
    
    if fix_cursor_sequences():
        print("🎉 Cursor visibility fix applied!")
        print("📝 The terminal cursor should now be clearly visible.")
        print("🔄 This fix is automatically applied with each color update.")
    else:
        print("❌ Failed to apply cursor fix.")
