import 'package:equatable/equatable.dart';

import '../../../expenses/domain/expense_category.dart';

enum ReportsStatus { initial, loading, success, failure }

enum ReportsDateRange { last30Days, last90Days, last1Year, allTime, custom }

extension ReportsDateRangeX on ReportsDateRange {
  String get label {
    switch (this) {
      case ReportsDateRange.last30Days:
        return '30d';
      case ReportsDateRange.last90Days:
        return '90d';
      case ReportsDateRange.last1Year:
        return '1y';
      case ReportsDateRange.allTime:
        return 'All';
      case ReportsDateRange.custom:
        return 'Custom';
    }
  }
}

class CategorySpend extends Equatable {
  const CategorySpend({
    required this.category,
    required this.total,
    required this.percentage,
  });

  final ExpenseCategory category;
  final double total;
  final double percentage;

  @override
  List<Object> get props => [category, total, percentage];
}

class MonthlySpend extends Equatable {
  const MonthlySpend({required this.monthStart, required this.total});

  final DateTime monthStart;
  final double total;

  @override
  List<Object> get props => [monthStart, total];
}

class VehicleSpend extends Equatable {
  const VehicleSpend({
    required this.vehicleId,
    required this.vehicleName,
    required this.total,
  });

  final int vehicleId;
  final String vehicleName;
  final double total;

  @override
  List<Object> get props => [vehicleId, vehicleName, total];
}

class MonthlyDeltaSummary extends Equatable {
  const MonthlyDeltaSummary({
    required this.previousMonth,
    required this.currentMonth,
    required this.previousTotal,
    required this.currentTotal,
    required this.amount,
    required this.changeRatio,
  });

  final DateTime previousMonth;
  final DateTime currentMonth;
  final double previousTotal;
  final double currentTotal;
  final double amount;
  final double? changeRatio;

  bool get isIncrease => amount > 0;
  bool get isDecrease => amount < 0;

  @override
  List<Object?> get props => [
    previousMonth,
    currentMonth,
    previousTotal,
    currentTotal,
    amount,
    changeRatio,
  ];
}

class ReportsState extends Equatable {
  const ReportsState({
    this.status = ReportsStatus.initial,
    this.selectedRange = ReportsDateRange.last30Days,
    this.customStart,
    this.customEnd,
    this.rangeStart,
    this.rangeEnd,
    this.totalPurchase = 0,
    this.totalExpenses = 0,
    this.totalOwnershipCost = 0,
    this.categoryBreakdown = const [],
    this.monthlyTrend = const [],
    this.vehicleComparison = const [],
    this.costPerKmBaseline,
    this.baselineVehicleCount = 0,
    this.reminderUpcomingCount = 0,
    this.reminderOverdueCount = 0,
    this.serviceReminderUpcomingCount = 0,
    this.serviceReminderOverdueCount = 0,
    this.licenseReminderUpcomingCount = 0,
    this.licenseReminderOverdueCount = 0,
    this.errorMessage,
  });

  final ReportsStatus status;
  final ReportsDateRange selectedRange;
  final DateTime? customStart;
  final DateTime? customEnd;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;
  final double totalPurchase;
  final double totalExpenses;
  final double totalOwnershipCost;
  final List<CategorySpend> categoryBreakdown;
  final List<MonthlySpend> monthlyTrend;
  final List<VehicleSpend> vehicleComparison;
  final double? costPerKmBaseline;
  final int baselineVehicleCount;
  final int reminderUpcomingCount;
  final int reminderOverdueCount;
  final int serviceReminderUpcomingCount;
  final int serviceReminderOverdueCount;
  final int licenseReminderUpcomingCount;
  final int licenseReminderOverdueCount;
  final String? errorMessage;

  CategorySpend? get topCostCategory =>
      categoryBreakdown.isEmpty ? null : categoryBreakdown.first;

  double? get averageMonthlySpend {
    if (monthlyTrend.isEmpty) {
      return null;
    }
    final total = monthlyTrend.fold<double>(
      0,
      (sum, month) => sum + month.total,
    );
    return total / monthlyTrend.length;
  }

  MonthlyDeltaSummary? get monthlyDeltaSummary {
    if (monthlyTrend.length < 2) {
      return null;
    }

    final previous = monthlyTrend[monthlyTrend.length - 2];
    final current = monthlyTrend.last;
    final delta = current.total - previous.total;

    return MonthlyDeltaSummary(
      previousMonth: previous.monthStart,
      currentMonth: current.monthStart,
      previousTotal: previous.total,
      currentTotal: current.total,
      amount: delta,
      changeRatio: previous.total == 0 ? null : delta / previous.total,
    );
  }

  ReportsState copyWith({
    ReportsStatus? status,
    ReportsDateRange? selectedRange,
    DateTime? customStart,
    bool clearCustomStart = false,
    DateTime? customEnd,
    bool clearCustomEnd = false,
    DateTime? rangeStart,
    bool clearRangeStart = false,
    DateTime? rangeEnd,
    bool clearRangeEnd = false,
    double? totalPurchase,
    double? totalExpenses,
    double? totalOwnershipCost,
    List<CategorySpend>? categoryBreakdown,
    List<MonthlySpend>? monthlyTrend,
    List<VehicleSpend>? vehicleComparison,
    double? costPerKmBaseline,
    bool clearCostPerKmBaseline = false,
    int? baselineVehicleCount,
    int? reminderUpcomingCount,
    int? reminderOverdueCount,
    int? serviceReminderUpcomingCount,
    int? serviceReminderOverdueCount,
    int? licenseReminderUpcomingCount,
    int? licenseReminderOverdueCount,
    String? errorMessage,
  }) {
    return ReportsState(
      status: status ?? this.status,
      selectedRange: selectedRange ?? this.selectedRange,
      customStart: clearCustomStart ? null : (customStart ?? this.customStart),
      customEnd: clearCustomEnd ? null : (customEnd ?? this.customEnd),
      rangeStart: clearRangeStart ? null : (rangeStart ?? this.rangeStart),
      rangeEnd: clearRangeEnd ? null : (rangeEnd ?? this.rangeEnd),
      totalPurchase: totalPurchase ?? this.totalPurchase,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      totalOwnershipCost: totalOwnershipCost ?? this.totalOwnershipCost,
      categoryBreakdown: categoryBreakdown ?? this.categoryBreakdown,
      monthlyTrend: monthlyTrend ?? this.monthlyTrend,
      vehicleComparison: vehicleComparison ?? this.vehicleComparison,
      costPerKmBaseline: clearCostPerKmBaseline
          ? null
          : (costPerKmBaseline ?? this.costPerKmBaseline),
      baselineVehicleCount: baselineVehicleCount ?? this.baselineVehicleCount,
      reminderUpcomingCount:
          reminderUpcomingCount ?? this.reminderUpcomingCount,
      reminderOverdueCount: reminderOverdueCount ?? this.reminderOverdueCount,
      serviceReminderUpcomingCount:
          serviceReminderUpcomingCount ?? this.serviceReminderUpcomingCount,
      serviceReminderOverdueCount:
          serviceReminderOverdueCount ?? this.serviceReminderOverdueCount,
      licenseReminderUpcomingCount:
          licenseReminderUpcomingCount ?? this.licenseReminderUpcomingCount,
      licenseReminderOverdueCount:
          licenseReminderOverdueCount ?? this.licenseReminderOverdueCount,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    selectedRange,
    customStart,
    customEnd,
    rangeStart,
    rangeEnd,
    totalPurchase,
    totalExpenses,
    totalOwnershipCost,
    categoryBreakdown,
    monthlyTrend,
    vehicleComparison,
    costPerKmBaseline,
    baselineVehicleCount,
    reminderUpcomingCount,
    reminderOverdueCount,
    serviceReminderUpcomingCount,
    serviceReminderOverdueCount,
    licenseReminderUpcomingCount,
    licenseReminderOverdueCount,
    errorMessage,
  ];
}
