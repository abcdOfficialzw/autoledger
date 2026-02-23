# motoledger

Auto Ledger MVP Phase 1 built with Flutter, `flutter_bloc`, and Isar (offline-first).

## App identity (release decision)

- User-facing app name: `Auto Ledger` (launcher title/store listing target)
- Internal Flutter package name: `motoledger` (kept stable)
- Android application ID / namespace: `zw.co.vetech.motoledger` (kept stable for upgrade continuity)

Rationale: keep internal IDs unchanged to avoid migration risk while polishing outward branding for release.

## Current state

- Vehicle management: create, edit, delete
- Quick add expense: select vehicle, amount, category, date, optional details
- Bottom navigation shell wired to real local persistence for Vehicles and Add Expense
- Reports/Settings remain placeholder pages for next phase

## Tech stack

- Flutter + Material 3
- `flutter_bloc` for feature state
- `go_router` for app routing
- Isar for local DB

## Run locally

1. Install dependencies:
```bash
flutter pub get
```

2. Generate Isar files:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

3. Run app:
```bash
flutter run
```

## Quality checks

Run static analysis and tests:

```bash
flutter analyze
flutter test
```

## Build examples

```bash
flutter build apk
flutter build ios
```

## Branding placeholders (Android-first)

Placeholder generator configs are committed:

- `flutter_launcher_icons.yaml`
- `flutter_native_splash.yaml`
- `assets/branding/README.md` (expected binary paths + generation steps)

Until final branding binaries are available, the project keeps the currently checked-in launcher/splash assets.

## Lightweight release checklist

- [ ] Verify version in `pubspec.yaml` (`version: x.y.z+build`).
- [ ] Run checks:
  - [ ] `/home/titus/development/flutter/bin/flutter analyze`
  - [ ] `/home/titus/development/flutter/bin/flutter test`
- [ ] Confirm app naming:
  - [ ] Android label is `Auto Ledger`
  - [ ] Android application ID remains `zw.co.vetech.motoledger`
- [ ] If new branding binaries exist, generate icon/splash assets via placeholder config files.
- [ ] Build Android release artifacts:
  - [ ] `/home/titus/development/flutter/bin/flutter build apk --release`
  - [ ] `/home/titus/development/flutter/bin/flutter build appbundle --release`
- [ ] Quick install sanity check:
  - [ ] Install release APK on a test device/emulator and verify launch/navigation.
