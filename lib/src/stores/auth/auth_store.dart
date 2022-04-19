import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobx/mobx.dart';
import 'package:oxen_wallet/src/domain/services/user_service.dart';
import 'package:oxen_wallet/src/domain/services/wallet_service.dart';
import 'package:oxen_wallet/src/stores/auth/auth_state.dart';
import 'package:oxen_wallet/l10n.dart';

part 'auth_store.g.dart';

class AuthStore = AuthStoreBase with _$AuthStore;

abstract class AuthStoreBase with Store {
  AuthStoreBase(
      {required this.userService,
      required this.walletService,
      required this.sharedPreferences});
  
  static const maxFailedLogins = 3;
  static const banTimeout = 180; // 3 minutes
  static const banTimeoutKey = 'ban_timeout';

  final UserService userService;
  final WalletService walletService;

  final SharedPreferences sharedPreferences;

  @observable
  AuthState state = AuthenticationStateInitial();

  @observable
  int _failureCounter = 0;

  @action
  Future auth({required String password, required AppLocalizations l10n}) async {
    state = AuthenticationStateInitial();
    final _banDuration = banDuration();

    if (_banDuration != null) {
      state = AuthenticationBanned(
          error: l10n.auth_store_banned_for(_banDuration.inMinutes));
      return;
    }

    state = AuthenticationInProgress();
    final isAuth = await userService.authenticate(password);

    if (isAuth) {
      state = AuthenticatedSuccessfully();
      _failureCounter = 0;
    } else {
      _failureCounter += 1;

      if (_failureCounter >= maxFailedLogins) {
        final banDuration = await ban();
        state = AuthenticationBanned(
            error: l10n.auth_store_banned_for(banDuration.inMinutes));
        return;
      }

      state = AuthenticationFailure(error: l10n.auth_store_incorrect_password);
    }
  }

  Duration? banDuration() {
    final unbanTimestamp = sharedPreferences.getInt(banTimeoutKey);

    if (unbanTimestamp == null) {
      return null;
    }

    final unbanTime = DateTime.fromMillisecondsSinceEpoch(unbanTimestamp);
    final now = DateTime.now();

    if (now.isAfter(unbanTime)) {
      return null;
    }

    return Duration(milliseconds: unbanTimestamp - now.millisecondsSinceEpoch);
  }

  Future<Duration> ban() async {
    final multiplier = _failureCounter - maxFailedLogins + 1;
    final timeout = (multiplier * banTimeout) * 1000;
    final unbanTimestamp = DateTime.now().millisecondsSinceEpoch + timeout;
    await sharedPreferences.setInt(banTimeoutKey, unbanTimestamp);

    return Duration(milliseconds: timeout);
  }

  @action
  void biometricAuth() {
    state = AuthenticatedSuccessfully();
  }
}
