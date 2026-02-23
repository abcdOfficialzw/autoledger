import 'package:flutter_test/flutter_test.dart';
import 'package:motoledger/features/expenses/domain/expense.dart';
import 'package:motoledger/features/expenses/domain/expense_category.dart';
import 'package:motoledger/features/expenses/domain/expense_repository.dart';
import 'package:motoledger/features/settings/domain/app_preferences.dart';
import 'package:motoledger/features/settings/domain/settings_repository.dart';
import 'package:motoledger/features/vehicles/domain/vehicle.dart';
import 'package:motoledger/features/vehicles/domain/vehicle_repository.dart';
import 'package:motoledger/main.dart';

void main() {
  testWidgets('renders vehicles page', (WidgetTester tester) async {
    await tester.pumpWidget(
      AutoLedgerApp(
        vehicleRepository: _FakeVehicleRepository(),
        expenseRepository: _FakeExpenseRepository(),
        settingsRepository: _FakeSettingsRepository(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Add Vehicle'), findsWidgets);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Currency'), findsOneWidget);
    expect(find.text('Distance unit'), findsOneWidget);
  });
}

class _FakeVehicleRepository implements VehicleRepository {
  final List<Vehicle> _vehicles = [];

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
  }) async {
    final id = _vehicles.length + 1;
    _vehicles.add(
      Vehicle(
        id: id,
        make: make,
        model: model,
        year: year,
        registrationNumber: registrationNumber,
        purchaseDate: purchaseDate,
        purchasePrice: purchasePrice,
        initialMileage: initialMileage,
        nickname: nickname,
      ),
    );
    return id;
  }

  @override
  Future<void> deleteVehicle(int id) async {
    _vehicles.removeWhere((vehicle) => vehicle.id == id);
  }

  @override
  Future<List<Vehicle>> getVehicles() async =>
      List<Vehicle>.unmodifiable(_vehicles);

  @override
  Future<void> updateVehicle(Vehicle vehicle) async {
    final index = _vehicles.indexWhere((entry) => entry.id == vehicle.id);
    if (index >= 0) {
      _vehicles[index] = vehicle;
    }
  }
}

class _FakeExpenseRepository implements ExpenseRepository {
  final List<Expense> _expenses = [];

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
    final id = _expenses.length + 1;
    _expenses.add(
      Expense(
        id: id,
        vehicleId: vehicleId,
        date: date,
        amount: amount,
        category: category,
        odometer: odometer,
        vendor: vendor,
        notes: notes,
      ),
    );
    return id;
  }

  @override
  Future<void> deleteExpense(int expenseId) async {
    _expenses.removeWhere((expense) => expense.id == expenseId);
  }

  @override
  Future<List<Expense>> getAllExpenses({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return _filter(_expenses, startDate: startDate, endDate: endDate);
  }

  @override
  Future<List<Expense>> getExpensesForVehicle(
    int vehicleId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return _filter(
      _expenses.where((expense) => expense.vehicleId == vehicleId),
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    final index = _expenses.indexWhere((item) => item.id == expense.id);
    if (index >= 0) {
      _expenses[index] = expense;
    }
  }

  List<Expense> _filter(
    Iterable<Expense> source, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return source
        .where((expense) {
          if (startDate != null && expense.date.isBefore(startDate)) {
            return false;
          }
          if (endDate != null && expense.date.isAfter(endDate)) {
            return false;
          }
          return true;
        })
        .toList(growable: false);
  }
}

class _FakeSettingsRepository implements SettingsRepository {
  AppPreferences _preferences = const AppPreferences();

  @override
  Future<AppPreferences> loadPreferences() async => _preferences;

  @override
  Future<void> savePreferences(AppPreferences preferences) async {
    _preferences = preferences;
  }
}
