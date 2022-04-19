import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oxen_wallet/src/domain/services/wallet_list_service.dart';
import 'package:oxen_wallet/src/wallet/mnemonic_item.dart';
import 'package:oxen_wallet/src/stores/wallet_restoration/wallet_restoration_state.dart';
import 'package:oxen_wallet/src/stores/authentication/authentication_store.dart';
import 'package:oxen_wallet/l10n.dart';
import 'package:oxen_wallet/src/util/validators.dart';

part 'wallet_restoration_store.g.dart';

class WalletRestorationStore = WalletRestorationStoreBase
    with _$WalletRestorationStore;

abstract class WalletRestorationStoreBase with Store {
  WalletRestorationStoreBase(
      {this.seed,
      required this.authStore,
      required this.walletListService,
      required this.sharedPreferences});

  final AuthenticationStore authStore;
  final WalletListService walletListService;
  final SharedPreferences sharedPreferences;

  @observable
  WalletRestorationState state = WalletRestorationStateInitial();

  @observable
  String? errorMessage;

  @observable
  List<MnemonicItem>? seed;

  @action
  Future restoreFromSeed({required String name, String? seed, required int restoreHeight}) async {
    state = WalletRestorationStateInitial();
    final _seed = seed ?? _seedText();

    try {
      state = WalletIsRestoring();
      await walletListService.restoreFromSeed(name, _seed, restoreHeight);
      authStore.restored();
      state = WalletRestoredSuccessfully();
    } catch (e) {
      state = WalletRestorationFailure(error: e.toString());
    }
  }

  @action
  Future restoreFromKeys(
      {required String name,
      required String language,
      required String address,
      required String viewKey,
      required String spendKey,
      required int restoreHeight}) async {
    state = WalletRestorationStateInitial();

    try {
      state = WalletIsRestoring();
      await walletListService.restoreFromKeys(
          name, language, restoreHeight, address, viewKey, spendKey);
      authStore.restored();
      state = WalletRestoredSuccessfully();
    } catch (e) {
      state = WalletRestorationFailure(error: e.toString());
    }
  }

  @action
  void setSeed(List<MnemonicItem> seed) {
    this.seed = seed;
  }

  @action
  void validateSeed(List<MnemonicItem>? seed, AppLocalizations l10n) {
    final _seed = seed ?? this.seed;

    if (_seed == null || _seed.length != 25) {
      errorMessage = l10n.wallet_restoration_store_incorrect_seed_length;
      return;
    }

    for (final item in _seed) {
      if (!item.isCorrect()) {
        errorMessage = l10n.incorrect_seed;
        return;
      }
    }

    errorMessage = null;
    return;
  }

  String _seedText() {
    return seed?.join(' ') ?? '';
  }

  void validateWalletName(String value, AppLocalizations l10n) {
    errorMessage = hasNonWhitespace(value) ? null : l10n.error_text_empty;
  }

  void validateAddress(String value, {required AppLocalizations l10n}) {
    errorMessage = isValidOxenAddress(value) ? null : l10n.error_text_address;
  }

  void validateKeys(String value, AppLocalizations l10n) {
    errorMessage = isHexKey(value) ? null : l10n.error_text_keys;
  }
}
