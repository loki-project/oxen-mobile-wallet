import 'package:oxen_wallet/src/wallet/oxen/oxen_amount_format.dart';
import 'package:oxen_coin/oxen_coin_structs.dart';
import 'package:oxen_wallet/src/util/parseBoolFromString.dart';
import 'package:oxen_wallet/src/wallet/transaction/transaction_direction.dart';
import 'package:oxen_wallet/src/domain/common/format_amount.dart';

class TransactionInfo {
  TransactionInfo.fromRow(TransactionInfoRow row)
      : id = row.getHash(),
        height = row.blockHeight,
        direction = parseTransactionDirectionFromInt(row.direction) ??
            TransactionDirection.incoming,
        date = DateTime.fromMillisecondsSinceEpoch(row.getDatetime() * 1000),
        isPending = row.isPending != 0,
        isStake = row.isStake != 0,
        amount = row.getAmount(),
        stakeAmount = row.isStake != 0 ? row.getTransferAmount() : null,
        fee = row.getFee(),
        accountIndex = row.subaddrAccount;

  final String id;
  final int height;
  final TransactionDirection direction;
  final DateTime date;
  final int accountIndex;
  final bool isPending;
  final bool isStake;
  final int amount;
  final int? stakeAmount;
  final int fee;
  String? recipientAddress;

  String? _fiatAmount;

  String amountFormatted({bool includeInsignificant = false})
    => '${oxenAmountToString(amount, includeInsignificant: includeInsignificant)} OXEN';

  String feeFormatted({bool includeInsignificant = false})
    => '${oxenAmountToString(fee, includeInsignificant: includeInsignificant)} OXEN';

  String? stakeFormatted({bool includeInsignificant = false})
    => isStake
        ? (stakeAmount != null ? oxenAmountToString(stakeAmount!, includeInsignificant: includeInsignificant) : '???') + ' OXEN'
        : null;

  String fiatAmount() => _fiatAmount ?? '';

  void changeFiatAmount(String amount) => _fiatAmount = formatAmount(amount);
}
