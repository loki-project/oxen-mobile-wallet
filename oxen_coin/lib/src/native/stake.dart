import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:oxen_coin/oxen_coin_structs.dart';
import 'package:oxen_coin/src/exceptions/creation_transaction_exception.dart';
import 'package:oxen_coin/src/oxen_api.dart';
import 'package:oxen_coin/src/util/signatures.dart';
import 'package:oxen_coin/src/util/types.dart';

final stakeCountNative = oxenApi
    .lookup<NativeFunction<stake_count>>('stake_count')
    .asFunction<StakeCount>();

final stakeGetAllNative = oxenApi
    .lookup<NativeFunction<stake_get_all>>('stake_get_all')
    .asFunction<StakeGetAll>();

final stakeCreateNative = oxenApi
    .lookup<NativeFunction<stake_create>>('stake_create')
    .asFunction<StakeCreate>();

final canRequestUnstakeNative = oxenApi
    .lookup<NativeFunction<can_request_unstake>>('can_request_stake_unlock')
    .asFunction<CanRequestUnstake>();

final submitStakeUnlockNative = oxenApi
    .lookup<NativeFunction<submit_stake_unlock>>('submit_stake_unlock')
    .asFunction<SubmitStakeUnlock>();

PendingTransactionDescription createStakeSync(
    String serviceNodeKey, String? amount) {
  final serviceNodeKeyPointer = serviceNodeKey.toNativeUtf8();
  final amountPointer = amount != null ? amount.toNativeUtf8() : nullptr;
  final pendingTransactionRawPointer = calloc<PendingTransactionRaw>();
  final created = stakeCreateNative(serviceNodeKeyPointer, amountPointer,
          pendingTransactionRawPointer);

  calloc.free(serviceNodeKeyPointer);
  calloc.free(amountPointer);

  if (!created.good) {
    throw CreationTransactionException(message: created.errorString());
  }

  return PendingTransactionDescription(
      amount: pendingTransactionRawPointer.ref.amount,
      fee: pendingTransactionRawPointer.ref.fee,
      hash: pendingTransactionRawPointer.ref.getHash(),
      pointerAddress: pendingTransactionRawPointer.address);
}

void submitStakeUnlockSync(String serviceNodeKey) {
  final serviceNodeKeyPointer = serviceNodeKey.toNativeUtf8();
  final pendingTransactionRawPointer = calloc<PendingTransactionRaw>();
  final result = submitStakeUnlockNative(serviceNodeKeyPointer, pendingTransactionRawPointer);

  calloc.free(serviceNodeKeyPointer);

  if (!result.good)
    throw CreationTransactionException(message: result.errorString());

  calloc.free(pendingTransactionRawPointer);
}
