import 'dart:io';

abstract class CsvExportService {
  Future<File> exportAllExpensesCsv();

  Future<File> exportVehicleExpensesCsv(int vehicleId);
}
