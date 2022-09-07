import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oxen_wallet/l10n.dart';
import 'package:oxen_wallet/palette.dart';
import 'package:oxen_wallet/routes.dart';
import 'package:oxen_wallet/src/screens/base_page.dart';
import 'package:oxen_wallet/src/stores/subaddress_list/subaddress_list_store.dart';
import 'package:oxen_wallet/src/stores/wallet/wallet_store.dart';
import 'package:oxen_wallet/src/widgets/oxen_text_field.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReceivePage extends BasePage {
  @override
  bool get isModalBackButton => true;

  @override
  String getTitle(AppLocalizations t) => t.receive;

  @override
  Widget trailing(BuildContext context) {
    final walletStore = Provider.of<WalletStore>(context);

    return SizedBox(
      height: 37.0,
      width: 37.0,
      child: ButtonTheme(
        minWidth: double.minPositive,
        child: TextButton(
            style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                padding: MaterialStateProperty.all(EdgeInsets.all(0))),
            onPressed: () => Share.share(walletStore.subaddress.address),
            child: Icon(
              Icons.share,
              size: 30.0,
            )),
      ),
    );
  }

  @override
  Widget body(BuildContext context) =>
      SingleChildScrollView(child: ReceiveBody());
}

class ReceiveBody extends StatefulWidget {
  @override
  ReceiveBodyState createState() => ReceiveBodyState();
}

class ReceiveBodyState extends State<ReceiveBody> {
  final amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletStore = Provider.of<WalletStore>(context);
    final subaddressListStore = Provider.of<SubaddressListStore>(context);

    final currentColor = Theme.of(context).selectedRowColor;
    final notCurrentColor = Theme.of(context).scaffoldBackgroundColor;

    amountController.addListener(() {
      if (_formKey.currentState?.validate() ?? false) {
        walletStore.onChangedAmountValue(amountController.text);
      } else {
        walletStore.onChangedAmountValue('');
      }
    });

    return SafeArea(
        child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(35.0),
                  color: Theme.of(context).backgroundColor,
                  child: Column(
                    children: <Widget>[
                      Observer(builder: (_) {
                        return Row(
                          children: <Widget>[
                            Spacer(flex: 1),
                            Flexible(
                                flex: 2,
                                child: AspectRatio(
                                  aspectRatio: 1.0,
                                  child: QrImage(
                                    size: 100.0,
                                    version: QrVersions.auto,
                                    errorCorrectionLevel: QrErrorCorrectLevel.M,
                                    data: walletStore.subaddress.address + walletStore.amountValue,
                                    embeddedImage: AssetImage('assets/images/oxen.png'),
                                    embeddedImageStyle: QrEmbeddedImageStyle(size: Size(40, 40)),
                                    backgroundColor: OxenPalette.whiteBlue,
                                    foregroundColor: OxenPalette.navy,
                                  ),
                                )),
                            Spacer(flex: 1)
                          ],
                        );
                      }),
                      Observer(builder: (_) {
                        return Row(
                          children: <Widget>[
                            Expanded(
                                child: Container(
                              padding: EdgeInsets.all(20.0),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(
                                        text: walletStore.subaddress.address));
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text(
                                        tr(context).copied_to_clipboard,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.green,
                                    ));
                                  },
                                  child: Text(
                                    walletStore.subaddress.address,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .primaryTextTheme
                                            .headline6
                                            ?.color)
                                  )
                                )
                              )
                            ))
                          ],
                        );
                      }),
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: Form(
                                  key: _formKey,
                                  child: OxenTextField(
                                    keyboardType:
                                        TextInputType.numberWithOptions(decimal: true),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(RegExp('[- ]'))
                                    ],
                                    hintText: tr(context).receive_amount,
                                    validator: (value) {
                                      walletStore.validateAmount(value ?? '', tr(context));
                                      return walletStore.errorMessage;
                                    },
                                    controller: amountController
                                  )))
                        ],
                      )
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Container(
                      color: Theme.of(context).accentTextTheme.headline5?.color,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              tr(context).subaddresses,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Theme.of(context)
                                      .primaryTextTheme
                                      .headline5
                                      ?.color),
                            ),
                            trailing: Container(
                              width: 28.0,
                              height: 28.0,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).selectedRowColor,
                                  shape: BoxShape.circle),
                              child: InkWell(
                                onTap: () => Navigator.of(context)
                                    .pushNamed(Routes.newSubaddress),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(14.0)),
                                child: Icon(
                                  Icons.add,
                                  color: OxenPalette.teal,
                                  size: 22.0,
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            color: Theme.of(context).dividerTheme.color,
                            height: 1.0,
                          )
                        ],
                      ),
                    ))
                  ],
                ),
                Observer(builder: (_) {
                  return ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: subaddressListStore.subaddresses.length,
                      separatorBuilder: (context, i) {
                        return Divider(
                          color: Theme.of(context).dividerTheme.color,
                          height: 1.0,
                        );
                      },
                      itemBuilder: (context, i) {
                        return Observer(builder: (_) {
                          final subaddress =
                              subaddressListStore.subaddresses[i];
                          final isCurrent = walletStore.subaddress.address ==
                              subaddress.address;
                          final label = subaddress.label.isNotEmpty
                              ? subaddress.label
                              : subaddress.address;

                          return InkWell(
                            onTap: () => walletStore.setSubaddress(subaddress),
                            child: Container(
                              color: isCurrent ? currentColor : notCurrentColor,
                              child: Column(children: <Widget>[
                                ListTile(
                                  title: Text(
                                    label,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Theme.of(context)
                                            .primaryTextTheme
                                            .headline5
                                            ?.color),
                                  ),
                                )
                              ]),
                            ),
                          );
                        });
                      });
                })
              ],
            ))));
  }
}
