import 'expense.dart';
import 'expense_category.dart';

abstract class ExpenseRepository {
  Future<int> createExpense({
    required int vehicleId,
    required DateTime date,
    required double amount,
    required ExpenseCategory category,
    int? odometer,
    String? vendor,
    String? notes,
  });

  Future<List<Expense>> getExpensesForVehicle(
    int vehicleId, {
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<List<Expense>> getAllExpenses({
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<void> updateExpense(Expense expense);

  Future<void> deleteExpense(int expenseId);
}
