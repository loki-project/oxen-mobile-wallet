import 'package:flutter/material.dart';
import 'package:oxen_wallet/routes.dart';
import 'package:provider/provider.dart';
import 'package:oxen_wallet/l10n.dart';
import 'package:oxen_wallet/src/stores/wallet_list/wallet_list_store.dart';
import 'package:oxen_wallet/src/wallet/wallet_description.dart';
import 'package:oxen_wallet/src/screens/auth/auth_page.dart';

class WalletMenu {
  WalletMenu(this.context);

  final BuildContext context;

  List<String> generateItemsForWalletMenu() {
    final l10n = tr(context);
    return [
        l10n.wallet_list_load_wallet,
        l10n.remove
    ];
  }

  void action(int index, WalletDescription wallet) {
    final _walletListStore = context.read<WalletListStore>();
    final t = tr(context);
    final nav = Navigator.of(context);

    nav.pushNamed(
      Routes.auth,
      arguments: (bool authSuccessful, AuthPageState auth) async {
        if (!authSuccessful)
          return;

        switch (index) {
          case 0:
            try {
              auth.changeProcessText(context, t.wallet_list_loading_wallet(wallet.name));
              await _walletListStore.loadWallet(wallet);
              auth.close();
              nav.pop();
            } catch (e) {
              auth.changeProcessText(context, t.wallet_list_failed_to_load(wallet.name, e.toString()));
            }
            break;
          case 1:
            auth.close();
            await nav.pushNamed(
              Routes.dangerzoneRemoveWallet,
              arguments: () async {
                try {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(t.wallet_list_removing_wallet(wallet.name)),
                    backgroundColor: Colors.green
                  ));
                  await _walletListStore.remove(wallet);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(t.wallet_list_failed_to_remove(wallet.name, e.toString())),
                    backgroundColor: Colors.red
                  ));
                }
              }
            );
            break;
        }
      },
    );
  }
}
