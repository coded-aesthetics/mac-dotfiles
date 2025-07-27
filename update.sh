#!/bin/bash

# Dotfiles Update Script
# This script pulls the latest changes and re-runs the installation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}🔄 Updating dotfiles...${NC}"

# Check if we're in a git repository
if [ ! -d "$DOTFILES_DIR/.git" ]; then
    echo -e "${RED}❌ This doesn't appear to be a git repository${NC}"
    echo -e "${YELLOW}💡 If you cloned from GitHub, make sure you're in the dotfiles directory${NC}"
    exit 1
fi

# Pull latest changes
echo -e "${BLUE}📡 Pulling latest changes from remote...${NC}"
cd "$DOTFILES_DIR"

# Stash any local changes
if ! git diff-index --quiet HEAD --; then
    echo -e "${YELLOW}⚠️  You have local changes. Stashing them...${NC}"
    git stash push -m "Auto-stash before update $(date)"
fi

# Pull from remote
git pull origin main || git pull origin master || {
    echo -e "${RED}❌ Failed to pull from remote${NC}"
    echo -e "${YELLOW}💡 You might need to resolve conflicts manually${NC}"
    exit 1
}

# Re-run installation
echo -e "${BLUE}🔧 Re-running installation...${NC}"
./install.sh

echo -e "${GREEN}✅ Dotfiles updated successfully!${NC}"

# Check if there were stashed changes
if git stash list | grep -q "Auto-stash before update"; then
    echo -e "${YELLOW}📝 You had local changes that were stashed.${NC}"
    echo -e "${YELLOW}💡 Run 'git stash pop' to restore them if needed.${NC}"
fi

echo -e "${BLUE}🎉 Update complete! Restart your terminal or run 'source ~/.zshrc'${NC}"
