import 'dart:ffi';
import 'package:ffi/ffi.dart';

class StakeRowPointer extends Struct {
  external Pointer<Utf8> _serviceNodeKey;

  @Uint64()
  external int _amount;

  String get serviceNodeKey => _serviceNodeKey.toDartString();
  int get amount => _amount;
}

class StakeRow {
  StakeRow(StakeRowPointer pointer) :
    amount = pointer.amount,
    serviceNodeKey = pointer.serviceNodeKey;

  int amount;
  String serviceNodeKey;
}
