import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oxen_wallet/src/domain/common/secret_store_key.dart';
import 'package:oxen_wallet/src/domain/common/encrypt.dart';

class UserService {
  UserService({required this.sharedPreferences, required this.secureStorage});

  final FlutterSecureStorage secureStorage;
  final SharedPreferences sharedPreferences;

  Future setPassword(String password) async {
    final key = generateStoreKeyFor(key: SecretStoreKey.pinCodePassword);

    try {
      final encodedPassword = encodedPinCode(pin: password);

      await secureStorage.write(key: key, value: encodedPassword);
    } catch (e) {
      print(e);
    }
  }

  Future<bool> canAuthenticate() async {
    final key = generateStoreKeyFor(key: SecretStoreKey.pinCodePassword);
    final sharedPreferences = await SharedPreferences.getInstance();
    final walletName = sharedPreferences.getString('current_wallet_name');
    if (!(walletName?.isNotEmpty ?? false))
      return false;

    String? password;
    try {
      password = await secureStorage.read(key: key);
    } catch (e) {
      print(e);
    }
    return password?.isNotEmpty ?? false;
  }

  Future<bool> authenticate(String pin) async {
    final key = generateStoreKeyFor(key: SecretStoreKey.pinCodePassword);
    final encodedPin = await secureStorage.read(key: key);
    if (encodedPin == null)
      return false;
    final decodedPin = decodedPinCode(pin: encodedPin);

    return decodedPin == pin;
  }
}
