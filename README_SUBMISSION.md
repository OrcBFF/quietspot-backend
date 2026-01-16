# QuietSpot - Submission README

## Install and Run

### Option A: Release APK (recommended for evaluators)
1. Download APK from: TBD
2. Install on Android device (allow unknown sources if prompted).

### Option B: Run from source
1. Install Flutter (Dart SDK >= 3.10.1) and Android SDK.
2. Open a terminal in `Φάση 3 - QuietSpot/quietspot`.
3. Run:
   ```bash
   flutter pub get
   flutter run \
     --dart-define=MAPBOX_ACCESS_TOKEN=pk.your_token_here \
     --dart-define=MAPBOX_STYLE_ID=mapbox/streets-v12
   ```

### Mapbox token
The map requires a Mapbox token. Without it, the app shows a message instead of tiles.

## Build Release APK (if needed)
```bash
flutter build apk --release \
  --dart-define=MAPBOX_ACCESS_TOKEN=pk.your_token_here \
  --dart-define=MAPBOX_STYLE_ID=mapbox/streets-v12
```
The APK will be in `Φάση 3 - QuietSpot/quietspot/build/app/outputs/flutter-apk/app-release.apk`.

## Android SDK Requirements
- Minimum SDK: API 21 (minSdk set by Flutter toolchain).
- Target/compile SDK: as provided by the installed Flutter toolchain.

## App Usage (quick)
1. Open the map and allow location permission (optional).
2. Tap on the map to place a pin for a quiet spot.
3. Add/edit spot details and optionally measure noise.
4. Save spots and view details from the map.

## Database (optional)
The demo app uses local storage (SharedPreferences) and does not require a backend.
If you want the MySQL schema + seed data for the MVP database:
- `Raf/quietspot.sql`
- `Raf/seed_quietspot.sql`

## Links
- Repository: TBD
- APK: TBD
- Demo video (optional): N/A

## Differences from Figma Prototype (optional)
- None noted yet.
