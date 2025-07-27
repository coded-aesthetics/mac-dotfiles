# 🚀 Quick Start Guide

## For New Users

### 1. First Time Setup
```bash
# Clone your dotfiles repository
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install everything
make install

# Restart your terminal
# Your new shell setup is ready!
```

### 2. What Just Happened?
- ✅ Oh My Zsh installed with optimized configuration
- ✅ Powerlevel10k theme with beautiful prompts
- ✅ 200+ useful aliases and functions
- ✅ Development tools integration (Git, Docker, Node.js, etc.)
- ✅ Modern CLI tools integration (bat, exa, ripgrep, etc.)
- ✅ Pywal color theming system
- ✅ All your config files are now symlinked

## For Existing Dotfiles Users

### Migrating Your Current Setup
```bash
# Backup your current dotfiles
make backup

# Install the new setup
make install

# Check everything is working
make health-check
```

## Essential Commands

### Daily Usage
```bash
# Update dotfiles from GitHub
make update

# Check if everything is working correctly
make health-check

# See current status of symlinks and git
make status
```

### Development Workflow
```bash
# Git shortcuts (examples from 200+ aliases)
gs              # git status
gaa             # git add --all
gcm "message"   # git commit -m "message"
qpush "fix"     # add all, commit, and push in one command

# Docker shortcuts
d ps            # docker ps
dc up           # docker-compose up
k get pods      # kubectl get pods

# Navigation
mkcd new-project    # create directory and cd into it
..                  # cd ..
...                 # cd ../..

# Modern CLI tools
cat file.json       # uses bat (syntax highlighting)
ls                  # uses exa (better output)
find . -name "*.js" # uses fd (faster)
grep "text" files   # uses ripgrep (faster)
```

### Color Theming
```bash
# Set wallpaper and generate color scheme
setwal ~/Pictures/wallpaper.jpg

# Random wallpaper from Pictures
setwal random

# Update colors from current wallpaper
walupdate

# Fix cursor visibility if needed
walcursor

# Control iTerm2 transparency
waltransparency 0.3
```

## Customization

### Adding Your Own Aliases
Edit `~/dotfiles/zsh/zshrc` and add to the aliases section:
```bash
# My custom aliases
alias myproject="cd ~/Development/my-project"
alias serve-local="python3 -m http.server 3000"
```

### Machine-Specific Settings
Create `~/.zshrc.local` for settings that shouldn't be in git:
```bash
# Work-specific settings
export COMPANY_API_KEY="secret-key"
alias work="cd ~/work/projects"
```

### Adding New Tools
1. Add installation to `scripts/setup-macos.sh`
2. Add aliases/configuration to `zsh/zshrc`
3. Update documentation

## Troubleshooting

### Common Issues

**Zsh not loading properly:**
```bash
make clean
make install
source ~/.zshrc
```

**Missing symlinks:**
```bash
make health-check
# Shows what's broken and how to fix it
```

**Powerlevel10k not working:**
```bash
# Install required font
brew install font-meslo-lg-nerd-font
# Set terminal to use the font
# Run configuration wizard
p10k configure
```

**Colors not working:**
```bash
# Install pywal
pip3 install pywal
# Set initial wallpaper
setwal ~/Pictures/some-image.jpg
```

### Getting Help

1. **Health Check**: `make health-check` - diagnoses issues
2. **Status Check**: `make status` - shows current setup
3. **Clean Install**: `make clean && make install` - fresh start
4. **Backup**: `make backup` - saves current configs before changes

## Advanced Usage

### For Multiple Machines
```bash
# Different configs per machine
# Add to ~/.zshrc.local on each machine:

# Work laptop
if [[ $(hostname) == "work-laptop" ]]; then
    export WORK_MODE=true
    alias deploy="kubectl apply -f"
fi

# Personal desktop
if [[ $(hostname) == "personal-desktop" ]]; then
    export PERSONAL_MODE=true
    alias gamemode="sudo performance-mode on"
fi
```

### Custom Functions
Add to `zsh/zshrc`:
```bash
# Custom function example
function project() {
    local name=$1
    mkcd ~/Development/$name
    git init
    echo "# $name" > README.md
    git add . && git commit -m "Initial commit"
}
```

### Environment Management
```bash
# Python virtual environments
mkcd my-python-project
python3 -m venv venv
activate  # alias for source venv/bin/activate

# Node.js projects
npm init -y
ni express  # alias for npm install express
nr dev      # alias for npm run dev
```

## Sharing Your Dotfiles

### Preparing for GitHub
```bash
# Setup git repository and GitHub integration
./scripts/setup-github.sh

# Creates:
# - Git repository with proper structure
# - GitHub templates and workflows
# - Offers to create GitHub repo automatically
```

### Keeping Updated
```bash
# Regular maintenance
git add .
git commit -m "Update configurations"
git push

# On other machines
make update  # pulls changes and reinstalls
```

---

**Happy coding with your new development environment!** 🎉

For more details, see the main [README.md](README.md) file.
