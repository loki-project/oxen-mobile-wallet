import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oxen_wallet/l10n.dart';
import 'package:oxen_wallet/palette.dart';

Widget oxenAmountField({
    required GestureTapCallback setAll,
    required TextEditingController controller,
    required BuildContext context,
    FormFieldValidator<String>? validator,
}) {

  final theme = Theme.of(context);

  return Padding(
    padding: const EdgeInsets.only(top: 20),
    child: TextFormField(
      style: TextStyle(
        fontSize: 18.0,
        color: theme.accentTextTheme.overline?.color),
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp('[- ]'))
      ],
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: SizedBox(
          width: 75,
          child: Padding(
            padding: EdgeInsets.only(left: 8, top: 12),
            child: Text(
              'OXEN:',
              style: TextStyle(fontSize: 18, color: theme.accentTextTheme.overline?.color)
            )
          ),
        ),
        suffixIcon: Container(
          width: 1,
          padding: EdgeInsets.only(top: 0),
          child: Center(
            child: InkWell(
              onTap: setAll,
              child: Text(
                tr(context).all,
                style: TextStyle(fontSize: 14, color: theme.accentTextTheme.overline?.decorationColor)
              )
            )
          ),
        ),
        hintStyle: TextStyle(fontSize: 18.0, color: theme.hintColor),
        hintText: '0.0000',
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: OxenPalette.teal, width: 2.0)),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: theme.focusColor, width: 1.0)),
        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: OxenPalette.red, width: 1.0)),
        focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: OxenPalette.red, width: 1.0)),
        errorStyle: TextStyle(color: OxenPalette.red)
      ),
    ),
  );
}
