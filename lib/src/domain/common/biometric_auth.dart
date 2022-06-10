import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:oxen_wallet/l10n.dart';

class BiometricAuth {
  Future<bool> isAuthenticated(AppLocalizations t) async {
    final _localAuth = LocalAuthentication();

    try {
      return await _localAuth.authenticate(
          localizedReason: t.biometric_auth_reason,
          options: const AuthenticationOptions(
            biometricOnly: true,
            useErrorDialogs: true,
            stickyAuth: false));
    } on PlatformException catch (e) {
      print(e);
    }

    return false;
  }
}
