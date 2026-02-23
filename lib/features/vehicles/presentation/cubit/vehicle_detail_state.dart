import 'package:equatable/equatable.dart';

import '../../../expenses/domain/expense.dart';

enum VehicleDetailStatus { initial, loading, success, failure }

enum VehicleExpenseActionStatus { idle, processing, success, failure }

class VehicleDetailState extends Equatable {
  const VehicleDetailState({
    this.status = VehicleDetailStatus.initial,
    this.actionStatus = VehicleExpenseActionStatus.idle,
    this.expenses = const [],
    this.actionMessage,
    this.errorMessage,
  });

  final VehicleDetailStatus status;
  final VehicleExpenseActionStatus actionStatus;
  final List<Expense> expenses;
  final String? actionMessage;
  final String? errorMessage;

  VehicleDetailState copyWith({
    VehicleDetailStatus? status,
    VehicleExpenseActionStatus? actionStatus,
    List<Expense>? expenses,
    String? actionMessage,
    String? errorMessage,
  }) {
    return VehicleDetailState(
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      expenses: expenses ?? this.expenses,
      actionMessage: actionMessage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    actionStatus,
    expenses,
    actionMessage,
    errorMessage,
  ];
}
