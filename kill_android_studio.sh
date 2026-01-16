#!/bin/bash

# Kill all Android Studio processes

echo "🛑 Stopping Android Studio processes..."

# Find and kill all Android Studio processes
pkill -9 -f "android-studio" 2>/dev/null
pkill -9 -f "studio.sh" 2>/dev/null

# Wait a moment
sleep 2

# Verify
if ps aux | grep -i "android-studio\|studio.sh" | grep -v grep > /dev/null; then
    echo "⚠️  Some processes may still be running"
    echo "Run: ps aux | grep android-studio"
else
    echo "✅ All Android Studio processes stopped"
fi

