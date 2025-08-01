#!/bin/zsh
# Kitty color initialization - simplified 
if [[ "$TERM" == "xterm-kitty" || -n "$KITTY_WINDOW_ID" ]]; then
    if command -v kitty >/dev/null 2>&1; then
        kitty @ load-config 2>/dev/null || true
    fi
    export KITTY_PYWAL_ACTIVE=1
fi
