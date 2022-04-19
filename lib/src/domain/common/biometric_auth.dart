import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:oxen_wallet/l10n.dart';

class BiometricAuth {
  Future<bool> isAuthenticated(AppLocalizations t) async {
    final _localAuth = LocalAuthentication();

    try {
      return await _localAuth.authenticate(
          biometricOnly: true,
          localizedReason: t.biometric_auth_reason,
          useErrorDialogs: true,
          stickyAuth: false);
    } on PlatformException catch (e) {
      print(e);
    }

    return false;
  }
}
