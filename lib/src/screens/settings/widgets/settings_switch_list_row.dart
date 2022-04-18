import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oxen_wallet/l10n.dart';
import 'package:oxen_wallet/src/stores/settings/settings_store.dart';
import 'package:oxen_wallet/src/widgets/standart_switch.dart';
import 'package:oxen_wallet/theme_changer.dart';
import 'package:oxen_wallet/themes.dart';
import 'package:provider/provider.dart';

class SettingsSwitchListRow extends StatelessWidget {
  SettingsSwitchListRow({required this.title});

  final String title;

  Widget? _getSwitch(BuildContext context) {
    final settingsStore = Provider.of<SettingsStore>(context);
    final _themeChanger = Provider.of<ThemeChanger>(context);

    if (title == tr(context).settings_save_recipient_address) {
      return Observer(
          builder: (_) => StandartSwitch(
              value: settingsStore.shouldSaveRecipientAddress,
              onTaped: () {
                final _currentValue = !settingsStore.shouldSaveRecipientAddress;
                settingsStore.setSaveRecipientAddress(
                    shouldSaveRecipientAddress: _currentValue);
              }));
    }

    if (title == tr(context).settings_allow_biometric_authentication) {
      return Observer(
          builder: (_) => StandartSwitch(
              value: settingsStore.allowBiometricAuthentication,
              onTaped: () {
                final _currentValue =
                    !settingsStore.allowBiometricAuthentication;
                settingsStore.setAllowBiometricAuthentication(
                    allowBiometricAuthentication: _currentValue);
              }));
    }

    if (title == tr(context).settings_dark_mode) {
      return Observer(
          builder: (_) => StandartSwitch(
              value: settingsStore.isDarkTheme,
              onTaped: () {
                final _currentValue = !settingsStore.isDarkTheme;
                settingsStore.saveDarkTheme(isDarkTheme: _currentValue);
                _themeChanger.setTheme(
                    _currentValue ? Themes.darkTheme : Themes.lightTheme);
              }));
    }

    if (title == tr(context).settings_enable_fiat_currency) {
      return Observer(
          builder: (_) => StandartSwitch(
              value: settingsStore.enableFiatCurrency,
              onTaped: () {
                final _currentValue = !settingsStore.enableFiatCurrency;
                settingsStore.setEnableFiatCurrency(
                    enableFiatCurrency: _currentValue);
              }));
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).accentTextTheme.headline5?.backgroundColor,
      child: ListTile(
          contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
          title: Text(title,
              style: TextStyle(
                  fontSize: 16.0,
                  color: Theme.of(context).primaryTextTheme.headline6?.color)),
          trailing: _getSwitch(context)),
    );
  }
}
