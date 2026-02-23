import 'package:equatable/equatable.dart';

import '../../../expenses/domain/expense.dart';
import '../../domain/vehicle.dart';

enum VehicleDetailStatus { initial, loading, success, failure }

enum VehicleExpenseActionStatus { idle, processing, success, failure }

enum VehicleReminderActionStatus { idle, processing, success, failure }

class VehicleDetailState extends Equatable {
  const VehicleDetailState({
    required this.vehicle,
    this.status = VehicleDetailStatus.initial,
    this.actionStatus = VehicleExpenseActionStatus.idle,
    this.reminderActionStatus = VehicleReminderActionStatus.idle,
    this.expenses = const [],
    this.actionMessage,
    this.reminderActionMessage,
    this.errorMessage,
  });

  final Vehicle vehicle;
  final VehicleDetailStatus status;
  final VehicleExpenseActionStatus actionStatus;
  final VehicleReminderActionStatus reminderActionStatus;
  final List<Expense> expenses;
  final String? actionMessage;
  final String? reminderActionMessage;
  final String? errorMessage;

  VehicleDetailState copyWith({
    Vehicle? vehicle,
    VehicleDetailStatus? status,
    VehicleExpenseActionStatus? actionStatus,
    VehicleReminderActionStatus? reminderActionStatus,
    List<Expense>? expenses,
    String? actionMessage,
    String? reminderActionMessage,
    String? errorMessage,
  }) {
    return VehicleDetailState(
      vehicle: vehicle ?? this.vehicle,
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      reminderActionStatus: reminderActionStatus ?? this.reminderActionStatus,
      expenses: expenses ?? this.expenses,
      actionMessage: actionMessage,
      reminderActionMessage: reminderActionMessage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    vehicle,
    status,
    actionStatus,
    reminderActionStatus,
    expenses,
    actionMessage,
    reminderActionMessage,
    errorMessage,
  ];
}
