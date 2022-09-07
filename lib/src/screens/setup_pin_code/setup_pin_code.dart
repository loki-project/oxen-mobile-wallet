import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oxen_wallet/src/stores/user/user_store.dart';
import 'package:oxen_wallet/src/screens/pin_code/pin_code.dart';
import 'package:oxen_wallet/src/screens/base_page.dart';
import 'package:oxen_wallet/src/stores/settings/settings_store.dart';
import 'package:oxen_wallet/l10n.dart';

class SetupPinCodePage extends BasePage {
  SetupPinCodePage({required this.onPinCodeSetup});

  final Function(BuildContext, String) onPinCodeSetup;

  @override
  String getTitle(AppLocalizations t) => t.setup_pin;

  @override
  Widget body(BuildContext context) =>
      SetupPinCodeForm(onPinCodeSetup: onPinCodeSetup, hasLengthSwitcher: true);
}

class SetupPinCodeForm extends PinCodeWidget {
  SetupPinCodeForm(
      {required this.onPinCodeSetup, required bool hasLengthSwitcher})
      : super(hasLengthSwitcher: hasLengthSwitcher);

  final Function(BuildContext, String) onPinCodeSetup;

  @override
  _SetupPinCodeFormState createState() => _SetupPinCodeFormState();
}

class _SetupPinCodeFormState<WidgetType extends SetupPinCodeForm>
    extends PinCodeState<WidgetType> {

  bool isEnteredOriginalPin() => _originalPin.isNotEmpty;
  List<int> _originalPin = [];
  UserStore? _userStore;
  SettingsStore? _settingsStore;

  @override
  void onPinCodeEntered(PinCodeState state) {
    if (!isEnteredOriginalPin()) {
      _originalPin = [...state.pin];
      state.setTitle(tr(context).enter_your_pin_again);
      state.clear();
    } else {
      if (listEquals<int>(state.pin, _originalPin)) {
        final pin = state.pin.join();
        _userStore?.set(password: pin);
        _settingsStore?.setDefaultPinLength(state.pinLength);

        showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text(tr(context).setup_successful),
                actions: <Widget>[
                  TextButton(
                    child: Text(tr(context).ok),
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onPinCodeSetup(context, pin);
                      reset(tr(context));
                    },
                  ),
                ],
              );
            });
      } else {
        showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text(tr(context).pin_is_incorrect),
                actions: <Widget>[
                  TextButton(
                    child: Text(tr(context).ok),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });

        reset(tr(context));
      }
    }
  }

  void reset(AppLocalizations l10n) {
    clear();
    setTitle(l10n.enter_your_pin);
    _originalPin = [];
  }

  @override
  Widget build(BuildContext context) {
    _userStore = Provider.of<UserStore>(context);
    _settingsStore = Provider.of<SettingsStore>(context);

    return body(context);
  }
}
