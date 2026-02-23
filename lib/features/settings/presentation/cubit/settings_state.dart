import 'package:equatable/equatable.dart';

import '../../domain/app_preferences.dart';

enum SettingsStatus { initial, loading, ready, failure }

class SettingsState extends Equatable {
  const SettingsState({
    this.status = SettingsStatus.initial,
    this.preferences = const AppPreferences(),
    this.errorMessage,
  });

  final SettingsStatus status;
  final AppPreferences preferences;
  final String? errorMessage;

  SettingsState copyWith({
    SettingsStatus? status,
    AppPreferences? preferences,
    String? errorMessage,
  }) {
    return SettingsState(
      status: status ?? this.status,
      preferences: preferences ?? this.preferences,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, preferences, errorMessage];
}
