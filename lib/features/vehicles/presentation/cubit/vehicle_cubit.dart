import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/vehicle.dart';
import '../../domain/vehicle_repository.dart';
import 'vehicle_state.dart';

class VehicleCubit extends Cubit<VehicleState> {
  VehicleCubit(this._vehicleRepository) : super(const VehicleState());

  final VehicleRepository _vehicleRepository;

  Future<void> loadVehicles() async {
    emit(state.copyWith(status: VehicleStatus.loading));
    try {
      final vehicles = await _vehicleRepository.getVehicles();
      emit(
        state.copyWith(
          status: VehicleStatus.success,
          vehicles: vehicles,
          errorMessage: null,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: VehicleStatus.failure,
          errorMessage: 'Failed to load vehicles.',
        ),
      );
    }
  }

  Future<void> addVehicle({
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
  }) async {
    try {
      await _vehicleRepository.createVehicle(
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
      await loadVehicles();
    } catch (_) {
      emit(
        state.copyWith(
          status: VehicleStatus.failure,
          errorMessage: 'Unable to save vehicle. Registration must be unique.',
        ),
      );
    }
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    try {
      await _vehicleRepository.updateVehicle(vehicle);
      await loadVehicles();
    } catch (_) {
      emit(
        state.copyWith(
          status: VehicleStatus.failure,
          errorMessage: 'Unable to update vehicle.',
        ),
      );
    }
  }

  Future<void> deleteVehicle(int id) async {
    try {
      await _vehicleRepository.deleteVehicle(id);
      await loadVehicles();
    } catch (_) {
      emit(
        state.copyWith(
          status: VehicleStatus.failure,
          errorMessage: 'Unable to delete vehicle.',
        ),
      );
    }
  }
}
