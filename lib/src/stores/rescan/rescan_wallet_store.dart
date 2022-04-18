import 'package:mobx/mobx.dart';
import 'package:oxen_wallet/src/domain/services/wallet_service.dart';

part 'rescan_wallet_store.g.dart';

class RescanWalletStore = RescanWalletStoreBase with _$RescanWalletStore;

enum RescanWalletState { rescaning, none }

abstract class RescanWalletStoreBase with Store {
  RescanWalletStoreBase({required WalletService walletService}) :
      _walletService = walletService;

  @observable
  RescanWalletState state = RescanWalletState.none;

  final WalletService _walletService;

  @action
  Future rescanCurrentWallet({required int restoreHeight}) async {
    state = RescanWalletState.rescaning;
    await _walletService.rescan(restoreHeight: restoreHeight);
    state = RescanWalletState.none;
  }
}
