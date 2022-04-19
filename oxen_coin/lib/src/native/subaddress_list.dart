import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:oxen_coin/src/oxen_api.dart';
import 'package:oxen_coin/src/util/signatures.dart';
import 'package:oxen_coin/src/util/types.dart';

final subaddressSizeNative = oxenApi
    .lookup<NativeFunction<subaddress_size>>('subaddress_size')
    .asFunction<SubaddressSize>();

final subaddressRefreshNative = oxenApi
    .lookup<NativeFunction<subaddress_refresh>>('subaddress_refresh')
    .asFunction<SubaddressRefresh>();

final subaddressGetAllNative = oxenApi
    .lookup<NativeFunction<subaddress_get_all>>('subaddress_get_all')
    .asFunction<SubaddressGetAll>();

final subaddressAddNewNative = oxenApi
    .lookup<NativeFunction<subaddress_add_new>>('subaddress_add_row')
    .asFunction<SubaddressAddNew>();

final subaddressSetLabelNative = oxenApi
    .lookup<NativeFunction<subaddress_set_label>>('subaddress_set_label')
    .asFunction<SubaddressSetLabel>();

void addSubaddressSync({required int accountIndex, required String label}) {
  final labelPointer = label.toNativeUtf8();
  subaddressAddNewNative(accountIndex, labelPointer);
  calloc.free(labelPointer);
}

void setLabelForSubaddressSync(
    {required int accountIndex, required int addressIndex, required String label}) {
  final labelPointer = label.toNativeUtf8();

  subaddressSetLabelNative(accountIndex, addressIndex, labelPointer);
  calloc.free(labelPointer);
}
