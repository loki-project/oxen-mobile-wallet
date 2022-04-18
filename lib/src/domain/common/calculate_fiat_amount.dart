import 'package:oxen_wallet/src/wallet/oxen/oxen_amount_format.dart';

String calculateFiatAmount({required double price, required int cryptoAmount}) {
  if (price.isNaN || price <= 0.0 || cryptoAmount <= 0)
    return '0.00';
  final result = price * oxenAmountToDouble(cryptoAmount);

  if (result == 0.0) {
    return '0.00';
  }

  return result > 0.01 ? result.toStringAsFixed(2) : '< 0.01';
}
