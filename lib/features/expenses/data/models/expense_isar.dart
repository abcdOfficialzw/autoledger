import 'package:isar/isar.dart';

import '../../domain/expense.dart';
import '../../domain/expense_category.dart';

part 'expense_isar.g.dart';

@collection
class ExpenseIsar {
  Id id = Isar.autoIncrement;

  @Index()
  int vehicleId = 0;

  DateTime date = DateTime.now();
  double amount = 0;

  @enumerated
  late ExpenseCategory category;

  int? odometer;
  String? vendor;
  String? notes;
}

extension ExpenseIsarMapper on ExpenseIsar {
  Expense toDomain() {
    return Expense(
      id: id,
      vehicleId: vehicleId,
      date: date,
      amount: amount,
      category: category,
      odometer: odometer,
      vendor: vendor,
      notes: notes,
    );
  }
}

extension ExpenseMapper on Expense {
  ExpenseIsar toIsar() {
    return ExpenseIsar()
      ..id = id
      ..vehicleId = vehicleId
      ..date = date
      ..amount = amount
      ..category = category
      ..odometer = odometer
      ..vendor = vendor?.trim()
      ..notes = notes?.trim();
  }
}
