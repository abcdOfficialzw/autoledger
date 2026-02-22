import 'package:equatable/equatable.dart';

import '../../domain/vehicle.dart';

enum VehicleStatus { initial, loading, success, failure }

class VehicleState extends Equatable {
  const VehicleState({
    this.status = VehicleStatus.initial,
    this.vehicles = const [],
    this.errorMessage,
  });

  final VehicleStatus status;
  final List<Vehicle> vehicles;
  final String? errorMessage;

  VehicleState copyWith({
    VehicleStatus? status,
    List<Vehicle>? vehicles,
    String? errorMessage,
  }) {
    return VehicleState(
      status: status ?? this.status,
      vehicles: vehicles ?? this.vehicles,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, vehicles, errorMessage];
}
