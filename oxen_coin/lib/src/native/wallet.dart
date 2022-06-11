import 'dart:async';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';
import 'package:oxen_coin/src/exceptions/setup_wallet_exception.dart';
import 'package:oxen_coin/src/oxen_api.dart';
import 'package:oxen_coin/src/util/signatures.dart';
import 'package:oxen_coin/src/util/types.dart';

int _boolToInt(bool value) => value ? 1 : 0;

final statusSyncChannel =
    BasicMessageChannel<ByteData>('oxen_coin.sync_listener', BinaryCodec());

final oxenMethodChannel = MethodChannel('oxen_coin');

final getFileNameNative = oxenApi
    .lookup<NativeFunction<get_filename>>('get_filename')
    .asFunction<GetFilename>();

final getSeedNative =
    oxenApi.lookup<NativeFunction<get_seed>>('seed').asFunction<GetSeed>();

final getAddressNative = oxenApi
    .lookup<NativeFunction<get_address>>('get_address')
    .asFunction<GetAddress>();

final getFullBalanceNative = oxenApi
    .lookup<NativeFunction<get_full_balance>>('get_full_balance')
    .asFunction<GetFullBalance>();

final getUnlockedBalanceNative = oxenApi
    .lookup<NativeFunction<get_unlocked_balance>>('get_unlocked_balance')
    .asFunction<GetUnlockedBalance>();

final getPendingRewardsNative = oxenApi
    .lookup<NativeFunction<get_pending_rewards>>('get_pending_rewards')
    .asFunction<GetPendingRewards>();

final getPendingRewardsHeightNative = oxenApi
    .lookup<NativeFunction<get_pending_rewards_height>>('get_pending_rewards_height')
    .asFunction<GetPendingRewardsHeight>();

final getCurrentHeightNative = oxenApi
    .lookup<NativeFunction<get_current_height>>('get_current_height')
    .asFunction<GetCurrentHeight>();

final getNodeHeightNative = oxenApi
    .lookup<NativeFunction<get_node_height>>('get_node_height')
    .asFunction<GetNodeHeight>();

final isRefreshingNative = oxenApi
    .lookup<NativeFunction<is_refreshing>>('is_refreshing')
    .asFunction<IsRefreshing>();

final isConnectedNative = oxenApi
    .lookup<NativeFunction<is_connected>>('is_connected')
    .asFunction<IsConnected>();

final setupNodeNative = oxenApi
    .lookup<NativeFunction<setup_node>>('setup_node')
    .asFunction<SetupNode>();

final startRefreshNative = oxenApi
    .lookup<NativeFunction<start_refresh>>('start_refresh')
    .asFunction<StartRefresh>();

final connecToNodeNative = oxenApi
    .lookup<NativeFunction<connect_to_node>>('connect_to_node')
    .asFunction<ConnectToNode>();

final setRefreshFromBlockHeightNative = oxenApi
    .lookup<NativeFunction<set_refresh_from_block_height>>(
        'set_refresh_from_block_height')
    .asFunction<SetRefreshFromBlockHeight>();

final setRecoveringFromSeedNative = oxenApi
    .lookup<NativeFunction<set_recovering_from_seed>>(
        'set_recovering_from_seed')
    .asFunction<SetRecoveringFromSeed>();

final storeNative =
    oxenApi.lookup<NativeFunction<store_c>>('store').asFunction<Store>();

final setListenerNative =
    oxenApi.lookupFunction<Void Function(), void Function()>('set_listener');

final getSyncingHeightNative = oxenApi
    .lookup<NativeFunction<get_syncing_height>>('get_syncing_height')
    .asFunction<GetSyncingHeight>();

final isNeededToRefreshNative = oxenApi
    .lookup<NativeFunction<is_needed_to_refresh>>('is_needed_to_refresh')
    .asFunction<IsNeededToRefresh>();

final isNewTransactionExistNative = oxenApi
    .lookup<NativeFunction<is_new_transaction_exist>>(
        'is_new_transaction_exist')
    .asFunction<IsNewTransactionExist>();

final getSecretViewKeyNative = oxenApi
    .lookup<NativeFunction<secret_view_key>>('secret_view_key')
    .asFunction<SecretViewKey>();

final getPublicViewKeyNative = oxenApi
    .lookup<NativeFunction<public_view_key>>('public_view_key')
    .asFunction<PublicViewKey>();

final getSecretSpendKeyNative = oxenApi
    .lookup<NativeFunction<secret_spend_key>>('secret_spend_key')
    .asFunction<SecretSpendKey>();

final getPublicSpendKeyNative = oxenApi
    .lookup<NativeFunction<public_spend_key>>('public_spend_key')
    .asFunction<PublicSpendKey>();

final closeCurrentWalletNative = oxenApi
    .lookup<NativeFunction<close_current_wallet>>('close_current_wallet')
    .asFunction<CloseCurrentWallet>();

final onStartupNative = oxenApi
    .lookup<NativeFunction<on_startup>>('on_startup')
    .asFunction<OnStartup>();

final rescanBlockchainAsyncNative = oxenApi
    .lookup<NativeFunction<rescan_blockchain>>('rescan_blockchain')
    .asFunction<RescanBlockchainAsync>();

int getNodeHeightSync() => getNodeHeightNative();

bool isRefreshingSync() => isRefreshingNative() != 0;

bool isConnectedSync() => isConnectedNative() != 0;

bool setupNodeSync(
    {required String address,
    String? login,
    String? password,
    bool useSSL = false,
    bool isLightWallet = false}) {
  final addressPointer = address.toNativeUtf8();
  Pointer<Utf8> loginPointer = nullptr;
  Pointer<Utf8> passwordPointer = nullptr;

  if (login != null)
    loginPointer = login.toNativeUtf8();

  if (password != null)
    passwordPointer = password.toNativeUtf8();

  final isSetupNode = setupNodeNative(
          addressPointer,
          loginPointer,
          passwordPointer,
          _boolToInt(useSSL),
          _boolToInt(isLightWallet));

  calloc.free(addressPointer);
  if (loginPointer != nullptr)
    calloc.free(loginPointer);
  if (passwordPointer != nullptr)
    calloc.free(passwordPointer);

  if (isSetupNode.good)
    return true;

  throw SetupWalletException(message: isSetupNode.errorString());
}

void startRefreshSync() => startRefreshNative();

Future<bool> connectToNode() async => connecToNodeNative().good;

void setRefreshFromBlockHeight({required int height}) =>
    setRefreshFromBlockHeightNative(height);

void setRecoveringFromSeed({required bool isRecovery}) =>
    setRecoveringFromSeedNative(_boolToInt(isRecovery));

void storeSync() {
  final pathPointer = ''.toNativeUtf8();
  storeNative(pathPointer);
  calloc.free(pathPointer);
}
