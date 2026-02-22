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

  Future<List<Expense>> getExpensesForVehicle(int vehicleId);
}
