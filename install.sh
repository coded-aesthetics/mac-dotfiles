#!/bin/bash

# Dotfiles Installation Script
# This script will create symlinks for all configuration files

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}🚀 Setting up dotfiles...${NC}"
echo -e "${BLUE}Dotfiles directory: ${DOTFILES_DIR}${NC}"

# Function to create symlink
create_symlink() {
    local source="$1"
    local target="$2"
    
    # Create directory if it doesn't exist
    mkdir -p "$(dirname "$target")"
    
    if [ -L "$target" ]; then
        echo -e "${YELLOW}⚠️  Removing existing symlink: $target${NC}"
        rm "$target"
    elif [ -f "$target" ] || [ -d "$target" ]; then
        echo -e "${YELLOW}⚠️  Backing up existing file: $target -> $target.backup$(date +%Y%m%d_%H%M%S)${NC}"
        mv "$target" "$target.backup$(date +%Y%m%d_%H%M%S)"
    fi
    
    echo -e "${GREEN}✅ Creating symlink: $target -> $source${NC}"
    ln -s "$source" "$target"
}

# Function to install Oh My Zsh if not present
install_oh_my_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo -e "${BLUE}📦 Installing Oh My Zsh...${NC}"
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        echo -e "${GREEN}✅ Oh My Zsh already installed${NC}"
    fi
}

# Function to install Powerlevel10k
install_powerlevel10k() {
    local p10k_dir="$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
    if [ ! -d "$p10k_dir" ]; then
        echo -e "${BLUE}📦 Installing Powerlevel10k theme...${NC}"
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
    else
        echo -e "${GREEN}✅ Powerlevel10k already installed${NC}"
    fi
}

# Function to install useful zsh plugins
install_zsh_plugins() {
    local custom_plugins_dir="$HOME/.oh-my-zsh/custom/plugins"
    
    # zsh-autosuggestions
    if [ ! -d "$custom_plugins_dir/zsh-autosuggestions" ]; then
        echo -e "${BLUE}📦 Installing zsh-autosuggestions...${NC}"
        git clone https://github.com/zsh-users/zsh-autosuggestions "$custom_plugins_dir/zsh-autosuggestions"
    fi
    
    # zsh-syntax-highlighting
    if [ ! -d "$custom_plugins_dir/zsh-syntax-highlighting" ]; then
        echo -e "${BLUE}📦 Installing zsh-syntax-highlighting...${NC}"
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$custom_plugins_dir/zsh-syntax-highlighting"
    fi
}

# Main installation
main() {
    echo -e "${BLUE}🔧 Starting dotfiles installation...${NC}\n"
    
    # Install dependencies
    install_oh_my_zsh
    install_powerlevel10k
    install_zsh_plugins
    
    echo -e "\n${BLUE}🔗 Creating symlinks...${NC}"
    
    # Create symlinks for dotfiles
    create_symlink "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
    create_symlink "$DOTFILES_DIR/zsh/zshenv" "$HOME/.zshenv"
    create_symlink "$DOTFILES_DIR/zsh/p10k.zsh" "$HOME/.p10k.zsh"
    create_symlink "$DOTFILES_DIR/zsh/profile" "$HOME/.profile"
    
    # Create symlink for git config
    if [ -f "$DOTFILES_DIR/git/gitconfig" ]; then
        create_symlink "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"
    fi
    
    # Create symlinks for config directories
    if [ -d "$DOTFILES_DIR/config" ]; then
        for config_dir in "$DOTFILES_DIR/config"/*; do
            if [ -d "$config_dir" ]; then
                config_name=$(basename "$config_dir")
                create_symlink "$config_dir" "$HOME/.config/$config_name"
            fi
        done
    fi
    
    # Make scripts executable
    if [ -d "$DOTFILES_DIR/bin" ]; then
        chmod +x "$DOTFILES_DIR/bin"/*
    fi
    
    if [ -d "$DOTFILES_DIR/scripts" ]; then
        chmod +x "$DOTFILES_DIR/scripts"/*
    fi
    
    echo -e "\n${GREEN}🎉 Dotfiles installation completed!${NC}"
    echo -e "${YELLOW}📝 Please restart your terminal or run 'source ~/.zshrc' to apply changes.${NC}"
    
    # Optional: Set zsh as default shell
    if [ "$SHELL" != "$(which zsh)" ]; then
        echo -e "\n${YELLOW}💡 Would you like to set zsh as your default shell? (y/n)${NC}"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            chsh -s "$(which zsh)"
            echo -e "${GREEN}✅ Default shell changed to zsh${NC}"
        fi
    fi
}

# Run the installation
main "$@"
