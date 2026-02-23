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

  String get displayName {
    final nick = nickname?.trim();
    if (nick != null && nick.isNotEmpty) {
      return nick;
    }
    return '$make $model';
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
  ];
}
