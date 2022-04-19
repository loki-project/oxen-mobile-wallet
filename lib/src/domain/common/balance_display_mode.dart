import 'package:oxen_wallet/l10n.dart';
import 'package:oxen_wallet/src/domain/common/enumerable_item.dart';

class BalanceDisplayMode extends EnumerableItem<int> with Serializable<int> {
  const BalanceDisplayMode({required int raw})
      : super(raw: raw);

  static const all = [
    BalanceDisplayMode.fullBalance,
    BalanceDisplayMode.availableBalance,
    BalanceDisplayMode.hiddenBalance
  ];
  static const fullBalance = BalanceDisplayMode(raw: 0);
  static const availableBalance = BalanceDisplayMode(raw: 1);
  static const hiddenBalance = BalanceDisplayMode(raw: 2);

  static BalanceDisplayMode deserialize({required int? raw}) {
    switch (raw) {
      case 0:
        return fullBalance;
      case 2:
        return hiddenBalance;
      case 1:
      default:
        return availableBalance;
    }
  }

  @override
  String getTitle(AppLocalizations l10n) {
    switch (this) {
      case BalanceDisplayMode.fullBalance:
        return l10n.oxen_full_balance;
      case BalanceDisplayMode.hiddenBalance:
        return l10n.oxen_hidden;
      case BalanceDisplayMode.availableBalance:
      default:
        return l10n.oxen_available_balance;
    }
  }
}
