#!/bin/bash

# Get the path to aerospace.toml
AEROSPACE_CONFIG="${HOME}/.config/aerospace/aerospace.toml"

# Get current macOS keyboard layout
# This returns the keyboard layout name (e.g., "ABC", "Dvorak", "Colemak")
CURRENT_LAYOUT=$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | \
    grep '"KeyboardLayout Name"' | \
    sed 's/.*"KeyboardLayout Name" = \(.*\);/\1/' | \
    tr -d ' ' | \
    tr -d ';')

echo "Current macOS keyboard layout: $CURRENT_LAYOUT"
# Map macOS layout to aerospace preset
# Default to qwerty if layout is not recognized
AEROSPACE_PRESET="qwerty"

if [[ "$CURRENT_LAYOUT" == *"Dvorak"* ]]; then
    AEROSPACE_PRESET="dvorak"
fi

# Read the current preset from aerospace.toml
CURRENT_PRESET=$(grep "preset = " "$AEROSPACE_CONFIG" | sed "s/.*preset = '\(.*\)'/\1/")

# Only update if the preset needs to change
if [[ "$CURRENT_PRESET" != "$AEROSPACE_PRESET" ]]; then
    echo "Switching Aerospace keyboard preset from '$CURRENT_PRESET' to '$AEROSPACE_PRESET'"

    # Update the preset line in aerospace.toml
    sed -i '' "s/preset = '.*'/preset = '$AEROSPACE_PRESET'/" "$AEROSPACE_CONFIG"

    # Reload aerospace config
    aerospace reload-config
else
    echo "Aerospace keyboard preset already set to '$AEROSPACE_PRESET'"
fi
