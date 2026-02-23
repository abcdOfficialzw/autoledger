import 'package:isar/isar.dart';

import '../../domain/vehicle.dart';

part 'vehicle_isar.g.dart';

@collection
class VehicleIsar {
  Id id = Isar.autoIncrement;

  String make = '';
  String model = '';
  int year = 0;

  @Index(unique: true, replace: true)
  String registrationNumber = '';

  DateTime purchaseDate = DateTime.now();
  double purchasePrice = 0;
  int initialMileage = 0;
  String? nickname;
  int? serviceIntervalKm;
  int? lastServiceMileage;
  DateTime? lastServiceDate;
  DateTime? licenseExpiryDate;
}

extension VehicleIsarMapper on VehicleIsar {
  Vehicle toDomain() {
    return Vehicle(
      id: id,
      make: make,
      model: model,
      year: year,
      registrationNumber: registrationNumber,
      purchaseDate: purchaseDate,
      purchasePrice: purchasePrice,
      initialMileage: initialMileage,
      nickname: nickname,
      serviceIntervalKm: serviceIntervalKm,
      lastServiceMileage: lastServiceMileage,
      lastServiceDate: lastServiceDate,
      licenseExpiryDate: licenseExpiryDate,
    );
  }
}

extension VehicleMapper on Vehicle {
  VehicleIsar toIsar() {
    return VehicleIsar()
      ..id = id
      ..make = make
      ..model = model
      ..year = year
      ..registrationNumber = registrationNumber
      ..purchaseDate = purchaseDate
      ..purchasePrice = purchasePrice
      ..initialMileage = initialMileage
      ..nickname = nickname
      ..serviceIntervalKm = serviceIntervalKm
      ..lastServiceMileage = lastServiceMileage
      ..lastServiceDate = lastServiceDate
      ..licenseExpiryDate = licenseExpiryDate;
  }
}
