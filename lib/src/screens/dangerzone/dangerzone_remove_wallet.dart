import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oxen_wallet/generated/l10n.dart';
import 'package:oxen_wallet/palette.dart';
import 'package:oxen_wallet/routes.dart';
import 'package:oxen_wallet/src/screens/base_page.dart';
import 'package:oxen_wallet/src/widgets/primary_button.dart';

class DangerzoneRemoveWalletPage extends BasePage {
  DangerzoneRemoveWalletPage({this.onConfirmed});

  final void Function() onConfirmed;

  @override
  Widget body(BuildContext context) {
    final _baseWidth = 411.43;
    final _screenWidth = MediaQuery.of(context).size.width;
    final textScaleFactor = _screenWidth < _baseWidth ? 0.76 : 1.0;

    return Column(children: <Widget>[
      Expanded(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: Icon(Icons.warning_amber_sharp,
                    size: 125, color: OxenPalette.red),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  S.of(context).dangerzone,
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
                    S.of(context).remove_wallet_confirmation,
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
                    S.of(context).dangerzone_remove_wallet_warning,
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
        child: PrimaryButton(
            onPressed: () {
              onConfirmed();
              Navigator.of(context).pop();
            },
            text: S.of(context).yes_im_sure,
            color: Theme.of(context).primaryTextTheme.button.backgroundColor,
            borderColor:
            Theme.of(context).primaryTextTheme.button.decorationColor),
      )
    ]);
  }
}
