# Install Android SDK Without Android Studio

If Android Studio is having issues, you can install the SDK tools manually via command line.

## Method 1: Install via Package Manager (Easiest)

```bash
# Install Android SDK components
sudo apt-get update
sudo apt-get install -y android-sdk-build-tools android-sdk-platform-tools android-sdk-common

# Set environment variables
export ANDROID_HOME=/usr/lib/android-sdk
export PATH=$PATH:$ANDROID_HOME/build-tools/34.0.0:$ANDROID_HOME/platform-tools

# Make permanent
echo 'export ANDROID_HOME=/usr/lib/android-sdk' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/build-tools/34.0.0:$ANDROID_HOME/platform-tools' >> ~/.bashrc
source ~/.bashrc
```

## Method 2: Download Command-line Tools Manually

```bash
# Create SDK directory
mkdir -p ~/Android/Sdk
cd ~/Android/Sdk

# Download command-line tools
wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
unzip commandlinetools-linux-11076708_latest.zip
mkdir -p cmdline-tools
mv cmdline-tools latest
mv latest cmdline-tools/

# Set environment
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin

# Accept licenses
yes | sdkmanager --licenses

# Install build tools and platform
sdkmanager "build-tools;34.0.0" "platforms;android-34" "platform-tools"

# Make permanent
echo 'export ANDROID_HOME=$HOME/Android/Sdk' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/platform-tools' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/build-tools/34.0.0' >> ~/.bashrc
source ~/.bashrc
```

## Verify Installation

```bash
flutter doctor
```

You should see Android toolchain with ✓.

## After Installation

You can run your Flutter app:

```bash
cd "/home/aragorn/projects/projectHCI (copy)/Φάση 3 - QuietSpot/quietspot"
adb reverse tcp:3000 tcp:3000
flutter run -d 4664c848 \
  --dart-define=API_BASE_URL=http://localhost:3000 \
  --dart-define=MAPBOX_ACCESS_TOKEN=pk.your_token_here
```

