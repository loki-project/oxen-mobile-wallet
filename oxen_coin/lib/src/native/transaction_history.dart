import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:oxen_coin/oxen_coin_structs.dart';
import 'package:oxen_coin/src/exceptions/creation_transaction_exception.dart';
import 'package:oxen_coin/src/oxen_api.dart';
import 'package:oxen_coin/src/util/signatures.dart';
import 'package:oxen_coin/src/util/types.dart';

final transactionsRefreshNative = oxenApi
    .lookup<NativeFunction<transactions_refresh>>('transactions_refresh')
    .asFunction<TransactionsRefresh>();

final transactionsCountNative = oxenApi
    .lookup<NativeFunction<transactions_count>>('transactions_count')
    .asFunction<TransactionsCount>();

final transactionsGetAllNative = oxenApi
    .lookup<NativeFunction<transactions_get_all>>('transactions_get_all')
    .asFunction<TransactionsGetAll>();

final transactionCreateNative = oxenApi
    .lookup<NativeFunction<transaction_create>>('transaction_create')
    .asFunction<TransactionCreate>();

final transactionCommitNative = oxenApi
    .lookup<NativeFunction<transaction_commit>>('transaction_commit')
    .asFunction<TransactionCommit>();

final transactionEstimateFeeNative = oxenApi
    .lookup<NativeFunction<transaction_estimate_fee>>(
        'transaction_estimate_fee')
    .asFunction<TransactionEstimateFee>();

PendingTransactionDescription createTransactionSync(
    {required String address, required String? amount, required int priorityRaw, int accountIndex = 0}) {
  final addressPointer = address.toNativeUtf8();
  final amountPointer = amount != null ? amount.toNativeUtf8() : nullptr;
  final pendingTransactionRawPointer = calloc<PendingTransactionRaw>();
  final result = transactionCreateNative(
          addressPointer,
          amountPointer,
          priorityRaw,
          accountIndex,
          pendingTransactionRawPointer);

  calloc.free(addressPointer);
  if (amountPointer != nullptr)
    calloc.free(amountPointer);

  if (result.good)
    return PendingTransactionDescription(
      amount: pendingTransactionRawPointer.ref.amount,
      fee: pendingTransactionRawPointer.ref.fee,
      hash: pendingTransactionRawPointer.ref.getHash(),
      pointerAddress: pendingTransactionRawPointer.address);

  calloc.free(pendingTransactionRawPointer);
  throw CreationTransactionException(message: result.errorString());
}

void commitTransaction({required Pointer<PendingTransactionRaw> transactionPointer}) {
  final result = transactionCommitNative(transactionPointer);

  if (!result.good)
    throw CreationTransactionException(message: result.errorString());
}
