import 'package:equatable/equatable.dart';

import '../../../vehicles/domain/vehicle.dart';
import '../../domain/expense_category.dart';

enum AddExpenseStatus { initial, loading, ready, submitting, success, failure }

class AddExpenseState extends Equatable {
  const AddExpenseState({
    this.status = AddExpenseStatus.initial,
    this.vehicles = const [],
    this.selectedVehicleId,
    this.selectedCategory = ExpenseCategory.fuel,
    this.errorMessage,
  });

  final AddExpenseStatus status;
  final List<Vehicle> vehicles;
  final int? selectedVehicleId;
  final ExpenseCategory selectedCategory;
  final String? errorMessage;

  bool get canSubmit => selectedVehicleId != null && vehicles.isNotEmpty;

  AddExpenseState copyWith({
    AddExpenseStatus? status,
    List<Vehicle>? vehicles,
    int? selectedVehicleId,
    bool clearSelectedVehicle = false,
    ExpenseCategory? selectedCategory,
    String? errorMessage,
  }) {
    return AddExpenseState(
      status: status ?? this.status,
      vehicles: vehicles ?? this.vehicles,
      selectedVehicleId: clearSelectedVehicle
          ? null
          : (selectedVehicleId ?? this.selectedVehicleId),
      selectedCategory: selectedCategory ?? this.selectedCategory,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        vehicles,
        selectedVehicleId,
        selectedCategory,
        errorMessage,
      ];
}
