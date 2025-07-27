#!/usr/bin/env python3

# iTerm2 Dynamic Color Profile Script
# This script creates an iTerm2 color profile from pywal colors

import json
import os
import sys

def hex_to_rgb(hex_color):
    """Convert hex color to RGB tuple (0-1 range)"""
    hex_color = hex_color.lstrip('#')
    return tuple(int(hex_color[i:i+2], 16) / 255.0 for i in (0, 2, 4))

def calculate_luminance(rgb):
    """Calculate the relative luminance of a color"""
    def linearize(c):
        if c <= 0.03928:
            return c / 12.92
        else:
            return pow((c + 0.055) / 1.055, 2.4)
    
    r, g, b = [linearize(c) for c in rgb]
    return 0.2126 * r + 0.7152 * g + 0.0722 * b

def find_best_cursor_color(colors, background_rgb):
    """Find the best cursor color that contrasts well with background"""
    bg_luminance = calculate_luminance(background_rgb)
    best_color = None
    best_contrast = 0
    
    # Check all available colors for best contrast
    candidates = []
    
    # Add foreground color as primary candidate
    if 'foreground' in colors['special']:
        fg_rgb = hex_to_rgb(colors['special']['foreground'])
        candidates.append(('foreground', fg_rgb))
    
    # Add bright colors (usually better for cursor)
    for i in range(8, 16):  # Bright colors
        color_key = f'color{i}'
        if color_key in colors['colors']:
            color_rgb = hex_to_rgb(colors['colors'][color_key])
            candidates.append((color_key, color_rgb))
    
    # Add regular colors but skip very dark ones
    for i in range(1, 8):  # Skip color0 (often black)
        color_key = f'color{i}'
        if color_key in colors['colors']:
            color_rgb = hex_to_rgb(colors['colors'][color_key])
            color_luminance = calculate_luminance(color_rgb)
            # Only consider colors that aren't too dark
            if color_luminance > 0.1:  # Avoid very dark colors
                candidates.append((color_key, color_rgb))
    
    # Find color with best contrast
    for name, rgb in candidates:
        luminance = calculate_luminance(rgb)
        # Calculate contrast ratio
        if bg_luminance > luminance:
            contrast = (bg_luminance + 0.05) / (luminance + 0.05)
        else:
            contrast = (luminance + 0.05) / (bg_luminance + 0.05)
        
        if contrast > best_contrast:
            best_contrast = contrast
            best_color = rgb
    
    # Fallback to foreground color if no good contrast found
    if best_color is None and 'foreground' in colors['special']:
        best_color = hex_to_rgb(colors['special']['foreground'])
    
    # Ultimate fallback to white
    if best_color is None:
        best_color = (1.0, 1.0, 1.0)
    
    return best_color

def create_iterm_profile():
    """Create iTerm2 dynamic profile from wal colors"""
    
    # Read wal colors
    wal_colors_file = os.path.expanduser("~/.cache/wal/colors.json")
    
    if not os.path.exists(wal_colors_file):
        print("Error: wal colors file not found. Run 'wal -i <image>' first.")
        sys.exit(1)
    
    with open(wal_colors_file, 'r') as f:
        colors = json.load(f)
    
    # Convert colors to RGB
    bg_rgb = hex_to_rgb(colors['special']['background'])
    fg_rgb = hex_to_rgb(colors['special']['foreground'])
    
    # Simple fix: always use foreground color for cursor (never black)
    cursor_rgb = fg_rgb
    
    print(f"📍 Cursor color set to foreground: {colors['special']['foreground']} (always visible)")
    
    # Create the profile with transparency and visual effects
    profile = {
        "Profiles": [
            {
                "Name": "Pywal",
                "Guid": "pywal-generated",
                "Dynamic Profile Parent Name": "Default",
                
                # Window transparency and effects
                "Transparency": 0.3,  # 30% transparency
                "Blur": True,         # Enable blur effect
                "Blur Radius": 2.0,   # Subtle blur
                "Use Blur": True,
                
                # Background and foreground colors
                "Background Color": {
                    "Red Component": bg_rgb[0],
                    "Green Component": bg_rgb[1], 
                    "Blue Component": bg_rgb[2],
                    "Color Space": "sRGB",
                    "Alpha Component": 1
                },
                "Foreground Color": {
                    "Red Component": fg_rgb[0],
                    "Green Component": fg_rgb[1],
                    "Blue Component": fg_rgb[2], 
                    "Color Space": "sRGB",
                    "Alpha Component": 1
                },
                
                # Cursor settings
                "Cursor Color": {
                    "Red Component": cursor_rgb[0],
                    "Green Component": cursor_rgb[1],
                    "Blue Component": cursor_rgb[2],
                    "Color Space": "sRGB", 
                    "Alpha Component": 1
                },
                "Cursor Text Color": {
                    "Red Component": bg_rgb[0],
                    "Green Component": bg_rgb[1],
                    "Blue Component": bg_rgb[2],
                    "Color Space": "sRGB",
                    "Alpha Component": 1
                },
                
                # Additional visual enhancements
                "Minimum Contrast": 0.5,  # Ensure text readability
                "Use Bold Font": True,     # Better text visibility with transparency
                "Draw Powerline Glyphs": True,  # Support for powerline fonts
                
                # Window behavior
                "Window Type": 0,          # Normal window
                "Screen": -1,              # Default screen
                "Space": -1                # Default space
            }
        ]
    }
    
    # Add ANSI colors with smart dark color handling
    for i in range(16):
        color_key = f"color{i}"
        if color_key in colors['colors']:
            rgb = hex_to_rgb(colors['colors'][color_key])
            
            # For color0 (often black), check if it's too dark and adjust if needed
            if i == 0:
                luminance = calculate_luminance(rgb)
                bg_luminance = calculate_luminance(bg_rgb)
                
                # If color0 is too similar to background, use a slightly lighter version
                if abs(luminance - bg_luminance) < 0.1:  # Too similar
                    # Create a slightly lighter version that maintains contrast
                    if bg_luminance < 0.5:  # Dark background
                        rgb = (min(rgb[0] + 0.2, 1.0), min(rgb[1] + 0.2, 1.0), min(rgb[2] + 0.2, 1.0))
                    else:  # Light background  
                        rgb = (max(rgb[0] - 0.2, 0.0), max(rgb[1] - 0.2, 0.0), max(rgb[2] - 0.2, 0.0))
                    
                    adjusted_hex = '#{:02x}{:02x}{:02x}'.format(
                        int(rgb[0] * 255), int(rgb[1] * 255), int(rgb[2] * 255)
                    )
                    print(f"⚠️  Adjusted color0 for better contrast: {adjusted_hex}")
            
            profile["Profiles"][0][f"Ansi {i} Color"] = {
                "Red Component": rgb[0],
                "Green Component": rgb[1], 
                "Blue Component": rgb[2],
                "Color Space": "sRGB",
                "Alpha Component": 1
            }
    
    # Write the profile
    iterm_dir = os.path.expanduser("~/Library/Application Support/iTerm2/DynamicProfiles")
    os.makedirs(iterm_dir, exist_ok=True)
    
    profile_file = os.path.join(iterm_dir, "pywal.json")
    with open(profile_file, 'w') as f:
        json.dump(profile, f, indent=2)
    
    print(f"Created iTerm2 profile with 30% transparency: {profile_file}")
    
    # Tell iTerm2 to reload (with error handling)
    try:
        import subprocess
        # Try different approaches to reload iTerm2
        reload_commands = [
            ['osascript', '-e', 'tell application "iTerm2"', '-e', 'reload dynamic profiles', '-e', 'end tell'],
            ['osascript', '-e', 'tell application id "com.googlecode.iterm2" to reload dynamic profiles'],
            ['killall', '-USR1', 'iTerm2']  # Signal approach as fallback
        ]
        
        success = False
        for cmd in reload_commands:
            try:
                result = subprocess.run(cmd, capture_output=True, text=True, timeout=5)
                if result.returncode == 0:
                    print("Reloaded iTerm2 dynamic profiles")
                    success = True
                    break
            except:
                continue
        
        if not success:
            print("Note: iTerm2 profile created. You may need to manually reload profiles in iTerm2.")
            
    except Exception as e:
        print(f"iTerm2 profile created. Manual reload may be needed: {e}")

if __name__ == "__main__":
    create_iterm_profile()
