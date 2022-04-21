import 'dart:math';

import 'package:flutter/material.dart';
import 'package:oxen_coin/oxen_coin_structs.dart';
import 'package:oxen_coin/stake.dart';
import 'package:oxen_wallet/l10n.dart';
import 'package:oxen_wallet/palette.dart';
import 'package:oxen_wallet/routes.dart';
import 'package:oxen_wallet/src/screens/auth/auth_page.dart';
import 'package:oxen_wallet/src/screens/base_page.dart';
import 'package:oxen_wallet/src/wallet/crypto_amount_format.dart';
import 'package:oxen_wallet/src/wallet/oxen/oxen_amount_format.dart';
import 'package:oxen_wallet/src/widgets/nav/nav_list_header.dart';
import 'package:oxen_wallet/src/widgets/nav/nav_list_trailing.dart';
import 'package:oxen_wallet/src/widgets/oxen_dialog.dart';
import 'package:oxen_wallet/devtools.dart';

const double fullSNStake = isTestnet ? 100 : 15000;

extension StakeParsing on StakeRow {
  double get ownedPercentage {
    final percentage = amount / OXEN_DIVISOR / fullSNStake;
    if (percentage > 1) return 1;
    return percentage;
  }
}

class StakePage extends BasePage {
  final _bodyKey = GlobalKey();

  @override
  Widget body(BuildContext context) => StakePageBody(key: _bodyKey);
}

class StakePageBody extends StatefulWidget {
  StakePageBody({required Key key}) : super(key: key);

  @override
  StakePageBodyState createState() => StakePageBodyState();
}

class StakePageBodyState extends State<StakePageBody> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<StakeRow>>(
        future: getAllStakes(),
        builder: (BuildContext context, AsyncSnapshot<List<StakeRow>> snapshot) {
          final t = tr(context);
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError || !snapshot.hasData) {
              return Center(
                child: Container(
                    width: 200,
                    height: 400,
                    child: Center(
                      child: Text(snapshot.error?.toString() ?? 'No snapshot stake data'),
                    )
                ),
              );
            }
            final allStakes = snapshot.data!;
            final goodColor = OxenPalette.lime;
            final badColor = OxenPalette.lightRed;
            var totalAmountStaked = 0;
            for (final stake in allStakes) {
              totalAmountStaked += stake.amount;
            }
            final stakePercentage = allStakes.isEmpty ? 1.0 : min(totalAmountStaked / OXEN_DIVISOR / fullSNStake, 1.0);
            return ListView(
              children: [
                SizedBox(
                  height: 160.0,
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Container(
                          width: 140,
                          height: 140,
                          child: CircularProgressIndicator(
                            strokeWidth: 15,
                            value: stakePercentage,
                            valueColor: AlwaysStoppedAnimation<Color>(allStakes.isEmpty ? badColor : goodColor),
                          ),
                        ),
                      ),
                      Center(
                          child: Text(allStakes.isNotEmpty
                              ? oxenAmountToString(totalAmountStaked, detail: AmountDetail.none) + '\nOXEN'
                              : t.nothing_staked,
                              style: TextStyle(fontSize: 24, color: Palette.blueGrey, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                          )
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_upward_rounded),
                        onPressed: () => Navigator.of(context, rootNavigator: true)
                            .pushNamed(Routes.newStake),
                      ),
                      Text(allStakes.isEmpty
                          ? t.start_staking
                          : t.stake_more)
                    ],
                  ),
                ),
                if (allStakes.isNotEmpty)
                  NavListHeader(title: t.your_contributions),
                if (allStakes.isNotEmpty)
                  for (var stake in allStakes)
                        Dismissible(
                            key: Key(stake.serviceNodeKey),
                            confirmDismiss: (direction) async {
                              if (!canRequestUnstake(stake.serviceNodeKey)) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(t.unable_unlock_stake),
                                  backgroundColor: Colors.red,
                                ));
                                return false;
                              }
                              var isSuccessful = false;
                              var isAuthenticated = false;

                              await Navigator.of(context).pushNamed(Routes.auth,
                                  arguments: (bool isAuthenticatedSuccessfully,
                                      AuthPageState auth) async {
                                    if (isAuthenticatedSuccessfully) {
                                      isAuthenticated = true;
                                      Navigator.of(auth.context).pop();
                                    }
                                  });

                              if (isAuthenticated) {
                                await showConfirmOxenDialog(
                                    context,
                                    t.title_confirm_unlock_stake,
                                    t.body_confirm_unlock_stake(stake.serviceNodeKey),
                                    onDismiss: (buildContext) {
                                      isSuccessful = false;
                                      Navigator.of(buildContext).pop();
                                    },
                                    onConfirm: (buildContext) {
                                      isSuccessful = true;
                                      Navigator.of(buildContext).pop();
                                    },
                                );
                              }

                              return isSuccessful;
                            },
                            onDismissed: (direction) async {
                              await submitStakeUnlock(stake.serviceNodeKey);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(t.unlock_stake_requested),
                                backgroundColor: Colors.green,
                              ));
                            },
                            direction: DismissDirection.endToStart,
                            background: Container(
                                padding: EdgeInsets.only(right: 10.0),
                                alignment: AlignmentDirectional.centerEnd,
                                color: OxenPalette.red,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Icon(
                                      Icons.arrow_downward_sharp,
                                      color: Colors.white,
                                    )
                                  ],
                                )),
                            child: NavListTrailing(
                              leading: SizedBox(
                                height: 50,
                                width: 50,
                                child: Stack(
                                  children: [
                                    Center(child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(stake.decommissioned ? badColor : goodColor),
                                        value: stake.ownedPercentage)),
                                    Center(child: Text(
                                        stake.decommissioned ? '⚠' :
                                        stake.unlockHeight != null && stake.unlockHeight! > 0 ? '🔓' :
                                        stake.awaiting ? '📬' :
                                        '👍',
                                        style: TextStyle(fontSize: 16, color: Palette.blueGrey, fontWeight: FontWeight.bold)
                                    )),
                                  ]
                                )
                              ),
                              text: '${stake.serviceNodeKey.substring(0, 10)}...${stake.serviceNodeKey.substring(stake.serviceNodeKey.length - 3)}',
                              trailing: Text('${oxenAmountToString(stake.amount)} OXEN',
                                    style: TextStyle(fontSize: 16, color: Palette.blueGrey)),
                            ),
                        )
              ],
            );
          } else {
            return Center(
              child: Container(
                width: 200,
                height: 400,
                child: Center(
                  child: CircularProgressIndicator(),
                )
              ),
            );
          }
        },
    );
  }
}
