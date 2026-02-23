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

  Expense copyWith({
    int? id,
    int? vehicleId,
    DateTime? date,
    double? amount,
    ExpenseCategory? category,
    int? odometer,
    bool clearOdometer = false,
    String? vendor,
    bool clearVendor = false,
    String? notes,
    bool clearNotes = false,
  }) {
    return Expense(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      odometer: clearOdometer ? null : (odometer ?? this.odometer),
      vendor: clearVendor ? null : (vendor ?? this.vendor),
      notes: clearNotes ? null : (notes ?? this.notes),
    );
  }

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
