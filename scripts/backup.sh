#!/bin/bash

# Backup current dotfiles before installation
# Usage: ./scripts/backup.sh

BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
echo "Creating backup directory: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# List of files to backup
files=(
    "$HOME/.zshrc"
    "$HOME/.zshenv" 
    "$HOME/.profile"
    "$HOME/.p10k.zsh"
    "$HOME/.gitconfig"
    "$HOME/.vimrc"
    "$HOME/.tmux.conf"
)

echo "Backing up existing dotfiles..."
for file in "${files[@]}"; do
    if [ -f "$file" ] || [ -L "$file" ]; then
        echo "Backing up: $file"
        cp -L "$file" "$BACKUP_DIR/" 2>/dev/null || true
    fi
done

# Backup config directories
config_dirs=(
    "$HOME/.config/git"
    "$HOME/.config/wal"
)

for dir in "${config_dirs[@]}"; do
    if [ -d "$dir" ]; then
        echo "Backing up directory: $dir"
        cp -r "$dir" "$BACKUP_DIR/" 2>/dev/null || true
    fi
done

echo "Backup completed: $BACKUP_DIR"
