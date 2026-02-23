import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../expenses/domain/expense.dart';
import '../../../expenses/domain/expense_category.dart';
import '../../../expenses/domain/expense_repository.dart';
import '../../../vehicles/domain/vehicle.dart';
import '../../../vehicles/domain/vehicle_repository.dart';
import 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit(this._vehicleRepository, this._expenseRepository)
    : super(const ReportsState());

  final VehicleRepository _vehicleRepository;
  final ExpenseRepository _expenseRepository;

  Future<void> load() async {
    await _loadForRange(showLoading: true);
  }

  Future<void> setDateRange(ReportsDateRange range) async {
    emit(
      state.copyWith(
        selectedRange: range,
        errorMessage: null,
        clearRangeStart: range == ReportsDateRange.allTime,
        clearRangeEnd: range == ReportsDateRange.allTime,
      ),
    );

    if (range == ReportsDateRange.custom &&
        (state.customStart == null || state.customEnd == null)) {
      return;
    }

    await _loadForRange(showLoading: true);
  }

  Future<void> setCustomRange(DateTime start, DateTime end) async {
    final normalizedStart = DateTime(start.year, start.month, start.day);
    final normalizedEnd = DateTime(
      end.year,
      end.month,
      end.day,
      23,
      59,
      59,
      999,
    );

    emit(
      state.copyWith(
        selectedRange: ReportsDateRange.custom,
        customStart: normalizedStart,
        customEnd: normalizedEnd,
        rangeStart: normalizedStart,
        rangeEnd: normalizedEnd,
        errorMessage: null,
      ),
    );

    await _loadForRange(showLoading: true);
  }

  Future<void> _loadForRange({required bool showLoading}) async {
    if (showLoading) {
      emit(state.copyWith(status: ReportsStatus.loading, errorMessage: null));
    }

    try {
      final vehicles = await _vehicleRepository.getVehicles();
      final bounds = _resolveRangeBounds();

      final expensesByVehicle = await Future.wait(
        vehicles.map(
          (vehicle) => _expenseRepository.getExpensesForVehicle(
            vehicle.id,
            startDate: bounds.start,
            endDate: bounds.end,
          ),
        ),
      );

      final categoryTotals = <ExpenseCategory, double>{};
      final monthlyTotals = <DateTime, double>{};
      var totalExpenses = 0.0;
      var totalPurchase = 0.0;

      for (var index = 0; index < vehicles.length; index++) {
        final vehicle = vehicles[index];
        final vehicleExpenses = expensesByVehicle[index];

        totalPurchase += vehicle.purchasePrice;

        for (final expense in vehicleExpenses) {
          totalExpenses += expense.amount;
          categoryTotals.update(
            expense.category,
            (value) => value + expense.amount,
            ifAbsent: () => expense.amount,
          );

          final monthStart = DateTime(expense.date.year, expense.date.month);
          monthlyTotals.update(
            monthStart,
            (value) => value + expense.amount,
            ifAbsent: () => expense.amount,
          );
        }
      }

      final categoryBreakdown =
          categoryTotals.entries
              .map(
                (entry) => CategorySpend(
                  category: entry.key,
                  total: entry.value,
                  percentage: totalExpenses <= 0
                      ? 0
                      : entry.value / totalExpenses,
                ),
              )
              .toList(growable: false)
            ..sort((a, b) => b.total.compareTo(a.total));

      final monthlyTrend =
          monthlyTotals.entries
              .map(
                (entry) =>
                    MonthlySpend(monthStart: entry.key, total: entry.value),
              )
              .toList(growable: false)
            ..sort((a, b) => a.monthStart.compareTo(b.monthStart));

      final baseline = _buildCostPerKmBaseline(
        vehicles: vehicles,
        expensesByVehicle: expensesByVehicle,
      );

      emit(
        state.copyWith(
          status: ReportsStatus.success,
          rangeStart: bounds.start,
          rangeEnd: bounds.end,
          totalPurchase: totalPurchase,
          totalExpenses: totalExpenses,
          totalOwnershipCost: totalPurchase + totalExpenses,
          categoryBreakdown: categoryBreakdown,
          monthlyTrend: monthlyTrend,
          baselineVehicleCount: baseline.vehicleCount,
          clearCostPerKmBaseline: baseline.costPerKm == null,
          costPerKmBaseline: baseline.costPerKm,
          errorMessage: null,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: ReportsStatus.failure,
          errorMessage: 'Failed to load reports.',
        ),
      );
    }
  }

  _DateRangeBounds _resolveRangeBounds() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

    switch (state.selectedRange) {
      case ReportsDateRange.last30Days:
        return _DateRangeBounds(
          start: today.subtract(const Duration(days: 29)),
          end: endOfToday,
        );
      case ReportsDateRange.last90Days:
        return _DateRangeBounds(
          start: today.subtract(const Duration(days: 89)),
          end: endOfToday,
        );
      case ReportsDateRange.last1Year:
        return _DateRangeBounds(
          start: DateTime(today.year - 1, today.month, today.day),
          end: endOfToday,
        );
      case ReportsDateRange.allTime:
        return const _DateRangeBounds(start: null, end: null);
      case ReportsDateRange.custom:
        return _DateRangeBounds(start: state.customStart, end: state.customEnd);
    }
  }

  _CostPerKmBaseline _buildCostPerKmBaseline({
    required List<Vehicle> vehicles,
    required List<List<Expense>> expensesByVehicle,
  }) {
    var distanceKm = 0;
    var expenseTotal = 0.0;
    var vehicleCount = 0;

    for (var index = 0; index < vehicles.length; index++) {
      final vehicle = vehicles[index];
      final expenses = expensesByVehicle[index];
      if (expenses.isEmpty) {
        continue;
      }

      final withOdometer = expenses
          .where((expense) => expense.odometer != null)
          .toList();
      if (withOdometer.isEmpty) {
        continue;
      }

      final odometerValues = withOdometer
          .map((expense) => expense.odometer!)
          .toList();
      final maxOdometer = odometerValues.reduce(
        (value, element) => value > element ? value : element,
      );
      final minOdometer = odometerValues.reduce(
        (value, element) => value < element ? value : element,
      );

      final travelledWithinPeriod = maxOdometer - minOdometer;
      final travelledFromBaseline = maxOdometer - vehicle.initialMileage;
      final travelled = travelledWithinPeriod > 0
          ? travelledWithinPeriod
          : travelledFromBaseline;

      if (travelled <= 0) {
        continue;
      }

      vehicleCount += 1;
      distanceKm += travelled;
      expenseTotal += expenses.fold<double>(
        0,
        (sum, expense) => sum + expense.amount,
      );
    }

    if (distanceKm <= 0) {
      return _CostPerKmBaseline(costPerKm: null, vehicleCount: vehicleCount);
    }

    return _CostPerKmBaseline(
      costPerKm: expenseTotal / distanceKm,
      vehicleCount: vehicleCount,
    );
  }
}

class _CostPerKmBaseline {
  const _CostPerKmBaseline({
    required this.costPerKm,
    required this.vehicleCount,
  });

  final double? costPerKm;
  final int vehicleCount;
}

class _DateRangeBounds {
  const _DateRangeBounds({required this.start, required this.end});

  final DateTime? start;
  final DateTime? end;
}
