import 'package:intl/intl.dart';

class Formatters {
  const Formatters._();

  static final NumberFormat _number = NumberFormat.decimalPattern();
  static final NumberFormat _percent = NumberFormat.decimalPercentPattern(
    decimalDigits: 1,
  );

  static String currency(
    double value, {
    String currencyCode = 'USD',
    String currencySymbol = r'$',
  }) {
    return NumberFormat.currency(
      name: currencyCode,
      symbol: currencySymbol,
    ).format(value);
  }

  static String date(DateTime value) => DateFormat.yMMMd().format(value);

  static String number(num value) => _number.format(value);

  static String percent(double value) => _percent.format(value);
}
