#!/bin/bash

# Launch Android Studio

echo "🚀 Launching Android Studio..."

# Try common locations
if [ -f "/opt/android-studio/bin/studio.sh" ]; then
    echo "Found at /opt/android-studio/bin/studio.sh"
    /opt/android-studio/bin/studio.sh &
elif [ -f "$HOME/.local/share/JetBrains/Toolbox/apps/AndroidStudio" ]; then
    echo "Found in JetBrains Toolbox"
    find "$HOME/.local/share/JetBrains/Toolbox/apps/AndroidStudio" -name "studio.sh" | head -1 | xargs bash &
elif [ -f "/usr/local/bin/android-studio" ]; then
    echo "Found at /usr/local/bin/android-studio"
    /usr/local/bin/android-studio &
else
    echo "❌ Android Studio not found in common locations"
    echo ""
    echo "Searching system..."
    find /opt /usr/local ~/.local -name "studio.sh" 2>/dev/null | head -3
    echo ""
    echo "If found, run: /path/to/studio.sh"
fi

