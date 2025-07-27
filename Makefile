# Dotfiles Makefile
# Provides convenient commands for managing dotfiles

.PHONY: help install update backup clean test setup-macos health-check git-setup status

# Default target
help:
	@echo "🏡 Dotfiles Management"
	@echo "======================"
	@echo ""
	@echo "Available commands:"
	@echo "  make install      - Install dotfiles (create symlinks)"
	@echo "  make update       - Update dotfiles from remote repository"
	@echo "  make backup       - Backup current dotfiles"
	@echo "  make clean        - Remove symlinks and restore backups"
	@echo "  make test         - Test the installation in a safe way"
	@echo "  make setup-macos  - Install essential macOS tools and apps"
	@echo "  make health-check - Check dotfiles health and configuration"
	@echo "  make git-setup    - Initialize git repository for sharing"
	@echo ""

# Install dotfiles
install:
	@echo "🚀 Installing dotfiles..."
	@./install.sh

# Update dotfiles
update:
	@echo "🔄 Updating dotfiles..."
	@./update.sh

# Backup existing dotfiles
backup:
	@echo "💾 Creating backup..."
	@./scripts/backup.sh

# Clean installation (remove symlinks)
clean:
	@echo "🧹 Cleaning up symlinks..."
	@rm -f ~/.zshrc ~/.zshenv ~/.profile ~/.p10k.zsh
	@echo "✅ Symlinks removed"

# Test installation without making changes
test:
	@echo "🧪 Testing installation (dry run)..."
	@echo "This would create the following symlinks:"
	@echo "  ~/.zshrc -> $(PWD)/zsh/zshrc"
	@echo "  ~/.zshenv -> $(PWD)/zsh/zshenv"
	@echo "  ~/.profile -> $(PWD)/zsh/profile"
	@echo "  ~/.p10k.zsh -> $(PWD)/zsh/p10k.zsh"

# Setup macOS with essential tools
setup-macos:
	@echo "🍎 Setting up macOS..."
	@./scripts/setup-macos.sh

# Initialize git repository for sharing
git-setup:
	@echo "📝 Setting up git repository..."
	@if [ ! -d .git ]; then \
		git init; \
		git add .; \
		git commit -m "Initial commit: Add dotfiles configuration"; \
		echo "✅ Git repository initialized"; \
		echo "💡 Next steps:"; \
		echo "   1. Create a repository on GitHub"; \
		echo "   2. git remote add origin <your-repo-url>"; \
		echo "   3. git push -u origin main"; \
	else \
		echo "✅ Git repository already exists"; \
	fi

# Run health check
health-check:
	@echo "🔍 Running dotfiles health check..."
	@./scripts/health-check.sh

# Show current status
status:
	@echo "📊 Dotfiles Status"
	@echo "=================="
	@echo ""
	@echo "Symlinks:"
	@ls -la ~ | grep -E "\.(zshrc|zshenv|profile|p10k\.zsh)" | while read line; do \
		echo "  $line"; \
	done
	@echo ""
	@echo "Git status:"
	@if [ -d .git ]; then \
		git status --short; \
	else \
		echo "  Not a git repository"; \
	fi
