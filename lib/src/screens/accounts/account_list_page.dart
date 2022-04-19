import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:oxen_wallet/palette.dart';
import 'package:oxen_wallet/routes.dart';
import 'package:oxen_wallet/l10n.dart';
import 'package:oxen_wallet/src/stores/account_list/account_list_store.dart';
import 'package:oxen_wallet/src/stores/wallet/wallet_store.dart';
import 'package:oxen_wallet/src/screens/base_page.dart';

class AccountListPage extends BasePage {
  @override
  String getTitle(AppLocalizations t) => t.accounts;

  @override
  Widget trailing(BuildContext context) {
    final accountListStore = Provider.of<AccountListStore>(context);

    return Container(
        width: 28.0,
        height: 28.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Theme.of(context).selectedRowColor),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Icon(Icons.add, color: OxenPalette.teal, size: 22.0),
            ButtonTheme(
              minWidth: 28.0,
              height: 28.0,
              child: FlatButton(
                  shape: CircleBorder(),
                  onPressed: () async {
                    await Navigator.of(context)
                        .pushNamed(Routes.accountCreation);
                    accountListStore.updateAccountList();
                  },
                  child: Offstage()),
            )
          ],
        ));
  }

  @override
  Widget body(BuildContext context) {
    final accountListStore = Provider.of<AccountListStore>(context);
    final walletStore = Provider.of<WalletStore>(context);

    final currentColor = Theme.of(context).selectedRowColor;
    final notCurrentColor = Theme.of(context).backgroundColor;

    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 20),
      child: Observer(builder: (_) {
        final accounts = accountListStore.accounts;
        return ListView.builder(
            itemCount: accounts.length,
            itemBuilder: (BuildContext context, int index) {
              final account = accounts[index];

              return Observer(builder: (_) {
                final isCurrent = walletStore.account.id == account.id;

                return Slidable(
                  key: Key(account.id.toString()),
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        label: tr(context).edit,
                        backgroundColor: Colors.blue,
                        icon: Icons.edit,
                        onPressed: (context) async {
                          await Navigator.of(context).pushNamed(
                              Routes.accountCreation,
                              arguments: account);
                          // await accountListStore.updateAccountList().then((_) {
                          //   if (isCurrent) walletStore.setAccount(accountListStore.accounts[index]);
                          // });
                        },
                      )
                    ],
                  ),
                  child: Container(
                    color: isCurrent ? currentColor : notCurrentColor,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            account.label,
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Theme.of(context)
                                    .primaryTextTheme
                                    .headline5
                                    ?.color),
                          ),
                          onTap: () {
                            if (isCurrent) return;

                            walletStore.setAccount(account);
                            Navigator.of(context).pop();
                          },
                        ),
                        Divider(
                          color: Theme.of(context).dividerTheme.color,
                          height: 1.0,
                        )
                      ],
                    ),
                  ),
                );
              });
            });
      }),
    );
  }
}
