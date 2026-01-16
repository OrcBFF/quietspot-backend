# Debug Testing Guide - Calibration

## How to Test Calibration on Your Phone (USB Debug Mode)

### Prerequisites
1. Connect your phone via USB
2. Enable USB debugging on your phone
3. Run the app in debug mode: `flutter run`

### Testing Steps

#### 1. **Set Calibration**
1. Open the app
2. Go to **Settings** → **Calibration**
3. Enter a test offset (e.g., `-2.5` or `+3.0`)
4. Tap **Save Calibration**
5. You should see: "Calibration set. It will be validated against future measurements."

#### 2. **Test Calibration (Visual Test)**
1. Still in Calibration screen
2. Tap **"Test Calibration (Debug)"** button
3. A dialog will show:
   - Raw values: 45.0, 50.0, 55.0, 60.0 dB
   - Calibrated values: Shows how each value changes with your offset
   - Example: If offset is -2.5, then 50.0 dB → 47.5 dB

#### 3. **Test with Real Measurement**
1. Go to **Map** or **Home** screen
2. Create/Edit a spot
3. Tap **"Press for sound measurement"**
4. Start measurement (10 seconds)
5. **Watch the debug output in your terminal/console:**
   ```
   === CALIBRATION DEBUG ===
   Raw measurement: 52.34 dB
   Calibration offset: -2.50 dB
   Calibrated measurement: 49.84 dB
   Device ID: device_1234567890
   ========================
   ```

#### 4. **See Calibration in UI**
After measurement completes, you'll see:
- **Blue badge** showing: "Calibration: -2.5 dB"
- **Text below**: "Raw: 52.3 dB → Calibrated: 49.8 dB"
- Final displayed value will be the **calibrated** value

### What to Look For

#### ✅ **Calibration Working Correctly:**
- Terminal shows calibration offset being applied
- UI shows calibration badge with offset value
- Raw and calibrated values are different (if offset ≠ 0)
- Final saved value matches calibrated value

#### ❌ **If Calibration Not Working:**
- Check terminal for errors
- Verify device ID is set (should see in terminal)
- Check if calibration was saved (go back to Calibration screen, should show current offset)
- Try setting calibration again

### Debug Console Output

When you make a measurement, you'll see in your terminal:

```
EditSpotScreen: Starting measurement...
EditSpotScreen: Calling startMeasuring...
NoiseMeasurementService: Checking permission...
NoiseMeasurementService: Received dB reading: 52.34
EditSpotScreen: onData called with db = 52.34
=== CALIBRATION DEBUG ===
Raw measurement: 52.34 dB
Calibration offset: -2.50 dB
Calibrated measurement: 49.84 dB
Device ID: device_1234567890
========================
MeasurementValidationService: Validating measurement...
```

### Visual Indicators

1. **Calibration Screen:**
   - Shows current offset (if set)
   - "Test Calibration" button shows preview

2. **Measurement Dialog:**
   - Blue badge: "Calibration: -2.5 dB"
   - Shows raw → calibrated conversion
   - Final value is calibrated

3. **Terminal/Console:**
   - Debug prints show all calibration steps
   - Easy to verify calibration is applied

### Quick Test Scenario

1. **Set calibration to -5.0 dB**
2. **Make a measurement** (should read ~50 dB raw)
3. **Check terminal**: Should show calibrated value ~45 dB
4. **Check UI**: Should show "Raw: 50.0 dB → Calibrated: 45.0 dB"
5. **Save measurement**: Saved value should be 45.0 dB

### Troubleshooting

**Problem**: Calibration not showing in UI
- **Solution**: Make sure you saved calibration first (Settings → Calibration)

**Problem**: Values not changing
- **Solution**: Check terminal output - calibration might be 0.0 (no offset set)

**Problem**: Can't see debug output
- **Solution**: Make sure you're running `flutter run` (not release mode)

**Problem**: Device ID not found
- **Solution**: This is auto-generated on first run, check terminal for device ID

### Advanced Debugging

To see all calibration-related data:

1. **Check SharedPreferences** (in terminal):
   ```bash
   adb shell run-as com.example.quietspot cat /data/data/com.example.quietspot/shared_prefs/*.xml
   ```

2. **View all measurements**:
   - All measurements are stored in SharedPreferences
   - Check terminal for "MeasurementValidationService" logs

3. **Reset calibration**:
   - Clear app data or uninstall/reinstall
   - Or set calibration to 0.0

### Expected Behavior

- ✅ Calibration offset is applied to ALL measurements
- ✅ UI shows calibration status
- ✅ Terminal shows debug info
- ✅ Saved values are calibrated values
- ✅ Validation uses calibrated values

Now you can easily verify that calibration is working correctly on your phone! 🎯

