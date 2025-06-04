import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final _currencyFormat = NumberFormat.currency(
    symbol: 'R',
    decimalDigits: 2,
    locale: 'en_ZA',
  );

  static String format(double amount) {
    return _currencyFormat.format(amount);
  }

  static String formatWithoutSymbol(double amount) {
    return _currencyFormat.format(amount).replaceAll('R', '').trim();
  }

  static double parse(String value) {
    value = value.replaceAll('R', '').trim();
    return double.parse(value);
  }
}
