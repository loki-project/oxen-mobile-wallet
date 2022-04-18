import 'package:flutter/material.dart';
import 'package:oxen_wallet/palette.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:oxen_wallet/src/stores/seed_language/seed_language_store.dart';
import 'package:oxen_wallet/src/widgets/present_picker.dart';
import 'package:oxen_wallet/l10n.dart';

class SeedLanguagePicker extends StatelessWidget {
  List<String> getSeedLocales(AppLocalizations l10n) {
    return [
      l10n.seed_language_english,
      l10n.seed_language_chinese,
      l10n.seed_language_dutch,
      l10n.seed_language_german,
      l10n.seed_language_japanese,
      l10n.seed_language_portuguese,
      l10n.seed_language_russian,
      l10n.seed_language_spanish,
      l10n.seed_language_french,
      l10n.seed_language_italian
    ];
  }

  @override
  Widget build(BuildContext context) {
    final seedLocales = getSeedLocales(tr(context));
    final seedLanguageStore = Provider.of<SeedLanguageStore>(context);

    return Observer(
        builder: (_) => InkWell(
          onTap: () => _setSeedLanguage(context),
          child: Container(
            padding: EdgeInsets.all(8.0),
            //width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).dividerTheme.color ?? Palette.lightGrey
                ),
                borderRadius: BorderRadius.circular(8.0)
            ),
            child: Text(seedLocales[seedLanguages.indexOf(seedLanguageStore.selectedSeedLanguage)],
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0, color: Palette.lightBlue),
            ),
          ),
        ));
  }

  Future<void> _setSeedLanguage(BuildContext context) async {
    final seedLocales = getSeedLocales(tr(context));
    final seedLanguageStore = context.read<SeedLanguageStore>();
    var selectedSeedLanguage = await presentPicker(context, seedLocales);

    if (selectedSeedLanguage != null) {
      selectedSeedLanguage = seedLanguages[seedLocales.indexOf(selectedSeedLanguage)];
      seedLanguageStore.setSelectedSeedLanguage(selectedSeedLanguage);
    }
  }
}
