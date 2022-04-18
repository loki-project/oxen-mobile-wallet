import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:oxen_wallet/l10n.dart';
import 'package:oxen_wallet/palette.dart';
import 'package:oxen_wallet/src/widgets/primary_button.dart';
import 'package:oxen_wallet/src/widgets/slide_to_act.dart';

Future showOxenDialog(BuildContext context, Widget child,
    {required void Function(BuildContext context) onDismiss}) {
  return showDialog<void>(
      builder: (_) => OxenDialog(body: child, onDismiss: onDismiss),
      context: context);
}

Future showSimpleOxenDialog(BuildContext context, String title, String body,
    {String? buttonText,
    required void Function(BuildContext context) onPressed,
    void Function(BuildContext context)? onDismiss}) {
  return showDialog<void>(
      builder: (_) => SimpleOxenDialog(title, body,
          buttonText: buttonText, onDismiss: onDismiss, onPressed: onPressed),
      context: context);
}

Future showConfirmOxenDialog(BuildContext context, String title, String body,
    {void Function(BuildContext context)? onConfirm,
    Future Function(BuildContext context)? onFutureConfirm,
    void Function(BuildContext context)? onDismiss}) {
  return showDialog<void>(
      builder: (_) => ConfirmOxenDialog(title, body,
          onDismiss: onDismiss,
          onConfirm: onConfirm,
          onFutureConfirm: onFutureConfirm),
      context: context);
}

class OxenDialog extends StatelessWidget {
  OxenDialog({required this.body, this.onDismiss});

  final void Function(BuildContext context)? onDismiss;
  final Widget body;

  void _onDismiss(BuildContext context) {
    if (onDismiss == null) {
      Navigator.of(context).pop();
    } else {
      onDismiss!(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onDismiss(context),
      child: Container(
        color: Colors.transparent,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.55)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    child: body),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SimpleOxenDialog extends StatelessWidget {
  SimpleOxenDialog(this.title, this.body,
      {this.buttonText, required this.onPressed, this.onDismiss});

  final String title;
  final String body;
  final String? buttonText;
  final void Function(BuildContext context) onPressed;
  final void Function(BuildContext context)? onDismiss;

  @override
  Widget build(BuildContext context) {
    return OxenDialog(
        onDismiss: onDismiss,
        body: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          decoration: TextDecoration.none,
                          color: Theme.of(context)
                              .primaryTextTheme
                              .caption
                              ?.color))),
              Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 30),
                  child: Text(body,
                      style: TextStyle(
                          fontSize: 15,
                          decoration: TextDecoration.none,
                          color: Theme.of(context)
                              .primaryTextTheme
                              .caption
                              ?.color))),
              PrimaryButton(
                  text: buttonText ?? tr(context).ok,
                  color:
                      Theme.of(context).primaryTextTheme.button?.backgroundColor,
                  borderColor:
                      Theme.of(context).primaryTextTheme.button?.decorationColor,
                  onPressed: () {
                    onPressed(context);
                  })
            ],
          ),
        ));
  }
}

class ConfirmOxenDialog extends StatelessWidget {
  ConfirmOxenDialog(this.title, this.body,
      {this.onFutureConfirm, this.onConfirm, this.onDismiss});

  final String title;
  final String body;
  final Future Function(BuildContext context)? onFutureConfirm;
  final void Function(BuildContext context)? onConfirm;
  final void Function(BuildContext context)? onDismiss;

  @override
  Widget build(BuildContext context) {
    return OxenDialog(
        onDismiss: onDismiss,
        body: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          decoration: TextDecoration.none,
                          color: Theme.of(context)
                              .primaryTextTheme
                              .caption
                              ?.color))),
              Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 30),
                  child: Text(body,
                      style: TextStyle(
                          fontSize: 15,
                          decoration: TextDecoration.none,
                          color: Theme.of(context)
                              .primaryTextTheme
                              .caption
                              ?.color))),
              SlideToAct(
                text: tr(context).ok,
                outerColor: Theme.of(context).primaryTextTheme.subtitle2?.color,
                innerColor: OxenPalette.teal,
                onFutureSubmit: onFutureConfirm != null
                    ? () async => await onFutureConfirm!(context)
                    : null,
                onSubmit: onConfirm != null ? () => onConfirm!(context) : null,
              )
            ],
          ),
        ));
  }
}
