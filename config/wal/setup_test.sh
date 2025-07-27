#!/bin/bash

# Pywal Setup and Test Script
# This script sets up pywal with your current screenshot and demonstrates the integration

echo "🎨 Setting up Pywal with zsh integration..."
echo "============================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if pywal is installed
if ! command -v "$HOME/Library/Python/3.9/bin/wal" &> /dev/null; then
    echo -e "${RED}❌ Pywal not found. Please install it first.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Pywal found${NC}"

# Test with the screenshot
SCREENSHOT="/Users/jan/Desktop/Screenshot 2025-07-27 at 08.46.32.png"

if [ ! -f "$SCREENSHOT" ]; then
    echo -e "${RED}❌ Screenshot not found: $SCREENSHOT${NC}"
    echo "Please provide an image file to test with."
    exit 1
fi

echo -e "${BLUE}🖼️  Using image: $(basename "$SCREENSHOT")${NC}"

# Generate colors with pywal
echo -e "${YELLOW}🎨 Generating color scheme...${NC}"
"$HOME/Library/Python/3.9/bin/wal" --backend colorz -i "$SCREENSHOT" -n

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Color scheme generated successfully${NC}"
else
    echo -e "${RED}❌ Failed to generate color scheme${NC}"
    exit 1
fi

# Update iTerm2
echo -e "${YELLOW}🖥️  Updating iTerm2 colors...${NC}"
python3 "$HOME/.config/wal/scripts/update_iterm2.py"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ iTerm2 colors updated${NC}"
else
    echo -e "${RED}❌ Failed to update iTerm2 colors${NC}"
fi

# Show generated colors
echo -e "${BLUE}🌈 Generated color palette:${NC}"
echo "================================"

# Read the colors from the generated file
if [ -f "$HOME/.cache/wal/colors.sh" ]; then
    source "$HOME/.cache/wal/colors.sh"
    
    echo -e "Background: ${background}"
    echo -e "Foreground: ${foreground}"
    echo -e "Cursor:     ${cursor}"
    echo ""
    echo "ANSI Colors:"
    for i in {0..15}; do
        color_var="color$i"
        eval "color_value=\$$color_var"
        printf "Color %2d: %s\\n" "$i" "$color_value"
    done
else
    echo -e "${RED}❌ Colors file not found${NC}"
fi

echo ""
echo -e "${GREEN}🎉 Setup complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Open a new terminal or run: source ~/.zshrc"
echo "2. Your terminal should now use the new colors"
echo "3. In iTerm2, you can switch to the 'Pywal' profile"
echo ""
echo "Available commands:"
echo "  setwal <image>     - Set wallpaper and update colors"
echo "  setwal random      - Use random image from ~/Pictures/Wallpapers/"
echo "  wal-refresh        - Refresh current colors"
echo "  walcolors          - Show current color palette"
echo "  wal-image <image>  - Update colors without changing wallpaper"
echo ""
echo "To start the automatic wallpaper monitor:"
echo "  launchctl load ~/Library/LaunchAgents/com.user.pywal.wallpaper-monitor.plist"
