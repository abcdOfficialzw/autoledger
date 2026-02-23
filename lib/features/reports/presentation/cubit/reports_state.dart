import 'package:equatable/equatable.dart';

import '../../../expenses/domain/expense_category.dart';

enum ReportsStatus { initial, loading, success, failure }

class CategorySpend extends Equatable {
  const CategorySpend({required this.category, required this.total});

  final ExpenseCategory category;
  final double total;

  @override
  List<Object> get props => [category, total];
}

class ReportsState extends Equatable {
  const ReportsState({
    this.status = ReportsStatus.initial,
    this.totalPurchase = 0,
    this.totalExpenses = 0,
    this.totalOwnershipCost = 0,
    this.categoryBreakdown = const [],
    this.costPerKmBaseline,
    this.baselineVehicleCount = 0,
    this.errorMessage,
  });

  final ReportsStatus status;
  final double totalPurchase;
  final double totalExpenses;
  final double totalOwnershipCost;
  final List<CategorySpend> categoryBreakdown;
  final double? costPerKmBaseline;
  final int baselineVehicleCount;
  final String? errorMessage;

  ReportsState copyWith({
    ReportsStatus? status,
    double? totalPurchase,
    double? totalExpenses,
    double? totalOwnershipCost,
    List<CategorySpend>? categoryBreakdown,
    double? costPerKmBaseline,
    bool clearCostPerKmBaseline = false,
    int? baselineVehicleCount,
    String? errorMessage,
  }) {
    return ReportsState(
      status: status ?? this.status,
      totalPurchase: totalPurchase ?? this.totalPurchase,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      totalOwnershipCost: totalOwnershipCost ?? this.totalOwnershipCost,
      categoryBreakdown: categoryBreakdown ?? this.categoryBreakdown,
      costPerKmBaseline: clearCostPerKmBaseline
          ? null
          : (costPerKmBaseline ?? this.costPerKmBaseline),
      baselineVehicleCount: baselineVehicleCount ?? this.baselineVehicleCount,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    totalPurchase,
    totalExpenses,
    totalOwnershipCost,
    categoryBreakdown,
    costPerKmBaseline,
    baselineVehicleCount,
    errorMessage,
  ];
}
