import 'dart:convert';

import 'package:oxen_wallet/src/domain/common/fiat_currency.dart';
import 'package:http/http.dart';

const fiatApiAuthority = 'oxen.observer';

Future<double> fetchPriceFor({required FiatCurrency fiat}) async {
  var price = 0.0;

  try {
    final fiatStringed = fiat.toString();

    final apiPath = '/api/price/$fiatStringed';
    final uri = Uri.https(fiatApiAuthority, apiPath);
    final response = await get(uri);

    if (response.statusCode != 200) {
      return 0.0;
    }

    final responseJSON = json.decode(response.body) as Map<String, dynamic>;

    if (responseJSON.containsKey(fiatStringed.toLowerCase())) {
      price = responseJSON[fiatStringed.toLowerCase()] as double;
    }

    return price;
  } catch (e) {
    return price;
  }
}
