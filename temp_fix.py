#!/usr/bin/env python3

with open('zsh/zshrc', 'r') as f:
    content = f.read()

# Fix update-terminal-colors function
old_function = '''function update-terminal-colors() {
    echo "Updating terminal colors..."

    if [[ "$TERM_PROGRAM" == "iTerm.app" ]] || [[ -n "$ITERM_SESSION_ID" ]]; then
        python3 "$HOME/.config/wal/scripts/update_iterm2.py" 2>/dev/null
        echo "✅ Updated iTerm2 colors"
    elif [[ "$TERM" == "xterm-kitty" ]] || [[ -n "$KITTY_WINDOW_ID" ]]; then
        python3 "$HOME/.config/wal/scripts/update_kitty.py" 2>/dev/null
        echo "✅ Updated kitty colors"
    else
        echo "❓ Terminal not detected, trying both..."
        python3 "$HOME/.config/wal/scripts/update_iterm2.py" 2>/dev/null
        python3 "$HOME/.config/wal/scripts/update_kitty.py" 2>/dev/null
        echo "✅ Updated colors for available terminals"
    fi
}'''

new_function = '''function update-terminal-colors() {
    echo "Updating terminal colors..."

    if [[ "$TERM" == "xterm-kitty" ]] || [[ -n "$KITTY_WINDOW_ID" ]] || command -v kitty >/dev/null 2>&1; then
        python3 "$HOME/.config/wal/scripts/update_kitty.py" 2>/dev/null
        echo "✅ Updated kitty colors"
    else
        echo "❓ Kitty not detected, colors available in ~/.cache/wal/"
    fi
}'''

content = content.replace(old_function, new_function)

# Remove color loading hook that may be causing conflicts
old_hook = '''# Apply wallust colors after initialization (deferred loading)
if [[ -f ~/.cache/wal/colors.sh ]]; then
    # Schedule color loading after prompt is ready
    autoload -U add-zsh-hook

    # Function to load colors after first prompt
    _load_wallust_colors() {
        source ~/.cache/wal/colors.sh

        # Also load kitty colors if running in kitty
        if [[ -f ~/.config/wal/load_kitty_colors.zsh ]]; then
            source ~/.config/wal/load_kitty_colors.zsh
        fi

        # Clean up hook after first run
        add-zsh-hook -d precmd _load_wallust_colors
    }

    # Set up hook to load colors after first prompt
    add-zsh-hook precmd _load_wallust_colors
fi'''

new_hook = '''# Apply wallust colors - simplified loading without hooks
if [[ -f ~/.cache/wal/colors.sh ]]; then
    source ~/.cache/wal/colors.sh
fi'''

content = content.replace(old_hook, new_hook)

# Write the fixed content
with open('zsh/zshrc', 'w') as f:
    f.write(content)

print("✅ Fixed zshrc - removed iTerm2 references and color loading conflicts")
