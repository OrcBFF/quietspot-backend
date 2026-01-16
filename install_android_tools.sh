#!/bin/bash

# Install Android SDK Command-line Tools and Build Tools

echo "📦 Installing Android SDK components..."

SDK_DIR="/usr/lib/android-sdk"
ANDROID_HOME="$SDK_DIR"

# Create directories if needed
sudo mkdir -p "$SDK_DIR/cmdline-tools"
sudo mkdir -p "$SDK_DIR/build-tools"
sudo mkdir -p "$SDK_DIR/platforms"

echo ""
echo "🔧 You need to install Android SDK components."
echo ""
echo "Option 1: Use Android Studio (Recommended)"
echo "   1. Open Android Studio"
echo "   2. Go to Tools → SDK Manager"
echo "   3. Install:"
echo "      - Android SDK Command-line Tools"
echo "      - Android SDK Build-Tools (latest)"
echo "      - Android SDK Platform (API 33 or 34)"
echo ""
echo "Option 2: Download command-line tools manually"
echo "   1. Download from: https://developer.android.com/studio#command-line-tools-only"
echo "   2. Extract to: $SDK_DIR/cmdline-tools/latest"
echo "   3. Run: $SDK_DIR/cmdline-tools/latest/bin/sdkmanager 'build-tools;34.0.0' 'platforms;android-34'"
echo ""
echo "Option 3: Install via package manager"
echo "   sudo apt-get install android-sdk-build-tools android-sdk-platform-tools"
echo ""

