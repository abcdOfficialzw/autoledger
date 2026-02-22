import 'package:isar/isar.dart';

import '../domain/expense.dart';
import '../domain/expense_category.dart';
import '../domain/expense_repository.dart';
import 'models/expense_isar.dart';

class IsarExpenseRepository implements ExpenseRepository {
  IsarExpenseRepository(this._isar);

  final Isar _isar;

  @override
  Future<int> createExpense({
    required int vehicleId,
    required DateTime date,
    required double amount,
    required ExpenseCategory category,
    int? odometer,
    String? vendor,
    String? notes,
  }) async {
    final expense = ExpenseIsar()
      ..vehicleId = vehicleId
      ..date = date
      ..amount = amount
      ..category = category
      ..odometer = odometer
      ..vendor = vendor?.trim()
      ..notes = notes?.trim();

    return _isar.writeTxn(() => _isar.expenseIsars.put(expense));
  }

  @override
  Future<List<Expense>> getExpensesForVehicle(int vehicleId) async {
    final records = await _isar.expenseIsars
        .filter()
        .vehicleIdEqualTo(vehicleId)
        .sortByDateDesc()
        .findAll();

    return records.map((record) => record.toDomain()).toList(growable: false);
  }
}
