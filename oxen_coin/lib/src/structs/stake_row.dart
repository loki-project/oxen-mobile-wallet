import 'dart:ffi';
import 'package:ffi/ffi.dart';

class StakeRowPointer extends Struct {
  external Pointer<Utf8> _serviceNodeKey;

  @Uint64()
  external int _amount;

  @Uint64()
  external int _unlock_height;

  @Bool()
  external bool _awaiting;

  @Bool()
  external bool _decommissioned;

  String get serviceNodeKey => _serviceNodeKey.toDartString();
  int get amount => _amount;
  int? get unlockHeight => _unlock_height > 0 ? _unlock_height : null;
  bool get awaiting => _awaiting;
  bool get decommissioned => _decommissioned;
}

class StakeRow {
  StakeRow(StakeRowPointer pointer) :
    amount = pointer.amount,
    serviceNodeKey = pointer.serviceNodeKey,
    unlockHeight = pointer.unlockHeight,
    awaiting = pointer.awaiting,
    decommissioned = pointer.decommissioned;

  int amount;
  String serviceNodeKey;
  int? unlockHeight;
  bool awaiting;
  bool decommissioned;
}
