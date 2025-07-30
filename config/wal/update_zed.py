#!/usr/bin/env python3

# Zed Theme Generator for Pywal (Correct Schema v0.2.0)
# Generates a proper Zed theme family from pywal colors

import json
import os
from pathlib import Path

def hex_to_rgb(hex_color):
    """Convert hex color to RGB tuple (0-1 range)"""
    hex_color = hex_color.lstrip('#')
    return tuple(int(hex_color[i:i+2], 16) / 255.0 for i in (0, 2, 4))

def calculate_luminance(hex_color):
    """Calculate relative luminance of a color"""
    rgb = hex_to_rgb(hex_color)

    def linearize(c):
        if c <= 0.03928:
            return c / 12.92
        else:
            return pow((c + 0.055) / 1.055, 2.4)

    r, g, b = [linearize(c) for c in rgb]
    return 0.2126 * r + 0.7152 * g + 0.0722 * b

def adjust_color_brightness(hex_color, factor):
    """Adjust brightness of a color by factor (0.0-2.0)"""
    rgb = hex_to_rgb(hex_color)
    adjusted = tuple(min(1.0, max(0.0, c * factor)) for c in rgb)
    return '#{:02x}{:02x}{:02x}'.format(
        int(adjusted[0] * 255),
        int(adjusted[1] * 255),
        int(adjusted[2] * 255)
    )

def blend_colors(color1, color2, ratio=0.5):
    """Blend two colors together"""
    rgb1 = hex_to_rgb(color1)
    rgb2 = hex_to_rgb(color2)

    blended = tuple(
        rgb1[i] * (1 - ratio) + rgb2[i] * ratio
        for i in range(3)
    )

    return '#{:02x}{:02x}{:02x}'.format(
        int(blended[0] * 255),
        int(blended[1] * 255),
        int(blended[2] * 255)
    )

def create_zed_theme_family():
    """Create Zed theme family from pywal colors"""

    # Read pywal colors
    colors_file = os.path.expanduser("~/.cache/wal/colors.json")

    if not os.path.exists(colors_file):
        print("❌ No pywal colors found. Run 'walupdate' first.")
        return False

    with open(colors_file, 'r') as f:
        colors = json.load(f)

    # Extract key colors
    background = colors['special']['background']
    foreground = colors['special']['foreground']

    # Determine if theme is dark or light
    bg_luminance = calculate_luminance(background)
    is_dark = bg_luminance < 0.5
    appearance = "dark" if is_dark else "light"

    print(f"🎨 Creating {appearance} theme from wallpaper colors")
    print(f"   Background: {background}")
    print(f"   Foreground: {foreground}")

    # Smart color assignment for syntax highlighting
    color_palette = [colors['colors'][f'color{i}'] for i in range(16)]

    # Find best colors for different syntax elements
    def get_accent_color(index, fallback_brightness=1.2):
        """Get an accent color, adjusting brightness if needed"""
        if index < len(color_palette):
            color = color_palette[index]
            # Ensure good contrast with background
            color_lum = calculate_luminance(color)
            if abs(color_lum - bg_luminance) < 0.3:
                # Adjust brightness for better contrast
                factor = fallback_brightness if is_dark else 0.8
                return adjust_color_brightness(color, factor)
            return color
        return foreground

    # Create the theme family (proper Zed v0.2.0 format)
    theme_family = {
        "author": "Pywal Integration",
        "name": "Pywal",
        "themes": [
            {
                "name": "Pywal",
                "appearance": appearance,
                "style": {
                    # Basic colors
                    "background": background,
                    "text": foreground,
                    "text.muted": adjust_color_brightness(foreground, 0.7),
                    "text.placeholder": adjust_color_brightness(foreground, 0.5),
                    "text.disabled": adjust_color_brightness(foreground, 0.4),
                    "text.accent": get_accent_color(4),

                    # Icon colors
                    "icon": foreground,
                    "icon.muted": adjust_color_brightness(foreground, 0.6),
                    "icon.disabled": adjust_color_brightness(foreground, 0.4),
                    "icon.placeholder": adjust_color_brightness(foreground, 0.5),
                    "icon.accent": get_accent_color(4),

                    # Border colors
                    "border": adjust_color_brightness(foreground, 0.2),
                    "border.variant": adjust_color_brightness(foreground, 0.15),
                    "border.focused": get_accent_color(4),
                    "border.selected": get_accent_color(4),
                    "border.transparent": "#00000000",
                    "border.disabled": adjust_color_brightness(foreground, 0.1),

                    # Surface colors
                    "surface.background": background,
                    "elevated_surface.background": adjust_color_brightness(background, 1.05 if is_dark else 0.95),

                    # Element colors
                    "element.background": "transparent",
                    "element.hover": blend_colors(background, foreground, 0.1),
                    "element.active": blend_colors(background, get_accent_color(4), 0.2),
                    "element.selected": blend_colors(background, get_accent_color(4), 0.15),
                    "element.disabled": adjust_color_brightness(background, 0.9 if is_dark else 1.1),

                    # Ghost element (subtle interactive)
                    "ghost_element.background": "transparent",
                    "ghost_element.hover": blend_colors(background, foreground, 0.05),
                    "ghost_element.active": blend_colors(background, foreground, 0.1),
                    "ghost_element.selected": blend_colors(background, get_accent_color(4), 0.1),
                    "ghost_element.disabled": "transparent",

                    # Drop target
                    "drop_target.background": blend_colors(background, get_accent_color(4), 0.3),

                    # Status colors
                    "status_bar.background": adjust_color_brightness(background, 0.95 if is_dark else 1.05),
                    "title_bar.background": background,
                    "title_bar.inactive_background": adjust_color_brightness(background, 0.9 if is_dark else 1.1),
                    "toolbar.background": background,

                    # Panel
                    "panel.background": background,
                    "panel.focused_border": get_accent_color(4),

                    # Pane
                    "pane.focused_border": get_accent_color(4),
                    "pane_group.border": adjust_color_brightness(foreground, 0.2),

                    # Tab colors
                    "tab_bar.background": adjust_color_brightness(background, 0.95 if is_dark else 1.05),
                    "tab.inactive_background": "transparent",
                    "tab.active_background": background,

                    # Editor colors
                    "editor.background": background,
                    "editor.foreground": foreground,
                    "editor.gutter.background": background,
                    "editor.subheader.background": adjust_color_brightness(background, 0.95 if is_dark else 1.05),
                    "editor.active_line.background": blend_colors(background, foreground, 0.05),
                    "editor.highlighted_line.background": blend_colors(background, get_accent_color(3), 0.1),
                    "editor.line_number": adjust_color_brightness(foreground, 0.4),
                    "editor.active_line_number": foreground,
                    "editor.invisible": adjust_color_brightness(foreground, 0.3),
                    "editor.wrap_guide": adjust_color_brightness(foreground, 0.2),
                    "editor.active_wrap_guide": adjust_color_brightness(foreground, 0.4),
                    "editor.indent_guide": adjust_color_brightness(foreground, 0.2),
                    "editor.indent_guide_active": adjust_color_brightness(foreground, 0.4),
                    "editor.document_highlight.read_background": blend_colors(background, get_accent_color(3), 0.2),
                    "editor.document_highlight.write_background": blend_colors(background, get_accent_color(1), 0.2),
                    "editor.document_highlight.bracket_background": blend_colors(background, get_accent_color(4), 0.2),

                    # Terminal
                    "terminal.background": background,
                    "terminal.foreground": foreground,
                    "terminal.bright_foreground": foreground,
                    "terminal.dim_foreground": adjust_color_brightness(foreground, 0.7),
                    "terminal.ansi.background": background,
                    "terminal.ansi.black": color_palette[0],
                    "terminal.ansi.red": color_palette[1],
                    "terminal.ansi.green": color_palette[2],
                    "terminal.ansi.yellow": color_palette[3],
                    "terminal.ansi.blue": color_palette[4],
                    "terminal.ansi.magenta": color_palette[5],
                    "terminal.ansi.cyan": color_palette[6],
                    "terminal.ansi.white": color_palette[7],
                    "terminal.ansi.bright_black": color_palette[8],
                    "terminal.ansi.bright_red": color_palette[9],
                    "terminal.ansi.bright_green": color_palette[10],
                    "terminal.ansi.bright_yellow": color_palette[11],
                    "terminal.ansi.bright_blue": color_palette[12],
                    "terminal.ansi.bright_magenta": color_palette[13],
                    "terminal.ansi.bright_cyan": color_palette[14],
                    "terminal.ansi.bright_white": color_palette[15],

                    # Search
                    "search.match_background": blend_colors(background, get_accent_color(3), 0.4),

                    # Scrollbar
                    "scrollbar.track.background": "transparent",
                    "scrollbar.track.border": "transparent",
                    "scrollbar.thumb.background": adjust_color_brightness(foreground, 0.3),
                    "scrollbar.thumb.border": "transparent",
                    "scrollbar.thumb.hover_background": adjust_color_brightness(foreground, 0.4),

                    # Status indicators
                    "success": get_accent_color(2),
                    "success.background": blend_colors(background, get_accent_color(2), 0.2),
                    "success.border": get_accent_color(2),

                    "warning": get_accent_color(3),
                    "warning.background": blend_colors(background, get_accent_color(3), 0.2),
                    "warning.border": get_accent_color(3),

                    "error": get_accent_color(1),
                    "error.background": blend_colors(background, get_accent_color(1), 0.2),
                    "error.border": get_accent_color(1),

                    "info": get_accent_color(4),
                    "info.background": blend_colors(background, get_accent_color(4), 0.2),
                    "info.border": get_accent_color(4),

                    "hint": adjust_color_brightness(foreground, 0.6),
                    "hint.background": blend_colors(background, foreground, 0.1),
                    "hint.border": adjust_color_brightness(foreground, 0.6),

                    # Git status colors
                    "created": get_accent_color(2),
                    "created.background": blend_colors(background, get_accent_color(2), 0.2),
                    "created.border": get_accent_color(2),

                    "modified": get_accent_color(3),
                    "modified.background": blend_colors(background, get_accent_color(3), 0.2),
                    "modified.border": get_accent_color(3),

                    "deleted": get_accent_color(1),
                    "deleted.background": blend_colors(background, get_accent_color(1), 0.2),
                    "deleted.border": get_accent_color(1),

                    "renamed": get_accent_color(4),
                    "renamed.background": blend_colors(background, get_accent_color(4), 0.2),
                    "renamed.border": get_accent_color(4),

                    "conflict": get_accent_color(5),
                    "conflict.background": blend_colors(background, get_accent_color(5), 0.2),
                    "conflict.border": get_accent_color(5),

                    "ignored": adjust_color_brightness(foreground, 0.5),
                    "ignored.background": blend_colors(background, foreground, 0.05),
                    "ignored.border": adjust_color_brightness(foreground, 0.5),

                    "hidden": adjust_color_brightness(foreground, 0.4),
                    "hidden.background": "transparent",
                    "hidden.border": adjust_color_brightness(foreground, 0.4),

                    "predictive": adjust_color_brightness(foreground, 0.5),
                    "predictive.background": blend_colors(background, foreground, 0.05),
                    "predictive.border": adjust_color_brightness(foreground, 0.5),

                    "unreachable": adjust_color_brightness(foreground, 0.3),
                    "unreachable.background": adjust_color_brightness(background, 0.8 if is_dark else 1.2),
                    "unreachable.border": adjust_color_brightness(foreground, 0.3),

                    # Link colors
                    "link_text.hover": get_accent_color(4),

                    # Syntax highlighting (proper v0.2.0 format)
                    "syntax": {
                        # Comments
                        "comment": {
                            "color": adjust_color_brightness(foreground, 0.6),
                            "font_style": "italic"
                        },
                        "comment.doc": {
                            "color": adjust_color_brightness(foreground, 0.7),
                            "font_style": "italic"
                        },

                        # Keywords
                        "keyword": {
                            "color": get_accent_color(1)
                        },

                        # Strings
                        "string": {
                            "color": get_accent_color(2)
                        },
                        "string.escape": {
                            "color": get_accent_color(6)
                        },
                        "string.regex": {
                            "color": get_accent_color(6)
                        },

                        # Numbers and constants
                        "number": {
                            "color": get_accent_color(3)
                        },
                        "constant": {
                            "color": get_accent_color(3)
                        },
                        "boolean": {
                            "color": get_accent_color(5)
                        },

                        # Functions
                        "function": {
                            "color": get_accent_color(4)
                        },
                        "constructor": {
                            "color": get_accent_color(4)
                        },

                        # Types
                        "type": {
                            "color": get_accent_color(5)
                        },
                        "enum": {
                            "color": get_accent_color(5)
                        },

                        # Variables
                        "variable": {
                            "color": foreground
                        },
                        "variable.special": {
                            "color": get_accent_color(5)
                        },

                        # Properties and attributes
                        "property": {
                            "color": get_accent_color(4)
                        },
                        "attribute": {
                            "color": get_accent_color(3)
                        },

                        # Operators
                        "operator": {
                            "color": get_accent_color(6)
                        },

                        # Punctuation
                        "punctuation": {
                            "color": adjust_color_brightness(foreground, 0.8)
                        },
                        "punctuation.bracket": {
                            "color": adjust_color_brightness(foreground, 0.9)
                        },
                        "punctuation.delimiter": {
                            "color": adjust_color_brightness(foreground, 0.8)
                        },

                        # Tags (HTML/XML)
                        "tag": {
                            "color": get_accent_color(1)
                        },

                        # Labels
                        "label": {
                            "color": get_accent_color(4)
                        },

                        # Text and literals
                        "text.literal": {
                            "color": get_accent_color(2)
                        },

                        # Titles and headings
                        "title": {
                            "color": get_accent_color(4),
                            "font_weight": 700
                        },

                        # Links
                        "link_text": {
                            "color": get_accent_color(4),
                            "font_style": "italic"
                        },
                        "link_uri": {
                            "color": get_accent_color(6)
                        },

                        # Emphasis
                        "emphasis": {
                            "font_style": "italic"
                        },
                        "emphasis.strong": {
                            "font_weight": 700
                        },

                        # Special elements
                        "embedded": {
                            "color": foreground
                        },
                        "preproc": {
                            "color": get_accent_color(1)
                        },
                        "primary": {
                            "color": foreground
                        },
                        "variant": {
                            "color": get_accent_color(5)
                        },

                        # Editor hints and diagnostics
                        "hint": {
                            "color": adjust_color_brightness(foreground, 0.6),
                            "font_weight": 700
                        },
                        "predictive": {
                            "color": adjust_color_brightness(foreground, 0.5),
                            "font_style": "italic"
                        },
                    },

                    # Players (for collaborative editing)
                    "players": [
                        {
                            "cursor": get_accent_color(4),
                            "background": get_accent_color(4),
                            "selection": blend_colors(background, get_accent_color(4), 0.3)
                        },
                        {
                            "cursor": get_accent_color(2),
                            "background": get_accent_color(2),
                            "selection": blend_colors(background, get_accent_color(2), 0.3)
                        },
                        {
                            "cursor": get_accent_color(3),
                            "background": get_accent_color(3),
                            "selection": blend_colors(background, get_accent_color(3), 0.3)
                        },
                        {
                            "cursor": get_accent_color(5),
                            "background": get_accent_color(5),
                            "selection": blend_colors(background, get_accent_color(5), 0.3)
                        }
                    ]
                }
            }
        ]
    }

    return theme_family

def write_zed_theme_family(theme_family):
    """Write theme family to dotfiles and link to Zed config"""

    # Dotfiles theme path
    dotfiles_theme_dir = Path.home() / "dotfiles" / "config" / "zed" / "themes"
    dotfiles_theme_file = dotfiles_theme_dir / "pywal.json"

    # Zed config paths
    zed_config_dir = Path.home() / ".config" / "zed"
    zed_themes_dir = zed_config_dir / "themes"
    zed_theme_file = zed_themes_dir / "pywal.json"

    # Create directories if they don't exist
    dotfiles_theme_dir.mkdir(parents=True, exist_ok=True)
    zed_themes_dir.mkdir(parents=True, exist_ok=True)

    # Write theme family to dotfiles
    with open(dotfiles_theme_file, 'w') as f:
        json.dump(theme_family, f, indent=2)

    print(f"✅ Theme family written to dotfiles: {dotfiles_theme_file}")

    # Create symlink to Zed config (for immediate use)
    if zed_theme_file.exists() or zed_theme_file.is_symlink():
        zed_theme_file.unlink()

    try:
        zed_theme_file.symlink_to(dotfiles_theme_file)
        print(f"🔗 Symlinked to Zed config: {zed_theme_file}")
    except OSError as e:
        # Fallback: copy file if symlink fails
        import shutil
        shutil.copy2(dotfiles_theme_file, zed_theme_file)
        print(f"📋 Copied to Zed config: {zed_theme_file}")

    return True

def update_zed_settings():
    """Update Zed settings to use the pywal theme"""

    zed_settings_file = Path.home() / ".config" / "zed" / "settings.json"
    dotfiles_settings_file = Path.home() / "dotfiles" / "config" / "zed" / "settings.json"

    # Preserve existing settings if they exist
    settings = {}

    if dotfiles_settings_file.exists():
        try:
            with open(dotfiles_settings_file, 'r') as f:
                settings = json.load(f)
        except json.JSONDecodeError:
            print("⚠️  Existing settings file has invalid JSON, starting fresh")
    elif zed_settings_file.exists():
        try:
            with open(zed_settings_file, 'r') as f:
                settings = json.load(f)
        except json.JSONDecodeError:
            print("⚠️  Existing Zed settings file has invalid JSON, starting fresh")

    # Preserve user's font settings and other preferences
    if not settings:
        # Default settings only if no existing settings found
        settings = {
            "buffer_font_family": "Operator Mono Lig",
            "ui_font_family": "MesloLGLDZ Nerd Font",
            "buffer_font_size": 17,
            "auto_update": False,
            "telemetry": {
                "diagnostics": False,
                "metrics": False
            },
            "vim_mode": True,
            "relative_line_numbers": True,
            "show_whitespaces": "selection",
            "tab_size": 4,
            "soft_wrap": "editor_width",
            "preview_tabs": {
                "enabled": False
            },
            "scrollbar": {
                "show": "auto"
            },
            "terminal": {
                "shell": {
                    "program": "zsh"
                },
                "working_directory": "current_project_directory"
            }
        }

    # Always set pywal theme
    settings["theme"] = "Pywal"

    # Write to dotfiles
    dotfiles_settings_file.parent.mkdir(parents=True, exist_ok=True)
    with open(dotfiles_settings_file, 'w') as f:
        json.dump(settings, f, indent=4)

    print(f"✅ Settings written to dotfiles: {dotfiles_settings_file}")

    # Create symlink to Zed config
    zed_settings_file.parent.mkdir(parents=True, exist_ok=True)

    if zed_settings_file.exists() or zed_settings_file.is_symlink():
        zed_settings_file.unlink()

    try:
        zed_settings_file.symlink_to(dotfiles_settings_file)
        print(f"🔗 Symlinked to Zed config: {zed_settings_file}")
    except OSError:
        # Fallback: copy file if symlink fails
        import shutil
        shutil.copy2(dotfiles_settings_file, zed_settings_file)
        print(f"📋 Copied to Zed config: {zed_settings_file}")

def main():
    print("🎨 Zed Theme Generator for Pywal (Schema v0.2.0)")
    print("=================================================")

    # Create theme family from pywal colors
    theme_family = create_zed_theme_family()
    if not theme_family:
        return False

    # Write theme family files
    if write_zed_theme_family(theme_family):
        print("✅ Zed theme family created successfully")
    else:
        print("❌ Failed to write theme family files")
        return False

    # Update settings
    update_zed_settings()

    print("")
    print("🎉 Zed integration complete!")
    print("📝 Next steps:")
    print("   1. Restart Zed editor (Cmd+Q, then reopen)")
    print("   2. Theme should automatically be applied")
    print("   3. Check Preferences → Theme if needed")
    print("")
    print("📁 Files created:")
    print(f"   • ~/dotfiles/config/zed/themes/pywal.json")
    print(f"   • ~/dotfiles/config/zed/settings.json")
    print(f"   • ~/.config/zed/themes/pywal.json (symlinked)")
    print(f"   • ~/.config/zed/settings.json (symlinked)")
    print("")
    print("🎯 Theme uses proper Zed schema v0.2.0 format!")

    return True

if __name__ == "__main__":
    main()
