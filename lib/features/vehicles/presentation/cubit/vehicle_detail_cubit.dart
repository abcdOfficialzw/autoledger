import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../expenses/domain/expense_repository.dart';
import 'vehicle_detail_state.dart';

class VehicleDetailCubit extends Cubit<VehicleDetailState> {
  VehicleDetailCubit(this._expenseRepository)
    : super(const VehicleDetailState());

  final ExpenseRepository _expenseRepository;

  Future<void> loadExpenses(int vehicleId) async {
    emit(
      state.copyWith(status: VehicleDetailStatus.loading, errorMessage: null),
    );
    try {
      final expenses = await _expenseRepository.getExpensesForVehicle(
        vehicleId,
      );
      emit(
        state.copyWith(
          status: VehicleDetailStatus.success,
          expenses: expenses,
          errorMessage: null,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: VehicleDetailStatus.failure,
          errorMessage: 'Failed to load expenses for this vehicle.',
        ),
      );
    }
  }
}
