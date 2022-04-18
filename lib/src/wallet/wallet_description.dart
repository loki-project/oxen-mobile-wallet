import 'package:oxen_wallet/src/wallet/wallet_type.dart';

class WalletDescription {
  WalletDescription({required this.name, required this.type});
  
  final String name;
  final WalletType type;
}
