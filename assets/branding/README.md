# Branding Placeholder Notes (Android-first)

Real branding binaries are not committed yet. Keep using the current generated assets until final artwork is ready.

Expected files for generator configs:

- `assets/branding/icon/android-launcher-1024.png`
- `assets/branding/icon/android-launcher-foreground-1024.png`
- `assets/branding/splash/android-splash-logo-1024.png`

When binaries are available:

1. Add `flutter_launcher_icons` and `flutter_native_splash` under `dev_dependencies` in `pubspec.yaml`.
2. Run `flutter pub get`.
3. Generate launcher icons: `dart run flutter_launcher_icons -f flutter_launcher_icons.yaml`.
4. Generate splash assets: `dart run flutter_native_splash:create --path=flutter_native_splash.yaml`.
5. Rebuild Android artifacts.

