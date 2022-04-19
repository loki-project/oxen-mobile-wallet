import 'package:mobx/mobx.dart';
import 'package:oxen_wallet/src/domain/services/user_service.dart';
import 'package:oxen_wallet/src/stores/user/user_store_state.dart';

part 'user_store.g.dart';

class UserStore = UserStoreBase with _$UserStore;

abstract class UserStoreBase with Store {
  UserStoreBase({required this.accountService});

  UserService accountService;

  @observable
  UserStoreState state = UserStoreStateInitial();

  @action
  Future set({required String password}) async {
    state = UserStoreStateInitial();

    try {
      await accountService.setPassword(password);
      state = PinCodeSetSuccessfully();
    } catch (e) {
      state = PinCodeSetFailed(error: e.toString());
    }
  }
}
