import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oxen_wallet/l10n.dart';
import 'package:oxen_wallet/src/screens/base_page.dart';
import 'package:oxen_wallet/src/stores/settings/settings_store.dart';
import 'package:oxen_wallet/src/widgets/oxen_dialog.dart';
import 'package:provider/provider.dart';

class ChangeLanguage extends BasePage {
  @override
  String? getTitle(AppLocalizations t) => t.settings_change_language;

  @override
  Widget body(BuildContext context) {
    final settingsStore = Provider.of<SettingsStore>(context);
    final langNotifier = Provider.of<LanguageNotifier>(context);

    final currentColor = Theme.of(context).selectedRowColor;
    final notCurrentColor =
        Theme.of(context).accentTextTheme.subtitle1?.backgroundColor;

    final t = tr(context);

    final languages = <LanguageName>[
        LanguageName('', t.change_language_system_default),
        ...languageNames];

    return Container(
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: ListView.builder(
          itemCount: languages.length,
          itemBuilder: (BuildContext context, int index) {
            final lang = languages[index];
            final isCurrent = lang.code == (settingsStore.languageOverride ?? '');

            return Container(
              margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
              color: isCurrent ? currentColor : notCurrentColor,
              child: ListTile(
                title: Text(
                  lang.name,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).primaryTextTheme.headline6?.color
                  ),
                ),
                onTap: () async {
                  if (!isCurrent) {
                    await showSimpleOxenDialog(
                      context,
                      t.change_language,
                      t.change_language_to(lang.name),
                      onPressed: (context) {
                        settingsStore.saveLanguageOverride(lang.code == '' ? null : lang.code);
                        langNotifier.trigger();
                        Navigator.of(context).pop();
                      },
                    );
                  }
                },
              ),
            );
          },
        ));
  }
}
