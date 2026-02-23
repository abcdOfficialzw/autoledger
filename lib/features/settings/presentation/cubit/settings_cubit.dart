import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/app_preferences.dart';
import '../../domain/settings_repository.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._settingsRepository) : super(const SettingsState());

  final SettingsRepository _settingsRepository;

  Future<void> loadPreferences() async {
    emit(
      state.copyWith(
        status: SettingsStatus.loading,
        errorMessage: null,
        clearAction: true,
      ),
    );
    try {
      final preferences = await _settingsRepository.loadPreferences();
      emit(
        state.copyWith(
          status: SettingsStatus.ready,
          preferences: preferences,
          errorMessage: null,
          clearAction: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: SettingsStatus.failure,
          errorMessage: 'Failed to load settings.',
          clearAction: true,
        ),
      );
    }
  }

  Future<void> setCurrency(CurrencyOption currency) async {
    await _save(
      state.preferences.copyWith(
        currencyCode: currency.code,
        currencySymbol: currency.symbol,
      ),
    );
  }

  Future<void> setDistanceUnit(DistanceUnit unit) async {
    await _save(state.preferences.copyWith(distanceUnit: unit));
  }

  Future<void> setServiceReminderEnabled(bool enabled) async {
    await _save(state.preferences.copyWith(serviceReminderEnabled: enabled));
  }

  Future<void> setLicenseReminderEnabled(bool enabled) async {
    await _save(state.preferences.copyWith(licenseReminderEnabled: enabled));
  }

  void triggerExportEntryPoint() {
    _emitAction(
      action: SettingsAction.exportEntryPoint,
      message: 'Export entry point selected.',
    );
  }

  void triggerImportEntryPoint() {
    _emitAction(
      action: SettingsAction.importEntryPoint,
      message: 'Import entry point selected.',
    );
  }

  Future<void> resetPreferencesToDefaults() async {
    await _save(
      const AppPreferences(),
      action: SettingsAction.resetCompleted,
      actionMessage: 'Settings reset to defaults.',
    );
  }

  Future<void> _save(
    AppPreferences preferences, {
    SettingsAction? action,
    String? actionMessage,
  }) async {
    try {
      await _settingsRepository.savePreferences(preferences);
      emit(
        state.copyWith(
          status: SettingsStatus.ready,
          preferences: preferences,
          errorMessage: null,
          lastAction: action,
          actionMessage: actionMessage,
          actionVersion: action == null
              ? state.actionVersion
              : state.actionVersion + 1,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: SettingsStatus.failure,
          errorMessage: 'Failed to save settings.',
          clearAction: true,
        ),
      );
    }
  }

  void _emitAction({required SettingsAction action, required String message}) {
    emit(
      state.copyWith(
        lastAction: action,
        actionMessage: message,
        actionVersion: state.actionVersion + 1,
      ),
    );
  }
}
