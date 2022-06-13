import 'package:oxen_wallet/src/wallet/balance.dart';

class OxenBalance extends Balance {
  OxenBalance({
    required this.fullBalance,
    required this.unlockedBalance,
    required this.pendingRewards,
    required this.pendingRewardsHeight});

  final int fullBalance;
  final int unlockedBalance;
  final int pendingRewards;
  final int pendingRewardsHeight;
}
