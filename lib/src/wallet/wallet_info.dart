import 'package:hive/hive.dart';
import 'package:oxen_wallet/src/wallet/wallet_type.dart';

part 'wallet_info.g.dart';

@HiveType(typeId: 4)
class WalletInfo extends HiveObject {
  WalletInfo(
      {required this.id,
      required this.name,
      required this.type,
      required this.isRecovery,
      required this.restoreHeight,
      required this.timestamp,
      this.hasTestnet = false});

  static const boxName = 'WalletInfo';

  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  WalletType type;

  @HiveField(3)
  bool isRecovery;

  @HiveField(4)
  int restoreHeight;

  @HiveField(5)
  int timestamp;

  @HiveField(6)
  bool hasTestnet;

  DateTime get date => DateTime.fromMillisecondsSinceEpoch(timestamp);
}
