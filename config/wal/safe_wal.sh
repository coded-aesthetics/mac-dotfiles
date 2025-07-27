#!/bin/bash

# Ultra-safe pywal wrapper
# This prevents terminal closure by controlling pywal execution environment

# Set safe execution environment
export TERM=xterm-256color
unset TMUX
unset SCREEN

# Function to run wal safely
safe_wal() {
    local image_path="$1"
    local extra_args="$2"
    
    echo "🎨 Generating colors safely..."
    
    # Create a subshell to isolate the execution
    (
        # Prevent environment reloading
        export WAL_SKIP_RELOAD=1
        
        # Run wal with controlled output
        "$HOME/Library/Python/3.9/bin/wal" \
            --backend colorz \
            -i "$image_path" \
            -n \
            --saturate 0.8 \
            $extra_args 2>&1 | grep -E "(Using image|Set theme|Found cached|Generated|Exported)" | head -10
    )
    
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        echo "✅ Colors generated successfully"
        return 0
    else
        echo "❌ Color generation failed"
        return 1
    fi
}

# Main execution
if [ $# -eq 0 ]; then
    echo "Usage: $0 <image_path> [extra_args]"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "❌ Image file not found: $1"
    exit 1
fi

# Run the safe wal function
if safe_wal "$1" "$2"; then
    echo "🎉 Process completed safely"
else
    echo "❌ Process failed"
    exit 1
fi
