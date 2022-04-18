import 'package:flutter/material.dart';
import 'package:oxen_wallet/palette.dart';

class SettingsLinktListRow extends StatelessWidget {
  SettingsLinktListRow(
      {this.onTaped, required this.title, this.link, this.image});

  final VoidCallback? onTaped;
  final String title;
  final String? link;
  final Image? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).accentTextTheme.headline5?.backgroundColor,
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            image ?? Offstage(),
            Container(
              padding: image != null ? EdgeInsets.only(left: 10) : null,
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryTextTheme.headline6?.color),
              ),
            )
          ],
        ),
        trailing: link == null ? null : Text(
          link!,
          style: TextStyle(fontSize: 14.0, color: OxenPalette.teal),
        ),
        onTap: onTaped,
      ),
    );
  }
}
