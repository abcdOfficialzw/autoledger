import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:motoledger/features/expenses/domain/expense.dart';
import 'package:motoledger/features/expenses/domain/expense_category.dart';
import 'package:motoledger/features/expenses/domain/expense_repository.dart';
import 'package:motoledger/features/reminders/domain/services/reminder_computation_service.dart';
import 'package:motoledger/features/settings/domain/app_preferences.dart';
import 'package:motoledger/features/settings/domain/settings_repository.dart';
import 'package:motoledger/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:motoledger/features/settings/presentation/settings_page.dart';
import 'package:motoledger/features/vehicles/domain/vehicle.dart';
import 'package:motoledger/features/vehicles/domain/vehicle_repository.dart';

void main() {
  testWidgets('export and import entry points trigger feedback', (
    tester,
  ) async {
    await tester.pumpWidget(_buildSettingsHarness());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Export data'));
    await tester.pump();
    expect(find.text('Export entry point selected.'), findsOneWidget);

    await tester.tap(find.text('Import data'));
    await tester.pump();
    expect(find.text('Import entry point selected.'), findsOneWidget);
  });

  testWidgets('opens backup and restore guidance screen', (tester) async {
    await tester.pumpWidget(_buildSettingsHarness());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Backup & restore guidance'));
    await tester.pumpAndSettle();

    expect(find.text('Backup & restore guidance'), findsWidgets);
    expect(find.text('Before you export'), findsOneWidget);
  });

  testWidgets('requires explicit text confirmation before reset', (
    tester,
  ) async {
    final settingsRepository = _FakeSettingsRepository(
      initial: const AppPreferences(
        currencyCode: 'EUR',
        currencySymbol: '€',
        distanceUnit: DistanceUnit.mi,
        serviceReminderEnabled: false,
        licenseReminderEnabled: false,
      ),
    );

    await tester.pumpWidget(_buildSettingsHarness(settingsRepository));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('settings-reset-tile')));
    await tester.pumpAndSettle();

    expect(find.text('Reset settings'), findsWidgets);
    expect(find.text('Reset now'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('reset-confirm-input')),
      'RESET',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reset now'));
    await tester.pumpAndSettle();

    expect(find.text('Settings reset to defaults.'), findsOneWidget);
    expect(settingsRepository.savedPreferences, const AppPreferences());
  });
}

Widget _buildSettingsHarness([_FakeSettingsRepository? settingsRepository]) {
  final repository = settingsRepository ?? _FakeSettingsRepository();

  return MultiRepositoryProvider(
    providers: [
      RepositoryProvider<SettingsRepository>.value(value: repository),
      RepositoryProvider<VehicleRepository>.value(
        value: _FakeVehicleRepository(),
      ),
      RepositoryProvider<ExpenseRepository>.value(
        value: _FakeExpenseRepository(),
      ),
      RepositoryProvider<ReminderComputationService>.value(
        value: const ReminderComputationService(),
      ),
    ],
    child: BlocProvider(
      create: (context) =>
          SettingsCubit(context.read<SettingsRepository>())..loadPreferences(),
      child: const MaterialApp(home: SettingsPage()),
    ),
  );
}

class _FakeSettingsRepository implements SettingsRepository {
  _FakeSettingsRepository({AppPreferences initial = const AppPreferences()})
    : _preferences = initial;

  AppPreferences _preferences;
  AppPreferences? savedPreferences;

  @override
  Future<AppPreferences> loadPreferences() async => _preferences;

  @override
  Future<void> savePreferences(AppPreferences preferences) async {
    _preferences = preferences;
    savedPreferences = preferences;
  }
}

class _FakeVehicleRepository implements VehicleRepository {
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
    return 1;
  }

  @override
  Future<void> deleteVehicle(int id) async {}

  @override
  Future<List<Vehicle>> getVehicles() async => const [];

  @override
  Future<void> updateVehicle(Vehicle vehicle) async {}
}

class _FakeExpenseRepository implements ExpenseRepository {
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
    return 1;
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
    return const [];
  }

  @override
  Future<void> updateExpense(Expense expense) async {}
}
