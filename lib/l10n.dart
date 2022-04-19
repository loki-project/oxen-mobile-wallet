import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

export 'package:flutter_gen/gen_l10n/app_localizations.dart' show AppLocalizations;

AppLocalizations tr(BuildContext ctx) {
    return AppLocalizations.of(ctx) ?? lookupAppLocalizations(Locale('en', ''));
}
