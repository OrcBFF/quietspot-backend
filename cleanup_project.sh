#!/bin/bash

# Cleanup script for QuietSpot project
# Removes build artifacts, logs, and other regeneratable files

echo "🧹 Cleaning up QuietSpot project..."
echo ""

# Build artifacts (can be regenerated)
echo "Removing build artifacts..."
rm -rf "quietspot/build"
rm -rf "quietspot/android/build"
echo "✅ Build artifacts removed"

# Log files
echo "Removing log files..."
rm -f quietspot/flutter_*.log
rm -f backend/server.log
echo "✅ Log files removed"

# Old archive
if [ -f "quietspot.zip" ]; then
    echo "Removing old archive..."
    rm -f quietspot.zip
    echo "✅ Archive removed"
fi

# IDE files (can be regenerated)
echo "Removing IDE files..."
rm -f quietspot/quietspot.iml
rm -f quietspot/android/quietspot_android.iml
# Note: local.properties is kept as it contains local paths
echo "✅ IDE files removed"

# Platform-specific folders (uncomment if you don't need these platforms)
# echo "Removing platform-specific folders..."
# rm -rf quietspot/ios
# rm -rf quietspot/macos
# rm -rf quietspot/windows
# rm -rf quietspot/linux
# rm -rf quietspot/web
# echo "✅ Platform-specific folders removed"

# Backend node_modules (can be regenerated with npm install)
# Uncomment if you want to remove it (you'll need to run npm install after)
# echo "Removing backend node_modules..."
# rm -rf backend/node_modules
# echo "✅ Backend node_modules removed (run 'npm install' in backend/ to restore)"

echo ""
echo "✨ Cleanup complete!"
echo ""
echo "💡 To regenerate:"
echo "   - Build artifacts: Run 'flutter build' or 'flutter run'"
echo "   - Backend dependencies: Run 'npm install' in backend/"
echo "   - IDE files: Will be regenerated when opening in IDE"

