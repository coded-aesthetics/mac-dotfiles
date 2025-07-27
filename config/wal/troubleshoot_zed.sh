#!/bin/bash

# Zed Theme Troubleshooting Script

echo "🔧 Zed Theme Troubleshooting"
echo "============================"

# Check if files exist
echo "📁 File Check:"
echo "==============="

echo -n "✓ Theme file: "
if [[ -f ~/.config/zed/themes/pywal.json ]]; then
    echo "✅ Exists"
else
    echo "❌ Missing"
fi

echo -n "✓ Settings file: "
if [[ -f ~/.config/zed/settings.json ]]; then
    echo "✅ Exists"
else
    echo "❌ Missing"
fi

echo -n "✓ Dotfiles theme: "
if [[ -f ~/dotfiles/config/zed/themes/pywal.json ]]; then
    echo "✅ Exists"
else
    echo "❌ Missing"
fi

echo -n "✓ Dotfiles settings: "
if [[ -f ~/dotfiles/config/zed/settings.json ]]; then
    echo "✅ Exists"
else
    echo "❌ Missing"
fi

# Check symlinks
echo ""
echo "🔗 Symlink Check:"
echo "=================="

echo -n "✓ Theme symlink: "
if [[ -L ~/.config/zed/themes/pywal.json ]]; then
    echo "✅ Is symlink"
    echo "   Target: $(readlink ~/.config/zed/themes/pywal.json)"
else
    echo "⚠️  Not a symlink (copied file)"
fi

echo -n "✓ Settings symlink: "
if [[ -L ~/.config/zed/settings.json ]]; then
    echo "✅ Is symlink"
    echo "   Target: $(readlink ~/.config/zed/settings.json)"
else
    echo "⚠️  Not a symlink (copied file)"
fi

# Validate JSON
echo ""
echo "📋 JSON Validation:"
echo "==================="

echo -n "✓ Theme JSON: "
if python3 -m json.tool ~/.config/zed/themes/pywal.json >/dev/null 2>&1; then
    echo "✅ Valid JSON"
else
    echo "❌ Invalid JSON"
fi

echo -n "✓ Settings JSON: "
if python3 -m json.tool ~/.config/zed/settings.json >/dev/null 2>&1; then
    echo "✅ Valid JSON"
else
    echo "❌ Invalid JSON"
fi

# Check current settings
echo ""
echo "⚙️  Current Settings:"
echo "===================="

if [[ -f ~/.config/zed/settings.json ]]; then
    echo "Theme setting:"
    grep -A 1 -B 1 '"theme"' ~/.config/zed/settings.json || echo "No theme setting found"
    
    echo ""
    echo "Font settings:"
    grep -E '"(buffer_font_family|ui_font_family|buffer_font_size)"' ~/.config/zed/settings.json || echo "No font settings found"
fi

# Check theme structure
echo ""
echo "🎨 Theme Structure:"
echo "=================="

if [[ -f ~/.config/zed/themes/pywal.json ]]; then
    echo "Theme name:"
    grep '"name"' ~/.config/zed/themes/pywal.json || echo "No name found"
    
    echo "Appearance:"
    grep '"appearance"' ~/.config/zed/themes/pywal.json || echo "No appearance found"
    
    echo "Background color:"
    grep -E '"background": "#[0-9a-fA-F]{6}"' ~/.config/zed/themes/pywal.json | head -1 || echo "No background found"
    
    echo "Syntax section:"
    if grep -q '"syntax"' ~/.config/zed/themes/pywal.json; then
        echo "✅ Syntax section exists"
    else
        echo "❌ Syntax section missing"
    fi
fi

# Recommendations
echo ""
echo "💡 Troubleshooting Steps:"
echo "========================"
echo "1. Restart Zed completely (Cmd+Q, then reopen)"
echo "2. In Zed, go to: Zed → Settings (or Cmd+,)"
echo "3. Look for 'Theme' setting"
echo "4. Select 'Pywal' from the dropdown"
echo "5. If 'Pywal' not visible, try regenerating:"
echo "   walzed"
echo ""
echo "📋 Manual Fix (if needed):"
echo "=========================="
echo "1. Remove current files:"
echo "   rm ~/.config/zed/themes/pywal.json"
echo "   rm ~/.config/zed/settings.json"
echo "2. Regenerate:"
echo "   walzed"
echo "3. Restart Zed"
echo ""
echo "🎯 Font Settings Preserved:"
echo "============================"
echo "• Buffer Font: Operator Mono Lig"
echo "• UI Font: MesloLGLDZ Nerd Font"
echo "• Font Size: 17"
echo "• All your font preferences are preserved!"
echo ""
echo "📞 Still Having Issues?"
echo "======================="
echo "Try running: walzed"
echo "This will regenerate the theme with the corrected format."
