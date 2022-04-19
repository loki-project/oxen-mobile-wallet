import 'package:flutter/material.dart';
import 'package:oxen_wallet/src/widgets/nav/nav_list_trailing.dart';

class NavListArrow extends StatelessWidget {
  NavListArrow({required this.text, this.leading, this.onTap});

  final String text;
  final Widget? leading;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return NavListTrailing(
        leading: leading,
        text: text,
        trailing: Icon(Icons.arrow_forward_ios_rounded,
            color: Theme.of(context).primaryTextTheme.headline6?.color,
            size: 20),
        onTap: onTap);
  }
}
