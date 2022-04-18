import 'package:flutter/material.dart';
import 'package:oxen_wallet/l10n.dart';
import 'package:oxen_wallet/routes.dart';
import 'package:oxen_wallet/src/stores/balance/balance_store.dart';
import 'package:oxen_wallet/src/stores/wallet/wallet_store.dart';
import 'package:oxen_wallet/src/widgets/oxen_dialog.dart';
import 'package:provider/provider.dart';

class WalletMenu {
  WalletMenu(this.context)
    : items = [
      tr(context).reconnect,
      tr(context).rescan,
      tr(context).reload_fiat
    ];

  final List<String> items;

  final BuildContext context;

  void action(int index) {
    switch (index) {
      case 0:
        _presentReconnectAlert(context);
        break;
      case 1:
        Navigator.of(context).pushNamed(Routes.rescan);
        break;
      case 2:
        context.read<BalanceStore>().updateFiatBalance();
        break;
    }
  }

  Future<void> _presentReconnectAlert(BuildContext context) async {
    final walletStore = context.read<WalletStore>();

    await showSimpleOxenDialog(
        context, tr(context).reconnection, tr(context).reconnect_alert_text,
        onPressed: (context) {
      walletStore.reconnect();
      Navigator.of(context).pop();
    });
  }
}
