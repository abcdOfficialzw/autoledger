import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/expenses/data/models/expense_isar.dart';
import '../../features/vehicles/data/models/vehicle_isar.dart';

class LocalDatabase {
  static const _dbName = 'auto_ledger_db';

  static Future<Isar> open() async {
    if (Isar.instanceNames.isNotEmpty) {
      final existing = Isar.getInstance(_dbName);
      if (existing != null) {
        return Future<Isar>.value(existing);
      }
    }

    final directory = await getApplicationDocumentsDirectory();
    return Isar.open(
      [VehicleIsarSchema, ExpenseIsarSchema],
      directory: directory.path,
      name: _dbName,
    );
  }
}
