import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:oxen_wallet/l10n.dart';
import 'package:oxen_wallet/src/stores/auth/auth_state.dart';
import 'package:oxen_wallet/src/stores/auth/auth_store.dart';
import 'package:oxen_wallet/src/screens/pin_code/pin_code.dart';
import 'package:oxen_wallet/src/stores/settings/settings_store.dart';
import 'package:oxen_wallet/src/domain/common/biometric_auth.dart';

typedef OnAuthenticationFinished = void Function(bool, AuthPageState);

class AuthPage extends StatefulWidget {
  AuthPage({this.onAuthenticationFinished, this.closable = true});

  final OnAuthenticationFinished? onAuthenticationFinished;
  final bool closable;

  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  final _key = GlobalKey<ScaffoldState>();
  final _pinCodeKey = GlobalKey<PinCodeState>();

  void changeProcessText(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(text), backgroundColor: Colors.green));
  }

  void close() {
    if (_key.currentContext != null)
      Navigator.of(_key.currentContext!).pop();
  }

  @override
  Widget build(BuildContext context) {
    final authStore = Provider.of<AuthStore>(context);
    final settingsStore = Provider.of<SettingsStore>(context);

    if (settingsStore.allowBiometricAuthentication) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        final biometricAuth = BiometricAuth();
        biometricAuth.isAuthenticated(tr(context)).then(
                (isAuth) {
              if (isAuth) {
                authStore.biometricAuth();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(tr(context).authenticated),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            }
        );
      });
    }

    reaction((_) => authStore.state, (AuthState state) {
      if (state is AuthenticatedSuccessfully) {
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          if (widget.onAuthenticationFinished != null) {
            widget.onAuthenticationFinished!(true, this);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(tr(context).authenticated),
                backgroundColor: Colors.green,
              ),
            );
          }
        });
      } else if (state is AuthenticationFailure) {
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          _pinCodeKey.currentState?.clear();
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(tr(context).failed_authentication(state.error)),
              backgroundColor: Colors.red,
            ),
          );

          if (widget.onAuthenticationFinished != null) {
            widget.onAuthenticationFinished!(false, this);
          }
        });
      } else if (state is AuthenticationBanned) {
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          _pinCodeKey.currentState?.clear();
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(tr(context).failed_authentication(state.error)),
              backgroundColor: Colors.red,
            ),
          );

          if (widget.onAuthenticationFinished != null) {
            widget.onAuthenticationFinished!(false, this);
          }
        });
      }
    });

    return Scaffold(
        key: _key,
        appBar: CupertinoNavigationBar(
          leading: widget.closable ? CloseButton() : Container(),
          backgroundColor: Theme.of(context).backgroundColor,
          border: null,
        ),
        resizeToAvoidBottomInset: false,
        body: PinCode(
            (pin, _) => authStore.auth(
                l10n: tr(context),
                password: pin.fold('', (ac, val) => ac + '$val')),
            false,
            _pinCodeKey));
  }
}
