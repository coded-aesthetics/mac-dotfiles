# Kitty Terminal Integration with Pywal

This document explains how to use the kitty terminal integration with your existing pywal/setwal setup.

## Overview

The kitty integration extends your existing `setwal` system to work seamlessly with the kitty terminal emulator, providing:

- Automatic color scheme updates from wallpaper images
- Transparency and visual effects similar to your iTerm2 setup
- Smart cursor color detection for optimal visibility
- Real-time color reloading without restarting kitty

## Features

### Visual Enhancements
- **85% background opacity** for subtle transparency
- **Dynamic opacity control** (can be adjusted on-the-fly)
- **Window padding** for better visual spacing
- **Optimized rendering** for performance with transparency

### Smart Color Management
- **Intelligent cursor color selection** - automatically picks the best contrasting color
- **Dark color adjustment** - prevents invisible text by adjusting colors that are too similar to background
- **ANSI color mapping** - full 16-color palette support
- **Tab and border theming** - consistent color scheme throughout the interface

## Installation

### 1. Install Kitty
```bash
# macOS
brew install kitty

# Or download from https://sw.kovidgoyal.net/kitty/
```

### 2. Set Up Configuration
The integration automatically creates and manages these files:
- `~/.config/kitty/kitty.conf` - Main kitty configuration
- `~/.config/kitty/pywal-colors.conf` - Pywal-generated colors

### 3. Enable Remote Control
Kitty's remote control is used for real-time color updates. The integration automatically adds:
```
allow_remote_control yes
listen_on unix:/tmp/kitty
```

## Usage

### Using setwal
Your existing `setwal` function automatically detects kitty and updates colors:

```bash
# Set wallpaper and update colors
setwal ~/Pictures/wallpaper.jpg

# Random wallpaper
setwal random
```

### Manual Color Updates
Force update terminal colors without changing wallpaper:
```bash
update-terminal-colors
```

### Terminal Information
Check current terminal and pywal status:
```bash
terminal-info
```

## How It Works

### 1. Wallpaper Processing
```
setwal image.jpg
    ↓
pywal extracts colors
    ↓
Colors saved to ~/.cache/wal/
```

### 2. Terminal Detection
The system detects kitty using:
- `$TERM` environment variable (`xterm-kitty`)
- `$KITTY_WINDOW_ID` environment variable

### 3. Color Application
```
update_kitty.py script
    ↓
Reads ~/.cache/wal/colors.json
    ↓
Generates ~/.config/kitty/pywal-colors.conf
    ↓
Reloads kitty config via remote control
```

### 4. Real-time Updates
- Colors update immediately without restarting kitty
- Uses `kitty @ load-config` for live reloading
- Fallback to signal-based reload if remote control fails

## Configuration Files

### Generated Color Config (`pywal-colors.conf`)
```
# Basic colors
foreground #color
background #color

# Transparency
background_opacity 0.85
dynamic_background_opacity yes

# 16 ANSI colors
color0 #color
...
color15 #color
```

### Main Kitty Config
The integration adds this line to your `kitty.conf`:
```
include pywal-colors.conf
```

## Customization

### Adjusting Transparency
Change opacity in the generated config or override in your main `kitty.conf`:
```
background_opacity 0.9  # More opaque
background_opacity 0.7  # More transparent
```

### Window Styling
The integration sets sensible defaults, but you can override:
```
window_padding_width 10    # More padding
window_margin_width 2      # Add margins
```

### Cursor Appearance
Customize cursor behavior:
```
cursor_shape beam          # Beam cursor
cursor_blink_interval 1.0  # Slower blinking
```

## Compatibility

### Terminal Detection
The system works with:
- **Primary**: Kitty terminal (`$TERM=xterm-kitty`)
- **Fallback**: Any terminal with `$KITTY_WINDOW_ID` set

### Color Scheme Compatibility
- Full 16-color ANSI support
- True color (24-bit) color support
- Automatic color contrast adjustment
- Preserves pywal color relationships

## Troubleshooting

### Colors Not Updating
1. Check if kitty remote control is enabled:
   ```bash
   kitty @ ls
   ```

2. Verify pywal colors exist:
   ```bash
   ls ~/.cache/wal/colors.json
   ```

3. Manually reload colors:
   ```bash
   update-terminal-colors
   ```

### Remote Control Issues
If `kitty @` commands fail:
1. Check if `allow_remote_control yes` is in your config
2. Restart kitty to enable remote control
3. Verify socket file exists: `/tmp/kitty`

### Color Visibility Issues
The system automatically adjusts problematic colors, but you can:
1. Use `terminal-info` to check current setup
2. Run `setwal` again to regenerate colors
3. Manually edit `~/.config/kitty/pywal-colors.conf`

## Integration with Other Tools

### Zed Editor
Your existing Zed integration continues to work alongside kitty.

### Shell Integration
The color variables are available in your shell:
```bash
echo $color0    # First ANSI color
echo $background # Background color
```

### Powerline/Starship
Kitty works well with your existing prompt setup and supports:
- Powerline glyphs
- Unicode symbols
- True color prompts

## Performance Notes

- **Startup**: Colors load asynchronously after shell initialization
- **Rendering**: Optimized for transparency with `sync_to_monitor yes`
- **Memory**: Minimal overhead for color management
- **CPU**: Efficient real-time updates via remote control

## Switching Between Terminals

You can run both iTerm2 and kitty with the same color scheme:
- `setwal` automatically detects and updates the current terminal
- Colors are synchronized across all supported terminals
- Each terminal maintains its own specific configuration

This allows for seamless switching between terminals while maintaining consistent theming.