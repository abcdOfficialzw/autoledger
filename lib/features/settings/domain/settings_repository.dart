import 'app_preferences.dart';

abstract class SettingsRepository {
  Future<AppPreferences> loadPreferences();

  Future<void> savePreferences(AppPreferences preferences);
}
