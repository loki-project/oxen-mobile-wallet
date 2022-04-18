import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:oxen_wallet/src/wallet/wallet.dart';
import 'package:oxen_wallet/src/wallet/oxen/oxen_wallet.dart';
import 'package:oxen_wallet/src/wallet/oxen/account.dart';
import 'package:oxen_wallet/src/wallet/oxen/account_list.dart';
import 'package:oxen_wallet/src/domain/services/wallet_service.dart';
import 'package:oxen_wallet/src/util/validators.dart';
import 'package:oxen_wallet/l10n.dart';

part 'account_list_store.g.dart';

class AccountListStore = AccountListStoreBase with _$AccountListStore;

abstract class AccountListStoreBase with Store {
  AccountListStoreBase({required WalletService walletService}) {
    if (walletService.currentWallet != null) {
      _onWalletChanged(walletService.currentWallet!);
    }

    _onWalletChangeSubscription =
        walletService.onWalletChange.listen(_onWalletChanged);
  }

  @observable
  List<Account> accounts = [];

  @observable
  String? errorMessage;

  @observable
  bool isAccountCreating = false;

  AccountList _accountList = AccountList();
  late StreamSubscription<Wallet> _onWalletChangeSubscription;
  StreamSubscription<List<Account>>? _onAccountsChangeSubscription;

//  @override
//  void dispose() {
//    _onWalletChangeSubscription.cancel();
//
//    if (_onAccountsChangeSubscription != null) {
//      _onAccountsChangeSubscription.cancel();
//    }
//
//    super.dispose();
//  }

  void updateAccountList() {
    _accountList.refresh();
    accounts = _accountList.getAll();
  }

  Future addAccount({required String label}) async {
    try {
      isAccountCreating = true;
      await _accountList.addAccount(label: label);
      updateAccountList();
      isAccountCreating = false;
    } catch (e) {
      isAccountCreating = false;
    }
  }

  Future renameAccount({required int index, required String label}) async {
    await _accountList.setLabelSubaddress(accountIndex: index, label: label);
    updateAccountList();
  }

  Future _onWalletChanged(Wallet wallet) async {
    if (_onAccountsChangeSubscription != null) {
      await _onAccountsChangeSubscription!.cancel();
    }

    if (wallet is OxenWallet) {
      _accountList = wallet.getAccountList();
      _onAccountsChangeSubscription =
          _accountList.accounts.listen((accounts) => this.accounts = accounts);
      updateAccountList();

      return;
    }

    print('Incorrect wallet type for this operation (AccountList)');
  }

  void validateAccountName(String? value, AppLocalizations t) {
    errorMessage = hasNonWhitespace(value) ? null : t.error_text_empty;
  }
}
