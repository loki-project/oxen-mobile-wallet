import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

Future<List<int>> getEncryptionKey(
    {required String forKey, required FlutterSecureStorage secureStorage}) async {
  final keyFromStorage = await secureStorage.read(key: forKey);
  List<int> key;

  if (keyFromStorage == null) {
    key = Hive.generateSecureKey();
    final keyToStorage = key.join(',');
    await secureStorage.write(key: forKey, value: keyToStorage);
  } else {
    key = keyFromStorage.split(',').map((i) => int.parse(i)).toList();
  }

  return key;
}
