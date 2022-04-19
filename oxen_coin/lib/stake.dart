import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:oxen_coin/oxen_coin_structs.dart';
import 'package:oxen_coin/src/native/stake.dart' as stake_native;

int countOfTransactions() => stake_native.stakeCountNative();

List<StakeRow> _getAllStakesSync(int _) {
  final size = countOfTransactions();
  final stakePointer = stake_native.stakeGetAllNative();
  final stakeAddresses = stakePointer.asTypedList(size);

  return stakeAddresses
      .map((addr) => StakeRow(Pointer<StakeRowPointer>.fromAddress(addr).ref))
      .toList();
}

Future<List<StakeRow>> getAllStakes() =>
    compute<int, List<StakeRow>>(_getAllStakesSync, 0);

PendingTransactionDescription _createStakeSync(Map args) {
  final serviceNodeKey = args['service_node_key'] as String;
  final amount = args['amount'] as String;

  return stake_native.createStakeSync(serviceNodeKey, amount);
}

Future<PendingTransactionDescription> createStake(
        String serviceNodeKey, String? amount) =>
    compute(_createStakeSync,
        {'service_node_key': serviceNodeKey, 'amount': amount});

bool canRequestUnstake(String serviceNodeKey) {
  final serviceNodeKeyPointer = serviceNodeKey.toNativeUtf8();
  final result = stake_native.canRequestUnstakeNative(serviceNodeKeyPointer) != 0;
  calloc.free(serviceNodeKeyPointer);
  return result;
}

void _submitStakeUnlockSync(Map args) {
  final serviceNodeKey = args['service_node_key'] as String;
  stake_native.submitStakeUnlockSync(serviceNodeKey);
}

Future<void> submitStakeUnlock(String serviceNodeKey) =>
    compute(_submitStakeUnlockSync, {'service_node_key': serviceNodeKey});
