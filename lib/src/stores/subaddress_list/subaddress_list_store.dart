import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:oxen_wallet/src/wallet/wallet.dart';
import 'package:oxen_wallet/src/wallet/oxen/oxen_wallet.dart';
import 'package:oxen_wallet/src/wallet/oxen/subaddress.dart';
import 'package:oxen_wallet/src/wallet/oxen/subaddress_list.dart';
import 'package:oxen_wallet/src/domain/services/wallet_service.dart';
import 'package:oxen_wallet/src/wallet/oxen/account.dart';

part 'subaddress_list_store.g.dart';

class SubaddressListStore = SubaddressListStoreBase with _$SubaddressListStore;

abstract class SubaddressListStoreBase with Store {
  SubaddressListStoreBase({required WalletService walletService}) :
      subaddresses = ObservableList<Subaddress>()
  {
    if (walletService.currentWallet != null) {
      _onWalletChanged(walletService.currentWallet!);
    }

    _onWalletChangeSubscription =
        walletService.onWalletChange.listen(_onWalletChanged);
  }

  @observable
  ObservableList<Subaddress> subaddresses;

  SubaddressList _subaddressList = SubaddressList();
  late StreamSubscription<Wallet> _onWalletChangeSubscription;
  StreamSubscription<List<Subaddress>>? _onSubaddressesChangeSubscription;
  StreamSubscription<Account>? _onAccountChangeSubscription;
  Account _account = Account(id: 0);

//  @override
//  void dispose() {
//    if (_onSubaddressesChangeSubscription != null) {
//      _onSubaddressesChangeSubscription.cancel();
//    }
//
//    if (_onAccountChangeSubscription != null) {
//      _onAccountChangeSubscription.cancel();
//    }
//
//    _onWalletChangeSubscription.cancel();
//    super.dispose();
//  }

  Future<void> _updateSubaddressList({required int accountIndex}) async {
    await _subaddressList.refresh(accountIndex: accountIndex);
    subaddresses = ObservableList.of(_subaddressList.getAll());
  }

  Future<void> _onWalletChanged(Wallet wallet) async {
    if (_onSubaddressesChangeSubscription != null) {
      await _onSubaddressesChangeSubscription!.cancel();
    }

    if (wallet is OxenWallet) {
      _account = wallet.account;
      _subaddressList = wallet.getSubaddress();
      _onSubaddressesChangeSubscription = _subaddressList.subaddresses
          .listen((subaddress) => subaddresses = ObservableList.of(subaddress));
      await _updateSubaddressList(accountIndex: _account.id);

      _onAccountChangeSubscription =
          wallet.onAccountChange.listen((account) async {
        _account = account;
        await _updateSubaddressList(accountIndex: account.id);
      });

      return;
    }

    print('Incorrect wallet type for this operation (SubaddressList)');
  }
}
