import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:oxen_wallet/src/domain/services/wallet_service.dart';
import 'package:oxen_wallet/src/wallet/oxen/transaction/transaction_description.dart';
import 'package:oxen_wallet/src/screens/dashboard/dashboard_page.dart';
import 'package:oxen_wallet/src/stores/action_list/action_list_store.dart';
import 'package:oxen_wallet/src/stores/action_list/transaction_filter_store.dart';
import 'package:oxen_wallet/src/stores/price/price_store.dart';
import 'package:oxen_wallet/src/stores/settings/settings_store.dart';
import 'package:oxen_wallet/src/stores/wallet/wallet_store.dart';
import 'package:provider/provider.dart';

Widget createDashboardPage(
        {required WalletService walletService,
        required PriceStore priceStore,
        required Box<TransactionDescription> transactionDescriptions,
        required SettingsStore settingsStore,
        required WalletStore walletStore}) =>
    Provider(
        create: (_) => ActionListStore(
            walletService: walletService,
            settingsStore: settingsStore,
            priceStore: priceStore,
            transactionFilterStore: TransactionFilterStore(),
            transactionDescriptions: transactionDescriptions),
        child: DashboardPage());
