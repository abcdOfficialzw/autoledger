import 'package:isar/isar.dart';

import '../../expenses/data/models/expense_isar.dart';
import '../domain/vehicle.dart';
import '../domain/vehicle_repository.dart';
import 'models/vehicle_isar.dart';

class IsarVehicleRepository implements VehicleRepository {
  IsarVehicleRepository(this._isar);

  final Isar _isar;

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
    final vehicle = VehicleIsar()
      ..make = make.trim()
      ..model = model.trim()
      ..year = year
      ..registrationNumber = registrationNumber.trim()
      ..purchaseDate = purchaseDate
      ..purchasePrice = purchasePrice
      ..initialMileage = initialMileage
      ..nickname = nickname?.trim();

    return _isar.writeTxn(() => _isar.vehicleIsars.put(vehicle));
  }

  @override
  Future<void> deleteVehicle(int id) async {
    await _isar.writeTxn(() async {
      await _isar.expenseIsars.filter().vehicleIdEqualTo(id).deleteAll();
      await _isar.vehicleIsars.delete(id);
    });
  }

  @override
  Future<List<Vehicle>> getVehicles() async {
    final records = await _isar.vehicleIsars.where().sortByMake().findAll();
    return records.map((record) => record.toDomain()).toList(growable: false);
  }

  @override
  Future<void> updateVehicle(Vehicle vehicle) async {
    await _isar.writeTxn(() => _isar.vehicleIsars.put(vehicle.toIsar()));
  }
}
