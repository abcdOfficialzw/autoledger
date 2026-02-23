import 'package:equatable/equatable.dart';

enum DistanceUnit { km, mi }

extension DistanceUnitX on DistanceUnit {
  String get label {
    switch (this) {
      case DistanceUnit.km:
        return 'Kilometers (km)';
      case DistanceUnit.mi:
        return 'Miles (mi)';
    }
  }

  String get shortLabel {
    switch (this) {
      case DistanceUnit.km:
        return 'km';
      case DistanceUnit.mi:
        return 'mi';
    }
  }

  double fromKilometers(num kilometers) {
    switch (this) {
      case DistanceUnit.km:
        return kilometers.toDouble();
      case DistanceUnit.mi:
        return kilometers.toDouble() * 0.621371;
    }
  }

  double fromCostPerKilometer(num costPerKilometer) {
    switch (this) {
      case DistanceUnit.km:
        return costPerKilometer.toDouble();
      case DistanceUnit.mi:
        return costPerKilometer.toDouble() / 0.621371;
    }
  }
}

class CurrencyOption extends Equatable {
  const CurrencyOption({
    required this.code,
    required this.symbol,
    required this.label,
  });

  final String code;
  final String symbol;
  final String label;

  static const usd = CurrencyOption(
    code: 'USD',
    symbol: r'$',
    label: 'US Dollar',
  );
  static const eur = CurrencyOption(code: 'EUR', symbol: '€', label: 'Euro');
  static const gbp = CurrencyOption(
    code: 'GBP',
    symbol: '£',
    label: 'British Pound',
  );
  static const kes = CurrencyOption(
    code: 'KES',
    symbol: 'KSh',
    label: 'Kenyan Shilling',
  );
  static const zar = CurrencyOption(
    code: 'ZAR',
    symbol: 'R',
    label: 'South African Rand',
  );

  static const values = [usd, eur, gbp, kes, zar];

  static CurrencyOption fromCodeOrDefault(String code) {
    for (final item in values) {
      if (item.code == code) {
        return item;
      }
    }
    return usd;
  }

  @override
  List<Object> get props => [code, symbol, label];
}

class AppPreferences extends Equatable {
  const AppPreferences({
    this.currencyCode = 'USD',
    this.currencySymbol = r'$',
    this.distanceUnit = DistanceUnit.km,
    this.serviceReminderEnabled = true,
    this.licenseReminderEnabled = true,
  });

  final String currencyCode;
  final String currencySymbol;
  final DistanceUnit distanceUnit;
  final bool serviceReminderEnabled;
  final bool licenseReminderEnabled;

  CurrencyOption get selectedCurrency =>
      CurrencyOption.fromCodeOrDefault(currencyCode);

  AppPreferences copyWith({
    String? currencyCode,
    String? currencySymbol,
    DistanceUnit? distanceUnit,
    bool? serviceReminderEnabled,
    bool? licenseReminderEnabled,
  }) {
    return AppPreferences(
      currencyCode: currencyCode ?? this.currencyCode,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      distanceUnit: distanceUnit ?? this.distanceUnit,
      serviceReminderEnabled:
          serviceReminderEnabled ?? this.serviceReminderEnabled,
      licenseReminderEnabled:
          licenseReminderEnabled ?? this.licenseReminderEnabled,
    );
  }

  @override
  List<Object> get props => [
    currencyCode,
    currencySymbol,
    distanceUnit,
    serviceReminderEnabled,
    licenseReminderEnabled,
  ];
}
