import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/app_preferences.dart';
import '../../domain/settings_repository.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._settingsRepository) : super(const SettingsState());

  final SettingsRepository _settingsRepository;

  Future<void> loadPreferences() async {
    emit(state.copyWith(status: SettingsStatus.loading, errorMessage: null));
    try {
      final preferences = await _settingsRepository.loadPreferences();
      emit(
        state.copyWith(
          status: SettingsStatus.ready,
          preferences: preferences,
          errorMessage: null,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: SettingsStatus.failure,
          errorMessage: 'Failed to load settings.',
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

  Future<void> _save(AppPreferences preferences) async {
    try {
      await _settingsRepository.savePreferences(preferences);
      emit(
        state.copyWith(
          status: SettingsStatus.ready,
          preferences: preferences,
          errorMessage: null,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: SettingsStatus.failure,
          errorMessage: 'Failed to save settings.',
        ),
      );
    }
  }
}
