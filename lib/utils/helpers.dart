import 'package:currency_formatter/currency_formatter.dart';

class Helpers {
  static const CurrencyFormat vndSettings = CurrencyFormat(
    code: 'vn',
    symbol: 'vnđ',
    symbolSide: SymbolSide.right,
    thousandSeparator: '.',
    decimalSeparator: ',',
    symbolSeparator: ' ',
  );

  static String formatPrice(int amount) {
    return CurrencyFormatter.format(amount.toDouble(), vndSettings);
  }
}
