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
    emit(state.copyWith(status: ReportsStatus.loading, errorMessage: null));
    try {
      final vehicles = await _vehicleRepository.getVehicles();
      final expensesByVehicle = await Future.wait(
        vehicles.map(
          (vehicle) => _expenseRepository.getExpensesForVehicle(vehicle.id),
        ),
      );

      final categoryTotals = <ExpenseCategory, double>{};
      var totalExpenses = 0.0;
      var totalPurchase = 0.0;

      for (var index = 0; index < vehicles.length; index++) {
        final vehicle = vehicles[index];
        totalPurchase += vehicle.purchasePrice;
        for (final expense in expensesByVehicle[index]) {
          totalExpenses += expense.amount;
          categoryTotals.update(
            expense.category,
            (value) => value + expense.amount,
            ifAbsent: () => expense.amount,
          );
        }
      }

      final categoryBreakdown =
          categoryTotals.entries
              .map(
                (entry) =>
                    CategorySpend(category: entry.key, total: entry.value),
              )
              .toList(growable: false)
            ..sort((a, b) => b.total.compareTo(a.total));

      final baseline = _buildCostPerKmBaseline(
        vehicles: vehicles,
        expensesByVehicle: expensesByVehicle,
      );

      emit(
        state.copyWith(
          status: ReportsStatus.success,
          totalPurchase: totalPurchase,
          totalExpenses: totalExpenses,
          totalOwnershipCost: totalPurchase + totalExpenses,
          categoryBreakdown: categoryBreakdown,
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

      final withOdometer = expenses.where(
        (expense) => expense.odometer != null,
      );
      if (withOdometer.isEmpty) {
        continue;
      }

      final latestOdometer = withOdometer
          .map((expense) => expense.odometer!)
          .reduce((value, element) => value > element ? value : element);
      final travelled = latestOdometer - vehicle.initialMileage;
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
