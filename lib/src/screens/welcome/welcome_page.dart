import 'package:flutter/material.dart';
import 'package:oxen_wallet/l10n.dart';
import 'package:oxen_wallet/palette.dart';
import 'package:oxen_wallet/routes.dart';
import 'package:oxen_wallet/src/screens/base_page.dart';
import 'package:oxen_wallet/src/widgets/primary_button.dart';

class WelcomePage extends BasePage {
  static const _baseWidth = 411.43;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        resizeToAvoidBottomInset: false,
        body: SafeArea(child: body(context)));
  }

  @override
  Widget body(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    final textScaleFactor = _screenWidth < _baseWidth ? 0.76 : 1.0;

    return Column(children: <Widget>[
      Expanded(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: Image.asset('assets/images/oxen.png', height: 124, width: 400),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  tr(context).welcome,
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textScaleFactor: textScaleFactor,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    tr(context).first_wallet_text,
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Palette.lightBlue,
                    ),
                    textScaleFactor: textScaleFactor,
                    textAlign: TextAlign.center,
                  )),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    tr(context).please_make_selection,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Palette.lightBlue,
                    ),
                    textScaleFactor: textScaleFactor,
                    textAlign: TextAlign.center,
                  ))
            ]),
      ),
      Container(
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
          child: Column(children: <Widget>[
            PrimaryButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.newWalletFromWelcome);
                },
                text: tr(context).create_new,
                color:
                    Theme.of(context).primaryTextTheme.button?.backgroundColor,
                borderColor:
                    Theme.of(context).primaryTextTheme.button?.decorationColor),
            SizedBox(height: 10),
            PrimaryButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.restoreOptions);
              },
              color: Theme.of(context).accentTextTheme.caption?.backgroundColor,
              borderColor:
                  Theme.of(context).accentTextTheme.caption?.decorationColor,
              text: tr(context).restore_wallet,
            )
          ]))
    ]);
  }
}
