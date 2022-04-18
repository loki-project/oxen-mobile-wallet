import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oxen_wallet/l10n.dart';
import 'package:oxen_wallet/src/widgets/primary_button.dart';

import 'oxen_dialog.dart';

Future<T?> presentPicker<T extends dynamic>(
    BuildContext context, List<T> list, {T? initial}) async {
  var initialIndex = 0;
  if (initial != null) {
    for (var i = 0; i < list.length; i++) {
      if (list[i] == initial) {
        initialIndex = i;
        break;
      }
    }
  }

  var _value = list[initialIndex];

  final t = tr(context);

  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return OxenDialog(
            body: Container(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(tr(context).please_select,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              decoration: TextDecoration.none,
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .caption
                                  ?.color))),
                  Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 30),
                    child: Container(
                      height: 150.0,
                      child: CupertinoPicker(
                          backgroundColor: Theme.of(context).backgroundColor,
                          itemExtent: 45.0,
                          scrollController: FixedExtentScrollController(initialItem: initialIndex),
                          onSelectedItemChanged: (int index) =>
                              _value = list[index],
                          children: List.generate(
                              list.length,
                              (index) => Center(
                                    child: Text(
                                      (list[index] is String ? list[index] : list[index].getTitle(t)) as String,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryTextTheme
                                              .caption
                                              ?.color),
                                    ),
                                  ))),
                    ),
                  ),
                  PrimaryButton(
                    text: tr(context).ok,
                    color: Theme.of(context)
                        .primaryTextTheme
                        .button
                        ?.backgroundColor,
                    borderColor: Theme.of(context)
                        .primaryTextTheme
                        .button
                        ?.decorationColor,
                    onPressed: () => Navigator.of(context).pop(_value),
                  )
                ],
              ),
            ));
      });
}
