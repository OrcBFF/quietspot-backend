# Install Android SDK Command-line Tools

## Quick Fix via Android Studio (Easiest)

1. **Open Android Studio**
2. **Click "More Actions" → "SDK Manager"** (or Tools → SDK Manager)
3. **Go to "SDK Tools" tab**
4. **Check these items:**
   - ✅ Android SDK Command-line Tools (latest)
   - ✅ Android SDK Build-Tools (latest)
   - ✅ Android SDK Platform-Tools
   - ✅ Android SDK Platform (API 33 or 34)
5. **Click "Apply"** and wait for installation
6. **Set ANDROID_HOME:**
   - The SDK is usually at: `~/Android/Sdk` or `/opt/android-studio/android-studio/jbr`
   - Find it in Android Studio: Settings → Appearance & Behavior → System Settings → Android SDK
   - Copy the "Android SDK Location" path

7. **Add to your ~/.bashrc:**
   ```bash
   export ANDROID_HOME=$HOME/Android/Sdk
   export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
   export PATH=$PATH:$ANDROID_HOME/platform-tools
   export PATH=$PATH:$ANDROID_HOME/build-tools/34.0.0
   source ~/.bashrc
   ```

8. **Verify:**
   ```bash
   flutter doctor
   ```

## Alternative: Manual Installation

If Android Studio doesn't work, download manually:

```bash
# Create directory
mkdir -p ~/Android/Sdk/cmdline-tools
cd ~/Android/Sdk/cmdline-tools

# Download command-line tools (replace URL with latest from Android website)
wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
unzip commandlinetools-linux-11076708_latest.zip
mv cmdline-tools latest

# Set environment
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin

# Accept licenses and install build tools
yes | sdkmanager --licenses
sdkmanager "build-tools;34.0.0" "platforms;android-34" "platform-tools"

# Add to ~/.bashrc
echo 'export ANDROID_HOME=$HOME/Android/Sdk' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/platform-tools' >> ~/.bashrc
source ~/.bashrc
```

## After Installation

Run:
```bash
flutter doctor
```

You should see Android toolchain with ✓.

Then you can run your app:
```bash
cd "/home/aragorn/projects/projectHCI (copy)/Φάση 3 - QuietSpot/quietspot"
adb reverse tcp:3000 tcp:3000
flutter run --dart-define=API_BASE_URL=http://localhost:3000
```

