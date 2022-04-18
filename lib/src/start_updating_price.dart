import 'dart:async';
import 'package:oxen_wallet/src/domain/common/fiat_currency.dart';
import 'package:flutter/foundation.dart';
import 'package:oxen_wallet/src/domain/common/fetch_price.dart';
import 'package:oxen_wallet/src/stores/price/price_store.dart';
import 'package:oxen_wallet/src/stores/settings/settings_store.dart';

bool _startedUpdatingPrice = false;

Future<double> _updatePrice(Map args) async => await fetchPriceFor(
    fiat: args['fiat'] as FiatCurrency);

Future<double> updatePrice(Map args) async => compute(_updatePrice, args);

Future<void> startUpdatingPrice(
    {required SettingsStore settingsStore, required PriceStore priceStore}) async {
  if (_startedUpdatingPrice || !settingsStore.enableFiatCurrency) {
    return;
  }

  _startedUpdatingPrice = true;

  final price = await updatePrice(
      <String, dynamic>{'fiat': settingsStore.fiatCurrency});
  priceStore.changePriceForFiat(
      fiat: settingsStore.fiatCurrency, price: price);

  Timer.periodic(Duration(seconds: 30), (_) async {
    final price = await updatePrice(
        <String, dynamic>{'fiat': settingsStore.fiatCurrency});
    priceStore.changePriceForFiat(
        fiat: settingsStore.fiatCurrency, price: price);
  });
}
