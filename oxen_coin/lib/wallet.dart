import 'dart:async';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:oxen_coin/src/exceptions/setup_wallet_exception.dart';
import 'package:oxen_coin/src/native/wallet.dart' as oxen_wallet;
import 'package:oxen_coin/src/util/convert_utf8_to_string.dart';

int _boolToInt(bool value) => value ? 1 : 0;

final statusSyncChannel =
    BasicMessageChannel<ByteData>('oxen_coin.sync_listener', BinaryCodec());

final oxenMethodChannel = MethodChannel('oxen_coin');

int getSyncingHeight() => oxen_wallet.getSyncingHeightNative();

bool isNeededToRefresh() => oxen_wallet.isNeededToRefreshNative() != 0;

bool isNewTransactionExist() => oxen_wallet.isNewTransactionExistNative() != 0;

String getFilename() =>
    convertUTF8ToString(pointer: oxen_wallet.getFileNameNative());

String getSeed() => convertUTF8ToString(pointer: oxen_wallet.getSeedNative());

String getAddress({int accountIndex = 0, int addressIndex = 0}) =>
    convertUTF8ToString(
        pointer: oxen_wallet.getAddressNative(accountIndex, addressIndex));

int _getFullBalanceSync(int accountIndex) =>
    oxen_wallet.getFullBalanceNative(accountIndex);

Future<int> getFullBalance({int accountIndex = 0}) =>
  compute<int, int>(_getFullBalanceSync, accountIndex);

int _getUnlockedBalanceSync(int accountIndex) =>
    oxen_wallet.getUnlockedBalanceNative(accountIndex);

Future<int> getUnlockedBalance({int accountIndex = 0}) =>
    compute<int, int>(_getUnlockedBalanceSync, accountIndex);

int getCurrentHeight() => oxen_wallet.getCurrentHeightNative();

int getNodeHeightSync() => oxen_wallet.getNodeHeightNative();

bool isRefreshingSync() => oxen_wallet.isRefreshingNative() != 0;

bool isConnectedSync() => oxen_wallet.isConnectedNative() != 0;

bool setupNodeSync(
    {required String address,
    String? login,
    String? password,
    bool useSSL = false,
    bool isLightWallet = false}) {
  final addressPointer = address.toNativeUtf8();
  final loginPointer = (login ?? '').toNativeUtf8();
  final passwordPointer = (password ?? '').toNativeUtf8();

  final isSetupNode = oxen_wallet.setupNodeNative(
          addressPointer,
          loginPointer,
          passwordPointer,
          _boolToInt(useSSL),
          _boolToInt(isLightWallet));

  calloc.free(addressPointer);
  calloc.free(loginPointer);
  calloc.free(passwordPointer);

  if (!isSetupNode.good) {
    throw SetupWalletException(message: isSetupNode.errorString());
  }

  return true;
}

void startRefreshSync() => oxen_wallet.startRefreshNative();

Future<bool> connectToNode() async => oxen_wallet.connecToNodeNative().good;

void setRefreshFromBlockHeight({required int height}) =>
    oxen_wallet.setRefreshFromBlockHeightNative(height);

void setRecoveringFromSeed({required bool isRecovery}) =>
    oxen_wallet.setRecoveringFromSeedNative(_boolToInt(isRecovery));

void closeCurrentWallet() => oxen_wallet.closeCurrentWalletNative();

String getSecretViewKey() =>
    convertUTF8ToString(pointer: oxen_wallet.getSecretViewKeyNative());

String getPublicViewKey() =>
    convertUTF8ToString(pointer: oxen_wallet.getPublicViewKeyNative());

String getSecretSpendKey() =>
    convertUTF8ToString(pointer: oxen_wallet.getSecretSpendKeyNative());

String getPublicSpendKey() =>
    convertUTF8ToString(pointer: oxen_wallet.getPublicSpendKeyNative());

class SyncListener {
  SyncListener(this.onNewBlock, this.onNewTransaction);

  void Function(int, int, double, bool) onNewBlock;
  void Function() onNewTransaction;

  Timer? _updateSyncInfoTimer;
  int _cachedBlockchainHeight = 0;
  int _lastKnownBlockHeight = 0;
  int _initialSyncHeight = 0;

  Future<int> getNodeHeightOrUpdate(int baseHeight) async {
    if (_cachedBlockchainHeight < baseHeight || _cachedBlockchainHeight == 0) {
      _cachedBlockchainHeight = await getNodeHeight();
    }

    return _cachedBlockchainHeight;
  }

  void start() {
    _cachedBlockchainHeight = 0;
    _lastKnownBlockHeight = 0;
    _initialSyncHeight = 0;
    _updateSyncInfoTimer ??=
        Timer.periodic(Duration(milliseconds: 1200), (_) async {
      // var syncHeight = getSyncingHeight();
      //
      // if (syncHeight <= 0) {
      //   syncHeight = getCurrentHeight();
      // }

      final syncHeight = getCurrentHeight();

      if (_initialSyncHeight <= 0) {
        _initialSyncHeight = syncHeight;
      }

      final bchHeight = await getNodeHeightOrUpdate(syncHeight);

      if (_lastKnownBlockHeight == syncHeight) {
        return;
      }

      _lastKnownBlockHeight = syncHeight;
      final track = bchHeight - _initialSyncHeight;
      final diff = track - (bchHeight - syncHeight);
      final ptc = diff <= 0 ? 0.0 : diff / track;
      final left = bchHeight - syncHeight;

      if (syncHeight < 0 || left < 0) {
        return;
      }

      final refreshing = isRefreshing();
      if (!refreshing) {
        if (isNewTransactionExist()) {
          onNewTransaction.call();
        }
      }

      // 1. Actual new height; 2. Blocks left to finish; 3. Progress in percents;
      onNewBlock.call(syncHeight, left, ptc, refreshing);
    });
  }

  void stop() => _updateSyncInfoTimer?.cancel();
}

SyncListener setListeners(void Function(int, int, double, bool) onNewBlock,
    void Function() onNewTransaction) {
  final listener = SyncListener(onNewBlock, onNewTransaction);
  oxen_wallet.setListenerNative();
  return listener;
}

void onStartup() => oxen_wallet.onStartupNative();

void _storeSync(Object _) => oxen_wallet.storeSync();

bool _setupNodeSync(Map args) {
  final address = args['address'] as String;
  final login = (args['login'] ?? '') as String;
  final password = (args['password'] ?? '') as String;
  final useSSL = args['useSSL'] as bool;
  final isLightWallet = args['isLightWallet'] as bool;

  return setupNodeSync(
      address: address,
      login: login,
      password: password,
      useSSL: useSSL,
      isLightWallet: isLightWallet);
}

bool _isConnected(Object _) => isConnectedSync();

bool isRefreshing() => isRefreshingSync();

int _getNodeHeight(Object _) => getNodeHeightSync();

void startRefresh() => startRefreshSync();

Future setupNode(
        {required String address,
        /*
        required String login,
        required String password,
        */
        bool useSSL = false,
        bool isLightWallet = false}) =>
    compute<Map<String, Object>, void>(_setupNodeSync, {
      'address': address,
      /*
      'login': login,
      'password': password,
      */
      'useSSL': useSSL,
      'isLightWallet': isLightWallet
    });

Future store() => compute<int, void>(_storeSync, 0);

Future<bool> isConnected() => compute(_isConnected, 0);

Future<int> getNodeHeight() => compute(_getNodeHeight, 0);

void rescanBlockchainAsync() => oxen_wallet.rescanBlockchainAsyncNative();
