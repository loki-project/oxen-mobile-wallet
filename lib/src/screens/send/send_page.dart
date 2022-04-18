import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:oxen_wallet/l10n.dart';
import 'package:oxen_wallet/palette.dart';
import 'package:oxen_wallet/routes.dart';
import 'package:oxen_wallet/src/domain/common/balance_display_mode.dart';
import 'package:oxen_wallet/src/node/sync_status.dart';
import 'package:oxen_wallet/src/screens/auth/auth_page.dart';
import 'package:oxen_wallet/src/screens/base_page.dart';
import 'package:oxen_wallet/src/screens/oxen_amount.dart';
import 'package:oxen_wallet/src/stores/balance/balance_store.dart';
import 'package:oxen_wallet/src/stores/send/send_store.dart';
import 'package:oxen_wallet/src/stores/send/sending_state.dart';
import 'package:oxen_wallet/src/stores/settings/settings_store.dart';
import 'package:oxen_wallet/src/stores/sync/sync_store.dart';
import 'package:oxen_wallet/src/stores/wallet/wallet_store.dart';
import 'package:oxen_wallet/src/wallet/oxen/calculate_estimated_fee.dart';
import 'package:oxen_wallet/src/widgets/address_text_field.dart';
import 'package:oxen_wallet/src/widgets/oxen_dialog.dart';
import 'package:oxen_wallet/src/widgets/scollable_with_bottom_section.dart';
import 'package:oxen_wallet/src/widgets/slide_to_act.dart';
import 'package:provider/provider.dart';

class SendPage extends BasePage {
  @override
  String getTitle(AppLocalizations t) => t.send_title;

  @override
  bool get isModalBackButton => true;

  @override
  bool get resizeToAvoidBottomInset => false;

  @override
  Widget body(BuildContext context) => SendForm();
}

class SendForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SendFormState();
}

class SendFormState extends State<SendForm> {
  final _addressController = TextEditingController();
  final _cryptoAmountController = TextEditingController();
  final _fiatAmountController = TextEditingController();

  final _focusNodeAddress = FocusNode();

  bool _effectsInstalled = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _focusNodeAddress.addListener(() {
      if (!_focusNodeAddress.hasFocus && _addressController.text.isNotEmpty) {
        getOpenAliasRecord(context);
      }
    });

    super.initState();
  }

  Future<void> getOpenAliasRecord(BuildContext context) async {
    final sendStore = Provider.of<SendStore>(context);
    final isOpenAlias =
        await sendStore.isOpenaliasRecord(_addressController.text);

    if (isOpenAlias) {
      _addressController.text = sendStore.recordAddress ?? '';

      await showSimpleOxenDialog(context, tr(context).openalias_alert_title,
          tr(context).openalias_alert_content(sendStore.recordName ?? ''),
          onPressed: (_) => Navigator.of(context).pop());
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsStore = Provider.of<SettingsStore>(context);
    final sendStore = Provider.of<SendStore>(context);
    sendStore.settingsStore = settingsStore;
    final balanceStore = Provider.of<BalanceStore>(context);
    final walletStore = Provider.of<WalletStore>(context);
    final syncStore = Provider.of<SyncStore>(context);

    _setEffects(context);

    final t = tr(context);

    return ScrollableWithBottomSection(
        contentPadding: EdgeInsets.all(0),
        content: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 18, right: 18),
                decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Palette.shadowGrey,
                        blurRadius: 10,
                        offset: Offset(0, 12),
                      )
                    ],
                    border: Border(
                        top: BorderSide(
                            width: 1,
                            color: Theme.of(context)
                                .accentTextTheme
                                .subtitle2
                                ?.backgroundColor ?? OxenPalette.black))),
                child: SizedBox(
                  height: 56,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Observer(builder: (_) {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(t.send_your_wallet,
                                  style: TextStyle(
                                      fontSize: 12, color: OxenPalette.teal)),
                              Text(walletStore.name,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context)
                                          .accentTextTheme
                                          .overline
                                          ?.color,
                                      height: 1.25)),
                            ]);
                      }),
                      Observer(builder: (context) {
                        final savedDisplayMode =
                            settingsStore.balanceDisplayMode;
                        final availableBalance =
                            savedDisplayMode == BalanceDisplayMode.hiddenBalance
                                ? '---'
                                : balanceStore.unlockedBalanceString;

                        return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(t.oxen_available_balance,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .accentTextTheme
                                        .overline
                                        ?.backgroundColor,
                                  )),
                              Text(availableBalance,
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Theme.of(context)
                                          .accentTextTheme
                                          .overline
                                          ?.color,
                                      height: 1.1)),
                            ]);
                      })
                    ],
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Container(
                  padding:
                      EdgeInsets.only(left: 18, right: 18, top: 10, bottom: 30),
                  child: Column(children: <Widget>[
                    AddressTextField(
                      controller: _addressController,
                      placeholder: t.send_oxen_address,
                      focusNode: _focusNodeAddress,
                      onURIScanned: (uri) {
                        _addressController.text = uri.path;
                        _cryptoAmountController.text = uri.queryParameters['tx_amount'] ?? '';
                      },
                      options: [
                        AddressTextFieldOption.qrCode,
                        AddressTextFieldOption.addressBook
                      ],
                      validator: (value) {
                        sendStore.validateAddress(value ?? '', l10n: t);
                        return sendStore.errorMessage;
                      },
                    ),
                    oxenAmountField(
                      context: context,
                      setAll: () => sendStore.setSendAll(t),
                      controller: _cryptoAmountController,
                      validator: (value) {
                        sendStore.validateOXEN(value ?? '', balanceStore.unlockedBalance, t);
                        return sendStore.errorMessage;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: !settingsStore.enableFiatCurrency ? null : TextFormField(
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Theme.of(context)
                                  .accentTextTheme
                                  .overline
                                  ?.color),
                          controller: _fiatAmountController,
                          keyboardType: TextInputType.numberWithOptions(
                              signed: false, decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp('[- ]'))
                          ],
                          decoration: InputDecoration(
                              prefixIcon: SizedBox(
                                width: 75,
                                child: Padding(
                                    padding: EdgeInsets.only(left: 8, top: 12),
                                    child: Text(
                                        '${settingsStore.fiatCurrency.toString()}:',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Theme.of(context)
                                                .accentTextTheme
                                                .overline
                                                ?.color))),
                              ),
                              hintStyle: TextStyle(
                                  fontSize: 18.0,
                                  color: Theme.of(context).hintColor),
                              hintText: '0.00',
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: OxenPalette.teal, width: 2.0)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).focusColor,
                                      width: 1.0)),
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: OxenPalette.red, width: 1.0)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: OxenPalette.red, width: 1.0)),
                              errorStyle: TextStyle(color: OxenPalette.red))),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(t.send_estimated_fee,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context)
                                    .accentTextTheme
                                    .overline
                                    ?.backgroundColor,
                              )),
                          Text(
                              '${calculateEstimatedFee(priority: settingsStore.transactionPriority)} OXEN',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context)
                                    .primaryTextTheme
                                    .overline
                                    ?.backgroundColor,
                              ))
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                          t.send_priority(settingsStore.transactionPriority.getTitle(t)),
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .subtitle2
                                  ?.color,
                              height: 1.3)),
                    ),
                  ]),
                ),
              )
            ],
          ),
        ),
        bottomSection: Observer(builder: (_) {
          return SlideToAct(
            text: t.send_title,
            outerColor: Theme.of(context).primaryTextTheme.subtitle2?.color,
            innerColor: OxenPalette.teal,
            onFutureSubmit: syncStore.status is SyncedSyncStatus
                ? () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      var isSuccessful = false;

                      await Navigator.of(context).pushNamed(Routes.auth,
                          arguments: (bool isAuthenticatedSuccessfully,
                              AuthPageState auth) async {
                        if (!isAuthenticatedSuccessfully) {
                          isSuccessful = false;
                          return;
                        }

                        await sendStore.createTransaction(
                            recipient: _addressController.text,
                            l10n: t);

                        Navigator.of(auth.context).pop();
                        isSuccessful = true;
                      });
                      return isSuccessful;
                    } else {
                      return false;
                    }
                  }
                : null,
          );
        }));
  }

  void _setEffects(BuildContext context) {
    if (_effectsInstalled) return;

    final sendStore = Provider.of<SendStore>(context);

    reaction((_) => sendStore.fiatAmount, (String amount) {
      if (amount != _fiatAmountController.text) {
        _fiatAmountController.text = amount;
      }
    });

    reaction((_) => sendStore.cryptoAmount, (String amount) {
      if (amount != _cryptoAmountController.text) {
        _cryptoAmountController.text = amount;
      }
    });

    _fiatAmountController.addListener(() {
      final fiatAmount = _fiatAmountController.text;

      if (sendStore.fiatAmount != fiatAmount) {
        sendStore.changeFiatAmount(fiatAmount);
      }
    });

    _cryptoAmountController.addListener(() {
      final cryptoAmount = _cryptoAmountController.text;

      if (sendStore.cryptoAmount != cryptoAmount) {
        sendStore.changeCryptoAmount(cryptoAmount);
      }
    });

    reaction((_) => sendStore.state, (SendingState state) {
      if (state is SendingFailed) {
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          showSimpleOxenDialog(context, tr(context).error, state.error,
              onPressed: (_) => Navigator.of(context).pop());
        });
      }

      if (state is TransactionCreatedSuccessfully && sendStore.pendingTransaction != null) {
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          showConfirmOxenDialog(
            context,
            tr(context).confirm_sending,
            tr(context).confirm_transaction_amount_fee(
                sendStore.pendingTransaction!.amount,
                sendStore.pendingTransaction!.fee),
            onConfirm: (_) {
              Navigator.of(context).pop();
              sendStore.commitTransaction();
            }
          );
        });
      }

      if (state is TransactionCommitted) {
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          showSimpleOxenDialog(
              context, tr(context).sending, tr(context).transaction_sent,
              onPressed: (_) {
            _addressController.text = '';
            _cryptoAmountController.text = '';
            Navigator.of(context)..pop()..pop();
          });
        });
      }
    });

    _effectsInstalled = true;
  }
}
