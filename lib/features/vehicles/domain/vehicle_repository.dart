import 'vehicle.dart';

abstract class VehicleRepository {
  Future<List<Vehicle>> getVehicles();

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
  });

  Future<void> updateVehicle(Vehicle vehicle);

  Future<void> deleteVehicle(int id);
}
