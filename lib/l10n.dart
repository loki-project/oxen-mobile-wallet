import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

export 'package:flutter_gen/gen_l10n/app_localizations.dart' show AppLocalizations;

AppLocalizations tr(BuildContext ctx) {
    return AppLocalizations.of(ctx) ?? lookupAppLocalizations(Locale('en', ''));
}

class LanguageName {
    final String code;
    final String name;
    const LanguageName(this.code, this.name);
}

const languageNames = <LanguageName>[
  LanguageName('en', 'English'),
  LanguageName('de', 'Deutsch (German)'),
  LanguageName('fr', 'Français (French)'),
  // LanguageName('es', 'Español (Spanish)'),
  // LanguageName('hi', 'हिंदी (Hindi)'),
  // LanguageName('ja', '日本 (Japanese)'),
  // LanguageName('ko', '한국어 (Korean)'),
  // LanguageName('nl', 'Nederlands (Dutch)'),
  // LanguageName('pl', 'Polski (Polish)'),
  // LanguageName('pt', 'Português (Portuguese)'),
  // LanguageName('ru', 'Русский (Russian)'),
  // LanguageName('uk', 'Українська (Ukrainian)'),
  // LanguageName('zh', '中文 (Chinese)')
];

class LanguageNotifier with ChangeNotifier {
  LanguageNotifier();
  void trigger() { notifyListeners(); }
}
