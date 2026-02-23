import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../vehicles/domain/vehicle_repository.dart';
import '../../domain/expense_category.dart';
import '../../domain/expense_repository.dart';
import 'add_expense_state.dart';

class AddExpenseCubit extends Cubit<AddExpenseState> {
  AddExpenseCubit(this._expenseRepository, this._vehicleRepository)
    : super(const AddExpenseState());

  final ExpenseRepository _expenseRepository;
  final VehicleRepository _vehicleRepository;

  Future<void> loadVehicles() async {
    emit(state.copyWith(status: AddExpenseStatus.loading));
    try {
      final vehicles = await _vehicleRepository.getVehicles();
      final selectedId = vehicles.any((v) => v.id == state.selectedVehicleId)
          ? state.selectedVehicleId
          : (vehicles.isEmpty ? null : vehicles.first.id);

      emit(
        state.copyWith(
          status: AddExpenseStatus.ready,
          vehicles: vehicles,
          selectedVehicleId: selectedId,
          errorMessage: null,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: AddExpenseStatus.failure,
          errorMessage: 'Failed to load vehicles.',
        ),
      );
    }
  }

  void setSelectedVehicle(int vehicleId) {
    emit(state.copyWith(selectedVehicleId: vehicleId));
  }

  void setSelectedCategory(ExpenseCategory category) {
    emit(state.copyWith(selectedCategory: category));
  }

  Future<void> submit({
    required DateTime date,
    required double amount,
    int? odometer,
    String? vendor,
    String? notes,
  }) async {
    if (state.selectedVehicleId == null) {
      emit(
        state.copyWith(
          status: AddExpenseStatus.failure,
          errorMessage: 'Select a vehicle before saving expense.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(status: AddExpenseStatus.submitting, errorMessage: null),
    );

    try {
      await _expenseRepository.createExpense(
        vehicleId: state.selectedVehicleId!,
        date: date,
        amount: amount,
        category: state.selectedCategory,
        odometer: odometer,
        vendor: vendor,
        notes: notes,
      );
      emit(state.copyWith(status: AddExpenseStatus.success));
      emit(state.copyWith(status: AddExpenseStatus.ready));
    } catch (_) {
      emit(
        state.copyWith(
          status: AddExpenseStatus.failure,
          errorMessage: 'Failed to save expense.',
        ),
      );
    }
  }
}
