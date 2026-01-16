# Installing Android SDK via Android Studio - Step by Step

## Step 1: Open Android Studio

1. Launch Android Studio from your applications menu
2. If you see a welcome screen, click **"More Actions"** → **"SDK Manager"**
   - OR if you have a project open, go to **File** → **Settings** (or **Preferences** on Mac)
   - Then navigate to **Appearance & Behavior** → **System Settings** → **Android SDK**

## Step 2: Access SDK Manager

You should see the **SDK Manager** window with two tabs:
- **SDK Platforms** (for Android versions)
- **SDK Tools** (for build tools and command-line tools)

## Step 3: Install SDK Tools

1. Click on the **"SDK Tools"** tab
2. Check the following boxes:
   - ✅ **Android SDK Command-line Tools (latest)**
     - This is the most important one - it includes `sdkmanager` and other CLI tools
   - ✅ **Android SDK Build-Tools**
     - Select the latest version (e.g., 34.0.0 or 33.0.0)
   - ✅ **Android SDK Platform-Tools**
     - Includes `adb`, `fastboot`, etc.
   - ✅ **Android SDK Platform** (API 33 or 34)
     - Your phone is Android 13 (API 33), so API 33 or 34 will work

3. Click **"Apply"** button at the bottom
4. A dialog will appear showing what will be installed - click **"OK"**
5. Wait for the download and installation to complete (this may take a few minutes)

## Step 4: Find Your SDK Location

1. In the same SDK Manager window, look at the top
2. You'll see **"Android SDK Location"** with a path like:
   - `/home/aragorn/Android/Sdk` (most common)
   - Or `/opt/android-studio/android-studio/jbr` (if installed system-wide)
   - **Copy this path** - you'll need it!

## Step 5: Set Environment Variables

Open a terminal and run:

```bash
# Replace /home/aragorn/Android/Sdk with YOUR actual SDK path from Step 4
export ANDROID_HOME=/home/aragorn/Android/Sdk

# Add to PATH
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/build-tools/34.0.0

# Make it permanent (add to ~/.bashrc)
echo 'export ANDROID_HOME=/home/aragorn/Android/Sdk' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/platform-tools' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/build-tools/34.0.0' >> ~/.bashrc

# Reload your shell configuration
source ~/.bashrc
```

**Important:** Replace `/home/aragorn/Android/Sdk` with the actual path you found in Step 4!

## Step 6: Verify Installation

```bash
# Check if tools are available
which adb
which sdkmanager

# Check Flutter
flutter doctor
```

You should now see:
```
[✓] Android toolchain - develop for Android devices
```

## Step 7: Accept Android Licenses

```bash
# Accept all Android licenses
flutter doctor --android-licenses
# Press 'y' for each license
```

## Troubleshooting

### If SDK location is different:

Find your actual SDK path:
```bash
# Check common locations
ls -la ~/Android/Sdk
ls -la ~/.android/sdk
ls -la /opt/android-studio
```

Then update the `ANDROID_HOME` path accordingly.

### If cmdline-tools folder structure is different:

Sometimes it's `cmdline-tools/bin` instead of `cmdline-tools/latest/bin`. Check:
```bash
ls -la $ANDROID_HOME/cmdline-tools/
```

Adjust the PATH accordingly.

### If build-tools version is different:

Check what version was installed:
```bash
ls -la $ANDROID_HOME/build-tools/
```

Use the actual version number in your PATH (e.g., `33.0.0` instead of `34.0.0`).

## After Setup is Complete

You can now run your Flutter app:

```bash
cd "/home/aragorn/projects/projectHCI (copy)/Φάση 3 - QuietSpot/quietspot"
adb reverse tcp:3000 tcp:3000
flutter run -d 4664c848 \
  --dart-define=API_BASE_URL=http://localhost:3000 \
  --dart-define=MAPBOX_ACCESS_TOKEN=pk.your_token_here
```

