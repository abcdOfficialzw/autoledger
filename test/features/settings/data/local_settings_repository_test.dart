import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:motoledger/features/settings/data/local_settings_repository.dart';
import 'package:motoledger/features/settings/domain/app_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads defaults when no settings file exists', () async {
    final directory = await Directory.systemTemp.createTemp('motoledger_test_');
    final repository = LocalSettingsRepository(overrideDirectory: directory);

    final result = await repository.loadPreferences();

    expect(result, const AppPreferences());
    await directory.delete(recursive: true);
  });

  test('persists and reloads preferences from local file', () async {
    final directory = await Directory.systemTemp.createTemp('motoledger_test_');
    final repository = LocalSettingsRepository(overrideDirectory: directory);
    const custom = AppPreferences(
      currencyCode: 'KES',
      currencySymbol: 'KSh',
      distanceUnit: DistanceUnit.mi,
      serviceReminderEnabled: false,
      licenseReminderEnabled: true,
    );

    await repository.savePreferences(custom);
    final reloaded = await repository.loadPreferences();

    expect(reloaded, custom);
    await directory.delete(recursive: true);
  });
}
