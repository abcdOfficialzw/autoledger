import 'package:flutter_test/flutter_test.dart';
import 'package:motoledger/features/expenses/domain/expense.dart';
import 'package:motoledger/features/expenses/domain/expense_category.dart';
import 'package:motoledger/features/reminders/domain/reminder_candidate.dart';
import 'package:motoledger/features/reminders/domain/services/reminder_computation_service.dart';
import 'package:motoledger/features/settings/domain/app_preferences.dart';
import 'package:motoledger/features/vehicles/domain/vehicle.dart';

void main() {
  const service = ReminderComputationService(
    serviceDueSoonWindowKm: 500,
    licenseDueSoonWindowDays: 30,
  );

  Vehicle buildVehicle({
    int id = 1,
    int initialMileage = 10000,
    int? serviceIntervalKm,
    int? lastServiceMileage,
    DateTime? licenseExpiryDate,
    DateTime? serviceReminderSnoozedUntil,
    int? serviceReminderRescheduledMileage,
    DateTime? serviceReminderRescheduledDate,
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
      serviceReminderRescheduledDate: serviceReminderRescheduledDate,
      licenseReminderSnoozedUntil: licenseReminderSnoozedUntil,
      licenseReminderRescheduledDate: licenseReminderRescheduledDate,
    );
  }

  Expense buildExpense({required int odometer}) {
    return Expense(
      id: odometer,
      vehicleId: 1,
      date: DateTime(2025, 1, 1),
      amount: 100,
      category: ExpenseCategory.service,
      odometer: odometer,
    );
  }

  group('upcomingServiceReminderCandidate', () {
    test('returns upcoming service reminder when within due-soon window', () {
      final vehicle = buildVehicle(
        serviceIntervalKm: 5000,
        lastServiceMileage: 20000,
      );

      final candidate = service.upcomingServiceReminderCandidate(
        vehicle: vehicle,
        expenses: [buildExpense(odometer: 24600)],
        preferences: const AppPreferences(serviceReminderEnabled: true),
      );

      expect(candidate, isNotNull);
      expect(candidate!.type, ReminderType.service);
      expect(candidate.urgency, ReminderUrgency.upcoming);
      expect(candidate.remainingDistanceKm, 400);
      expect(candidate.dueMileage, 25000);
    });

    test('returns overdue service reminder when due mileage is exceeded', () {
      final vehicle = buildVehicle(
        serviceIntervalKm: 5000,
        lastServiceMileage: 20000,
      );

      final candidate = service.upcomingServiceReminderCandidate(
        vehicle: vehicle,
        expenses: [buildExpense(odometer: 25250)],
        preferences: const AppPreferences(serviceReminderEnabled: true),
      );

      expect(candidate, isNotNull);
      expect(candidate!.urgency, ReminderUrgency.overdue);
      expect(candidate.remainingDistanceKm, -250);
    });

    test('returns null when service reminders are disabled', () {
      final vehicle = buildVehicle(
        serviceIntervalKm: 5000,
        lastServiceMileage: 20000,
      );

      final candidate = service.upcomingServiceReminderCandidate(
        vehicle: vehicle,
        expenses: [buildExpense(odometer: 24800)],
        preferences: const AppPreferences(serviceReminderEnabled: false),
      );

      expect(candidate, isNull);
    });
  });

  group('upcomingLicenseReminderCandidate', () {
    test('returns upcoming candidate when expiry is within window', () {
      final expiry = DateTime.now().add(const Duration(days: 10));
      final vehicle = buildVehicle(licenseExpiryDate: expiry);

      final candidate = service.upcomingLicenseReminderCandidate(
        vehicle: vehicle,
        preferences: const AppPreferences(licenseReminderEnabled: true),
      );

      expect(candidate, isNotNull);
      expect(candidate!.type, ReminderType.license);
      expect(candidate.urgency, ReminderUrgency.upcoming);
      expect(candidate.remainingDays, inInclusiveRange(9, 10));
    });

    test('returns overdue candidate when expiry is in the past', () {
      final expiry = DateTime.now().subtract(const Duration(days: 3));
      final vehicle = buildVehicle(licenseExpiryDate: expiry);

      final candidate = service.upcomingLicenseReminderCandidate(
        vehicle: vehicle,
        preferences: const AppPreferences(licenseReminderEnabled: true),
      );

      expect(candidate, isNotNull);
      expect(candidate!.urgency, ReminderUrgency.overdue);
      expect(candidate.remainingDays, lessThan(0));
    });

    test('returns null when license reminders are disabled', () {
      final expiry = DateTime.now().add(const Duration(days: 7));
      final vehicle = buildVehicle(licenseExpiryDate: expiry);

      final candidate = service.upcomingLicenseReminderCandidate(
        vehicle: vehicle,
        preferences: const AppPreferences(licenseReminderEnabled: false),
      );

      expect(candidate, isNull);
    });
  });

  test('summarize aggregates upcoming and overdue counts by type', () {
    final first = buildVehicle(
      id: 1,
      serviceIntervalKm: 5000,
      lastServiceMileage: 20000,
      licenseExpiryDate: DateTime.now().add(const Duration(days: 14)),
    );
    final second = buildVehicle(
      id: 2,
      serviceIntervalKm: 5000,
      lastServiceMileage: 20000,
      licenseExpiryDate: DateTime.now().subtract(const Duration(days: 2)),
    );

    final summary = service.summarize(
      vehicles: [first, second],
      expensesByVehicle: {
        1: [buildExpense(odometer: 24650)],
        2: [buildExpense(odometer: 25300).copyWith(vehicleId: 2)],
      },
      preferences: const AppPreferences(),
    );

    expect(summary.totalUpcoming, 2);
    expect(summary.totalOverdue, 2);
    expect(summary.serviceUpcoming, 1);
    expect(summary.serviceOverdue, 1);
    expect(summary.licenseUpcoming, 1);
    expect(summary.licenseOverdue, 1);
  });

  group('reminder action flows', () {
    test('snooze suppresses service reminder while keeping next due', () {
      final vehicle = buildVehicle(
        serviceIntervalKm: 5000,
        lastServiceMileage: 20000,
        serviceReminderSnoozedUntil: DateTime.now().add(
          const Duration(days: 2),
        ),
      );

      final snapshot = service.vehicleReminders(
        vehicle: vehicle,
        expenses: [buildExpense(odometer: 24800)],
        preferences: const AppPreferences(serviceReminderEnabled: true),
      );

      expect(snapshot.service, isNull);
      expect(snapshot.serviceNextDue, isNotNull);
      expect(snapshot.serviceNextDue!.remainingDistanceKm, 200);
    });

    test('reschedule overrides due target for service and license', () {
      final licenseDate = DateTime.now().add(const Duration(days: 45));
      final vehicle = buildVehicle(
        serviceIntervalKm: 5000,
        lastServiceMileage: 20000,
        licenseExpiryDate: DateTime.now().add(const Duration(days: 10)),
        serviceReminderRescheduledMileage: 25500,
        serviceReminderRescheduledDate: DateTime.now(),
        licenseReminderRescheduledDate: licenseDate,
      );

      final snapshot = service.vehicleReminders(
        vehicle: vehicle,
        expenses: [buildExpense(odometer: 25200)],
        preferences: const AppPreferences(),
      );

      expect(snapshot.serviceNextDue, isNotNull);
      expect(snapshot.serviceNextDue!.dueMileage, 25500);
      expect(snapshot.serviceNextDue!.remainingDistanceKm, 300);
      expect(snapshot.service, isNotNull);

      expect(snapshot.licenseNextDue, isNotNull);
      expect(
        snapshot.licenseNextDue!.dueDate,
        DateTime(licenseDate.year, licenseDate.month, licenseDate.day),
      );
      expect(snapshot.license, isNull);
    });

    test('mark done recalculates next due from updated baseline', () {
      final vehicle = buildVehicle(
        serviceIntervalKm: 5000,
        lastServiceMileage: 25200,
        licenseExpiryDate: DateTime.now().add(const Duration(days: 365)),
      );

      final snapshot = service.vehicleReminders(
        vehicle: vehicle,
        expenses: [buildExpense(odometer: 25200)],
        preferences: const AppPreferences(),
      );

      expect(snapshot.service, isNull);
      expect(snapshot.serviceNextDue, isNotNull);
      expect(snapshot.serviceNextDue!.dueMileage, 30200);
      expect(snapshot.serviceNextDue!.remainingDistanceKm, 5000);
      expect(snapshot.license, isNull);
      expect(snapshot.licenseNextDue, isNotNull);
    });
  });
}
