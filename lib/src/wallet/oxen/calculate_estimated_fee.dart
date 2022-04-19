import 'package:oxen_coin/transaction_history.dart';
import 'package:oxen_wallet/src/wallet/oxen/oxen_amount_format.dart';
import 'package:oxen_wallet/src/wallet/oxen/transaction/transaction_priority.dart';

double calculateEstimatedFee({required OxenTransactionPriority priority}) {
  return oxenAmountToDouble(estimateTransactionFee(priority.raw));
}
