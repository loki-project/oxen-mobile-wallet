import 'package:mobx/mobx.dart';
import 'package:oxen_wallet/src/domain/common/fiat_currency.dart';

part 'price_store.g.dart';

class PriceStore = PriceStoreBase with _$PriceStore;

abstract class PriceStoreBase with Store {
  PriceStoreBase() : prices = ObservableMap();

  static String generateSymbolForFiat({required FiatCurrency fiat}) =>
      'OXEN' + fiat.toString().toUpperCase();

  @observable
  ObservableMap<String, double> prices;

  @action
  void changePriceForFiat(
      {required FiatCurrency fiat, required double price}) {
    final symbol = generateSymbolForFiat(fiat: fiat);
    prices[symbol] = price;
  }
}
