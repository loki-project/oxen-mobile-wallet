import 'package:intl/intl.dart';
import 'package:oxen_wallet/src/wallet/crypto_amount_format.dart';

const int OXEN_DIVISOR = 1000000000;

String oxenAmountToString(int amount,
    {AmountDetail detail = AmountDetail.ultra,
    bool includeInsignificant = false}) {
  final oxenAmountFormat = NumberFormat()
    ..maximumFractionDigits = detail.fraction
    ..minimumFractionDigits = includeInsignificant ? detail.fraction : 0;
  return oxenAmountFormat.format(amount / OXEN_DIVISOR);
}
