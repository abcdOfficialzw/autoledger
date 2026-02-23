import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../expenses/domain/expense.dart';
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
          actionStatus: VehicleExpenseActionStatus.idle,
          expenses: expenses,
          actionMessage: null,
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

  Future<void> updateExpense(Expense expense) async {
    emit(
      state.copyWith(
        actionStatus: VehicleExpenseActionStatus.processing,
        actionMessage: null,
      ),
    );
    try {
      await _expenseRepository.updateExpense(expense);
      final updatedExpenses = List<Expense>.from(state.expenses);
      final index = updatedExpenses.indexWhere((item) => item.id == expense.id);
      if (index >= 0) {
        updatedExpenses[index] = expense;
      }
      emit(
        state.copyWith(
          expenses: updatedExpenses,
          actionStatus: VehicleExpenseActionStatus.success,
          actionMessage: 'Expense updated.',
        ),
      );
      emit(state.copyWith(actionStatus: VehicleExpenseActionStatus.idle));
    } catch (_) {
      emit(
        state.copyWith(
          actionStatus: VehicleExpenseActionStatus.failure,
          actionMessage: 'Failed to update expense.',
        ),
      );
      emit(state.copyWith(actionStatus: VehicleExpenseActionStatus.idle));
    }
  }

  Future<void> deleteExpense(int expenseId) async {
    emit(
      state.copyWith(
        actionStatus: VehicleExpenseActionStatus.processing,
        actionMessage: null,
      ),
    );
    try {
      await _expenseRepository.deleteExpense(expenseId);
      final updatedExpenses = state.expenses
          .where((expense) => expense.id != expenseId)
          .toList(growable: false);
      emit(
        state.copyWith(
          expenses: updatedExpenses,
          actionStatus: VehicleExpenseActionStatus.success,
          actionMessage: 'Expense deleted.',
        ),
      );
      emit(state.copyWith(actionStatus: VehicleExpenseActionStatus.idle));
    } catch (_) {
      emit(
        state.copyWith(
          actionStatus: VehicleExpenseActionStatus.failure,
          actionMessage: 'Failed to delete expense.',
        ),
      );
      emit(state.copyWith(actionStatus: VehicleExpenseActionStatus.idle));
    }
  }
}
