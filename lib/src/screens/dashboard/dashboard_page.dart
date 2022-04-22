import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oxen_wallet/l10n.dart';
import 'package:oxen_wallet/palette.dart';
import 'package:oxen_wallet/routes.dart';
import 'package:oxen_wallet/src/domain/common/balance_display_mode.dart';
import 'package:oxen_wallet/src/node/sync_status.dart';
import 'package:oxen_wallet/src/screens/base_page.dart';
import 'package:oxen_wallet/src/screens/dashboard/date_section_row.dart';
import 'package:oxen_wallet/src/screens/dashboard/transaction_row.dart';
import 'package:oxen_wallet/src/screens/dashboard/wallet_menu.dart';
import 'package:oxen_wallet/src/stores/action_list/action_list_store.dart';
import 'package:oxen_wallet/src/stores/action_list/date_section_item.dart';
import 'package:oxen_wallet/src/stores/action_list/transaction_list_item.dart';
import 'package:oxen_wallet/src/stores/balance/balance_store.dart';
import 'package:oxen_wallet/src/stores/settings/settings_store.dart';
import 'package:oxen_wallet/src/stores/sync/sync_store.dart';
import 'package:oxen_wallet/src/stores/wallet/wallet_store.dart';
import 'package:oxen_wallet/src/widgets/picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DashboardPage extends BasePage {
  final _bodyKey = GlobalKey();

  @override
  Widget leading(BuildContext context) {
    return SizedBox(
        width: 30,
        child: FlatButton(
            padding: EdgeInsets.all(0),
            onPressed: () => _presentWalletMenu(context),
            child: Icon(Icons.sync_rounded,
                color: Theme.of(context).primaryTextTheme.caption?.color,
                size: 30)));
  }

  @override
  Widget middle(BuildContext context) {
    final walletStore = Provider.of<WalletStore>(context);

    return Observer(builder: (_) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              walletStore.name,
              style: TextStyle(
                  color: Theme.of(context).primaryTextTheme.headline6?.color),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5),
            Text(
              '${walletStore.account.label}',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                  color: Theme.of(context).primaryTextTheme.headline6?.color),
              overflow: TextOverflow.ellipsis,
            ),
          ]);
    });
  }

  @override
  Widget trailing(BuildContext context) {
    return SizedBox(
      width: 30,
      child: FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: () => Navigator.of(context).pushNamed(Routes.profile),
          child: Icon(Icons.account_circle_rounded,
              color: Theme.of(context).primaryTextTheme.caption?.color,
              size: 30)),
    );
  }

  @override
  Widget body(BuildContext context) => DashboardPageBody(key: _bodyKey);

  void _presentWalletMenu(BuildContext bodyContext) {
    final walletMenu = WalletMenu(bodyContext);

    showDialog<void>(
        builder: (_) => Picker(
            items: walletMenu.items,
            selectedAtIndex: -1,
            title: tr(bodyContext).wallet_menu,
            pickerHeight: 300,
            onItemSelected: (String item) =>
                walletMenu.action(walletMenu.items.indexOf(item))),
        context: bodyContext);
  }
}

class DashboardPageBody extends StatefulWidget {
  DashboardPageBody({required Key key}) : super(key: key);

  @override
  DashboardPageBodyState createState() => DashboardPageBodyState();
}

class DashboardPageBodyState extends State<DashboardPageBody> {
  final _connectionStatusObserverKey = GlobalKey();
  final _balanceObserverKey = GlobalKey();
  final _balanceTitleObserverKey = GlobalKey();
  final _syncingObserverKey = GlobalKey();
  final _listObserverKey = GlobalKey();
  final _listKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final balanceStore = Provider.of<BalanceStore>(context);
    final actionListStore = Provider.of<ActionListStore>(context);
    final syncStore = Provider.of<SyncStore>(context);
    final settingsStore = Provider.of<SettingsStore>(context);
    final t = tr(context);
    final transactionDateFormat = DateFormat.yMMMd(t.localeName).add_jm();

    return Observer(
        key: _listObserverKey,
        builder: (_) {
          final items = actionListStore.items;
          final itemsCount = items.length + 2;

          return ListView.builder(
              key: _listKey,
              padding: EdgeInsets.only(bottom: 15),
              itemCount: itemsCount,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        boxShadow: [
                          BoxShadow(
                              color: Palette.shadowGreyWithOpacity,
                              blurRadius: 10,
                              offset: Offset(0, 12))
                        ]),
                    child: Column(
                      children: <Widget>[
                        Observer(
                            key: _syncingObserverKey,
                            builder: (_) {
                              final status = syncStore.status;
                              final statusText = status.title(t);
                              final progress = syncStore.status.progress();
                              final isFailure = status is FailedSyncStatus;

                              var descriptionText = '';

                              if (status is SyncingSyncStatus) {
                                descriptionText = t.blocks_remaining(syncStore.status.toString());
                              }

                              if (status is FailedSyncStatus) {
                                descriptionText = t.please_try_to_connect_to_another_node;
                              }

                              return Container(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 3,
                                      child: LinearProgressIndicator(
                                        backgroundColor: Palette.separator,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                OxenPalette.teal),
                                        value: progress,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(statusText,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: isFailure
                                                ? OxenPalette.red
                                                : OxenPalette.teal)),
                                    Text(descriptionText,
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: Palette.wildDarkBlue,
                                            height: 2.0))
                                  ],
                                ),
                              );
                            }),
                        GestureDetector(
                          onTapUp: (_) => balanceStore.isReversing = false,
                          onTapDown: (_) => balanceStore.isReversing = true,
                          child: Container(
                            padding: EdgeInsets.only(top: 40, bottom: 40),
                            color: Colors.transparent,
                            child: Column(
                              children: <Widget>[
                                Container(width: double.infinity),
                                Observer(
                                    key: _balanceTitleObserverKey,
                                    builder: (_) {
                                      final savedDisplayMode =
                                          settingsStore.balanceDisplayMode;
                                      final displayMode = balanceStore
                                              .isReversing
                                          ? (savedDisplayMode == BalanceDisplayMode.availableBalance
                                              ? BalanceDisplayMode.fullBalance
                                              : BalanceDisplayMode.availableBalance)
                                          : savedDisplayMode;

                                      return Text(displayMode.getTitle(t),
                                          style: TextStyle(
                                              color: OxenPalette.teal,
                                              fontSize: 16));
                                    }),
                                Observer(
                                    key: _connectionStatusObserverKey,
                                    builder: (_) {
                                      final savedDisplayMode =
                                          settingsStore.balanceDisplayMode;
                                      var balance = '---';
                                      final displayMode = balanceStore.isReversing
                                          ? (savedDisplayMode == BalanceDisplayMode.availableBalance
                                              ? BalanceDisplayMode.fullBalance
                                              : BalanceDisplayMode.availableBalance)
                                          : savedDisplayMode;

                                      if (displayMode == BalanceDisplayMode.availableBalance)
                                        balance = balanceStore.unlockedBalanceString;
                                      else if (displayMode == BalanceDisplayMode.fullBalance)
                                        balance = balanceStore.fullBalanceString;

                                      return Text(
                                        balance,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryTextTheme
                                                .caption
                                                ?.color,
                                            fontSize: 42),
                                      );
                                    }),
                                Padding(
                                    padding: EdgeInsets.only(top: 7),
                                    child: Observer(
                                        key: _balanceObserverKey,
                                        builder: (_) {
                                          final savedDisplayMode =
                                              settingsStore.balanceDisplayMode;
                                          final displayMode = settingsStore
                                                  .enableFiatCurrency
                                              ? (balanceStore.isReversing
                                                  ? (savedDisplayMode == BalanceDisplayMode.availableBalance
                                                      ? BalanceDisplayMode.fullBalance
                                                      : BalanceDisplayMode.availableBalance)
                                                  : savedDisplayMode)
                                              : BalanceDisplayMode.hiddenBalance;
                                          final symbol = settingsStore.fiatCurrency.toString();
                                          var balance = '---';

                                          if (displayMode == BalanceDisplayMode.availableBalance) {
                                            balance = '${balanceStore.fiatUnlockedBalance} $symbol';
                                          }

                                          if (displayMode == BalanceDisplayMode.fullBalance) {
                                            balance = '${balanceStore.fiatFullBalance} $symbol';
                                          }

                                          return Text(balance,
                                              style: TextStyle(
                                                  color: Palette.wildDarkBlue,
                                                  fontSize: 16));
                                        }))
                              ],
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 30),
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.arrow_upward_rounded),
                                        onPressed: () => Navigator.of(context,
                                                rootNavigator: true)
                                            .pushNamed(Routes.send),
                                      ),
                                      Text(t.send)
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      IconButton(
                                        icon:
                                            Icon(Icons.arrow_downward_rounded),
                                        onPressed: () => Navigator.of(context,
                                                rootNavigator: true)
                                            .pushNamed(Routes.receive),
                                      ),
                                      Text(t.receive)
                                    ],
                                  )
                                ],
                              ),
                            )),
                      ],
                    ),
                  );
                }

                if (index == 1 && actionListStore.totalCount > 0) {
                  return Padding(
                    padding: EdgeInsets.only(right: 20, top: 10, bottom: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          PopupMenuButton<int>(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                enabled: false,
                                value: -1,
                                child: Text(t.transactions,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryTextTheme.caption?.color
                                  )
                                )
                              ),
                              PopupMenuItem(
                                value: 0,
                                child: Observer(
                                  builder: (_) => Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(t.incoming),
                                      Checkbox(
                                        value: actionListStore.transactionFilterStore.displayIncoming,
                                        onChanged: (value) => actionListStore.transactionFilterStore.toggleIncoming(),
                                      )
                                    ]
                                  )
                                )
                              ),
                              PopupMenuItem(
                                value: 1,
                                child: Observer(
                                  builder: (_) => Row(
                                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(t.outgoing),
                                      Checkbox(
                                        value: actionListStore.transactionFilterStore.displayOutgoing,
                                        onChanged: (value) => actionListStore.transactionFilterStore.toggleOutgoing(),
                                      )
                                    ]
                                  )
                                )
                              ),
                              PopupMenuItem(
                                value: 2,
                                child: Text(t.transactions_by_date)
                              ),
                            ],
                            child: Text(t.filters,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Theme.of(context).primaryTextTheme.subtitle2?.color
                              )
                            ),
                            onSelected: (item) async {
                              if (item == 2) {
                                final picked = await showDateRangePicker(
                                  context: context,
                                  initialDateRange: DateTimeRange(
                                    start: DateTime.now().subtract(Duration(days: 1)),
                                    end: DateTime.now()
                                  ),
                                  firstDate: DateTime(2018),
                                  lastDate: DateTime.now()
                                );

                                actionListStore.transactionFilterStore.changeStartDate(picked?.start);
                                // Add 1d to the end date because we want the picker returns the
                                // DateTime of the beginning of the end date, but we want to include
                                // everything on that date as well.
                                actionListStore.transactionFilterStore.changeEndDate(
                                  picked == null ? null : picked.end.add(Duration(days: 1)));
                              }
                            },
                          )
                        ]),
                  );
                }

                index -= 2;

                if (index < 0 || index >= items.length) {
                  return Container();
                }

                final item = items[index];

                if (item is DateSectionItem) {
                  return DateSectionRow(date: item.date);
                }

                if (item is TransactionListItem) {
                  final transaction = item.transaction;
                  final savedDisplayMode = settingsStore.balanceDisplayMode;
                  final formattedAmount =
                      savedDisplayMode == BalanceDisplayMode.hiddenBalance ? '---' :
                      transaction.stakeFormatted() ?? transaction.amountFormatted();

                  return TransactionRow(
                      onTap: () => Navigator.of(context).pushNamed(
                          Routes.transactionDetails,
                          arguments: transaction),
                      direction: transaction.direction,
                      formattedDate:
                          transactionDateFormat.format(transaction.date),
                      formattedAmount: formattedAmount,
                      formattedFee: transaction.feeFormatted(),
                      isPending: transaction.isPending,
                      isStake: transaction.isStake);
                }

                return Container();
              });
        });
  }
}
