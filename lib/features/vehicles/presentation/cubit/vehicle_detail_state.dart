import 'package:equatable/equatable.dart';

import '../../../expenses/domain/expense.dart';

enum VehicleDetailStatus { initial, loading, success, failure }

class VehicleDetailState extends Equatable {
  const VehicleDetailState({
    this.status = VehicleDetailStatus.initial,
    this.expenses = const [],
    this.errorMessage,
  });

  final VehicleDetailStatus status;
  final List<Expense> expenses;
  final String? errorMessage;

  VehicleDetailState copyWith({
    VehicleDetailStatus? status,
    List<Expense>? expenses,
    String? errorMessage,
  }) {
    return VehicleDetailState(
      status: status ?? this.status,
      expenses: expenses ?? this.expenses,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, expenses, errorMessage];
}
