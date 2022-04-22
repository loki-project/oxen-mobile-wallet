import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:oxen_wallet/src/domain/common/encrypt.dart';
import 'package:oxen_wallet/src/domain/common/secret_store_key.dart';
import 'package:oxen_wallet/src/domain/services/wallet_service.dart';
import 'package:oxen_wallet/src/wallet/oxen/oxen_wallets_manager.dart';
import 'package:oxen_wallet/src/wallet/wallet.dart';
import 'package:oxen_wallet/src/wallet/wallet_description.dart';
import 'package:oxen_wallet/src/wallet/wallet_info.dart';
import 'package:oxen_wallet/src/wallet/wallets_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class WalletIsExistException implements Exception {
  WalletIsExistException(this.name);

  String name;

  @override
  String toString() => 'Wallet with name $name already exists!';
}

class WalletListService {
  WalletListService(
      {required this.secureStorage,
      required this.walletInfoSource,
      WalletsManager? walletsManager,
      required this.walletService,
      required this.sharedPreferences})
  : walletsManager = walletsManager ?? OxenWalletsManager(walletInfoSource: walletInfoSource);

  final FlutterSecureStorage secureStorage;
  final WalletService walletService;
  final Box<WalletInfo> walletInfoSource;
  final SharedPreferences sharedPreferences;
  WalletsManager walletsManager;

  Future<List<WalletDescription>> getAll() async => walletInfoSource.values
      .map((info) => WalletDescription(name: info.name, type: info.type))
      .toList();

  Future create(String name, String language) async {
    if (await walletsManager.isWalletExit(name)) {
      throw WalletIsExistException(name);
    }

    if (walletService.currentWallet != null) {
      await walletService.close();
    }

    final password = Uuid().v4();
    await saveWalletPassword(password: password, walletName: name);

    final wallet = await walletsManager.create(name, password, language);

    await onWalletChange(wallet);
  }

  Future restoreFromSeed(String name, String seed, int restoreHeight) async {
    if (await walletsManager.isWalletExit(name)) {
      throw WalletIsExistException(name);
    }

    if (walletService.currentWallet != null) {
      await walletService.close();
    }

    final password = Uuid().v4();
    await saveWalletPassword(password: password, walletName: name);

    final wallet = await walletsManager.restoreFromSeed(
        name, password, seed, restoreHeight);

    await onWalletChange(wallet);
  }

  Future restoreFromKeys(String name, String language, int restoreHeight,
      String address, String viewKey, String spendKey) async {
    if (await walletsManager.isWalletExit(name)) {
      throw WalletIsExistException(name);
    }

    if (walletService.currentWallet != null) {
      await walletService.close();
    }

    final password = Uuid().v4();
    await saveWalletPassword(password: password, walletName: name);

    final wallet = await walletsManager.restoreFromKeys(
        name, password, language, restoreHeight, address, viewKey, spendKey);

    await onWalletChange(wallet);
  }

  Future openWallet(String name) async {
    if (walletService.currentWallet != null) {
      await walletService.close();
    }

    final password = await getWalletPassword(walletName: name);
    final wallet = await walletsManager.openWallet(name, password);

    await onWalletChange(wallet);
  }

  Future onWalletChange(Wallet wallet) async {
    walletService.currentWallet = wallet;
    final walletName = await wallet.getName();
    await sharedPreferences.setString('current_wallet_name', walletName);
  }

  Future remove(WalletDescription wallet) async =>
      await walletsManager.remove(wallet);

  Future<String> getWalletPassword({required String walletName}) async {
    final key = generateStoreKeyFor(
        key: SecretStoreKey.moneroWalletPassword, walletName: walletName);
    final encodedPassword = await secureStorage.read(key: key);

    return decodeWalletPassword(password: encodedPassword!);
  }

  Future saveWalletPassword({required String walletName, required String password}) async {
    final key = generateStoreKeyFor(
        key: SecretStoreKey.moneroWalletPassword, walletName: walletName);
    final encodedPassword = encodeWalletPassword(password: password);

    await secureStorage.write(key: key, value: encodedPassword);
  }
}
