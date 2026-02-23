import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../../vehicles/domain/vehicle.dart';
import '../../../vehicles/domain/vehicle_repository.dart';
import '../../domain/expense.dart';
import '../../domain/expense_repository.dart';
import '../../domain/services/csv_export_service.dart';

class LocalCsvExportService implements CsvExportService {
  LocalCsvExportService(this._expenseRepository, this._vehicleRepository);

  final ExpenseRepository _expenseRepository;
  final VehicleRepository _vehicleRepository;

  static const _header = 'vehicle,date,category,amount,odometer,vendor,notes';

  @override
  Future<File> exportAllExpensesCsv() async {
    final vehicles = await _vehicleRepository.getVehicles();
    final expenses = await _expenseRepository.getAllExpenses();
    return _writeCsvFile(
      fileName: _buildFileName('all_vehicles'),
      expenses: expenses,
      vehicles: vehicles,
    );
  }

  @override
  Future<File> exportVehicleExpensesCsv(int vehicleId) async {
    final vehicles = await _vehicleRepository.getVehicles();
    final expenses = await _expenseRepository.getExpensesForVehicle(vehicleId);
    final vehicleName = vehicles
        .firstWhere(
          (vehicle) => vehicle.id == vehicleId,
          orElse: () => Vehicle(
            id: 0,
            make: 'Unknown',
            model: 'Vehicle',
            year: 0,
            registrationNumber: '',
            purchaseDate: DateTime(1970),
            purchasePrice: 0,
            initialMileage: 0,
          ),
        )
        .displayName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');

    return _writeCsvFile(
      fileName: _buildFileName(vehicleName.isEmpty ? 'vehicle' : vehicleName),
      expenses: expenses,
      vehicles: vehicles,
    );
  }

  Future<File> _writeCsvFile({
    required String fileName,
    required List<Expense> expenses,
    required List<Vehicle> vehicles,
  }) async {
    final directory = await getApplicationDocumentsDirectory();
    final vehicleNames = {
      for (final vehicle in vehicles) vehicle.id: vehicle.displayName,
    };

    final rows = <String>[
      _header,
      ...expenses.map((expense) {
        final fields = <String>[
          vehicleNames[expense.vehicleId] ?? 'Unknown Vehicle',
          DateFormat('yyyy-MM-dd').format(expense.date),
          expense.category.label,
          expense.amount.toStringAsFixed(2),
          expense.odometer?.toString() ?? '',
          expense.vendor ?? '',
          expense.notes ?? '',
        ];
        return fields.map(_escapeCsv).join(',');
      }),
    ];

    final file = File('${directory.path}/$fileName');
    return file.writeAsString('${rows.join('\n')}\n');
  }

  String _buildFileName(String scope) {
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    return 'auto_ledger_${scope}_$timestamp.csv';
  }

  String _escapeCsv(String value) {
    final escaped = value.replaceAll('"', '""');
    if (escaped.contains(',') ||
        escaped.contains('"') ||
        escaped.contains('\n')) {
      return '"$escaped"';
    }
    return escaped;
  }
}
