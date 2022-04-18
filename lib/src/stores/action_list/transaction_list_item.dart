import 'package:oxen_wallet/src/wallet/transaction/transaction_info.dart';
import 'package:oxen_wallet/src/stores/action_list/action_list_item.dart';

class TransactionListItem extends ActionListItem {
  TransactionListItem({required this.transaction});

  final TransactionInfo transaction;

  @override
  DateTime get date => transaction.date;
}
