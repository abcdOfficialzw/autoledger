import 'package:equatable/equatable.dart';

import '../../domain/app_preferences.dart';

enum SettingsStatus { initial, loading, ready, failure }

enum SettingsAction { exportEntryPoint, importEntryPoint, resetCompleted }

class SettingsState extends Equatable {
  const SettingsState({
    this.status = SettingsStatus.initial,
    this.preferences = const AppPreferences(),
    this.errorMessage,
    this.lastAction,
    this.actionMessage,
    this.actionVersion = 0,
  });

  final SettingsStatus status;
  final AppPreferences preferences;
  final String? errorMessage;
  final SettingsAction? lastAction;
  final String? actionMessage;
  final int actionVersion;

  SettingsState copyWith({
    SettingsStatus? status,
    AppPreferences? preferences,
    String? errorMessage,
    SettingsAction? lastAction,
    String? actionMessage,
    int? actionVersion,
    bool clearAction = false,
  }) {
    return SettingsState(
      status: status ?? this.status,
      preferences: preferences ?? this.preferences,
      errorMessage: errorMessage,
      lastAction: clearAction ? null : (lastAction ?? this.lastAction),
      actionMessage: clearAction ? null : (actionMessage ?? this.actionMessage),
      actionVersion: actionVersion ?? this.actionVersion,
    );
  }

  @override
  List<Object?> get props => [
    status,
    preferences,
    errorMessage,
    lastAction,
    actionMessage,
    actionVersion,
  ];
}
