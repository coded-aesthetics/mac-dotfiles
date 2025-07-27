#!/bin/bash

# Test the integrated cursor fix

echo "🧪 Testing Integrated Cursor Fix"
echo "================================"

echo "📋 Testing walcursor function..."
if zsh -c 'source ~/.zshrc >/dev/null 2>&1 && walcursor'; then
    echo "✅ walcursor function works"
else
    echo "❌ walcursor function failed"
fi

echo ""
echo "📋 Testing walupdate with cursor fix..."
echo "This should:"
echo "1. Generate colors safely"
echo "2. Apply smart cursor fix"
echo "3. Show improved cursor visibility"
echo ""

# Let user decide to run the full test
echo "Run full walupdate test? (y/n)"
read -r response
if [[ "$response" == "y" || "$response" == "Y" ]]; then
    echo "Running walupdate..."
    zsh -c 'source ~/.zshrc >/dev/null 2>&1 && walupdate'
else
    echo "Skipped full test"
fi

echo ""
echo "📝 Manual Test Instructions:"
echo "============================"
echo "1. Open a new terminal"
echo "2. Run: walcursor"
echo "3. Open vim: vim ~/.zshrc"
echo "4. Check if cursor is visible"
echo "5. Try insert mode: press 'i'"
echo "6. Cursor should be clearly visible!"
