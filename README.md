# motoledger

Auto Ledger MVP Phase 1 built with Flutter, `flutter_bloc`, and Isar (offline-first).

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
