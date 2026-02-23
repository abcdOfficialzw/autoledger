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
  Future<void> deleteExpense(int expenseId) async {
    await _isar.writeTxn(() => _isar.expenseIsars.delete(expenseId));
  }

  @override
  Future<List<Expense>> getAllExpenses({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final records = await _isar.expenseIsars.where().sortByDateDesc().findAll();
    return _applyDateRange(
      records.map((record) => record.toDomain()),
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future<List<Expense>> getExpensesForVehicle(
    int vehicleId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final records = await _isar.expenseIsars
        .filter()
        .vehicleIdEqualTo(vehicleId)
        .sortByDateDesc()
        .findAll();

    return _applyDateRange(
      records.map((record) => record.toDomain()),
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    await _isar.writeTxn(() => _isar.expenseIsars.put(expense.toIsar()));
  }

  List<Expense> _applyDateRange(
    Iterable<Expense> expenses, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final normalizedStart = startDate == null
        ? null
        : DateTime(startDate.year, startDate.month, startDate.day);
    final normalizedEnd = endDate == null
        ? null
        : DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59, 999);

    return expenses
        .where((expense) {
          if (normalizedStart != null &&
              expense.date.isBefore(normalizedStart)) {
            return false;
          }
          if (normalizedEnd != null && expense.date.isAfter(normalizedEnd)) {
            return false;
          }
          return true;
        })
        .toList(growable: false);
  }
}
