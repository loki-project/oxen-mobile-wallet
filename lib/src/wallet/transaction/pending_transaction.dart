import 'package:oxen_coin/transaction_history.dart' as transaction_history;
import 'package:oxen_coin/oxen_coin_structs.dart';
import 'package:oxen_wallet/src/wallet/oxen/oxen_amount_format.dart';

class PendingTransaction {
  PendingTransaction.fromTransactionDescription(
      PendingTransactionDescription transactionDescription)
      : amount = oxenAmountToString(transactionDescription.amount),
        fee = oxenAmountToString(transactionDescription.fee),
        hash = transactionDescription.hash,
        _pointerAddress = transactionDescription.pointerAddress;

  final String amount;
  final String fee;
  final String hash;

  final int _pointerAddress;

  Future<void> commit() async => transaction_history
      .commitTransactionFromPointerAddress(address: _pointerAddress);
}
