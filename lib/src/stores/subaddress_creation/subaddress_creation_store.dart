import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:oxen_wallet/src/wallet/wallet.dart';
import 'package:oxen_wallet/src/wallet/oxen/oxen_wallet.dart';
import 'package:oxen_wallet/src/wallet/oxen/subaddress_list.dart';
import 'package:oxen_wallet/src/domain/services/wallet_service.dart';
import 'package:oxen_wallet/src/stores/subaddress_creation/subaddress_creation_state.dart';
import 'package:oxen_wallet/src/wallet/oxen/account.dart';
import 'package:oxen_wallet/src/util/validators.dart';
import 'package:oxen_wallet/l10n.dart';

part 'subaddress_creation_store.g.dart';

class SubadrressCreationStore = SubadrressCreationStoreBase
    with _$SubadrressCreationStore;

abstract class SubadrressCreationStoreBase with Store {
  SubadrressCreationStoreBase({required WalletService walletService}) {
    if (walletService.currentWallet != null) {
      _onWalletChanged(walletService.currentWallet!);
    }

    _onWalletChangeSubscription =
        walletService.onWalletChange.listen(_onWalletChanged);
  }

  SubaddressCreationState state = SubaddressCreationStateInitial();

  @observable
  String? errorMessage;

  SubaddressList _subaddressList = SubaddressList();
  late StreamSubscription<Wallet> _onWalletChangeSubscription;
  StreamSubscription<Account>? _onAccountChangeSubscription;
  Account _account = Account(id: 0);

//  @override
//  void dispose() {
//    _onWalletChangeSubscription.cancel();
//
//    if (_onAccountChangeSubscription != null) {
//      _onAccountChangeSubscription.cancel();
//    }
//
//    super.dispose();
//  }

  Future<void> add({required String label}) async {
    try {
      state = SubaddressIsCreating();
      await _subaddressList.addSubaddress(
          accountIndex: _account.id, label: label);
      state = SubaddressCreatedSuccessfully();
    } catch (e) {
      state = SubaddressCreationFailure(error: e.toString());
    }
  }

  Future<void> _onWalletChanged(Wallet wallet) async {
    if (wallet is OxenWallet) {
      _account = wallet.account;
      _subaddressList = wallet.getSubaddress();

      _onAccountChangeSubscription =
          wallet.onAccountChange.listen((account) async {
        _account = account;
        await _subaddressList.update(accountIndex: account.id);
      });
      return;
    }

    print('Incorrect wallet type for this operation (SubaddressList)');
  }

  void validateSubaddressName(String? value, AppLocalizations l10n) {
    errorMessage = hasNonWhitespace(value) ? null : l10n.error_text_empty;
  }
}
