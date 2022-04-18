import 'package:mobx/mobx.dart';
import 'package:oxen_wallet/src/wallet/wallet_description.dart';
import 'package:oxen_wallet/src/domain/services/wallet_list_service.dart';
import 'package:oxen_wallet/src/domain/services/wallet_service.dart';

part 'wallet_list_store.g.dart';

class WalletListStore = WalletListStoreBase with _$WalletListStore;

abstract class WalletListStoreBase with Store {
  WalletListStoreBase(
      {required WalletListService walletListService,
      required WalletService walletService})
  : _walletListService = walletListService,
    _walletService = walletService
  {
    walletListService.getAll().then((walletList) => wallets = walletList);
  }

  @observable
  List<WalletDescription> wallets = [];

  final WalletListService _walletListService;
  final WalletService _walletService;

  bool isCurrentWallet(WalletDescription wallet) =>
      _walletService.description?.name == wallet.name;

  @action
  Future<void> updateWalletList() async {
    wallets = await _walletListService.getAll();
  }

  @action
  Future<void> loadWallet(WalletDescription wallet) async {
    await _walletListService.openWallet(wallet.name);
  }

  @action
  Future<void> remove(WalletDescription wallet) async {
    await _walletListService.remove(wallet);
    await updateWalletList();
  }
}
