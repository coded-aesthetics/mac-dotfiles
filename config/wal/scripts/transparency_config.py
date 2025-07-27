#!/usr/bin/env python3

# Configure Pywal iTerm2 Profile Transparency
# This script lets you adjust the transparency level of the Pywal profile

import json
import os
import sys

def update_transparency(transparency_level):
    """Update the transparency level of the Pywal profile"""
    
    # Validate transparency level
    try:
        transparency = float(transparency_level)
        if transparency < 0 or transparency > 1:
            print("❌ Transparency must be between 0 (opaque) and 1 (fully transparent)")
            print("   Examples: 0.2 (20%), 0.3 (30%), 0.5 (50%)")
            return False
    except ValueError:
        print("❌ Invalid transparency value. Use a decimal between 0 and 1")
        return False
    
    # Read current profile
    profile_file = os.path.expanduser("~/Library/Application Support/iTerm2/DynamicProfiles/pywal.json")
    
    if not os.path.exists(profile_file):
        print("❌ Pywal profile not found. Run 'walupdate' or 'setwal' first to create it.")
        return False
    
    try:
        with open(profile_file, 'r') as f:
            profile_data = json.load(f)
        
        # Update transparency
        if "Profiles" in profile_data and len(profile_data["Profiles"]) > 0:
            profile_data["Profiles"][0]["Transparency"] = transparency
            
            # Write updated profile
            with open(profile_file, 'w') as f:
                json.dump(profile_data, f, indent=2)
            
            print(f"✅ Updated Pywal profile transparency to {int(transparency * 100)}%")
            
            # Reload iTerm2 profiles
            import subprocess
            try:
                subprocess.run(['osascript', '-e', 'tell application "iTerm2" to reload dynamic profiles'], 
                             capture_output=True, timeout=5)
                print("🔄 iTerm2 profiles reloaded")
            except:
                print("⚠️  Profile updated. You may need to manually reload iTerm2 profiles.")
            
            return True
        else:
            print("❌ Invalid profile structure")
            return False
            
    except Exception as e:
        print(f"❌ Error updating profile: {e}")
        return False

def show_current_transparency():
    """Show the current transparency setting"""
    
    profile_file = os.path.expanduser("~/Library/Application Support/iTerm2/DynamicProfiles/pywal.json")
    
    if not os.path.exists(profile_file):
        print("❌ Pywal profile not found")
        return
    
    try:
        with open(profile_file, 'r') as f:
            profile_data = json.load(f)
        
        if "Profiles" in profile_data and len(profile_data["Profiles"]) > 0:
            transparency = profile_data["Profiles"][0].get("Transparency", 0)
            print(f"🔍 Current transparency: {int(transparency * 100)}%")
        else:
            print("❌ Invalid profile structure")
            
    except Exception as e:
        print(f"❌ Error reading profile: {e}")

def main():
    if len(sys.argv) < 2:
        print("🎨 Pywal iTerm2 Transparency Configurator")
        print("=======================================")
        print("")
        print("Usage:")
        print("  python3 transparency_config.py <transparency>")
        print("  python3 transparency_config.py show")
        print("")
        print("Examples:")
        print("  python3 transparency_config.py 0.2    # 20% transparency")
        print("  python3 transparency_config.py 0.3    # 30% transparency")
        print("  python3 transparency_config.py 0.5    # 50% transparency")
        print("  python3 transparency_config.py show   # Show current setting")
        print("")
        print("Presets:")
        print("  0.1  - Subtle (10%)")
        print("  0.2  - Light (20%)")
        print("  0.3  - Medium (30%) [Default]")
        print("  0.4  - Strong (40%)")
        print("  0.5  - Dramatic (50%)")
        return
    
    command = sys.argv[1].lower()
    
    if command == "show":
        show_current_transparency()
    else:
        update_transparency(command)

if __name__ == "__main__":
    main()
