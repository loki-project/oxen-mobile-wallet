import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:mobx/mobx.dart';
import 'package:oxen_wallet/src/domain/common/balance_display_mode.dart';
import 'package:oxen_wallet/src/domain/common/default_settings_migration.dart';
import 'package:oxen_wallet/src/domain/common/fiat_currency.dart';
import 'package:oxen_wallet/src/node/node.dart';
import 'package:oxen_wallet/src/wallet/crypto_amount_format.dart';
import 'package:oxen_wallet/src/wallet/oxen/transaction/transaction_priority.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_store.g.dart';

class SettingsStore = SettingsStoreBase with _$SettingsStore;

abstract class SettingsStoreBase with Store {
  SettingsStoreBase(
      {required SharedPreferences sharedPreferences,
      required Box<Node> nodes,
      required FiatCurrency initialFiatCurrency,
      required OxenTransactionPriority initialTransactionPriority,
      required BalanceDisplayMode initialBalanceDisplayMode,
      required AmountDetail initialBalanceDetail,
      required bool initialSaveRecipientAddress,
      required bool allowBiometricAuthenticationKey,
      required bool enableFiatCurrencyKey,
      required bool initialDarkTheme,
      required int initialPinLength}) :
    fiatCurrency = initialFiatCurrency,
    transactionPriority = initialTransactionPriority,
    balanceDisplayMode = initialBalanceDisplayMode,
    balanceDetail = initialBalanceDetail,
    shouldSaveRecipientAddress = initialSaveRecipientAddress,
    _sharedPreferences = sharedPreferences,
    _nodes = nodes,
    allowBiometricAuthentication = allowBiometricAuthenticationKey,
    enableFiatCurrency = enableFiatCurrencyKey,
    isDarkTheme = initialDarkTheme,
    defaultPinLength = initialPinLength
  {
    PackageInfo.fromPlatform().then(
        (PackageInfo packageInfo) => currentVersion = packageInfo.version);
  }

  static const currentNodeIdKey = 'current_node_id';
  static const currentFiatCurrencyKey = 'current_fiat_currency';
  static const currentTransactionPriorityKey = 'current_fee_priority';
  static const currentBalanceDisplayModeKey = 'current_balance_display_mode';
  static const currentBalanceDetailKey = 'current_balance_detail';
  static const shouldSaveRecipientAddressKey = 'save_recipient_address';
  static const allowBiometricAuthenticationKey =
      'allow_biometric_authentication';
  static const currentDarkTheme = 'dark_theme';
  static const currentPinLength = 'current_pin_length';
  static const enableFiatCurrencyKey = 'enable_fiat_currency';

  static Future<SettingsStore> load(
      {required SharedPreferences sharedPreferences,
      required Box<Node> nodes,
      required FiatCurrency initialFiatCurrency,
      required OxenTransactionPriority initialTransactionPriority,
      required BalanceDisplayMode initialBalanceDisplayMode}) async {
    final currentFiatCurrency = FiatCurrency(
        symbol: sharedPreferences.getString(currentFiatCurrencyKey));
    final currentTransactionPriority = OxenTransactionPriority.deserialize(
        raw: sharedPreferences.getInt(currentTransactionPriorityKey));
    final currentBalanceDisplayMode = BalanceDisplayMode.deserialize(
        raw: sharedPreferences.getInt(currentBalanceDisplayModeKey));
    final currentBalanceDetail = AmountDetail.deserialize(
            sharedPreferences.getInt(currentBalanceDetailKey));
    final shouldSaveRecipientAddress =
        sharedPreferences.getBool(shouldSaveRecipientAddressKey) ?? true;
    final allowBiometricAuthentication =
        sharedPreferences.getBool(allowBiometricAuthenticationKey) ?? false;
    final enableFiatCurrency =
        sharedPreferences.getBool(enableFiatCurrencyKey) ?? false;

    final initialCurrentDarkMode =
        SchedulerBinding.instance?.window.platformBrightness == Brightness.dark;
    final savedDarkTheme =
        sharedPreferences.getBool(currentDarkTheme) ?? initialCurrentDarkMode;

    final defaultPinLength = sharedPreferences.getInt(currentPinLength) ?? 4;

    final store = SettingsStore(
        sharedPreferences: sharedPreferences,
        nodes: nodes,
        initialFiatCurrency: currentFiatCurrency,
        initialTransactionPriority: currentTransactionPriority,
        initialBalanceDisplayMode: currentBalanceDisplayMode,
        initialBalanceDetail: currentBalanceDetail,
        initialSaveRecipientAddress: shouldSaveRecipientAddress,
        allowBiometricAuthenticationKey: allowBiometricAuthentication,
        enableFiatCurrencyKey: enableFiatCurrency,
        initialDarkTheme: savedDarkTheme,
        initialPinLength: defaultPinLength);

    await store.loadSettings();

    return store;
  }

  @observable
  Node? node;

  @observable
  FiatCurrency fiatCurrency;

  @observable
  OxenTransactionPriority transactionPriority;

  @observable
  BalanceDisplayMode balanceDisplayMode;

  @observable
  AmountDetail balanceDetail;

  @observable
  bool shouldSaveRecipientAddress;

  @observable
  bool allowBiometricAuthentication;

  @observable
  bool enableFiatCurrency;

  @observable
  bool isDarkTheme;

  @observable
  int defaultPinLength;

  final SharedPreferences _sharedPreferences;
  final Box<Node> _nodes;
  late String currentVersion;

  @action
  Future setAllowBiometricAuthentication(
      {required bool allowBiometricAuthentication}) async {
    this.allowBiometricAuthentication = allowBiometricAuthentication;
    await _sharedPreferences.setBool(
        allowBiometricAuthenticationKey, allowBiometricAuthentication);
  }

  @action
  Future setEnableFiatCurrency({required bool enableFiatCurrency}) async {
    this.enableFiatCurrency = enableFiatCurrency;
    await _sharedPreferences.setBool(enableFiatCurrencyKey, enableFiatCurrency);
  }

  @action
  Future saveDarkTheme({required bool isDarkTheme}) async {
    this.isDarkTheme = isDarkTheme;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: isDarkTheme ? Colors.black : Colors.white));
    await _sharedPreferences.setBool(currentDarkTheme, isDarkTheme);
  }

  @action
  Future setCurrentNode({required Node node}) async {
    this.node = node;
    await _sharedPreferences.setInt(currentNodeIdKey, this.node!.key as int);
  }

  @action
  Future setCurrentFiatCurrency({required FiatCurrency currency}) async {
    fiatCurrency = currency;
    await _sharedPreferences.setString(
        currentFiatCurrencyKey, fiatCurrency.serialize());
  }

  @action
  Future setCurrentTransactionPriority(
      {required OxenTransactionPriority priority}) async {
    transactionPriority = priority;
    await _sharedPreferences.setInt(
        currentTransactionPriorityKey, priority.serialize());
  }

  @action
  Future setCurrentBalanceDisplayMode(
      {required BalanceDisplayMode balanceDisplayMode}) async {
    this.balanceDisplayMode = balanceDisplayMode;
    await _sharedPreferences.setInt(
        currentBalanceDisplayModeKey, balanceDisplayMode.serialize());
  }

  @action
  Future setCurrentBalanceDetail({required AmountDetail balanceDetail}) async {
    this.balanceDetail = balanceDetail;
    await _sharedPreferences.setInt(
        currentBalanceDetailKey, balanceDetail.index);
  }

  @action
  Future setSaveRecipientAddress(
      {required bool shouldSaveRecipientAddress}) async {
    this.shouldSaveRecipientAddress = shouldSaveRecipientAddress;
    await _sharedPreferences.setBool(
        shouldSaveRecipientAddressKey, shouldSaveRecipientAddress);
  }

  Future loadSettings() async => node = await _fetchCurrentNode();

  @action
  Future setDefaultPinLength({required int pinLength}) async {
    defaultPinLength = pinLength;
    await _sharedPreferences.setInt(currentPinLength, pinLength);
  }

  Future<Node> _fetchCurrentNode() async {
    final id = _sharedPreferences.getInt(currentNodeIdKey);
    return _nodes.get(id)!;
  }

  Future setCurrentNodeToDefault() async {
    await changeCurrentNodeToDefault(
        sharedPreferences: _sharedPreferences, nodes: _nodes);
    await loadSettings();
  }
}
