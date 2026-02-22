import 'package:equatable/equatable.dart';

import 'expense_category.dart';

class Expense extends Equatable {
  const Expense({
    required this.id,
    required this.vehicleId,
    required this.date,
    required this.amount,
    required this.category,
    this.odometer,
    this.vendor,
    this.notes,
  });

  final int id;
  final int vehicleId;
  final DateTime date;
  final double amount;
  final ExpenseCategory category;
  final int? odometer;
  final String? vendor;
  final String? notes;

  @override
  List<Object?> get props => [
        id,
        vehicleId,
        date,
        amount,
        category,
        odometer,
        vendor,
        notes,
      ];
}
