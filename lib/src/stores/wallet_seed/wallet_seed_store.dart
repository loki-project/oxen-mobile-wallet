import 'package:mobx/mobx.dart';
import 'package:oxen_wallet/src/domain/services/wallet_service.dart';

part 'wallet_seed_store.g.dart';

class WalletSeedStore = WalletSeedStoreBase with _$WalletSeedStore;

abstract class WalletSeedStoreBase with Store {
  WalletSeedStoreBase({required WalletService walletService}) {
    if (walletService.currentWallet != null) {
      walletService.getSeed().then((seed) => this.seed = seed);
      walletService.getName().then((name) => this.name = name);
    }
  }

  @observable
  String name = '';

  @observable
  String seed = '';
}
