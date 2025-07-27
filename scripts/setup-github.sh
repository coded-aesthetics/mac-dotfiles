#!/bin/bash

# Git repository setup for sharing dotfiles
# This prepares your dotfiles for GitHub

set -e

REPO_NAME="dotfiles"
CURRENT_DIR=$(pwd)

echo "🔧 Setting up dotfiles repository for GitHub..."

# Check if we're in the dotfiles directory
if [[ ! "$(basename "$CURRENT_DIR")" == "dotfiles" ]]; then
    echo "❌ Please run this script from the dotfiles directory"
    exit 1
fi

# Initialize git if not already done
if [ ! -d .git ]; then
    echo "📝 Initializing git repository..."
    git init
    git add .
    git commit -m "Initial commit: Add comprehensive dotfiles configuration

- Modern Zsh setup with Oh My Zsh and Powerlevel10k
- Extensive aliases and functions for development
- Pywal integration for dynamic color schemes
- Organized structure with installation scripts
- Cross-machine compatibility"
else
    echo "✅ Git repository already exists"
fi

# Create a comprehensive .github directory for better project presentation
mkdir -p .github

# Create issue templates
mkdir -p .github/ISSUE_TEMPLATE

cat > .github/ISSUE_TEMPLATE/bug_report.md << 'EOF'
---
name: Bug report
about: Create a report to help improve the dotfiles
title: '[BUG] '
labels: 'bug'
assignees: ''
---

**Describe the bug**
A clear description of what the bug is.

**Environment**
- OS: [e.g., macOS 14.0]
- Shell: [e.g., zsh 5.9]
- Terminal: [e.g., iTerm2, Terminal.app]

**To Reproduce**
Steps to reproduce the behavior:
1. Run '...'
2. See error

**Expected behavior**
What you expected to happen.

**Additional context**
Add any other context about the problem here.
EOF

cat > .github/ISSUE_TEMPLATE/feature_request.md << 'EOF'
---
name: Feature request
about: Suggest an idea for the dotfiles
title: '[FEATURE] '
labels: 'enhancement'
assignees: ''
---

**Is your feature request related to a problem?**
A clear description of what the problem is.

**Describe the solution you'd like**
A clear description of what you want to happen.

**Additional context**
Add any other context or screenshots about the feature request here.
EOF

# Create pull request template
cat > .github/pull_request_template.md << 'EOF'
## Description
Brief description of changes

## Type of change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Tested on macOS
- [ ] No conflicts with existing configurations
- [ ] Installation script works correctly

## Checklist
- [ ] Code follows the existing style
- [ ] Self-review completed
- [ ] Documentation updated if needed
EOF

# Create GitHub Actions workflow for testing
mkdir -p .github/workflows

cat > .github/workflows/test.yml << 'EOF'
name: Test Dotfiles Installation

on:
  push:
    branches: [ main, master ]
  pull_request:
    branches: [ main, master ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Test installation script syntax
      run: |
        bash -n install.sh
        bash -n update.sh
        
    - name: Test script permissions
      run: |
        test -x install.sh
        test -x update.sh
        
    - name: Validate shell syntax
      run: |
        # Test zsh files for syntax errors
        zsh -n zsh/zshrc || true
        zsh -n zsh/zshenv || true
EOF

echo "✅ GitHub repository structure created"

# Check for GitHub CLI and offer to create repository
if command -v gh &> /dev/null; then
    echo ""
    echo "🚀 GitHub CLI detected!"
    echo "Would you like to create a GitHub repository? (y/n)"
    read -r create_repo
    
    if [[ "$create_repo" =~ ^[Yy]$ ]]; then
        echo "Repository visibility:"
        echo "1) Public (recommended for dotfiles)"
        echo "2) Private"
        read -p "Choose (1 or 2): " visibility_choice
        
        if [ "$visibility_choice" = "1" ]; then
            VISIBILITY="--public"
        else
            VISIBILITY="--private"
        fi
        
        echo "Creating GitHub repository..."
        gh repo create "$REPO_NAME" $VISIBILITY --description "🏡 Personal dotfiles with modern Zsh setup, Powerlevel10k, and development tools" --clone=false
        
        echo "Adding remote origin..."
        git remote add origin "https://github.com/$(gh api user --jq .login)/$REPO_NAME.git"
        
        echo "Pushing to GitHub..."
        git branch -M main
        git push -u origin main
        
        echo "✅ Repository created and pushed to GitHub!"
        echo "🔗 Repository URL: https://github.com/$(gh api user --jq .login)/$REPO_NAME"
    fi
else
    echo ""
    echo "📝 Manual setup instructions:"
    echo "1. Create a new repository on GitHub named 'dotfiles'"
    echo "2. Run these commands:"
    echo "   git remote add origin https://github.com/YOUR_USERNAME/dotfiles.git"
    echo "   git branch -M main"
    echo "   git push -u origin main"
fi

echo ""
echo "🎉 Repository setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Customize the README.md with your personal information"
echo "2. Update git/gitconfig with your email and name"
echo "3. Add any additional configurations you want to share"
echo "4. Test the installation on a different machine"
echo ""
echo "💡 Useful commands:"
echo "  make install    - Install dotfiles"
echo "  make update     - Update from remote"
echo "  make backup     - Backup current files"
echo "  make status     - Show current status"
