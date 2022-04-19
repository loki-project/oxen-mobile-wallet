import 'package:hive/hive.dart';

part 'wallet_type.g.dart';

@HiveType(typeId: 5)
enum WalletType {
  @HiveField(0)
  monero,

  @HiveField(1)
  oxen,

  @HiveField(2)
  none
}

int serializeToInt(WalletType type) {
  switch (type) {
    case WalletType.monero:
      return 0;
    case WalletType.oxen:
      return 1;
    default:
      return -1;
  }
}

WalletType? deserializeToInt(int raw) {
  switch (raw) {
    case 0:
      return WalletType.monero;
    case 1:
      return WalletType.oxen;
    default:
      return null;
  }
}

String? walletTypeToString(WalletType type) {
  switch (type) {
    case WalletType.monero:
      return 'Monero';
    case WalletType.oxen:
      return 'Oxen';
    default:
      return '';
  }
}
