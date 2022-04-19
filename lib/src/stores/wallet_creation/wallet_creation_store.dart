import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oxen_wallet/src/domain/services/wallet_list_service.dart';
import 'package:oxen_wallet/src/stores/wallet_creation/wallet_creation_state.dart';
import 'package:oxen_wallet/src/stores/authentication/authentication_store.dart';
import 'package:oxen_wallet/src/util/validators.dart';
import 'package:oxen_wallet/l10n.dart';

part 'wallet_creation_store.g.dart';

class WalletCreationStore = WalletCreationStoreBase with _$WalletCreationStore;

abstract class WalletCreationStoreBase with Store {
  WalletCreationStoreBase(
      {required this.authStore,
      required this.walletListService,
      required this.sharedPreferences})
  :
      state = WalletCreationStateInitial();

  final AuthenticationStore authStore;
  final WalletListService walletListService;
  final SharedPreferences sharedPreferences;

  @observable
  WalletCreationState state;

  @observable
  String? errorMessage;

  @action
  Future create({required String name, required String language}) async {
    state = WalletCreationStateInitial();

    try {
      state = WalletIsCreating();
      await walletListService.create(name, language);
      authStore.created();
      state = WalletCreatedSuccessfully();
    } catch (e) {
      state = WalletCreationFailure(error: e.toString());
    }
  }

  void validateWalletName(String? value, AppLocalizations l10n) {
    errorMessage = hasNonWhitespace(value) ? null : l10n.error_text_empty;
  }
}
