#!/bin/bash

# Final test of terminal closure fix
echo "🔧 Testing Terminal Closure Fix"
echo "==============================="

echo "ℹ️  This test will:"
echo "   1. Test the safe wal wrapper"
echo "   2. Test walupdate function"
echo "   3. Test setwal function"
echo "   4. Verify terminal stays open throughout"
echo ""

# Test 1: Safe wal wrapper
echo "Test 1: Safe wal wrapper"
echo "------------------------"
if ~/.config/wal/safe_wal.sh ~/Desktop/Screenshot\ 2025-07-27\ at\ 08.46.32.png; then
    echo "✅ Safe wrapper test passed"
else
    echo "❌ Safe wrapper test failed"
fi
echo ""

# Test 2: Check if sequences were generated
echo "Test 2: Color sequences"
echo "----------------------"
if [[ -f ~/.cache/wal/sequences ]]; then
    echo "✅ Color sequences exist"
    echo "📏 Sequences file size: $(wc -c < ~/.cache/wal/sequences) bytes"
else
    echo "❌ No color sequences found"
fi
echo ""

# Test 3: iTerm2 integration
echo "Test 3: iTerm2 integration"
echo "--------------------------"
if python3 ~/.config/wal/scripts/update_iterm2.py 2>/dev/null; then
    echo "✅ iTerm2 integration working"
else
    echo "❌ iTerm2 integration failed"
fi
echo ""

echo "🎯 Manual Test Instructions:"
echo "============================"
echo "1. Open a NEW terminal window"
echo "2. Run: walupdate"
echo "3. Verify terminal DOES NOT close"
echo "4. Run: setwal ~/Desktop/Screenshot\\ 2025-07-27\\ at\\ 08.46.32.png"
echo "5. Verify terminal DOES NOT close"
echo ""
echo "🔍 What to Look For:"
echo "   ✅ Clean output without '^[[' sequences"
echo "   ✅ Terminal stays open"
echo "   ✅ Colors change properly"
echo "   ✅ No 'Reloaded environment' message"
echo ""
echo "❗ If terminal still closes, the issue may be in iTerm2 configuration"
echo "   or a deeper shell environment problem."
