import 'package:oxen_wallet/l10n.dart';
import 'package:oxen_wallet/src/domain/common/enumerable_item.dart';

class OxenTransactionPriority extends EnumerableItem<int> with Serializable<int> {
  const OxenTransactionPriority({required int raw})
      : super(raw: raw);

  static const all = [
    OxenTransactionPriority.slow,
    OxenTransactionPriority.blink
  ];

  static const slow = OxenTransactionPriority(raw: 1);
  static const blink = OxenTransactionPriority(raw: 5);
  static const standard = blink;

  static OxenTransactionPriority deserialize({required int? raw}) {
    switch (raw) {
      case 1:
        return slow;
      case 5:
      default:
        return blink;
    }
  }

  @override
  String getTitle(AppLocalizations l10n) {
    switch (this) {
      case OxenTransactionPriority.slow:
        return l10n.transaction_priority_slow;
      case OxenTransactionPriority.blink:
      default:
        return l10n.transaction_priority_blink;
    }
  }
}
