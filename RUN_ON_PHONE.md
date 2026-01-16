# Running Flutter App on Physical Android Device

## Step 1: Enable USB Debugging on Your Phone

1. Go to **Settings** → **About Phone**
2. Tap **Build Number** 7 times (until you see "You are now a developer")
3. Go back to **Settings** → **Developer Options**
4. Enable **USB Debugging**
5. Enable **Install via USB** (if available)

## Step 2: Connect Your Phone

1. Connect phone via USB cable
2. On your phone, when prompted, tap **"Allow USB debugging"** and check **"Always allow from this computer"**

## Step 3: Verify Device is Detected

```bash
flutter devices
```

You should see your Android device listed.

If not detected:
```bash
# Install Android platform tools if needed
sudo apt-get install android-tools-adb android-tools-fastboot

# Restart ADB
adb kill-server
adb start-server
adb devices
```

## Step 4: Run the App

**Important:** Your computer's IP is: **192.168.13.227**

Make sure your phone and computer are on the **same WiFi network**.

```bash
cd "/home/aragorn/projects/projectHCI (copy)/Φάση 3 - QuietSpot/quietspot"

# Run with API URL pointing to your computer
flutter run \
  --dart-define=API_BASE_URL=http://192.168.13.227:3000 \
  --dart-define=MAPBOX_ACCESS_TOKEN=pk.your_token_here
```

## Troubleshooting

### Device Not Detected

1. **Check USB connection:**
   ```bash
   lsusb  # Should show your phone
   ```

2. **Restart ADB:**
   ```bash
   adb kill-server
   adb start-server
   adb devices
   ```

3. **Check phone:** Make sure USB debugging is enabled and you've authorized the computer

### API Connection Issues

1. **Check firewall:** Make sure port 3000 is not blocked
   ```bash
   sudo ufw allow 3000/tcp
   ```

2. **Verify API is running:** 
   ```bash
   curl http://192.168.13.227:3000/api/health
   ```

3. **Test from phone's browser:** Open `http://192.168.13.227:3000/api/health` on your phone's browser

4. **Same WiFi:** Phone and computer must be on the same network

### Alternative: Use USB Tunneling (if WiFi doesn't work)

```bash
# Forward port 3000 from phone to computer
adb reverse tcp:3000 tcp:3000

# Then use localhost in Flutter
flutter run --dart-define=API_BASE_URL=http://localhost:3000
```

