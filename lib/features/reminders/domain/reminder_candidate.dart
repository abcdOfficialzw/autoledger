import 'package:equatable/equatable.dart';

enum ReminderType { service, license }

enum ReminderUrgency { upcoming, overdue }

class ReminderCandidate extends Equatable {
  const ReminderCandidate({
    required this.vehicleId,
    required this.type,
    required this.urgency,
    this.remainingDistanceKm,
    this.remainingDays,
    this.dueMileage,
    this.dueDate,
  });

  final int vehicleId;
  final ReminderType type;
  final ReminderUrgency urgency;
  final int? remainingDistanceKm;
  final int? remainingDays;
  final int? dueMileage;
  final DateTime? dueDate;

  @override
  List<Object?> get props => [
    vehicleId,
    type,
    urgency,
    remainingDistanceKm,
    remainingDays,
    dueMileage,
    dueDate,
  ];
}

class VehicleReminderSnapshot extends Equatable {
  const VehicleReminderSnapshot({this.service, this.license});

  final ReminderCandidate? service;
  final ReminderCandidate? license;

  bool get hasReminder => service != null || license != null;

  @override
  List<Object?> get props => [service, license];
}

class ReminderSummary extends Equatable {
  const ReminderSummary({
    this.totalUpcoming = 0,
    this.totalOverdue = 0,
    this.serviceUpcoming = 0,
    this.serviceOverdue = 0,
    this.licenseUpcoming = 0,
    this.licenseOverdue = 0,
  });

  final int totalUpcoming;
  final int totalOverdue;
  final int serviceUpcoming;
  final int serviceOverdue;
  final int licenseUpcoming;
  final int licenseOverdue;

  @override
  List<Object> get props => [
    totalUpcoming,
    totalOverdue,
    serviceUpcoming,
    serviceOverdue,
    licenseUpcoming,
    licenseOverdue,
  ];
}
