import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:oxen_wallet/l10n.dart';
import 'package:oxen_wallet/src/domain/services/wallet_service.dart';
import 'package:oxen_wallet/src/stores/price/price_store.dart';
import 'package:oxen_wallet/src/stores/send/sending_state.dart';
import 'package:oxen_wallet/src/stores/settings/settings_store.dart';
import 'package:oxen_wallet/src/wallet/oxen/transaction/transaction_description.dart';
import 'package:oxen_wallet/src/wallet/transaction/pending_transaction.dart';
import 'package:oxen_wallet/src/util/validators.dart';

part 'send_store.g.dart';

class SendStore = SendStoreBase with _$SendStore;

abstract class SendStoreBase with Store {
  SendStoreBase(
      {required this.walletService,
      required this.settingsStore,
      required this.transactionDescriptions,
      required this.priceStore}) :
    _cryptoNumberFormat = NumberFormat()..maximumFractionDigits = 9,
    _fiatNumberFormat = NumberFormat()..maximumFractionDigits = 2;

  WalletService walletService;
  SettingsStore settingsStore;
  PriceStore priceStore;
  Box<TransactionDescription> transactionDescriptions;
  String? recordName;
  String? recordAddress;

  @observable
  SendingState state = SendingStateInitial();

  @observable
  String fiatAmount = '';

  @observable
  String cryptoAmount = '';

  @observable
  String? errorMessage;

  PendingTransaction? get pendingTransaction => _pendingTransaction;
  PendingTransaction? _pendingTransaction;
  final NumberFormat _cryptoNumberFormat;
  final NumberFormat _fiatNumberFormat;
  String? _lastRecipientAddress;

  @action
  Future createStake({required String snPubkey, String? amount, required AppLocalizations l10n}) async {
    state = CreatingTransaction();

    try {
      final _amount = amount ??
          (cryptoAmount == l10n.all ? null : cryptoAmount.replaceAll(',', '.'));

      _pendingTransaction = await walletService.createStake(snPubkey: snPubkey, amount: _amount);
      state = TransactionCreatedSuccessfully();
    } catch (e) {
      state = SendingFailed(error: e.toString());
    }
  }

  @action
  Future createTransaction({required String recipient, String? amount, required AppLocalizations l10n}) async {
    state = CreatingTransaction();

    try {
      final _amount = amount ??
          (cryptoAmount == l10n.all ? null : cryptoAmount.replaceAll(',', '.'));

      _pendingTransaction = await walletService.createTransaction(
          recipient: recipient,
          amount: _amount,
          priority: settingsStore.transactionPriority);

      state = TransactionCreatedSuccessfully();
      _lastRecipientAddress = recipient;
    } catch (e) {
      state = SendingFailed(error: e.toString());
    }
  }

  @action
  Future commitTransaction() async {
    if (_pendingTransaction == null) {
      // Handle this here, but don't worry about translation because this is a logic error in the
      // caller that shouldn't happen.
      state = SendingFailed(error: 'No pending transaction');
      return;
    }
    try {
      final transactionId = _pendingTransaction!.hash;
      state = TransactionCommitting();
      await _pendingTransaction!.commit();
      state = TransactionCommitted();

      if (settingsStore.shouldSaveRecipientAddress && _lastRecipientAddress != null) {
        await transactionDescriptions.add(TransactionDescription(
            id: transactionId, recipientAddress: _lastRecipientAddress));
      }
    } catch (e) {
      state = SendingFailed(error: e.toString());
    }

    _pendingTransaction = null;
  }

  @action
  void setSendAll(AppLocalizations l10n) {
    cryptoAmount = l10n.all;
    fiatAmount = '';
  }

  @action
  void changeCryptoAmount(String amount) {
    cryptoAmount = amount;

    if (cryptoAmount.isNotEmpty)
      _calculateFiatAmount();
    else
      fiatAmount = '';
  }

  @action
  void changeFiatAmount(String amount) {
    fiatAmount = amount;

    if (fiatAmount.isNotEmpty)
      _calculateCryptoAmount();
    else
      cryptoAmount = '';
  }

  @action
  Future _calculateFiatAmount() async {
    final symbol = PriceStoreBase.generateSymbolForFiat(
        fiat: settingsStore.fiatCurrency);
    final price = priceStore.prices[symbol] ?? 0;

    try {
      final amount = double.parse(cryptoAmount) * price;
      fiatAmount = _fiatNumberFormat.format(amount);
    } catch (e) {
      fiatAmount = '0.00';
    }
  }

  @action
  Future _calculateCryptoAmount() async {
    final symbol = PriceStoreBase.generateSymbolForFiat(
        fiat: settingsStore.fiatCurrency);
    final price = priceStore.prices[symbol] ?? 0;

    try {
      final amount = double.parse(fiatAmount) / price;
      cryptoAmount = _cryptoNumberFormat.format(amount);
    } catch (e) {
      cryptoAmount = '0.00';
    }
  }

  void validateAddress(String value, {required AppLocalizations l10n}) {
    errorMessage = isValidOxenAddress(value) ? null : l10n.error_text_address;
  }

  final oxenAmountRE = RegExp('^([0-9]+([.][0-9]{0,9})?|[.][0-9]{1,9})\$');
  void validateOXEN(String amount, int availableBalance, AppLocalizations l10n) {
    final value = amount.replaceAll(',', '.');

    var isValid = false;
    if (value == l10n.all) {
      isValid = true;
    } else if (oxenAmountRE.hasMatch(value)) {
      try {
        final dValue = double.parse(value);
        final maxAvailable = availableBalance;
        isValid = (dValue <= maxAvailable && dValue > 0);
      } catch (e) {
        isValid = false;
      }
    } else {
      isValid = false;
    }

    errorMessage = isValid ? null : l10n.error_text_oxen;
  }
}
