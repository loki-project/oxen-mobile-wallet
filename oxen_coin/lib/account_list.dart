import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:oxen_coin/oxen_coin_structs.dart';
import 'package:oxen_coin/src/native/account_list.dart' as account_list;

void refreshAccounts() => account_list.accountRefreshNative();

List<AccountRow> getAllAccount() {
  final size = account_list.accountSizeNative();
  final accountAddressesPointer = account_list.accountGetAllNative();
  final accountAddresses = accountAddressesPointer.asTypedList(size);

  return accountAddresses
      .map((addr) => Pointer<AccountRow>.fromAddress(addr).ref)
      .toList();
}

void _addAccount(String label) => account_list.addAccountSync(label: label);

void _setLabelForAccount(Map<String, dynamic> args) {
  final label = args['label'] as String;
  final accountIndex = args['accountIndex'] as int;

  account_list.setLabelForAccountSync(label: label, accountIndex: accountIndex);
}

Future<void> addAccount({required String label}) async => compute(_addAccount, label);

Future<void> setLabelForAccount({required int accountIndex, required String label}) async =>
    compute(
        _setLabelForAccount, {'accountIndex': accountIndex, 'label': label});
