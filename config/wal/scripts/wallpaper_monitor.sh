#!/bin/bash

# Wallpaper monitor script for automatic pywal updates
# This script monitors the desktop wallpaper and updates pywal colors when it changes

SCRIPT_NAME="wallpaper_monitor"
LOG_FILE="$HOME/.cache/wal/monitor.log"
LAST_WALLPAPER_FILE="$HOME/.cache/wal/last_wallpaper"

# Create cache directory if it doesn't exist
mkdir -p "$(dirname "$LOG_FILE")"

# Function to get current wallpaper
get_current_wallpaper() {
    osascript -e 'tell application "Finder" to get POSIX path of (get desktop picture as alias)' 2>/dev/null
}

# Function to log with timestamp
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Function to update pywal colors
update_pywal() {
    local wallpaper="$1"
    log_message "Updating pywal colors for: $wallpaper"
    
    # Run pywal
    "$HOME/Library/Python/3.9/bin/wal" -i "$wallpaper" -q
    
    # Update iTerm2
    "$HOME/.config/wal/scripts/iterm2.sh" &>/dev/null
    
    # Store the current wallpaper
    echo "$wallpaper" > "$LAST_WALLPAPER_FILE"
    
    log_message "Pywal colors updated successfully"
}

# Main monitoring loop
main() {
    log_message "Starting wallpaper monitor"
    
    # Get initial wallpaper
    local current_wallpaper
    current_wallpaper=$(get_current_wallpaper)
    
    # If we have a previous wallpaper record, compare
    if [ -f "$LAST_WALLPAPER_FILE" ]; then
        local last_wallpaper
        last_wallpaper=$(cat "$LAST_WALLPAPER_FILE")
        
        if [ "$current_wallpaper" != "$last_wallpaper" ]; then
            log_message "Wallpaper changed from '$last_wallpaper' to '$current_wallpaper'"
            update_pywal "$current_wallpaper"
        fi
    else
        # First run, just update
        update_pywal "$current_wallpaper"
    fi
    
    # Monitor for changes (check every 5 seconds)
    while true; do
        sleep 5
        
        local new_wallpaper
        new_wallpaper=$(get_current_wallpaper)
        
        if [ "$new_wallpaper" != "$current_wallpaper" ] && [ -n "$new_wallpaper" ]; then
            log_message "Wallpaper changed from '$current_wallpaper' to '$new_wallpaper'"
            update_pywal "$new_wallpaper"
            current_wallpaper="$new_wallpaper"
        fi
    done
}

# Handle script termination
cleanup() {
    log_message "Wallpaper monitor stopped"
    exit 0
}

trap cleanup SIGINT SIGTERM

# Check if already running
if pgrep -f "$SCRIPT_NAME" > /dev/null; then
    echo "Wallpaper monitor is already running"
    exit 1
fi

# Start monitoring
main
