import 'package:flutter/material.dart';
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
import 'package:oxen_wallet/src/wallet/oxen/transaction/transaction_priority.dart';
import 'package:oxen_wallet/src/widgets/scollable_with_bottom_section.dart';
import 'package:oxen_wallet/src/widgets/slide_to_act.dart';
import 'package:oxen_wallet/src/widgets/address_text_field.dart';
import 'package:oxen_wallet/src/widgets/oxen_dialog.dart';
import 'package:oxen_wallet/src/util/validators.dart';
import 'package:provider/provider.dart';

class NewStakePage extends BasePage {
  @override
  String getTitle(AppLocalizations t) => t.title_new_stake;

  @override
  bool get isModalBackButton => true;

  @override
  bool get resizeToAvoidBottomInset => false;

  @override
  Widget body(BuildContext context) => NewStakeForm();
}

class NewStakeForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NewStakeFormState();
}

class NewStakeFormState extends State<NewStakeForm> {
  final _snpkController = TextEditingController();
  final _cryptoAmountController = TextEditingController();

  final _focusNode = FocusNode();

  bool _effectsInstalled = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
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
        content: Column(
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
                              ?.backgroundColor ?? Colors.white))),
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
                      final availableBalance =
                          settingsStore.balanceShowFull || settingsStore.balanceShowAvailable
                          ? balanceStore.unlockedBalanceString : '---';

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
                    controller: _snpkController,
                    placeholder: t.service_node_key,
                    focusNode: _focusNode,
                    validator: (value) => isHexKey(value) ? null : t.error_text_service_node,
                    options: [AddressTextFieldOption.qrCode],
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
                            '${calculateEstimatedFee(priority: OxenTransactionPriority.slow)} OXEN',
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
                  )
                ]),
              ),
            )
          ],
        ),
        bottomSection: Observer(builder: (_) {
          return SlideToAct(
            text: t.stake_oxen,
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

                        await sendStore.createStake(
                            snPubkey: _snpkController.text,
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
    if (_effectsInstalled) {
      return;
    }

    final sendStore = Provider.of<SendStore>(context);
    final t = tr(context);

    reaction((_) => sendStore.cryptoAmount, (String amount) {
      if (amount != _cryptoAmountController.text) {
        _cryptoAmountController.text = amount;
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
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(t.error),
                  content: Text(state.error),
                  actions: <Widget>[
                    FlatButton(
                        child: Text(t.ok),
                        onPressed: () => Navigator.of(context).pop())
                  ],
                );
              });
        });
      }

      if (state is TransactionCreatedSuccessfully && sendStore.pendingTransaction != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showConfirmOxenDialog(
            context,
            t.confirm_stake,
            t.amount(sendStore.pendingTransaction!.amount) + " OXEN\n"
                + t.fee(sendStore.pendingTransaction!.fee) + " OXEN",
            onConfirm: (_) {
              Navigator.of(context).pop();
              sendStore.commitTransaction();
            },
            onDismiss: (_) { Navigator.of(context).pop(); },
          );
        });
      }

      if (state is TransactionCommitted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(t.sending),
                  content: Text(t.transaction_sent),
                  actions: <Widget>[
                    FlatButton(
                        child: Text(t.ok),
                        onPressed: () {
                          _snpkController.text = '';
                          _cryptoAmountController.text = '';
                          Navigator.of(context)..pop()..pop();
                        })
                  ],
                );
              });
        });
      }
    });

    _effectsInstalled = true;
  }
}
