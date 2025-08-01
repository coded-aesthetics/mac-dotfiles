#!/bin/bash

# Fix zshrc by removing iTerm2 references and fixing color loading

# Create backup
cp zsh/zshrc zsh/zshrc.backup.$(date +%Y%m%d_%H%M%S)

# Create new zshrc with fixes
cat zsh/zshrc | \
# Replace the update-terminal-colors function
sed '/^function update-terminal-colors()/,/^}$/{
/^function update-terminal-colors()/c\
function update-terminal-colors() {\
    echo "Updating terminal colors..."\
\
    if [[ "$TERM" == "xterm-kitty" ]] || [[ -n "$KITTY_WINDOW_ID" ]] || command -v kitty >/dev/null 2>&1; then\
        python3 "$HOME/.config/wal/scripts/update_kitty.py" 2>/dev/null\
        echo "✅ Updated kitty colors"\
    else\
        echo "❓ Kitty not detected, colors available in ~/.cache/wal/"\
    fi\
}
/^function update-terminal-colors()/!d
}' | \
# Fix terminal-info function
sed '/^function terminal-info()/,/^}$/{
s/ITERM_SESSION_ID: $ITERM_SESSION_ID//
s/echo "🖥️  Running in iTerm2"//
/if.*ITERM_SESSION_ID/,/elif.*KITTY_WINDOW_ID/{
/if.*ITERM_SESSION_ID/d
/echo.*iTerm2/d
s/elif/if/
}
}' | \
# Remove any remaining iTerm2 references but keep the structure
sed 's/Running in iTerm2/Terminal not specifically detected/' | \
sed '/iTerm2/d' | \
sed '/ITERM_SESSION_ID/d' | \
sed '/update_iterm2.py/d' > zsh/zshrc.tmp

mv zsh/zshrc.tmp zsh/zshrc
