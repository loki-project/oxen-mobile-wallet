import 'package:oxen_wallet/src/wallet/balance.dart';

class OxenBalance extends Balance {
  OxenBalance({required this.fullBalance, required this.unlockedBalance});

  final int fullBalance;
  final int unlockedBalance;
}
