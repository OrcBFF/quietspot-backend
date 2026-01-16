# Measurement Validation & Trust System

## Overview

This system addresses the critical concern: **How to maintain data quality in a crowdsourced noise measurement app without blindly trusting user calibrations.**

## The Problem

1. **User Calibration Trust**: Should we trust users to calibrate their devices?
2. **Data Quality**: How to detect and handle bad/misunderstood measurements?
3. **User Empowerment**: How to put users in charge while maintaining data integrity?

## The Solution

We've implemented a **multi-layered validation system** that:

### 1. **Statistical Validation** (`MeasurementValidationService`)
- Compares each measurement with nearby spots (within 100m)
- Detects statistical outliers using z-scores
- Calculates trust scores (0.0 to 1.0) for each measurement
- Tracks measurement history per spot

**Key Features:**
- ✅ Validates against nearby measurements automatically
- ✅ Flags outliers (>2.5 standard deviations)
- ✅ Provides trust scores for each measurement
- ✅ Stores measurement history for analysis

### 2. **User Trust Profiles** (`UserTrustProfile`)
- Tracks each user's measurement history
- Calculates overall trustworthiness score
- Monitors validation rate and outlier frequency
- Builds reputation over time

**Trust Score Calculation:**
```
Overall Trust = (Validation Rate × 0.7) + (Average Trust Score × 0.3) - (Outlier Rate × 0.2)
```

### 3. **Validated Calibration** (`CalibrationService`)
- **NOT blindly trusted** - validated against nearby measurements
- Checks if calibration offset is reasonable (±15dB max)
- Compares with nearby spots to detect suspicious calibrations
- Auto-calibration option that analyzes measurement history
- Stores calibration confidence scores

**Calibration Validation:**
- Manual calibration is checked against nearby measurements
- Auto-calibration requires ≥3 measurements
- Confidence score based on consistency
- Only applied if confidence ≥ 0.5 and offset ≤ 10dB

### 4. **Measurement Records** (`MeasurementRecord`)
- Stores every measurement with metadata:
  - User ID (optional for privacy)
  - Device ID
  - Trust score
  - Validation status
  - Timestamp
  - Validation notes

## How It Works

### When a User Makes a Measurement:

1. **Measurement is taken** (10-second average)
2. **Validation runs automatically:**
   - Checks if value is in reasonable range (20-120 dB)
   - Compares with nearby spots (within 100m)
   - Calculates statistical z-score
   - Determines if it's an outlier
   - Calculates trust score

3. **Measurement is stored** with:
   - Raw dB value
   - Trust score
   - Validation status
   - Notes (e.g., "matches nearby spots well" or "differs significantly")

4. **User trust profile is updated:**
   - Total measurements count
   - Validated measurements count
   - Outlier count
   - Average trust score

### When a User Calibrates:

1. **User enters calibration offset** (e.g., -2.5 dB)
2. **System validates:**
   - Checks offset is reasonable (±15dB max)
   - Compares with nearby measurements (if available)
   - Warns if offset seems unusual
   - Stores with confidence score

3. **Calibration is applied** to future measurements
4. **Future measurements are validated** to ensure calibration is working correctly

### Detecting Bad Data:

The system automatically flags:
- **Outliers**: Measurements >2.5 standard deviations from nearby spots
- **Suspicious calibrations**: Offsets >10dB or inconsistent with nearby data
- **Low trust users**: Users with <60% overall trust score
- **Invalid ranges**: Measurements outside 20-120 dB

## Integration Example

### In `edit_spot_screen.dart`:

```dart
import 'package:quietspot/services/measurement_validation_service.dart';
import 'package:quietspot/services/calibration_service.dart';
import 'package:quietspot/models/measurement_record.dart';
import 'package:shared_preferences/shared_preferences.dart';

// After measurement is complete:
final validationService = MeasurementValidationService();
final calibrationService = CalibrationService();

// Get device ID
final prefs = await SharedPreferences.getInstance();
final deviceId = prefs.getString('device_id') ?? 'unknown';
final userId = 'user_${prefs.getString('user_id') ?? 'anonymous'}';

// Apply calibration if exists
final calibratedDb = await calibrationService.applyCalibration(rawDb, deviceId);

// Validate measurement
final location = LatLng(_latitude ?? 0, _longitude ?? 0);
final validation = await validationService.validateMeasurement(
  noiseDb: calibratedDb,
  location: location,
  spotId: widget.initialSpot?.id ?? 'new_spot',
  userId: userId,
  deviceId: deviceId,
  nearbySpots: nearbySpots, // Load from map_screen or database
);

// Show validation feedback to user
if (validation.isOutlier) {
  // Show warning: "This measurement differs from nearby spots"
}

// Store measurement record
final record = MeasurementRecord(
  id: DateTime.now().millisecondsSinceEpoch.toString(),
  spotId: widget.initialSpot?.id ?? 'new_spot',
  noiseDb: calibratedDb,
  timestamp: DateTime.now(),
  userId: userId,
  deviceId: deviceId,
  trustScore: validation.trustScore,
  isValidated: validation.isValid,
  validationNotes: validation.notes,
);

await validationService.storeMeasurement(record);

// Use validated measurement
setState(() {
  _noiseDb = calibratedDb;
  // ... update noise level
});
```

## Benefits

1. **Users Stay in Control**: They can calibrate, but system validates it
2. **Automatic Quality Control**: Bad measurements are flagged automatically
3. **Transparency**: Users see validation feedback
4. **Data Integrity**: Outliers are detected and can be filtered
5. **Reputation System**: Trustworthy users' measurements are weighted higher
6. **Self-Correcting**: System learns from patterns

## Future Enhancements

1. **Weighted Averages**: Use trust scores to weight measurements
2. **Admin Dashboard**: View flagged measurements and low-trust users
3. **User Feedback**: Allow users to report suspicious measurements
4. **Machine Learning**: Improve outlier detection with ML models
5. **Temporal Analysis**: Detect if measurements change over time (spot getting noisier?)

## Files Created

- `lib/models/measurement_record.dart` - Measurement metadata model
- `lib/models/user_trust_profile.dart` - User reputation tracking
- `lib/services/measurement_validation_service.dart` - Core validation logic
- `lib/services/calibration_service.dart` - Calibration with validation
- `lib/screens/calibration_screen.dart` - Calibration UI

## Usage

1. **Calibration**: Users go to Settings → Calibration
2. **Validation**: Happens automatically when measurements are saved
3. **Trust Scores**: Can be used to filter/weight measurements in UI
4. **History**: All measurements stored for analysis

This system ensures **data quality without removing user control** - users can calibrate, but the system validates and flags suspicious data automatically.

