import 'package:flutter_test/flutter_test.dart';
import 'package:motoledger/features/expenses/domain/expense.dart';
import 'package:motoledger/features/expenses/domain/expense_category.dart';
import 'package:motoledger/features/expenses/domain/expense_repository.dart';
import 'package:motoledger/features/reminders/domain/reminder_candidate.dart';
import 'package:motoledger/features/vehicles/domain/vehicle.dart';
import 'package:motoledger/features/vehicles/domain/vehicle_repository.dart';
import 'package:motoledger/features/vehicles/presentation/cubit/vehicle_detail_cubit.dart';

void main() {
  Vehicle buildVehicle({
    int id = 1,
    int initialMileage = 10000,
    int? serviceIntervalKm,
    int? lastServiceMileage,
    DateTime? licenseExpiryDate,
    DateTime? serviceReminderSnoozedUntil,
    int? serviceReminderRescheduledMileage,
    DateTime? licenseReminderSnoozedUntil,
    DateTime? licenseReminderRescheduledDate,
  }) {
    return Vehicle(
      id: id,
      make: 'Honda',
      model: 'Fit',
      year: 2019,
      registrationNumber: 'ABC123',
      purchaseDate: DateTime(2022, 1, 10),
      purchasePrice: 12000,
      initialMileage: initialMileage,
      serviceIntervalKm: serviceIntervalKm,
      lastServiceMileage: lastServiceMileage,
      licenseExpiryDate: licenseExpiryDate,
      serviceReminderSnoozedUntil: serviceReminderSnoozedUntil,
      serviceReminderRescheduledMileage: serviceReminderRescheduledMileage,
      licenseReminderSnoozedUntil: licenseReminderSnoozedUntil,
      licenseReminderRescheduledDate: licenseReminderRescheduledDate,
    );
  }

  Expense buildExpense({required int vehicleId, required int odometer}) {
    return Expense(
      id: odometer,
      vehicleId: vehicleId,
      date: DateTime(2025, 1, 1),
      amount: 100,
      category: ExpenseCategory.service,
      odometer: odometer,
    );
  }

  test('snooze and reschedule service persist reminder action state', () async {
    final vehicle = buildVehicle(
      serviceIntervalKm: 5000,
      lastServiceMileage: 20000,
    );
    final vehicleRepository = _FakeVehicleRepository(vehicle);
    final cubit = VehicleDetailCubit(
      _FakeExpenseRepository([]),
      vehicleRepository,
      vehicle,
    );

    await cubit.snoozeReminder(ReminderType.service);
    final snoozed = cubit.state.vehicle;
    expect(snoozed.serviceReminderSnoozedUntil, isNotNull);

    await cubit.rescheduleServiceReminder(25500);
    final rescheduled = cubit.state.vehicle;
    expect(rescheduled.serviceReminderRescheduledMileage, 25500);
    expect(rescheduled.serviceReminderSnoozedUntil, isNull);
  });

  test(
    'mark done service resets baseline and clears action overrides',
    () async {
      final vehicle = buildVehicle(
        serviceIntervalKm: 5000,
        lastServiceMileage: 20000,
        serviceReminderSnoozedUntil: DateTime.now().add(
          const Duration(days: 3),
        ),
        serviceReminderRescheduledMileage: 25000,
      );
      final expense = buildExpense(vehicleId: vehicle.id, odometer: 25250);
      final vehicleRepository = _FakeVehicleRepository(vehicle);
      final cubit = VehicleDetailCubit(
        _FakeExpenseRepository([expense]),
        vehicleRepository,
        vehicle,
      );
      await cubit.loadExpenses(vehicle.id);

      await cubit.markReminderDone(ReminderType.service);
      final updated = cubit.state.vehicle;

      expect(updated.lastServiceMileage, 25250);
      expect(updated.lastServiceDate, isNotNull);
      expect(updated.serviceReminderSnoozedUntil, isNull);
      expect(updated.serviceReminderRescheduledMileage, isNull);
    },
  );

  test(
    'mark done license rolls renewal forward and clears overrides',
    () async {
      final expiry = DateTime(2026, 3, 10);
      final vehicle = buildVehicle(
        licenseExpiryDate: expiry,
        licenseReminderSnoozedUntil: DateTime.now().add(
          const Duration(days: 2),
        ),
        licenseReminderRescheduledDate: DateTime(2026, 3, 15),
      );
      final vehicleRepository = _FakeVehicleRepository(vehicle);
      final cubit = VehicleDetailCubit(
        _FakeExpenseRepository([]),
        vehicleRepository,
        vehicle,
      );

      await cubit.markReminderDone(ReminderType.license);
      final updated = cubit.state.vehicle;

      expect(updated.licenseExpiryDate, DateTime(2027, 3, 15));
      expect(updated.licenseReminderSnoozedUntil, isNull);
      expect(updated.licenseReminderRescheduledDate, isNull);
    },
  );
}

class _FakeVehicleRepository implements VehicleRepository {
  _FakeVehicleRepository(this.vehicle);

  Vehicle vehicle;

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
    return vehicle.id;
  }

  @override
  Future<void> deleteVehicle(int id) async {}

  @override
  Future<List<Vehicle>> getVehicles() async => [vehicle];

  @override
  Future<void> updateVehicle(Vehicle updatedVehicle) async {
    vehicle = updatedVehicle;
  }
}

class _FakeExpenseRepository implements ExpenseRepository {
  _FakeExpenseRepository(this.expenses);

  final List<Expense> expenses;

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
    return [];
  }

  @override
  Future<List<Expense>> getExpensesForVehicle(
    int vehicleId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return expenses.where((expense) => expense.vehicleId == vehicleId).toList();
  }

  @override
  Future<void> updateExpense(Expense expense) async {}
}
