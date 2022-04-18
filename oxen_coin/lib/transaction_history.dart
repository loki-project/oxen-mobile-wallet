import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:oxen_coin/oxen_coin_structs.dart';
import 'package:oxen_coin/src/native/transaction_history.dart'
    as transaction_history;

void refreshTransactions() => transaction_history.transactionsRefreshNative();

int countOfTransactions() => transaction_history.transactionsCountNative();

int estimateTransactionFee(int priorityRaw, {int recipients = 1}) =>
    transaction_history.transactionEstimateFeeNative(priorityRaw, recipients);

List<TransactionInfoRow> getAllTransactions() {
  final size = transaction_history.transactionsCountNative();
  final transactionsPointer = transaction_history.transactionsGetAllNative();
  final transactionsAddresses = transactionsPointer.asTypedList(size);

  return transactionsAddresses
      .map((addr) => Pointer<TransactionInfoRow>.fromAddress(addr).ref)
      .toList();
}

void commitTransactionFromPointerAddress({required int address}) =>
    transaction_history.commitTransaction(
        transactionPointer:
            Pointer<PendingTransactionRaw>.fromAddress(address));

PendingTransactionDescription _createTransactionSync(Map args) {
  final address = args['address'] as String;
  final amount = args['amount'] as String?;
  final priorityRaw = args['priorityRaw'] as int;
  final accountIndex = args['accountIndex'] as int;

  return transaction_history.createTransactionSync(
      address: address,
      amount: amount,
      priorityRaw: priorityRaw,
      accountIndex: accountIndex);
}

Future<PendingTransactionDescription> createTransaction(
        {required String recipient,
        required String? amount,
        required int priorityRaw,
        int accountIndex = 0}) =>
    compute(_createTransactionSync, {
      'address': recipient,
      'amount': amount,
      'priorityRaw': priorityRaw,
      'accountIndex': accountIndex
    });
