import 'package:equatable/equatable.dart';

class Vehicle extends Equatable {
  const Vehicle({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.registrationNumber,
    required this.purchaseDate,
    required this.purchasePrice,
    required this.initialMileage,
    this.nickname,
    this.serviceIntervalKm,
    this.lastServiceMileage,
    this.lastServiceDate,
    this.licenseExpiryDate,
    this.serviceReminderSnoozedUntil,
    this.serviceReminderRescheduledMileage,
    this.serviceReminderRescheduledDate,
    this.serviceReminderLastDoneAt,
    this.licenseReminderSnoozedUntil,
    this.licenseReminderRescheduledDate,
    this.licenseReminderLastDoneAt,
  });

  final int id;
  final String make;
  final String model;
  final int year;
  final String registrationNumber;
  final DateTime purchaseDate;
  final double purchasePrice;
  final int initialMileage;
  final String? nickname;
  final int? serviceIntervalKm;
  final int? lastServiceMileage;
  final DateTime? lastServiceDate;
  final DateTime? licenseExpiryDate;
  final DateTime? serviceReminderSnoozedUntil;
  final int? serviceReminderRescheduledMileage;
  final DateTime? serviceReminderRescheduledDate;
  final DateTime? serviceReminderLastDoneAt;
  final DateTime? licenseReminderSnoozedUntil;
  final DateTime? licenseReminderRescheduledDate;
  final DateTime? licenseReminderLastDoneAt;

  String get displayName {
    final nick = nickname?.trim();
    if (nick != null && nick.isNotEmpty) {
      return nick;
    }
    return '$make $model';
  }

  Vehicle copyWith({
    String? make,
    String? model,
    int? year,
    String? registrationNumber,
    DateTime? purchaseDate,
    double? purchasePrice,
    int? initialMileage,
    String? nickname,
    bool clearNickname = false,
    int? serviceIntervalKm,
    bool clearServiceIntervalKm = false,
    int? lastServiceMileage,
    bool clearLastServiceMileage = false,
    DateTime? lastServiceDate,
    bool clearLastServiceDate = false,
    DateTime? licenseExpiryDate,
    bool clearLicenseExpiryDate = false,
    DateTime? serviceReminderSnoozedUntil,
    bool clearServiceReminderSnoozedUntil = false,
    int? serviceReminderRescheduledMileage,
    bool clearServiceReminderRescheduledMileage = false,
    DateTime? serviceReminderRescheduledDate,
    bool clearServiceReminderRescheduledDate = false,
    DateTime? serviceReminderLastDoneAt,
    bool clearServiceReminderLastDoneAt = false,
    DateTime? licenseReminderSnoozedUntil,
    bool clearLicenseReminderSnoozedUntil = false,
    DateTime? licenseReminderRescheduledDate,
    bool clearLicenseReminderRescheduledDate = false,
    DateTime? licenseReminderLastDoneAt,
    bool clearLicenseReminderLastDoneAt = false,
  }) {
    return Vehicle(
      id: id,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      initialMileage: initialMileage ?? this.initialMileage,
      nickname: clearNickname ? null : (nickname ?? this.nickname),
      serviceIntervalKm: clearServiceIntervalKm
          ? null
          : (serviceIntervalKm ?? this.serviceIntervalKm),
      lastServiceMileage: clearLastServiceMileage
          ? null
          : (lastServiceMileage ?? this.lastServiceMileage),
      lastServiceDate: clearLastServiceDate
          ? null
          : (lastServiceDate ?? this.lastServiceDate),
      licenseExpiryDate: clearLicenseExpiryDate
          ? null
          : (licenseExpiryDate ?? this.licenseExpiryDate),
      serviceReminderSnoozedUntil: clearServiceReminderSnoozedUntil
          ? null
          : (serviceReminderSnoozedUntil ?? this.serviceReminderSnoozedUntil),
      serviceReminderRescheduledMileage: clearServiceReminderRescheduledMileage
          ? null
          : (serviceReminderRescheduledMileage ??
                this.serviceReminderRescheduledMileage),
      serviceReminderRescheduledDate: clearServiceReminderRescheduledDate
          ? null
          : (serviceReminderRescheduledDate ??
                this.serviceReminderRescheduledDate),
      serviceReminderLastDoneAt: clearServiceReminderLastDoneAt
          ? null
          : (serviceReminderLastDoneAt ?? this.serviceReminderLastDoneAt),
      licenseReminderSnoozedUntil: clearLicenseReminderSnoozedUntil
          ? null
          : (licenseReminderSnoozedUntil ?? this.licenseReminderSnoozedUntil),
      licenseReminderRescheduledDate: clearLicenseReminderRescheduledDate
          ? null
          : (licenseReminderRescheduledDate ??
                this.licenseReminderRescheduledDate),
      licenseReminderLastDoneAt: clearLicenseReminderLastDoneAt
          ? null
          : (licenseReminderLastDoneAt ?? this.licenseReminderLastDoneAt),
    );
  }

  @override
  List<Object?> get props => [
    id,
    make,
    model,
    year,
    registrationNumber,
    purchaseDate,
    purchasePrice,
    initialMileage,
    nickname,
    serviceIntervalKm,
    lastServiceMileage,
    lastServiceDate,
    licenseExpiryDate,
    serviceReminderSnoozedUntil,
    serviceReminderRescheduledMileage,
    serviceReminderRescheduledDate,
    serviceReminderLastDoneAt,
    licenseReminderSnoozedUntil,
    licenseReminderRescheduledDate,
    licenseReminderLastDoneAt,
  ];
}
