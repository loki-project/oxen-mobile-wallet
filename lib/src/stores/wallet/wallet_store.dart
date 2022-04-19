import 'dart:async';
import 'package:oxen_wallet/src/node/node.dart';
import 'package:mobx/mobx.dart';
import 'package:oxen_wallet/src/wallet/wallet.dart';
import 'package:oxen_wallet/src/wallet/oxen/account.dart';
import 'package:oxen_wallet/src/wallet/oxen/oxen_wallet.dart';
import 'package:oxen_wallet/src/wallet/oxen/subaddress.dart';
import 'package:oxen_wallet/src/domain/services/wallet_service.dart';
import 'package:oxen_wallet/src/stores/settings/settings_store.dart';
import 'package:oxen_wallet/l10n.dart';

part 'wallet_store.g.dart';

class WalletStore = WalletStoreBase with _$WalletStore;

abstract class WalletStoreBase with Store {
  WalletStoreBase({required WalletService walletService, required SettingsStore settingsStore})
  : _walletService = walletService,
    _settingsStore = settingsStore,
    name = '',
    amountValue = ''
  {
    if (_walletService.currentWallet != null) {
      _onWalletChanged(_walletService.currentWallet!);
    }

    _onWalletChangeSubscription = _walletService.onWalletChange
        .listen((wallet) async => await _onWalletChanged(wallet));
  }

  @observable
  String? address;

  @observable
  String name;

  @observable
  Subaddress subaddress = Subaddress(id: 0, address: '', label: '');

  @observable
  Account account = Account(id: 0);

  @observable
  String amountValue;

  @observable
  String? errorMessage;

  String get id => name + 'oxen';

  final WalletService _walletService;
  final SettingsStore _settingsStore;
  late StreamSubscription<Wallet> _onWalletChangeSubscription;
  StreamSubscription<Account>? _onAccountChangeSubscription;
  StreamSubscription<Subaddress>? _onSubaddressChangeSubscription;

//  @override
//  void dispose() {
//    if (_onWalletChangeSubscription != null) {
//      _onWalletChangeSubscription.cancel();
//    }
//
//    if (_onAccountChangeSubscription != null) {
//      _onAccountChangeSubscription.cancel();
//    }
//
//    if (_onSubaddressChangeSubscription != null) {
//      _onSubaddressChangeSubscription.cancel();
//    }
//
//    super.dispose();
//  }

  @action
  void setAccount(Account account) {
    final wallet = _walletService.currentWallet;

    if (wallet is OxenWallet) {
      this.account = account;
      wallet.changeAccount(account);
    }
  }

  @action
  void setSubaddress(Subaddress subaddress) {
    final wallet = _walletService.currentWallet;

    if (wallet is OxenWallet) {
      this.subaddress = subaddress;
      wallet.changeCurrentSubaddress(subaddress);
    }
  }

  @action
  Future reconnect() async =>
      await _walletService.connectToNode(node: _settingsStore.node);

  @action
  Future rescan({required int restoreHeight}) async =>
      await _walletService.rescan(restoreHeight: restoreHeight);

  @action
  Future startSync() async => await _walletService.startSync();

  @action
  Future connectToNode({required Node? node}) async =>
      await _walletService.connectToNode(node: node);

  Future _onWalletChanged(Wallet wallet) async {
    wallet.onNameChange.listen((name) => this.name = name);
    wallet.onAddressChange.listen((address) => this.address = address);

    if (wallet is OxenWallet) {
      _onAccountChangeSubscription =
          wallet.onAccountChange.listen((account) => this.account = account);
      _onSubaddressChangeSubscription = wallet.subaddress
          .listen((subaddress) => this.subaddress = subaddress);
    }
  }

  @action
  void onChangedAmountValue(String value) =>
      amountValue = value.isNotEmpty ? '?tx_amount=$value' : '';

  @action
  void validateAmount(String amount, AppLocalizations t) {
    const maxValue = 18446744073.0;
    final value = amount.replaceAll(',', '.');

    bool isValid;
    if (value.isEmpty) {
      isValid = true;
    } else {
      const pattern = '^([0-9]+([.][0-9]{0,9})?|[.][0-9]{1,9})\$';
      final regExp = RegExp(pattern);

      if (regExp.hasMatch(value)) {
        try {
          final dValue = double.parse(value);
          isValid = dValue <= maxValue;
        } catch (e) {
          isValid = false;
        }
      } else {
        isValid = false;
      }
    }

    errorMessage = isValid ? null : t.error_text_amount;
  }

  Future<bool> isConnected() async => await _walletService.isConnected();
}
