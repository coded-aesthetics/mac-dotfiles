#!/bin/bash

# ⚠️  DEPRECATED: This script is no longer needed after migration to wallust
# Wallust doesn't have kitty detection issues that required these workarounds
# See WALLUST_MIGRATION.md for details
#
# Legacy: Alternative approach: Temporarily hide kitty binary from pywal
# This script renames the kitty binary during pywal execution to prevent detection

echo "⚠️  DEPRECATED: hide_kitty_pywal.sh is no longer needed"
echo "   Wallust has replaced pywal and doesn't require kitty detection workarounds"
echo "   Use 'setwal' command instead, which now uses wallust internally"
echo ""

set -e

# Function to log messages
log() {
    echo "🔧 [hide_kitty] $1"
}

# Function to find kitty binary
find_kitty() {
    # Common kitty installation paths on macOS
    local kitty_paths=(
        "/Applications/kitty.app/Contents/MacOS/kitty"
        "/usr/local/bin/kitty"
        "/opt/homebrew/bin/kitty"
        "$(which kitty 2>/dev/null || true)"
    )

    for path in "${kitty_paths[@]}"; do
        if [[ -n "$path" && -x "$path" ]]; then
            echo "$path"
            return 0
        fi
    done

    return 1
}

# Find kitty binary
KITTY_PATH=$(find_kitty)
KITTY_HIDDEN=false

if [[ -n "$KITTY_PATH" && -x "$KITTY_PATH" ]]; then
    log "Found kitty at: $KITTY_PATH"

    # Create backup name
    KITTY_BACKUP="${KITTY_PATH}.pywal_backup"

    # Hide kitty by renaming it
    if mv "$KITTY_PATH" "$KITTY_BACKUP" 2>/dev/null; then
        log "Temporarily hidden kitty binary"
        KITTY_HIDDEN=true
    else
        log "Could not hide kitty binary (permission issue), proceeding anyway..."
    fi
fi

# Cleanup function to restore kitty
cleanup() {
    if [[ "$KITTY_HIDDEN" == "true" && -f "$KITTY_BACKUP" ]]; then
        mv "$KITTY_BACKUP" "$KITTY_PATH" 2>/dev/null || true
        log "Restored kitty binary"
    fi
}

# Set up cleanup trap
trap cleanup EXIT

# Also hide kitty from environment
ORIGINAL_KITTY_WINDOW_ID="$KITTY_WINDOW_ID"
ORIGINAL_TERM="$TERM"

# Modify environment to prevent kitty detection
if [[ "$TERM" == "xterm-kitty" ]]; then
    export TERM="xterm-256color"
fi

unset KITTY_WINDOW_ID
unset KITTY_PID
unset KITTY_PUBLIC_KEY
unset KITTY_LISTEN_ON

log "Running pywal with kitty completely hidden..."

# Run pywal with all provided arguments
wal "$@"
exit_code=$?

# Restore environment
export TERM="$ORIGINAL_TERM"
if [[ -n "$ORIGINAL_KITTY_WINDOW_ID" ]]; then
    export KITTY_WINDOW_ID="$ORIGINAL_KITTY_WINDOW_ID"
fi

if [ $exit_code -eq 0 ]; then
    log "Pywal completed successfully"
else
    log "Pywal failed with exit code $exit_code"
fi

exit $exit_code
