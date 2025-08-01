# Wallust + zsh + Kitty Integration - Quick Reference

**⚠️ MIGRATED FROM PYWAL TO WALLUST** - See [WALLUST_MIGRATION.md](WALLUST_MIGRATION.md) for details

## What was installed:

### ✅ Wallust (Rust-based pywal replacement)
- **Location**: `/Users/jan/.cargo/bin/wallust`
- **Backend**: kmeans (advanced color extraction)
- **Config**: `~/.config/wallust/`
- **Compatibility**: Full pywal compatibility mode

### ✅ zsh Integration
- **Added to**: `~/.zshrc`
- **Auto-loads**: Colors when terminal starts
- **Path added**: Pywal binary automatically available

### ✅ Kitty Integration
- **Symlinked Config**: Configuration managed in dotfiles
- **Auto-updates**: Colors and config sync automatically
- **Font**: MesloLGLDZ Nerd Font at size 17
- **Location**: `~/.config/kitty` -> `~/dotfiles/config/kitty`

## 🎨 Available Commands:

### Basic Usage:
```bash
# Set wallpaper AND update colors (recommended)
setwal ~/Pictures/myimage.jpg

# Use a random image from wallpapers folder
setwal random

# Show current color palette in terminal
walcolors

# Test the setup
test-setwal
```

### Direct wallust commands (if needed):
```bash
# Basic usage (pywal compatibility mode)
wallust pywal -i ~/Pictures/image.jpg

# Light theme
wallust pywal -l -i ~/Pictures/image.jpg

# Don't set wallpaper, just colors
wallust pywal -n -i ~/Pictures/image.jpg

# Use different backend
wallust pywal --backend colorz -i ~/Pictures/image.jpg

# Native wallust command (more features)
wallust run ~/Pictures/image.jpg
```

## 🔧 Setup Files:

### Scripts:
- `~/.config/wal/scripts/wal` - **NEW**: Wallust compatibility wrapper
- `~/.config/wal/scripts/update_kitty.py` - Kitty color updater
- `~/.config/wal/scripts/update_zed.py` - Zed editor theme updater
- `~/.config/wal/scripts/wallpaper_monitor.sh` - Automatic wallpaper monitor
- `~/dotfiles/scripts/setup_kitty.sh` - **NEW**: Kitty configuration setup

### Configuration:
- `~/.config/wallust/` - **NEW**: Main wallust config directory
- `~/.config/wallust/wallust.toml` - **NEW**: Wallust configuration
- `~/.config/wallust/templates/` - **NEW**: Wallust templates
- `~/.config/wal/` - Legacy pywal config (kept for compatibility)
- `~/.cache/wal/` - Generated color schemes and cache (same location)

### Launch Agent (optional):
- `~/Library/LaunchAgents/com.user.pywal.wallpaper-monitor.plist` - Auto-start wallpaper monitoring

## 🚀 Getting Started:

1. **Test the setup:**
   ```bash
   test-setwal
   ```

2. **Use with an image:**
   ```bash
   setwal ~/Pictures/Wallpapers/your-image.jpg
   ```

3. **Open new terminal** or run `source ~/.zshrc`

4. **In Kitty**: Colors and fonts update automatically
   - MesloLGLDZ Nerd Font at size 17
   - Transparency and visual effects enabled

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
# Check if wallust is working
wallust --version

# Run diagnostics
test-setwal

# Manually source colors
source ~/.cache/wal/colors.sh

# Check if cache exists
ls ~/.cache/wal/
```

### If kitty config doesn't update:
```bash
# Re-run kitty setup
~/dotfiles/scripts/setup_kitty.sh

# Check symlink
ls -la ~/.config/kitty

# Reload kitty manually
kitty @ load-config
```

### Reset everything:
```bash
# Clear wallust cache
rm -rf ~/.cache/wal/

# Regenerate colors
setwal ~/Pictures/Wallpapers/your-image.jpg
```

## 🌈 What happens when you run setwal:

1. **Wallust** extracts colors from your image (faster, better algorithm)
2. **Terminal colors** are updated via escape sequences
3. **zsh** loads the new colors automatically
4. **Kitty** colors update automatically with transparency and MesloLGLDZ font
5. **Zed** editor theme updates automatically
6. **Wallpaper** is set using macOS native commands

## 🆕 Wallust Advantages:

- ✅ **No more terminal detection issues** - Seamless kitty support
- ✅ **Faster color extraction** - Rust-based performance
- ✅ **Better color algorithms** - kmeans clustering + LAB colorspace
- ✅ **Active maintenance** - Regularly updated unlike archived pywal
- ✅ **Simplified codebase** - Removed 60+ lines of pywal workarounds
- ✅ **Modern font setup** - MesloLGLDZ Nerd Font with proper configuration
- ✅ **Dotfiles integration** - Kitty config managed in version control

## 📚 Migration Info:

- **From**: pywal + iTerm2 (Python, archived)
- **To**: wallust + kitty (Rust, actively maintained)  
- **Terminal**: Switched from iTerm2 to Kitty for better integration
- **Font**: Configured with MesloLGLDZ Nerd Font at size 17
- **Config**: Kitty configuration now managed in dotfiles with symlinks
- **Performance**: Significantly improved
- **See**: [WALLUST_MIGRATION.md](WALLUST_MIGRATION.md) for complete details

Enjoy your dynamic, color-coordinated kitty terminal! 🎨✨ Now powered by wallust! 🦀

## 🚀 Quick Setup for New Systems:

```bash
# 1. Install kitty and font
brew install --cask kitty
brew install font-meslo-lg-nerd-font

# 2. Setup kitty config symlink
~/dotfiles/scripts/setup_kitty.sh

# 3. Test with wallpaper
setwal random
```
