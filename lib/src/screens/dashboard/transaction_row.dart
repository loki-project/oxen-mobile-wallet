import 'package:flutter/material.dart';
import 'package:oxen_wallet/l10n.dart';
import 'package:oxen_wallet/palette.dart';
import 'package:oxen_wallet/src/wallet/transaction/transaction_direction.dart';

class TransactionRow extends StatelessWidget {
  TransactionRow(
      {required this.direction,
      required this.formattedDate,
      required this.formattedAmount,
      required this.formattedFee,
      required this.isPending,
      required this.isStake,
      required this.onTap});

  final VoidCallback onTap;
  final TransactionDirection direction;
  final String formattedDate;
  final String formattedAmount;
  final String formattedFee;
  final bool isPending;
  final bool isStake;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.only(top: 14, bottom: 14, left: 20, right: 20),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: PaletteDark.darkGrey,
                      width: 0.5,
                      style: BorderStyle.solid))),
          child: Row(children: <Widget>[
            Container(
              height: 27,
              width: 27,
              decoration: BoxDecoration(
                color: direction == TransactionDirection.incoming
                    ? OxenPalette.limeWithOpacity
                    : isStake
                      ? OxenPalette.navyWithOpacity
                      : OxenPalette.lightRedWithOpacity,
                shape: BoxShape.circle,
              ),
              child: Icon(
                direction == TransactionDirection.incoming
                    ? Icons.arrow_downward_rounded
                    : Icons.arrow_upward_rounded,
                color: direction == TransactionDirection.incoming
                    ? OxenPalette.lime
                    : isStake
                      ? OxenPalette.teal
                      : OxenPalette.lightRed,
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                            (
                             direction == TransactionDirection.incoming ? tr(context).received :
                             isStake ? tr(context).stake :
                             tr(context).sent
                            ) + (isPending ? tr(context).pending : ''),
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).primaryTextTheme.subtitle1?.color)),
                        Text(formattedAmount,
                            style: const TextStyle(
                                fontSize: 16, color: Palette.purpleBlue))
                      ]),
                  SizedBox(height: 6),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(formattedDate,
                            style: const TextStyle(
                                fontSize: 13, color: Palette.blueGrey)),
                        Text(direction == TransactionDirection.incoming ? '' : tr(context).fee(formattedFee),
                            style: const TextStyle(
                                fontSize: 13, color: Palette.blueGrey))
                      ]),
                ],
              ),
            ))
          ]),
        ));
  }
}
