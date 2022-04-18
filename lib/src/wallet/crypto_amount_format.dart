import 'package:oxen_wallet/l10n.dart';

class AmountDetail {
  const AmountDetail(this.index, this.fraction);

  final int index;
  final int fraction;

  static const List<AmountDetail> all = [
    AmountDetail.ultra,
    AmountDetail.detailed,
    AmountDetail.normal,
    AmountDetail.none
  ];
  static const AmountDetail ultra = AmountDetail(0, 9);
  static const AmountDetail detailed = AmountDetail(1, 4);
  static const AmountDetail normal = AmountDetail(2, 2);
  static const AmountDetail none = AmountDetail(3, 0);

  static AmountDetail deserialize(int? index) {
    if (index == null)
      return ultra;
    for (var i = 0; i < all.length; i++)
      if (all[i].index == index)
        return all[i];
    return ultra;
  }

  String getTitle(AppLocalizations l10n) {
    switch (index) {
      case 1:
        return l10n.amount_detail_detailed;
      case 2:
        return l10n.amount_detail_normal;
      case 3:
        return l10n.amount_detail_none;
      case 0:
      default:
        return l10n.amount_detail_ultra;
    }
  }
}
