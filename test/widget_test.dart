import 'package:flutter_test/flutter_test.dart';
import 'package:motoledger/features/expenses/domain/expense.dart';
import 'package:motoledger/features/expenses/domain/expense_category.dart';
import 'package:motoledger/features/expenses/domain/expense_repository.dart';
import 'package:motoledger/features/vehicles/domain/vehicle.dart';
import 'package:motoledger/features/vehicles/domain/vehicle_repository.dart';
import 'package:motoledger/main.dart';

void main() {
  testWidgets('renders vehicles page', (WidgetTester tester) async {
    await tester.pumpWidget(
      AutoLedgerApp(
        vehicleRepository: _FakeVehicleRepository(),
        expenseRepository: _FakeExpenseRepository(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Vehicles'), findsOneWidget);
    expect(find.text('Add Vehicle'), findsOneWidget);
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
  Future<List<Vehicle>> getVehicles() async => List<Vehicle>.unmodifiable(_vehicles);

  @override
  Future<void> updateVehicle(Vehicle vehicle) async {
    final index = _vehicles.indexWhere((entry) => entry.id == vehicle.id);
    if (index >= 0) {
      _vehicles[index] = vehicle;
    }
  }
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
  Future<List<Expense>> getExpensesForVehicle(int vehicleId) async => const [];
}
