import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../domain/app_preferences.dart';
import '../domain/settings_repository.dart';

class LocalSettingsRepository implements SettingsRepository {
  LocalSettingsRepository({this.overrideDirectory});

  final Directory? overrideDirectory;

  static const _fileName = 'app_settings.json';

  @override
  Future<AppPreferences> loadPreferences() async {
    try {
      final file = await _settingsFile();
      if (!await file.exists()) {
        return const AppPreferences();
      }

      final content = await file.readAsString();
      if (content.trim().isEmpty) {
        return const AppPreferences();
      }

      final map = jsonDecode(content);
      if (map is! Map<String, dynamic>) {
        return const AppPreferences();
      }

      final currencyCode = map['currencyCode'] as String? ?? 'USD';
      final fallbackCurrency = CurrencyOption.fromCodeOrDefault(currencyCode);

      return AppPreferences(
        currencyCode: currencyCode,
        currencySymbol:
            map['currencySymbol'] as String? ?? fallbackCurrency.symbol,
        distanceUnit: switch (map['distanceUnit'] as String?) {
          'mi' => DistanceUnit.mi,
          _ => DistanceUnit.km,
        },
        serviceReminderEnabled: map['serviceReminderEnabled'] as bool? ?? true,
        licenseReminderEnabled: map['licenseReminderEnabled'] as bool? ?? true,
      );
    } catch (_) {
      return const AppPreferences();
    }
  }

  @override
  Future<void> savePreferences(AppPreferences preferences) async {
    final file = await _settingsFile();
    final payload = {
      'currencyCode': preferences.currencyCode,
      'currencySymbol': preferences.currencySymbol,
      'distanceUnit': preferences.distanceUnit.shortLabel,
      'serviceReminderEnabled': preferences.serviceReminderEnabled,
      'licenseReminderEnabled': preferences.licenseReminderEnabled,
    };
    await file.writeAsString(jsonEncode(payload), flush: true);
  }

  Future<File> _settingsFile() async {
    final directory =
        overrideDirectory ?? await getApplicationDocumentsDirectory();
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return File('${directory.path}/$_fileName');
  }
}
