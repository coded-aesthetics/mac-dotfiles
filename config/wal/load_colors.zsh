#!/bin/zsh

# Pywal color initialization for zsh
# This script loads pywal colors without producing console output

# Only proceed if pywal cache exists
if [[ ! -f ~/.cache/wal/sequences ]]; then
    return
fi

# Load colors silently
if [[ -f ~/.cache/wal/sequences ]]; then
    cat ~/.cache/wal/sequences 2>/dev/null
fi

# Source color variables
if [[ -f ~/.cache/wal/colors-tty.sh ]]; then
    source ~/.cache/wal/colors-tty.sh 2>/dev/null
fi

if [[ -f ~/.cache/wal/colors.sh ]]; then
    source ~/.cache/wal/colors.sh 2>/dev/null
fi
