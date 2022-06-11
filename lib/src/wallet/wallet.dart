import 'package:oxen_wallet/src/node/sync_status.dart';
import 'package:oxen_wallet/src/wallet/transaction/transaction_history.dart';
import 'package:oxen_wallet/src/wallet/wallet_type.dart';
import 'package:oxen_wallet/src/wallet/transaction/pending_transaction.dart';
import 'package:oxen_wallet/src/wallet/balance.dart';
import 'package:oxen_wallet/src/wallet/oxen/transaction/transaction_priority.dart';
import 'package:oxen_wallet/src/node/node.dart';

export 'package:oxen_wallet/src/wallet/oxen/transaction/transaction_priority.dart' show OxenTransactionPriority;

abstract class Wallet {
  WalletType get walletType;

  Stream<Balance> get onBalanceChange;

  Stream<SyncStatus> get syncStatus;

  Stream<String> get onNameChange;

  Stream<String> get onAddressChange;

  String get name;

  String get address;

  Future updateInfo();

  Future<String> getFilename();

  Future<String> getName();

  Future<String> getAddress();

  Future<String> getSeed();

  Future<Map<String, String>> getKeys();

  Future<int> getFullBalance();

  Future<int> getUnlockedBalance();

  Future<int> getPendingRewards();

  Future<int> getPendingRewardsHeight();

  int getCurrentHeight();

  bool isRefreshing();

  Future<int> getNodeHeight();

  Future<bool> isConnected();

  Future close();

  TransactionHistory getHistory();

  Future<void> connectToNode(
      {required Node node, bool useSSL = false, bool isLightWallet = false});

  Future startSync();

  Future<PendingTransaction> createStake({
      required String snPubkey,
      required String? amount});

  Future<PendingTransaction> createTransaction({
      required String recipient,
      required String? amount,
      OxenTransactionPriority priority = OxenTransactionPriority.blink});

  Future rescan({int restoreHeight = 0});
}
