# 🏡 Jan's Dotfiles

A comprehensive and well-organized collection of my personal dotfiles for macOS, featuring a modern terminal setup with Zsh, Oh My Zsh, Powerlevel10k, and extensive customizations.

## ✨ Features

- **Modern Zsh Setup**: Optimized Zsh configuration with Oh My Zsh
- **Beautiful Terminal**: Powerlevel10k theme with custom styling
- **Rich Aliases & Functions**: 200+ useful aliases and functions for development
- **Developer Tools**: Optimized for Node.js, Python, Go, Docker, Kubernetes, Git, and more
- **Color Theming**: Pywal integration for dynamic color schemes
- **Auto-completion**: Enhanced tab completion and command suggestions
- **Easy Installation**: One-command setup with symlink management
- **Modular Structure**: Organized and maintainable configuration files

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles

# Run the installation script
cd ~/dotfiles
./install.sh

# Restart your terminal or source the config
source ~/.zshrc
```

## 📁 Structure

```
dotfiles/
├── install.sh              # Main installation script
├── update.sh               # Update script for pulling latest changes
├── README.md               # This file
├── zsh/                    # Zsh configuration files
│   ├── zshrc              # Main Zsh configuration
│   ├── zshenv             # Zsh environment variables
│   ├── p10k.zsh           # Powerlevel10k configuration
│   └── profile            # Profile configuration
├── config/                 # Application configurations
│   └── wal/               # Pywal color scheme configurations
├── bin/                    # Custom executable scripts
├── scripts/               # Utility scripts
└── git/                   # Git configuration (if applicable)
```

## 🛠 What's Included

### Zsh Configuration
- **Oh My Zsh**: Popular Zsh framework with extensive plugin support
- **Powerlevel10k**: Fast and customizable prompt theme
- **Smart Plugins**: Auto-suggestions, syntax highlighting, and more
- **History Management**: Advanced history settings with deduplication

### Aliases & Functions

#### Git Workflow
```bash
gs          # git status
gaa         # git add --all
gcm         # git commit -m
gp          # git push
gpl         # git pull
gl          # git log with graph
gco         # git checkout
gcb         # git checkout -b
qcommit     # Quick add, commit with message
qpush       # Quick add, commit, and push
```

#### Development Tools
```bash
serve       # Start HTTP server on port 8000
myip        # Get external IP address
localip     # Get local IP address
ports       # Show listening ports
reload      # Reload Zsh configuration
```

#### Modern CLI Tools
- **bat** instead of cat (syntax highlighting)
- **exa** instead of ls (better file listing)
- **fd** instead of find (faster file searching)
- **rg** instead of grep (faster text searching)
- **htop** instead of top (better process viewer)

#### Docker & Kubernetes
```bash
d           # docker
dc          # docker-compose
k           # kubectl
kgp         # kubectl get pods
kgs         # kubectl get services
```

#### System Utilities
```bash
mkcd        # Create directory and cd into it
backup      # Create .bak copy of file
extract     # Extract any archive format
ff          # Find files by name
ftext       # Search text in files
```

### Color Theming
- **Pywal Integration**: Dynamic color schemes based on wallpapers
- **Terminal Colors**: Automatic terminal color updating
- **Kitty Support**: Modern terminal with MesloLGLDZ Nerd Font integration
- **Smart Cursor**: Intelligent cursor visibility fixes

## 🔧 Installation Details

The installation script will:

1. **Install Dependencies**:
   - Oh My Zsh framework
   - Powerlevel10k theme
   - Useful Zsh plugins (autosuggestions, syntax highlighting)

2. **Create Symlinks**:
   - Links dotfiles to appropriate locations
   - Backs up existing files with timestamps
   - Maintains directory structure

3. **Set Permissions**:
   - Makes scripts executable
   - Sets up proper file permissions

4. **Optional Setup**:
   - Offers to set Zsh as default shell
   - Configures additional tools if needed

## 🔄 Updating

To update your dotfiles with the latest changes:

```bash
cd ~/dotfiles
./update.sh
```

Or manually:

```bash
cd ~/dotfiles
git pull origin main
./install.sh
```

## 🎨 Customization

### Adding Your Own Configurations

1. **Custom Aliases**: Add to `zsh/zshrc` in the appropriate section
2. **Environment Variables**: Add to `zsh/zshenv`
3. **Functions**: Add to `zsh/zshrc` in the functions section
4. **App Configs**: Place in `config/` directory

### Local Customizations

Create a `~/.zshrc.local` file for machine-specific customizations that won't be tracked in git:

```bash
# ~/.zshrc.local
export WORK_EMAIL="your.work@email.com"
alias work="cd ~/work/projects"
```

## 🧰 Recommended Tools

These tools work great with this configuration:

### Essential CLI Tools
```bash
# Install via Homebrew
brew install bat exa fd ripgrep htop dust duf
brew install git gh fzf tree jq
brew install node python3 go
brew install docker kubectl helm
```

### Terminal & Editor
- **Kitty**: GPU-accelerated terminal with font ligatures
- **Zed**: Modern code editor (configured as default)
- **VS Code**: Alternative editor with excellent extensions

### Fonts
Install a Nerd Font for proper icon display:
```bash
brew tap homebrew/cask-fonts
brew install font-meslo-lg-nerd-font
```

## 🔐 Security & Privacy

- No sensitive information is stored in these dotfiles
- All configurations are safe to share publicly
- Local customizations should go in `.local` files
- API keys and tokens should use environment variables

## 🐛 Troubleshooting

### Common Issues

**Zsh not loading properly:**
```bash
# Reset Zsh configuration
mv ~/.zshrc ~/.zshrc.backup
source ~/dotfiles/install.sh
```

**Powerlevel10k not showing correctly:**
```bash
# Reconfigure Powerlevel10k
p10k configure
```

**Icons not displaying:**
- Install a Nerd Font
- Set your terminal to use the Nerd Font
- Restart your terminal

**Pywal colors not working:**
```bash
# Check pywal installation
pip3 install pywal
# Run configuration wizard
p10k configure
```

## 📜 License

This project is open source and available under the [MIT License](LICENSE).

## 🤝 Contributing

Feel free to fork this repository and customize it for your own use! If you have improvements or cool features to add, pull requests are welcome.

## 🙏 Credits

This configuration is built on the shoulders of giants:

- [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) - Zsh framework
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) - Terminal theme
- [Pywal](https://github.com/dylanaraps/pywal) - Color scheme generator
- Various plugin authors and the open source community

---

**Happy coding!** 🚀
