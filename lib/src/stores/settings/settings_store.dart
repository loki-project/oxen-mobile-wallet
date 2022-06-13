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
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_store.g.dart';

class SettingsStore = SettingsStoreBase with _$SettingsStore;

abstract class SettingsStoreBase with Store {
  SettingsStoreBase(
      {required SharedPreferences sharedPreferences,
      required Box<Node> nodes,
      required FiatCurrency initialFiatCurrency,
      required OxenTransactionPriority initialTransactionPriority,
      required bool initialBalanceShowFull,
      required bool initialBalanceShowAvailable,
      required bool initialBalanceShowPending,
      required bool initialBalanceFullIncludesPending,
      required AmountDetail initialBalanceDetail,
      required bool initialSaveRecipientAddress,
      required bool allowBiometricAuthenticationKey,
      required bool enableFiatCurrencyKey,
      required bool initialDarkTheme,
      required int initialPinLength,
      required String? initialLanguageOverride}) :
    fiatCurrency = initialFiatCurrency,
    transactionPriority = initialTransactionPriority,
    balanceShowFull = initialBalanceShowFull,
    balanceShowAvailable = initialBalanceShowAvailable,
    balanceShowPending = initialBalanceShowPending,
    balanceFullIncludesPending = initialBalanceFullIncludesPending,
    balanceDetail = initialBalanceDetail,
    shouldSaveRecipientAddress = initialSaveRecipientAddress,
    _sharedPreferences = sharedPreferences,
    _nodes = nodes,
    allowBiometricAuthentication = allowBiometricAuthenticationKey,
    enableFiatCurrency = enableFiatCurrencyKey,
    isDarkTheme = initialDarkTheme,
    defaultPinLength = initialPinLength,
    languageOverride = initialLanguageOverride
  {
    PackageInfo.fromPlatform().then(
        (PackageInfo packageInfo) => currentVersion = packageInfo.version);
  }

  static const currentNodeIdKey = 'current_node_id';
  static const currentFiatCurrencyKey = 'current_fiat_currency';
  static const currentTransactionPriorityKey = 'current_fee_priority';
  static const balanceShowFullKey = 'balance_show_full';
  static const balanceShowAvailableKey = 'balance_show_available';
  static const balanceShowPendingKey = 'balance_show_pending';
  static const balanceFullIncludesPendingKey = 'balance_full_incl_pending';
  static const balanceDetailKey = 'current_balance_detail';
  static const shouldSaveRecipientAddressKey = 'save_recipient_address';
  static const allowBiometricAuthenticationKey = 'allow_biometric_authentication';
  static const currentDarkTheme = 'dark_theme';
  static const currentPinLength = 'current_pin_length';
  static const currentLanguageOverride = 'language_code';
  static const enableFiatCurrencyKey = 'enable_fiat_currency';

  static Future<SettingsStore> load(
      {required SharedPreferences sharedPreferences,
      required Box<Node> nodes}) async {
    final store = SettingsStore(
        sharedPreferences: sharedPreferences,
        nodes: nodes,
        initialFiatCurrency: FiatCurrency(
            symbol: sharedPreferences.getString(currentFiatCurrencyKey)),
        initialTransactionPriority: OxenTransactionPriority.deserialize(
            raw: sharedPreferences.getInt(currentTransactionPriorityKey)),
        initialBalanceShowFull: sharedPreferences.getBool(balanceShowFullKey) ?? true,
        initialBalanceShowAvailable: sharedPreferences.getBool(balanceShowAvailableKey) ?? true,
        initialBalanceShowPending: sharedPreferences.getBool(balanceShowPendingKey) ?? true,
        initialBalanceFullIncludesPending: sharedPreferences.getBool(balanceFullIncludesPendingKey) ?? true,
        initialBalanceDetail: AmountDetail.deserialize(sharedPreferences.getInt(balanceDetailKey)),
        initialSaveRecipientAddress: sharedPreferences.getBool(shouldSaveRecipientAddressKey) ?? true,
        allowBiometricAuthenticationKey: sharedPreferences.getBool(allowBiometricAuthenticationKey) ?? false,
        enableFiatCurrencyKey: sharedPreferences.getBool(enableFiatCurrencyKey) ?? false,
        initialDarkTheme: sharedPreferences.getBool(currentDarkTheme) ??
            SchedulerBinding.instance.window.platformBrightness == Brightness.dark,
        initialPinLength: sharedPreferences.getInt(currentPinLength) ?? 4,
        initialLanguageOverride: sharedPreferences.getString(currentLanguageOverride));

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
  bool balanceShowFull;

  @observable
  bool balanceShowAvailable;

  @observable
  bool balanceShowPending;

  @observable
  bool balanceFullIncludesPending;

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

  @observable
  String? languageOverride;

  final SharedPreferences _sharedPreferences;
  final Box<Node> _nodes;
  late String currentVersion;

  @action
  Future setAllowBiometricAuthentication(bool allowBiometricAuthentication) async {
    this.allowBiometricAuthentication = allowBiometricAuthentication;
    await _sharedPreferences.setBool(
        allowBiometricAuthenticationKey, allowBiometricAuthentication);
  }

  @action
  Future setEnableFiatCurrency(bool enableFiatCurrency) async {
    this.enableFiatCurrency = enableFiatCurrency;
    await _sharedPreferences.setBool(enableFiatCurrencyKey, enableFiatCurrency);
  }

  @action
  Future saveDarkTheme(bool isDarkTheme) async {
    this.isDarkTheme = isDarkTheme;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: isDarkTheme ? Colors.black : Colors.white));
    await _sharedPreferences.setBool(currentDarkTheme, isDarkTheme);
  }

  @action
  Future saveLanguageOverride(String? language) async {
    this.languageOverride = language;
    if (language == null)
        await _sharedPreferences.remove(currentLanguageOverride);
    else
        await _sharedPreferences.setString(currentLanguageOverride, language);
  }

  @action
  Future setCurrentNode(Node node) async {
    this.node = node;
    await _sharedPreferences.setInt(currentNodeIdKey, this.node!.key as int);
  }

  @action
  Future setCurrentFiatCurrency(FiatCurrency currency) async {
    fiatCurrency = currency;
    await _sharedPreferences.setString(
        currentFiatCurrencyKey, fiatCurrency.serialize());
  }

  @action
  Future setCurrentTransactionPriority(OxenTransactionPriority priority) async {
    transactionPriority = priority;
    await _sharedPreferences.setInt(
        currentTransactionPriorityKey, priority.serialize());
  }

  @action
  Future setBalanceShowFull(bool shouldShowFull) async {
    balanceShowFull = shouldShowFull;
    await _sharedPreferences.setBool(balanceShowFullKey, balanceShowFull);
  }

  @action
  Future setBalanceShowAvailable(bool shouldShowAvailable) async {
    balanceShowAvailable = shouldShowAvailable;
    await _sharedPreferences.setBool(balanceShowAvailableKey, balanceShowAvailable);
  }

  @action
  Future setBalanceShowPending(bool shouldShowPending) async {
    balanceShowPending = shouldShowPending;
    await _sharedPreferences.setBool(balanceShowPendingKey, balanceShowPending);
  }

  @action
  Future setBalanceFullIncludesPending(bool fullInclPending) async {
    balanceFullIncludesPending = fullInclPending;
    await _sharedPreferences.setBool(balanceFullIncludesPendingKey, fullInclPending);
  }

  @action
  Future setBalanceDetail(AmountDetail balanceDetail) async {
    this.balanceDetail = balanceDetail;
    await _sharedPreferences.setInt(
        balanceDetailKey, balanceDetail.index);
  }

  @action
  Future setSaveRecipientAddress(bool shouldSaveRecipientAddress) async {
    this.shouldSaveRecipientAddress = shouldSaveRecipientAddress;
    await _sharedPreferences.setBool(
        shouldSaveRecipientAddressKey, shouldSaveRecipientAddress);
  }

  Future loadSettings() async => node = await _fetchCurrentNode();

  @action
  Future setDefaultPinLength(int pinLength) async {
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
