# Pywal + zsh + iTerm2 Integration - Quick Reference

## What was installed:

### ✅ Pywal
- **Location**: `/Users/jan/Library/Python/3.9/bin/wal`
- **Backend**: colorz (for better macOS compatibility)
- **Config**: `~/.config/wal/`

### ✅ zsh Integration
- **Added to**: `~/.zshrc`
- **Auto-loads**: Colors when terminal starts
- **Path added**: Pywal binary automatically available

### ✅ iTerm2 Integration
- **Dynamic Profile**: "Pywal" profile created automatically
- **Auto-updates**: When colors change
- **Location**: `~/Library/Application Support/iTerm2/DynamicProfiles/pywal.json`

## 🎨 Available Commands:

### Basic Usage:
```bash
# Set colors from an image (without changing wallpaper)
wal-image ~/Pictures/myimage.jpg

# Set wallpaper AND update colors
setwal ~/Pictures/myimage.jpg

# Use a random image from wallpapers folder
setwal random

# Refresh current colors
wal-refresh

# Show current color palette in terminal
walcolors

# Preview colors without applying (if supported)
walpreview ~/Pictures/myimage.jpg
```

### Original pywal commands:
```bash
# Basic usage
wal -i ~/Pictures/image.jpg

# Light theme
wal -l -i ~/Pictures/image.jpg

# Don't set wallpaper, just colors
wal -n -i ~/Pictures/image.jpg

# Use different backend
wal --backend colorz -i ~/Pictures/image.jpg
```

## 🔧 Setup Files:

### Scripts:
- `~/.config/wal/scripts/update_iterm2.py` - iTerm2 color updater
- `~/.config/wal/scripts/iterm2.sh` - Shell wrapper for iTerm2 updates
- `~/.config/wal/scripts/wallpaper_monitor.sh` - Automatic wallpaper monitor
- `~/.config/wal/setup_test.sh` - Test and verification script

### Configuration:
- `~/.config/wal/` - Main pywal config directory
- `~/.cache/wal/` - Generated color schemes and cache

### Launch Agent (optional):
- `~/Library/LaunchAgents/com.user.pywal.wallpaper-monitor.plist` - Auto-start wallpaper monitoring

## 🚀 Getting Started:

1. **Test the setup:**
   ```bash
   ~/.config/wal/setup_test.sh
   ```

2. **Use with an image:**
   ```bash
   setwal ~/Desktop/Screenshot\ 2025-07-27\ at\ 08.46.32.png
   ```

3. **Open new terminal** or run `source ~/.zshrc`

4. **In iTerm2**: Switch to "Pywal" profile in Preferences > Profiles

## 🎯 Pro Tips:

### Organize your wallpapers:
```bash
mkdir -p ~/Pictures/Wallpapers
# Put your favorite wallpapers here
setwal random  # Will pick from this folder
```

### Auto-monitor wallpaper changes:
```bash
# Load the service to auto-detect wallpaper changes
launchctl load ~/Library/LaunchAgents/com.user.pywal.wallpaper-monitor.plist

# Unload if you want to stop it
launchctl unload ~/Library/LaunchAgents/com.user.pywal.wallpaper-monitor.plist
```

### Color cache:
- Colors are cached, so the same image won't regenerate colors
- Cache location: `~/.cache/wal/`
- To force regeneration: `wal -i image.jpg` (without -R flag)

## 🔍 Troubleshooting:

### If colors don't appear:
```bash
# Check if pywal is working
wal -v

# Manually source colors
source ~/.cache/wal/colors.sh

# Check if cache exists
ls ~/.cache/wal/
```

### If iTerm2 profile doesn't appear:
```bash
# Manually update iTerm2
python3 ~/.config/wal/scripts/update_iterm2.py

# Check if profile was created
ls "~/Library/Application Support/iTerm2/DynamicProfiles/"
```

### Reset everything:
```bash
# Clear pywal cache
rm -rf ~/.cache/wal/

# Regenerate colors
wal --backend colorz -i ~/Desktop/Screenshot\ 2025-07-27\ at\ 08.46.32.png
```

## 🌈 What happens when you run setwal:

1. **Pywal** extracts colors from your image
2. **Terminal colors** are updated via escape sequences
3. **zsh** loads the new colors automatically
4. **iTerm2** gets a new dynamic profile with matching colors
5. **Wallpaper** is set (if using setwal command)

Enjoy your dynamic, color-coordinated terminal! 🎨✨
