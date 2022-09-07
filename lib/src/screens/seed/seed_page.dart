import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oxen_wallet/palette.dart';
import 'package:oxen_wallet/l10n.dart';
import 'package:oxen_wallet/src/widgets/primary_button.dart';
import 'package:oxen_wallet/src/stores/wallet_seed/wallet_seed_store.dart';
import 'package:oxen_wallet/src/screens/base_page.dart';

class SeedPage extends BasePage {
  SeedPage({this.onCloseCallback});

  // static final image = Image.asset('assets/images/seed_image.png');
  static final image = Image.asset('assets/images/oxen.png', height: 124, width: 400);

  @override
  bool get isModalBackButton => true;

  @override
  String getTitle(AppLocalizations t) => t.seed_title;

  final VoidCallback? onCloseCallback;

  @override
  void onClose(BuildContext context) =>
      onCloseCallback != null ? onCloseCallback!() : Navigator.of(context).pop();

  @override
  Widget? leading(BuildContext context) {
    return onCloseCallback != null ? Offstage() : super.leading(context);
  }

  @override
  Widget body(BuildContext context) {
    final walletSeedStore = Provider.of<WalletSeedStore>(context);
    var _seed = '';

    return Container(
      padding: EdgeInsets.all(30.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  image,
                  Container(
                    margin: EdgeInsets.only(left: 30.0, top: 10.0, right: 30.0),
                    child: Observer(builder: (_) {
                      _seed = walletSeedStore.seed;
                      return Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 1.0,
                                            color: Theme.of(context)
                                                .dividerColor))),
                                padding: EdgeInsets.only(bottom: 20.0),
                                margin: EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  walletSeedStore.name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: Theme.of(context)
                                          .primaryTextTheme
                                          .button
                                          ?.color),
                                ),
                              ))
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            walletSeedStore.seed,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Theme.of(context)
                                    .primaryTextTheme
                                    .headline6
                                    ?.color),
                          )
                        ],
                      );
                    }),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30.0),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                            child: Container(
                          padding: EdgeInsets.only(right: 8.0),
                          child: PrimaryButton(
                              onPressed: () => Share.share(_seed),
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .button
                                  ?.backgroundColor,
                              borderColor: Theme.of(context)
                                  .primaryTextTheme
                                  .button
                                  ?.decorationColor,
                              text: tr(context).save),
                        )),
                        Flexible(
                            child: Container(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Builder(
                                  builder: (context) => PrimaryButton(
                                      onPressed: () {
                                        Clipboard.setData(
                                            ClipboardData(text: _seed));
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(tr(context).copied_to_clipboard),
                                            backgroundColor: Colors.green,
                                            duration: Duration(milliseconds: 1500),
                                          ),
                                        );
                                      },
                                      text: tr(context).copy,
                                      color: Theme.of(context)
                                          .accentTextTheme
                                          .caption
                                          ?.backgroundColor,
                                      borderColor: Theme.of(context)
                                          .accentTextTheme
                                          .caption
                                          ?.decorationColor),
                                )))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          onCloseCallback != null
              ? PrimaryButton(
                  onPressed: () => onClose(context),
                  text: tr(context).restore_next,
                  color: Palette.darkGrey,
                  borderColor: Palette.darkGrey)
              : Offstage()
        ],
      ),
    );
  }
}
