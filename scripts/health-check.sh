#!/bin/bash

# Dotfiles Health Check
# Verifies that all symlinks are working and configurations are valid

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo -e "${BLUE}🔍 Dotfiles Health Check${NC}"
echo -e "${BLUE}========================${NC}"
echo ""

# Track issues
ISSUES=0

# Function to check symlink
check_symlink() {
    local target="$1"
    local expected_source="$2"
    local name="$3"
    
    if [ -L "$target" ]; then
        local actual_source=$(readlink "$target")
        if [ "$actual_source" = "$expected_source" ]; then
            echo -e "${GREEN}✅ $name symlink is correct${NC}"
        else
            echo -e "${RED}❌ $name symlink points to wrong location${NC}"
            echo -e "   Expected: $expected_source"
            echo -e "   Actual: $actual_source"
            ISSUES=$((ISSUES + 1))
        fi
    elif [ -f "$target" ] || [ -d "$target" ]; then
        echo -e "${YELLOW}⚠️  $name exists but is not a symlink${NC}"
        ISSUES=$((ISSUES + 1))
    else
        echo -e "${RED}❌ $name does not exist${NC}"
        ISSUES=$((ISSUES + 1))
    fi
}

# Function to check file syntax
check_syntax() {
    local file="$1"
    local type="$2"
    local name="$3"
    
    if [ -f "$file" ]; then
        case $type in
            "zsh")
                if zsh -n "$file" 2>/dev/null; then
                    echo -e "${GREEN}✅ $name syntax is valid${NC}"
                else
                    echo -e "${RED}❌ $name has syntax errors${NC}"
                    ISSUES=$((ISSUES + 1))
                fi
                ;;
            "bash")
                if bash -n "$file" 2>/dev/null; then
                    echo -e "${GREEN}✅ $name syntax is valid${NC}"
                else
                    echo -e "${RED}❌ $name has syntax errors${NC}"
                    ISSUES=$((ISSUES + 1))
                fi
                ;;
        esac
    else
        echo -e "${RED}❌ $name file not found${NC}"
        ISSUES=$((ISSUES + 1))
    fi
}

# Check symlinks
echo -e "${BLUE}🔗 Checking symlinks...${NC}"
check_symlink "$HOME/.zshrc" "$DOTFILES_DIR/zsh/zshrc" "Zsh config"
check_symlink "$HOME/.zshenv" "$DOTFILES_DIR/zsh/zshenv" "Zsh environment"
check_symlink "$HOME/.p10k.zsh" "$DOTFILES_DIR/zsh/p10k.zsh" "Powerlevel10k config"
check_symlink "$HOME/.profile" "$DOTFILES_DIR/zsh/profile" "Profile"
check_symlink "$HOME/.gitconfig" "$DOTFILES_DIR/git/gitconfig" "Git config"

echo ""

# Check file syntax
echo -e "${BLUE}📝 Checking file syntax...${NC}"
check_syntax "$DOTFILES_DIR/zsh/zshrc" "zsh" "Zsh config"
check_syntax "$DOTFILES_DIR/zsh/zshenv" "zsh" "Zsh environment"
check_syntax "$DOTFILES_DIR/install.sh" "bash" "Install script"
check_syntax "$DOTFILES_DIR/update.sh" "bash" "Update script"

echo ""

# Check dependencies
echo -e "${BLUE}🔧 Checking dependencies...${NC}"

if command -v zsh &> /dev/null; then
    echo -e "${GREEN}✅ Zsh is installed${NC}"
else
    echo -e "${RED}❌ Zsh is not installed${NC}"
    ISSUES=$((ISSUES + 1))
fi

if [ -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${GREEN}✅ Oh My Zsh is installed${NC}"
else
    echo -e "${YELLOW}⚠️  Oh My Zsh is not installed${NC}"
    ISSUES=$((ISSUES + 1))
fi

if [ -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
    echo -e "${GREEN}✅ Powerlevel10k is installed${NC}"
else
    echo -e "${YELLOW}⚠️  Powerlevel10k is not installed${NC}"
    ISSUES=$((ISSUES + 1))
fi

if command -v git &> /dev/null; then
    echo -e "${GREEN}✅ Git is installed${NC}"
else
    echo -e "${RED}❌ Git is not installed${NC}"
    ISSUES=$((ISSUES + 1))
fi

echo ""

# Check optional tools
echo -e "${BLUE}🛠️  Checking optional tools...${NC}"

optional_tools=("bat" "exa" "fd" "rg" "htop")
for tool in "${optional_tools[@]}"; do
    if command -v "$tool" &> /dev/null; then
        echo -e "${GREEN}✅ $tool is installed${NC}"
    else
        echo -e "${YELLOW}💡 $tool is not installed (optional)${NC}"
    fi
done

echo ""

# Check shell
echo -e "${BLUE}🐚 Checking shell configuration...${NC}"

if [ "$SHELL" = "$(which zsh)" ]; then
    echo -e "${GREEN}✅ Zsh is the default shell${NC}"
else
    echo -e "${YELLOW}⚠️  Default shell is not zsh (current: $SHELL)${NC}"
    echo -e "   Run: chsh -s \$(which zsh)"
fi

echo ""

# Summary
echo -e "${BLUE}📊 Summary${NC}"
echo -e "${BLUE}=========${NC}"

if [ $ISSUES -eq 0 ]; then
    echo -e "${GREEN}🎉 All checks passed! Your dotfiles are healthy.${NC}"
    exit 0
else
    echo -e "${RED}❌ Found $ISSUES issue(s) that need attention.${NC}"
    echo ""
    echo -e "${YELLOW}💡 To fix issues:${NC}"
    echo -e "   1. Run 'make install' to recreate symlinks"
    echo -e "   2. Run 'make setup-macos' to install missing tools"
    echo -e "   3. Check syntax errors in configuration files"
    exit 1
fi
