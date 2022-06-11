import 'dart:async';

import 'package:hive/hive.dart';
import 'package:oxen_coin/stake.dart' as oxen_stake;
import 'package:oxen_coin/transaction_history.dart' as transaction_history;
import 'package:oxen_coin/wallet.dart' as oxen_wallet;
import 'package:oxen_wallet/src/node/node.dart';
import 'package:oxen_wallet/src/node/sync_status.dart';
import 'package:oxen_wallet/src/wallet/balance.dart';
import 'package:oxen_wallet/src/wallet/oxen/account.dart';
import 'package:oxen_wallet/src/wallet/oxen/account_list.dart';
import 'package:oxen_wallet/src/wallet/oxen/oxen_balance.dart';
import 'package:oxen_wallet/src/wallet/oxen/subaddress.dart';
import 'package:oxen_wallet/src/wallet/oxen/subaddress_list.dart';
import 'package:oxen_wallet/src/wallet/oxen/transaction/oxen_transaction_history.dart';
import 'package:oxen_wallet/src/wallet/transaction/pending_transaction.dart';
import 'package:oxen_wallet/src/wallet/transaction/transaction_history.dart';
import 'package:oxen_wallet/src/wallet/wallet.dart';
import 'package:oxen_wallet/src/wallet/wallet_info.dart';
import 'package:oxen_wallet/src/wallet/wallet_type.dart';
import 'package:rxdart/rxdart.dart';

const oxenBlockSize = 1000;

class OxenWallet extends Wallet {
  OxenWallet({required this.walletInfoSource, required this.walletInfo}) :
    _cachedBlockchainHeight = 0,
    _name = BehaviorSubject<String>(),
    _address = BehaviorSubject<String>(),
    _syncStatus = BehaviorSubject<SyncStatus>(),
    _onBalanceChange = BehaviorSubject<OxenBalance>(),
    _account = BehaviorSubject<Account>()..add(Account(id: 0)),
    _subaddress = BehaviorSubject<Subaddress>();

  static Future<OxenWallet> createdWallet(
      {required Box<WalletInfo> walletInfoSource,
      required String name,
      bool isRecovery = false,
      int restoreHeight = 0}) async {
    const type = WalletType.oxen;
    final id = (walletTypeToString(type)?.toLowerCase() ?? 'unknown') + '_' + name;
    final walletInfo = WalletInfo(
        id: id,
        name: name,
        type: type,
        isRecovery: isRecovery,
        restoreHeight: restoreHeight,
        timestamp: DateTime.now().millisecondsSinceEpoch);
    await walletInfoSource.add(walletInfo);

    return await configured(
        walletInfo: walletInfo, walletInfoSource: walletInfoSource);
  }

  static Future<OxenWallet> load(
      Box<WalletInfo> walletInfoSource, String name, WalletType type) async {
    final id = (walletTypeToString(type)?.toLowerCase() ?? 'unknown') + '_' + name;
    final walletInfo = walletInfoSource.values.firstWhere((info) => info.id == id);
    return await configured(
        walletInfoSource: walletInfoSource, walletInfo: walletInfo);
  }

  static Future<OxenWallet> configured(
      {required Box<WalletInfo> walletInfoSource,
      required WalletInfo walletInfo}) async {
    final wallet =
        OxenWallet(walletInfoSource: walletInfoSource, walletInfo: walletInfo);

    if (walletInfo.isRecovery) {
      wallet.setRecoveringFromSeed();
      wallet.setRefreshFromBlockHeight(height: walletInfo.restoreHeight);
    }

    return wallet;
  }

  @override
  String get address => _address.value;

  @override
  String get name => _name.value;

  @override
  WalletType get walletType => WalletType.oxen;

  @override
  Stream<SyncStatus> get syncStatus => _syncStatus.stream;

  @override
  Stream<Balance> get onBalanceChange => _onBalanceChange.stream;

  @override
  Stream<String> get onNameChange => _name.stream;

  @override
  Stream<String> get onAddressChange => _address.stream;

  Stream<Account> get onAccountChange => _account.stream;

  Stream<Subaddress> get subaddress => _subaddress.stream;

  bool get isRecovery => walletInfo.isRecovery;

  Account get account => _account.value;

  Box<WalletInfo> walletInfoSource;
  WalletInfo walletInfo;

  oxen_wallet.SyncListener? _listener;
  final BehaviorSubject<Account> _account;
  final BehaviorSubject<OxenBalance> _onBalanceChange;
  final BehaviorSubject<SyncStatus> _syncStatus;
  final BehaviorSubject<String> _name;
  final BehaviorSubject<String> _address;
  final BehaviorSubject<Subaddress> _subaddress;
  int _cachedBlockchainHeight;

  TransactionHistory? _cachedTransactionHistory;
  SubaddressList? _cachedSubaddressList;
  AccountList? _cachedAccountList;
  Future<int>? _cachedGetNodeHeightOrUpdateRequest;

  @override
  Future updateInfo() async {
    _name.value = await getName();
    final acccountList = getAccountList();
    acccountList.refresh();
    _account.value = acccountList.getAll().first;
    final subaddressList = getSubaddress();
    await subaddressList.refresh(accountIndex: _account.value.id);
    final subaddresses = subaddressList.getAll();
    _subaddress.value = subaddresses.first;
    _address.value = await getAddress();
    setListeners();
  }

  @override
  Future<String> getFilename() async => oxen_wallet.getFilename();

  @override
  Future<String> getName() async => getFilename()
      .then((filename) => filename.split('/'))
      .then((splitted) => splitted.last);

  @override
  Future<String> getAddress() async => oxen_wallet.getAddress(
      accountIndex: _account.value.id, addressIndex: _subaddress.value.id);

  @override
  Future<String> getSeed() async => oxen_wallet.getSeed();

  @override
  Future<int> getFullBalance() async {
    return await oxen_wallet.getFullBalance(accountIndex: _account.value.id);
  }

  @override
  Future<int> getUnlockedBalance() async {
    return await oxen_wallet.getUnlockedBalance(accountIndex: _account.value.id);
  }

  @override
  Future<int> getPendingRewards() async {
    return await oxen_wallet.getPendingRewards();
  }

  @override
  Future<int> getPendingRewardsHeight() async {
    return await oxen_wallet.getPendingRewardsHeight();
  }

  @override
  int getCurrentHeight() => oxen_wallet.getCurrentHeight();

  @override
  bool isRefreshing() => oxen_wallet.isRefreshing();

  @override
  Future<int> getNodeHeight() async {
    _cachedGetNodeHeightOrUpdateRequest ??=
        oxen_wallet.getNodeHeight().then((value) {
      _cachedGetNodeHeightOrUpdateRequest = null;
      return value;
    });

    return _cachedGetNodeHeightOrUpdateRequest!;
  }

  @override
  Future<bool> isConnected() async => oxen_wallet.isConnected();

  @override
  Future<Map<String, String>> getKeys() async => {
        'publicViewKey': oxen_wallet.getPublicViewKey(),
        'privateViewKey': oxen_wallet.getSecretViewKey(),
        'publicSpendKey': oxen_wallet.getPublicSpendKey(),
        'privateSpendKey': oxen_wallet.getSecretSpendKey()
      };

  @override
  TransactionHistory getHistory() {
    _cachedTransactionHistory ??= OxenTransactionHistory();

    return _cachedTransactionHistory!;
  }

  SubaddressList getSubaddress() {
    _cachedSubaddressList ??= SubaddressList();

    return _cachedSubaddressList!;
  }

  AccountList getAccountList() {
    _cachedAccountList ??= AccountList();

    return _cachedAccountList!;
  }

  @override
  Future close() async {
    _listener?.stop();
    oxen_wallet.closeCurrentWallet();
    await _name.close();
    await _address.close();
    await _subaddress.close();
  }

  @override
  Future<void> connectToNode(
      {required Node node, bool useSSL = false, bool isLightWallet = false}) async {
    try {
      _syncStatus.value = ConnectingSyncStatus(getCurrentHeight());

      // Check if node is online to avoid crash
      final nodeIsOnline = await node.isOnline();
      if (!nodeIsOnline) {
        _syncStatus.value = FailedSyncStatus(getCurrentHeight());
        return;
      }

      await oxen_wallet.setupNode(
          address: node.uri,
          /*
          login: node.login,
          password: node.password,
          */
          useSSL: useSSL,
          isLightWallet: isLightWallet);
      _syncStatus.value = ConnectedSyncStatus(getCurrentHeight());
    } catch (e) {
      _syncStatus.value = FailedSyncStatus(getCurrentHeight());
      print(e);
    }
  }

  @override
  Future startSync() async {
    try {
      _setInitialHeight();
    } catch (_) {}

    try {
      _syncStatus.value = StartingSyncStatus(getCurrentHeight());
      oxen_wallet.startRefresh();
      _setListeners();
      _listener?.start();
    } catch (e) {
      _syncStatus.value = FailedSyncStatus(getCurrentHeight());
      print(e);
      rethrow;
    }
  }

  Future<int> getNodeHeightOrUpdate(int baseHeight) async {
    if (_cachedBlockchainHeight < baseHeight) {
      _cachedBlockchainHeight = await getNodeHeight();
    }

    return _cachedBlockchainHeight;
  }

  @override
  Future<PendingTransaction> createStake({
      required String snPubkey,
      required String? amount}) async {
    final transactionDescription =
    await oxen_stake.createStake(snPubkey, amount);

    return PendingTransaction.fromTransactionDescription(
        transactionDescription);
  }

  @override
  Future<PendingTransaction> createTransaction({
      required String recipient,
      required String? amount,
      OxenTransactionPriority priority = OxenTransactionPriority.blink}) async {
    final transactionDescription = await transaction_history.createTransaction(
        recipient: recipient,
        amount: amount,
        priorityRaw: priority.raw,
        accountIndex: _account.value.id);

    return PendingTransaction.fromTransactionDescription(transactionDescription);
  }

  @override
  Future rescan({int restoreHeight = 0}) async {
    _syncStatus.value = StartingSyncStatus(getCurrentHeight());
    setRefreshFromBlockHeight(height: restoreHeight);
    oxen_wallet.rescanBlockchainAsync();
    _syncStatus.value = StartingSyncStatus(getCurrentHeight());
  }

  void setRecoveringFromSeed() =>
      oxen_wallet.setRecoveringFromSeed(isRecovery: true);

  void setRefreshFromBlockHeight({required int height}) =>
      oxen_wallet.setRefreshFromBlockHeight(height: height);

  Future setAsRecovered() async {
    walletInfo.isRecovery = false;
    await walletInfo.save();
  }

  Future askForUpdateBalance() async {
    final fullBalance = await getFullBalance();
    final unlockedBalance = await getUnlockedBalance();
    final pendingRewards = await getPendingRewards();
    final pendingRewardsHeight = await getPendingRewardsHeight();
    final needToChange = !_onBalanceChange.hasValue ? true :
        _onBalanceChange.value.fullBalance != fullBalance ||
        _onBalanceChange.value.unlockedBalance != unlockedBalance ||
        _onBalanceChange.value.pendingRewards != pendingRewards ||
        _onBalanceChange.value.pendingRewardsHeight != pendingRewardsHeight;

    if (needToChange)
      _onBalanceChange.add(OxenBalance(
            fullBalance: fullBalance,
            unlockedBalance: unlockedBalance,
            pendingRewards: pendingRewards,
            pendingRewardsHeight: pendingRewardsHeight));
  }

  Future askForUpdateTransactionHistory() async {
    await getHistory().update();
  }

  void changeCurrentSubaddress(Subaddress subaddress) =>
      _subaddress.value = subaddress;

  void changeAccount(Account account) {
    _account.add(account);

    getSubaddress()
        .refresh(accountIndex: account.id)
        .then((dynamic _) => getSubaddress().getAll())
        .then((subaddresses) => _subaddress.value = subaddresses[0]);
  }

  oxen_wallet.SyncListener setListeners() =>
      oxen_wallet.setListeners(_onNewBlock, _onNewTransaction);

  Future _onNewBlock(int height, int target, bool isRefreshing) async {
    try {
      if (isRefreshing) {
        _syncStatus.add(SyncingSyncStatus(height, target));
      } else {
        await askForUpdateTransactionHistory();
        await askForUpdateBalance();

        if (target - height <= 2) {
          _syncStatus.add(SyncedSyncStatus(height));
          await oxen_wallet.store();

          if (walletInfo.isRecovery) {
            await setAsRecovered();
          }
        }
      }
    } catch (e) {
      print('new block error: $e');
    }
  }

  void _setListeners() {
    _listener?.stop();
    _listener = oxen_wallet.setListeners(_onNewBlock, _onNewTransaction);
  }

  void _setInitialHeight() {
    if (walletInfo.isRecovery) {
      return;
    }

    final currentHeight = getCurrentHeight();

    if (currentHeight <= 1) {
      final height = _getHeightByDate(walletInfo.date);
      oxen_wallet.setRecoveringFromSeed(isRecovery: true);
      oxen_wallet.setRefreshFromBlockHeight(height: height);
    }
  }

  int _getHeightDistance(DateTime date) {
    final distance =
        DateTime.now().millisecondsSinceEpoch - date.millisecondsSinceEpoch;
    final daysTmp = (distance / 86400).round();
    final days = daysTmp < 1 ? 1 : daysTmp;

    return days * 1000;
  }

  int _getHeightByDate(DateTime date) {
    final nodeHeight = oxen_wallet.getNodeHeightSync();
    final heightDistance = _getHeightDistance(date);

    if (nodeHeight <= 0) {
      return 0;
    }

    return nodeHeight - heightDistance;
  }

  Future _onNewTransaction() async {
    try {
      await askForUpdateTransactionHistory();
      await askForUpdateBalance();
    } catch (e) {
      print(e.toString());
    }
  }
}
