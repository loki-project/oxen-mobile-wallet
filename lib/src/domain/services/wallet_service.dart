import 'package:oxen_wallet/src/node/node.dart';
import 'package:oxen_wallet/src/node/sync_status.dart';
import 'package:oxen_wallet/src/wallet/balance.dart';
import 'package:oxen_wallet/src/wallet/transaction/pending_transaction.dart';
import 'package:oxen_wallet/src/wallet/transaction/transaction_history.dart';
import 'package:oxen_wallet/src/wallet/wallet.dart';
import 'package:oxen_wallet/src/wallet/wallet_description.dart';
import 'package:oxen_wallet/src/wallet/wallet_type.dart';
import 'package:rxdart/rxdart.dart';

class WalletService extends Wallet {
  WalletService() :
    _currentWallet = null,
    _syncStatus = BehaviorSubject<SyncStatus>(),
    _onBalanceChange = BehaviorSubject<Balance>(),
    _onWalletChanged = BehaviorSubject<Wallet>();

  @override
  Stream<Balance> get onBalanceChange => _onBalanceChange.stream;

  @override
  Stream<SyncStatus> get syncStatus => _syncStatus.stream;

  @override
  Stream<String> get onAddressChange => _currentWallet!.onAddressChange;

  @override
  Stream<String> get onNameChange => _currentWallet!.onNameChange;

  @override
  String get address => _currentWallet!.address;

  @override
  String get name => _currentWallet!.name;

  @override
  WalletType get walletType => _currentWallet?.walletType ?? WalletType.none;

  Stream<Wallet> get onWalletChange => _onWalletChanged.stream;

  SyncStatus get syncStatusValue => _syncStatus.value;

  Wallet? get currentWallet => _currentWallet;

  set currentWallet(Wallet? wallet) {
    _currentWallet = wallet;

    if (wallet == null) {
      return;
    }

    _currentWallet!.onBalanceChange
        .listen((wallet) => _onBalanceChange.add(wallet));
    _currentWallet!.syncStatus.listen((status) => _syncStatus.add(status));
    _onWalletChanged.add(wallet);

    final type = wallet.walletType;
    wallet.getName().then(
        (name) => description = WalletDescription(name: name, type: type));
  }

  final BehaviorSubject<Wallet> _onWalletChanged;
  final BehaviorSubject<Balance> _onBalanceChange;
  final BehaviorSubject<SyncStatus> _syncStatus;
  Wallet? _currentWallet;

  WalletDescription? description;

  @override
  Future<String> getFilename() => _currentWallet!.getFilename();

  @override
  Future<String> getName() => _currentWallet!.getName();

  @override
  Future<String> getAddress() => _currentWallet!.getAddress();

  @override
  Future<String> getSeed() => _currentWallet!.getSeed();

  @override
  Future<Map<String, String>> getKeys() => _currentWallet!.getKeys();

  @override
  Future<int> getFullBalance() => _currentWallet!.getFullBalance();

  @override
  Future<int> getUnlockedBalance() => _currentWallet!.getUnlockedBalance();

  @override
  int getCurrentHeight() => _currentWallet!.getCurrentHeight();

  @override
  bool isRefreshing() => currentWallet!.isRefreshing();

  @override
  Future<int> getNodeHeight() => _currentWallet!.getNodeHeight();

  @override
  Future<bool> isConnected() => _currentWallet!.isConnected();

  @override
  Future close() => _currentWallet!.close();

  @override
  Future<void> connectToNode(
          {required Node? node, bool useSSL = false, bool isLightWallet = false}) async {
      if (node == null)
        return;

      await _currentWallet!.connectToNode(
          node: node, useSSL: useSSL, isLightWallet: isLightWallet);
  }

  @override
  Future startSync() => _currentWallet!.startSync();

  @override
  TransactionHistory getHistory() => _currentWallet!.getHistory();

  @override
  Future<PendingTransaction> createStake({
      required String snPubkey,
      required String? amount})
    => _currentWallet!.createStake(snPubkey: snPubkey, amount: amount);

  @override
  Future<PendingTransaction> createTransaction({
      required String recipient,
      required String? amount,
      OxenTransactionPriority priority = OxenTransactionPriority.blink})
    => _currentWallet!.createTransaction(recipient: recipient, amount: amount, priority: priority);

  @override
  Future updateInfo() async => _currentWallet!.updateInfo();

  @override
  Future rescan({int restoreHeight = 0}) async =>
      _currentWallet!.rescan(restoreHeight: restoreHeight);
}
