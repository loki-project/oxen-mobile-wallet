import 'package:oxen_wallet/src/wallet/oxen/oxen_amount_format.dart';
import 'package:oxen_coin/oxen_coin_structs.dart';
import 'package:oxen_wallet/src/util/parseBoolFromString.dart';
import 'package:oxen_wallet/src/wallet/transaction/transaction_direction.dart';
import 'package:oxen_wallet/src/domain/common/format_amount.dart';

class TransactionInfo {
//  TransactionInfo(this.id, this.height, this.direction, this.date,
//      this.isPending, this.amount, this.accountIndex);

  TransactionInfo.fromMap(Map map)
      : id = (map['hash'] ?? '') as String,
        height = (map['height'] ?? 0) as int,
        direction =
            parseTransactionDirectionFromNumber(map['direction'] as String?) ??
                TransactionDirection.incoming,
        date = DateTime.fromMillisecondsSinceEpoch(
            (int.tryParse(map['timestamp'] as String? ?? '0') ?? 0) * 1000),
        isPending = parseBoolFromString(map['isPending'] as String?),
        isStake = parseBoolFromString(map['isStake'] as String?),
        amount = (map['amount'] ?? 0) as int,
        accountIndex = int.tryParse(map['accountIndex'] as String? ?? '0') ?? 0;

  TransactionInfo.fromRow(TransactionInfoRow row)
      : id = row.getHash(),
        height = row.blockHeight,
        direction = parseTransactionDirectionFromInt(row.direction) ??
            TransactionDirection.incoming,
        date = DateTime.fromMillisecondsSinceEpoch(row.getDatetime() * 1000),
        isPending = row.isPending != 0,
        isStake = row.isStake != 0,
        amount = row.getAmount(),
        accountIndex = row.subaddrAccount;

  final String id;
  final int height;
  final TransactionDirection direction;
  final DateTime date;
  final int accountIndex;
  final bool isPending;
  final bool isStake;
  final int amount;
  String? recipientAddress;

  String? _fiatAmount;

  String amountFormatted() => '${oxenAmountToString(amount)} OXEN';

  String fiatAmount() => _fiatAmount ?? '';

  void changeFiatAmount(String amount) => _fiatAmount = formatAmount(amount);
}
