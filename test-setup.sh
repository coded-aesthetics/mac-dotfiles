#!/bin/bash

# Quick setup verification script
# Run this to test that everything is working

echo "🧪 Testing dotfiles setup..."

# Test that all files exist
required_files=(
    "install.sh"
    "update.sh"
    "Makefile"
    "README.md"
    ".gitignore"
    "zsh/zshrc"
    "zsh/zshenv"
    "zsh/p10k.zsh"
    "zsh/profile"
    "git/gitconfig"
)

missing_files=()

for file in "${required_files[@]}"; do
    if [[ ! -f "$file" ]]; then
        missing_files+=("$file")
    fi
done

if [[ ${#missing_files[@]} -eq 0 ]]; then
    echo "✅ All required files present"
else
    echo "❌ Missing files:"
    printf '  %s\n' "${missing_files[@]}"
fi

# Test script permissions
scripts=(
    "install.sh"
    "update.sh"
    "scripts/backup.sh"
    "scripts/setup-macos.sh"
    "scripts/setup-github.sh"
    "scripts/health-check.sh"
)

echo ""
echo "🔐 Checking script permissions..."

for script in "${scripts[@]}"; do
    if [[ -x "$script" ]]; then
        echo "✅ $script is executable"
    else
        echo "❌ $script is not executable"
    fi
done

echo ""
echo "📁 Directory structure:"
find . -type d | head -10 | sed 's|^\./||' | sed 's|^|  |'

echo ""
echo "📝 Ready for GitHub!"
echo "Run './scripts/setup-github.sh' to prepare for sharing"
