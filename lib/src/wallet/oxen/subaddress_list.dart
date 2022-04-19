import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:oxen_coin/subaddress_list.dart' as subaddress_list;
import 'package:oxen_wallet/src/wallet/oxen/subaddress.dart';

class SubaddressList {
  SubaddressList() :
    _isRefreshing = false,
    _isUpdating = false,
    _subaddress = BehaviorSubject<List<Subaddress>>();

  Stream<List<Subaddress>> get subaddresses => _subaddress.stream;

  final BehaviorSubject<List<Subaddress>> _subaddress;
  bool _isRefreshing;
  bool _isUpdating;

  Future update({required int accountIndex}) async {
    if (_isUpdating) {
      return;
    }

    try {
      _isUpdating = true;
      await refresh(accountIndex: accountIndex);
      final subaddresses = getAll();
      _subaddress.add(subaddresses);
      _isUpdating = false;
    } catch (e) {
      _isUpdating = false;
      rethrow;
    }
  }

  List<Subaddress> getAll() {
    return subaddress_list
        .getAllSubaddresses()
        .map((subaddressRow) => Subaddress.fromRow(subaddressRow))
        .toList();
  }

  Future addSubaddress({required int accountIndex, required String label}) async {
    await subaddress_list.addSubaddress(
        accountIndex: accountIndex, label: label);
    await update(accountIndex: accountIndex);
  }

  Future setLabelSubaddress(
      {required int accountIndex, required int addressIndex, required String label}) async {
    await subaddress_list.setLabelForSubaddress(
        accountIndex: accountIndex, addressIndex: addressIndex, label: label);
    await update(accountIndex: accountIndex);
  }

  Future refresh({required int accountIndex}) async {
    if (_isRefreshing) {
      return;
    }

    try {
      _isRefreshing = true;
      subaddress_list.refreshSubaddresses(accountIndex: accountIndex);
      _isRefreshing = false;
    } on PlatformException catch (e) {
      _isRefreshing = false;
      print(e);
      rethrow;
    }
  }
}
