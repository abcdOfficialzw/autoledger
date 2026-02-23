import 'package:flutter_test/flutter_test.dart';
import 'package:motoledger/features/expenses/domain/expense.dart';
import 'package:motoledger/features/expenses/domain/expense_category.dart';
import 'package:motoledger/features/expenses/domain/expense_repository.dart';
import 'package:motoledger/features/reminders/domain/services/reminder_computation_service.dart';
import 'package:motoledger/features/reports/presentation/cubit/reports_cubit.dart';
import 'package:motoledger/features/reports/presentation/cubit/reports_state.dart';
import 'package:motoledger/features/settings/domain/app_preferences.dart';
import 'package:motoledger/features/settings/domain/settings_repository.dart';
import 'package:motoledger/features/vehicles/domain/vehicle.dart';
import 'package:motoledger/features/vehicles/domain/vehicle_repository.dart';

void main() {
  Vehicle buildVehicle({int id = 1}) {
    return Vehicle(
      id: id,
      make: 'Toyota',
      model: 'Corolla',
      year: 2020,
      registrationNumber: 'KAA 001A',
      purchaseDate: DateTime(2024, 1, 15),
      purchasePrice: 12000,
      initialMileage: 10000,
    );
  }

  Expense buildExpense({
    required int id,
    required int vehicleId,
    required DateTime date,
    required double amount,
    required ExpenseCategory category,
  }) {
    return Expense(
      id: id,
      vehicleId: vehicleId,
      date: date,
      amount: amount,
      category: category,
      odometer: 10000 + (id * 100),
    );
  }

  test('custom range filters expenses and normalizes end of day', () async {
    final vehicle = buildVehicle();
    final expenseRepository = _FakeExpenseRepository({
      vehicle.id: [
        buildExpense(
          id: 1,
          vehicleId: vehicle.id,
          date: DateTime(2025, 1, 5, 8),
          amount: 80,
          category: ExpenseCategory.fuel,
        ),
        buildExpense(
          id: 2,
          vehicleId: vehicle.id,
          date: DateTime(2025, 1, 31, 22, 30),
          amount: 20,
          category: ExpenseCategory.parkingTolls,
        ),
        buildExpense(
          id: 3,
          vehicleId: vehicle.id,
          date: DateTime(2025, 2, 1, 9),
          amount: 50,
          category: ExpenseCategory.fuel,
        ),
      ],
    });
    final cubit = ReportsCubit(
      _FakeVehicleRepository([vehicle]),
      expenseRepository,
      _FakeSettingsRepository(),
      const ReminderComputationService(),
    );

    await cubit.setCustomRange(DateTime(2025, 1, 1), DateTime(2025, 1, 31));

    expect(cubit.state.status, ReportsStatus.success);
    expect(cubit.state.totalExpenses, 100);
    expect(cubit.state.rangeStart, DateTime(2025, 1, 1));
    expect(cubit.state.rangeEnd, DateTime(2025, 1, 31, 23, 59, 59, 999));

    final filteredQueries = expenseRepository.queries
        .where((query) => query.startDate != null || query.endDate != null)
        .toList(growable: false);
    expect(filteredQueries, hasLength(1));
    expect(filteredQueries.single.startDate, DateTime(2025, 1, 1));
    expect(
      filteredQueries.single.endDate,
      DateTime(2025, 1, 31, 23, 59, 59, 999),
    );
  });

  test('summary logic exposes top category and monthly delta', () async {
    final vehicle = buildVehicle();
    final cubit = ReportsCubit(
      _FakeVehicleRepository([vehicle]),
      _FakeExpenseRepository({
        vehicle.id: [
          buildExpense(
            id: 1,
            vehicleId: vehicle.id,
            date: DateTime(2025, 1, 8),
            amount: 100,
            category: ExpenseCategory.fuel,
          ),
          buildExpense(
            id: 2,
            vehicleId: vehicle.id,
            date: DateTime(2025, 2, 8),
            amount: 160,
            category: ExpenseCategory.service,
          ),
          buildExpense(
            id: 3,
            vehicleId: vehicle.id,
            date: DateTime(2025, 2, 14),
            amount: 60,
            category: ExpenseCategory.service,
          ),
        ],
      }),
      _FakeSettingsRepository(),
      const ReminderComputationService(),
    );

    await cubit.setCustomRange(DateTime(2025, 1, 1), DateTime(2025, 2, 28));

    final topCategory = cubit.state.topCostCategory;
    final monthlyDelta = cubit.state.monthlyDeltaSummary;
    expect(topCategory, isNotNull);
    expect(topCategory!.category, ExpenseCategory.service);
    expect(topCategory.total, 220);
    expect(monthlyDelta, isNotNull);
    expect(monthlyDelta!.previousMonth, DateTime(2025, 1));
    expect(monthlyDelta.currentMonth, DateTime(2025, 2));
    expect(monthlyDelta.amount, 120);
    expect(monthlyDelta.changeRatio, 1.2);
    expect(cubit.state.averageMonthlySpend, 160);
  });

  test(
    'vehicle comparison ranks vehicles by spend in selected range',
    () async {
      final sedan = buildVehicle(id: 1);
      final hatch = buildVehicle(id: 2);
      final cubit = ReportsCubit(
        _FakeVehicleRepository([sedan, hatch]),
        _FakeExpenseRepository({
          sedan.id: [
            buildExpense(
              id: 1,
              vehicleId: sedan.id,
              date: DateTime(2025, 3, 8),
              amount: 60,
              category: ExpenseCategory.fuel,
            ),
            buildExpense(
              id: 2,
              vehicleId: sedan.id,
              date: DateTime(2025, 3, 14),
              amount: 40,
              category: ExpenseCategory.service,
            ),
          ],
          hatch.id: [
            buildExpense(
              id: 3,
              vehicleId: hatch.id,
              date: DateTime(2025, 3, 10),
              amount: 300,
              category: ExpenseCategory.repairs,
            ),
          ],
        }),
        _FakeSettingsRepository(),
        const ReminderComputationService(),
      );

      await cubit.setCustomRange(DateTime(2025, 3, 1), DateTime(2025, 3, 31));

      expect(cubit.state.vehicleComparison, hasLength(2));
      expect(cubit.state.vehicleComparison.first.vehicleId, hatch.id);
      expect(cubit.state.vehicleComparison.first.total, 300);
      expect(cubit.state.vehicleComparison.last.vehicleId, sedan.id);
      expect(cubit.state.vehicleComparison.last.total, 100);
    },
  );
}

class _FakeVehicleRepository implements VehicleRepository {
  _FakeVehicleRepository(this.vehicles);

  final List<Vehicle> vehicles;

  @override
  Future<int> createVehicle({
    required String make,
    required String model,
    required int year,
    required String registrationNumber,
    required DateTime purchaseDate,
    required double purchasePrice,
    required int initialMileage,
    String? nickname,
    int? serviceIntervalKm,
    int? lastServiceMileage,
    DateTime? lastServiceDate,
    DateTime? licenseExpiryDate,
    DateTime? serviceReminderSnoozedUntil,
    int? serviceReminderRescheduledMileage,
    DateTime? serviceReminderRescheduledDate,
    DateTime? serviceReminderLastDoneAt,
    DateTime? licenseReminderSnoozedUntil,
    DateTime? licenseReminderRescheduledDate,
    DateTime? licenseReminderLastDoneAt,
  }) async {
    return vehicles.length + 1;
  }

  @override
  Future<void> deleteVehicle(int id) async {}

  @override
  Future<List<Vehicle>> getVehicles() async => vehicles;

  @override
  Future<void> updateVehicle(Vehicle vehicle) async {}
}

class _ExpenseQuery {
  const _ExpenseQuery({
    required this.vehicleId,
    required this.startDate,
    required this.endDate,
  });

  final int vehicleId;
  final DateTime? startDate;
  final DateTime? endDate;
}

class _FakeExpenseRepository implements ExpenseRepository {
  _FakeExpenseRepository(this.expensesByVehicle);

  final Map<int, List<Expense>> expensesByVehicle;
  final List<_ExpenseQuery> queries = [];

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
    return 0;
  }

  @override
  Future<void> deleteExpense(int expenseId) async {}

  @override
  Future<List<Expense>> getAllExpenses({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return const [];
  }

  @override
  Future<List<Expense>> getExpensesForVehicle(
    int vehicleId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    queries.add(
      _ExpenseQuery(
        vehicleId: vehicleId,
        startDate: startDate,
        endDate: endDate,
      ),
    );
    return (expensesByVehicle[vehicleId] ?? const [])
        .where((expense) {
          final inStart =
              startDate == null || !expense.date.isBefore(startDate);
          final inEnd = endDate == null || !expense.date.isAfter(endDate);
          return inStart && inEnd;
        })
        .toList(growable: false);
  }

  @override
  Future<void> updateExpense(Expense expense) async {}
}

class _FakeSettingsRepository implements SettingsRepository {
  @override
  Future<AppPreferences> loadPreferences() async => const AppPreferences();

  @override
  Future<void> savePreferences(AppPreferences preferences) async {}
}
