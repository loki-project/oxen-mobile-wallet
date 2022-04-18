import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:oxen_coin/src/oxen_api.dart';
import 'package:oxen_coin/src/util/signatures.dart';
import 'package:oxen_coin/src/util/types.dart';
import 'package:oxen_coin/src/exceptions/wallet_creation_exception.dart';
import 'package:oxen_coin/src/exceptions/wallet_restore_from_keys_exception.dart';
import 'package:oxen_coin/src/exceptions/wallet_restore_from_seed_exception.dart';

final createWalletNative = oxenApi
    .lookup<NativeFunction<create_wallet>>('create_wallet')
    .asFunction<CreateWallet>();

final restoreWalletFromSeedNative = oxenApi
    .lookup<NativeFunction<restore_wallet_from_seed>>(
        'restore_wallet_from_seed')
    .asFunction<RestoreWalletFromSeed>();

final restoreWalletFromKeysNative = oxenApi
    .lookup<NativeFunction<restore_wallet_from_keys>>(
        'restore_wallet_from_keys')
    .asFunction<RestoreWalletFromKeys>();

final isWalletExistNative = oxenApi
    .lookup<NativeFunction<is_wallet_exist>>('is_wallet_exist')
    .asFunction<IsWalletExist>();

final loadWalletNative = oxenApi
    .lookup<NativeFunction<load_wallet>>('load_wallet')
    .asFunction<LoadWallet>();

void createWalletSync(
    {required String path, required String password, required String language, int nettype = 0}) {
  final pathPointer = path.toNativeUtf8();
  final passwordPointer = password.toNativeUtf8();
  final languagePointer = language.toNativeUtf8();
  final result = createWalletNative(pathPointer, passwordPointer, languagePointer, nettype);

  calloc.free(pathPointer);
  calloc.free(passwordPointer);
  calloc.free(languagePointer);

  if (!result.good)
    throw WalletCreationException(message: result.errorString());
}

bool isWalletExistSync({required String path}) {
  final pathPointer = path.toNativeUtf8();
  final isExist = isWalletExistNative(pathPointer) != 0;

  calloc.free(pathPointer);

  return isExist;
}

void restoreWalletFromSeedSync(
    {required String path,
    required String password,
    required String seed,
    int nettype = 0,
    int restoreHeight = 0}) {
  final pathPointer = path.toNativeUtf8();
  final passwordPointer = password.toNativeUtf8();
  final seedPointer = seed.toNativeUtf8();
  final result = restoreWalletFromSeedNative(
          pathPointer,
          passwordPointer,
          seedPointer,
          nettype,
          restoreHeight);

  calloc.free(pathPointer);
  calloc.free(passwordPointer);
  calloc.free(seedPointer);

  if (!result.good)
    throw WalletRestoreFromSeedException(message: result.errorString());
}

void restoreWalletFromKeysSync(
    {required String path,
    required String password,
    required String language,
    required String address,
    required String viewKey,
    required String spendKey,
    int nettype = 0,
    int restoreHeight = 0}) {
  final pathPointer = path.toNativeUtf8();
  final passwordPointer = password.toNativeUtf8();
  final languagePointer = language.toNativeUtf8();
  final addressPointer = address.toNativeUtf8();
  final viewKeyPointer = viewKey.toNativeUtf8();
  final spendKeyPointer = spendKey.toNativeUtf8();
  final result = restoreWalletFromKeysNative(
          pathPointer,
          passwordPointer,
          languagePointer,
          addressPointer,
          viewKeyPointer,
          spendKeyPointer,
          nettype,
          restoreHeight);

  calloc.free(pathPointer);
  calloc.free(passwordPointer);
  calloc.free(languagePointer);
  calloc.free(addressPointer);
  calloc.free(viewKeyPointer);
  calloc.free(spendKeyPointer);

  if (!result.good)
    throw WalletRestoreFromKeysException(message: result.errorString());
}
