#!/bin/bash

# System setup script for new macOS installations
# This installs essential tools and applications

set -e

echo "🍺 Installing Homebrew..."
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "✅ Homebrew already installed"
fi

echo "📦 Installing essential CLI tools..."
brew install \
    git \
    curl \
    wget \
    tree \
    jq \
    bat \
    exa \
    fd \
    ripgrep \
    htop \
    dust \
    duf \
    fzf \
    fastfetch \
    volta \
    gh \
    node \
    python3 \
    go \
    rust

echo "🐳 Installing development tools..."
brew install docker

echo "🎨 Installing fonts..."
brew tap homebrew/cask-fonts
brew install \
    font-meslo-lg-nerd-font \
    font-fira-code-nerd-font \
    font-hack-nerd-font

echo "📱 Installing applications..."
brew install --cask \
    kitty \
    zed \
    docker \
    insomnia \
    rectangle \
    alfred

echo "🎯 Installing Python packages..."
pip3 install \
    requests \
    virtualenv

echo "🔧 Setting up Git..."
if [ -z "$(git config --global user.name)" ]; then
    echo "Enter your Git username:"
    read -r git_username
    git config --global user.name "$git_username"
fi

if [ -z "$(git config --global user.email)" ]; then
    echo "Enter your Git email:"
    read -r git_email
    git config --global user.email "$git_email"
fi

echo "✅ System setup completed!"
echo "🔄 Please restart your terminal and run the dotfiles installation"
