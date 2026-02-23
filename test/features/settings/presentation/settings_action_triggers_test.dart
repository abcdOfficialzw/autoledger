import 'package:flutter_test/flutter_test.dart';
import 'package:motoledger/features/settings/domain/app_preferences.dart';
import 'package:motoledger/features/settings/domain/settings_repository.dart';
import 'package:motoledger/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:motoledger/features/settings/presentation/cubit/settings_state.dart';

void main() {
  test('export and import entry points trigger action state', () async {
    final cubit = SettingsCubit(_FakeSettingsRepository())..loadPreferences();
    await Future<void>.delayed(Duration.zero);

    cubit.triggerExportEntryPoint();
    expect(cubit.state.lastAction, SettingsAction.exportEntryPoint);
    expect(cubit.state.actionMessage, 'Export entry point selected.');

    cubit.triggerImportEntryPoint();
    expect(cubit.state.lastAction, SettingsAction.importEntryPoint);
    expect(cubit.state.actionMessage, 'Import entry point selected.');

    await cubit.close();
  });

  test('reset requires explicit call and saves defaults', () async {
    final repository = _FakeSettingsRepository(
      initial: const AppPreferences(
        currencyCode: 'EUR',
        currencySymbol: '€',
        distanceUnit: DistanceUnit.mi,
        serviceReminderEnabled: false,
        licenseReminderEnabled: false,
      ),
    );
    final cubit = SettingsCubit(repository);

    await cubit.loadPreferences();
    expect(cubit.state.preferences.currencyCode, 'EUR');

    await cubit.resetPreferencesToDefaults();

    expect(cubit.state.lastAction, SettingsAction.resetCompleted);
    expect(cubit.state.actionMessage, 'Settings reset to defaults.');
    expect(repository.savedPreferences, const AppPreferences());

    await cubit.close();
  });
}

class _FakeSettingsRepository implements SettingsRepository {
  _FakeSettingsRepository({AppPreferences initial = const AppPreferences()})
    : _preferences = initial;

  AppPreferences _preferences;
  AppPreferences? savedPreferences;

  @override
  Future<AppPreferences> loadPreferences() async => _preferences;

  @override
  Future<void> savePreferences(AppPreferences preferences) async {
    _preferences = preferences;
    savedPreferences = preferences;
  }
}
