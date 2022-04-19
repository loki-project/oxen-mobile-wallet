import 'package:flutter/material.dart';
import 'package:oxen_wallet/l10n.dart';
import 'package:oxen_wallet/routes.dart';
import 'package:oxen_wallet/src/screens/base_page.dart';
import 'package:oxen_wallet/src/screens/auth/auth_page.dart';
import 'package:oxen_wallet/src/widgets/nav/nav_list_arrow.dart';
import 'package:oxen_wallet/src/widgets/nav/nav_list_header.dart';

class ProfilePage extends BasePage {
  final _bodyKey = GlobalKey();

  @override
  Widget trailing(BuildContext context) {
    return SizedBox(
      width: 25,
      child: FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: () => Navigator.of(context).pushNamed(Routes.settings),
          child: Icon(Icons.settings_rounded,
              color: Theme.of(context).primaryTextTheme.caption?.color,
              size: 25)),
    );
  }

  @override
  Widget body(BuildContext context) => ProfilePageBody(key: _bodyKey);
}

class ProfilePageBody extends StatefulWidget {
  ProfilePageBody({required Key key}) : super(key: key);

  @override
  ProfilePageBodyState createState() => ProfilePageBodyState();
}

class ProfilePageBodyState extends State<ProfilePageBody> {
  @override
  Widget build(BuildContext context) {
    final t = tr(context);
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            NavListArrow(
                leading: Icon(Icons.account_balance_wallet_rounded,
                    color: Theme.of(context).primaryTextTheme.headline6?.color),
                text: t.wallets,
                onTap: () =>
                    Navigator.of(context).pushNamed(Routes.walletList)),
            NavListArrow(
                leading: Icon(Icons.settings_rounded,
                    color: Theme.of(context).primaryTextTheme.headline6?.color),
                text: t.settings_title,
                onTap: () =>
                    Navigator.of(context).pushNamed(Routes.settings)),
            NavListHeader(title: t.wallet_menu),
            NavListArrow(
                leading: Icon(Icons.attach_money_rounded,
                    color: Theme.of(context).primaryTextTheme.headline6?.color),
                text: t.title_stakes,
                onTap: () =>
                    Navigator.of(context).pushNamed(Routes.stake)),
            NavListArrow(
                leading: Icon(Icons.contacts_rounded,
                    color: Theme.of(context).primaryTextTheme.headline6?.color),
                text: t.address_book_menu,
                onTap: () =>
                    Navigator.of(context).pushNamed(Routes.addressBook)),
            NavListArrow(
                leading: Icon(Icons.account_circle_rounded,
                    color: Theme.of(context).primaryTextTheme.headline6?.color),
                text: t.accounts,
                onTap: () =>
                    Navigator.of(context).pushNamed(Routes.accountList)),
            NavListHeader(title: t.dangerzone),
            NavListArrow(
                leading: Icon(Icons.vpn_key_rounded,
                    color: Theme.of(context).primaryTextTheme.headline6?.color),
                text: t.show_keys,
                onTap: () => Navigator.of(context).pushNamed(Routes.auth,
                    arguments: (bool isAuthenticatedSuccessfully,
                            AuthPageState auth) =>
                        isAuthenticatedSuccessfully
                            ? Navigator.of(auth.context)
                                .popAndPushNamed(Routes.dangerzoneKeys)
                            : null)),
            NavListArrow(
                leading: Icon(Icons.vpn_key_rounded,
                    color: Theme.of(context).primaryTextTheme.headline6?.color),
                text: t.show_seed,
                onTap: () => Navigator.of(context).pushNamed(Routes.auth,
                    arguments: (bool isAuthenticatedSuccessfully,
                            AuthPageState auth) =>
                        isAuthenticatedSuccessfully
                            ? Navigator.of(auth.context)
                                .popAndPushNamed(Routes.dangerzoneSeed)
                            : null)),
          ],
        ),
      ],
    ));
  }
}
