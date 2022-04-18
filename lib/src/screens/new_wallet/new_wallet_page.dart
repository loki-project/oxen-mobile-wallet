import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter/material.dart';
import 'package:oxen_wallet/l10n.dart';
import 'package:oxen_wallet/src/stores/wallet_creation/wallet_creation_store.dart';
import 'package:oxen_wallet/src/stores/wallet_creation/wallet_creation_state.dart';
import 'package:oxen_wallet/src/domain/services/wallet_list_service.dart';
import 'package:oxen_wallet/src/domain/services/wallet_service.dart';
import 'package:oxen_wallet/src/screens/base_page.dart';
import 'package:oxen_wallet/src/widgets/primary_button.dart';
import 'package:oxen_wallet/src/widgets/scollable_with_bottom_section.dart';
import 'package:oxen_wallet/palette.dart';
import 'package:oxen_wallet/src/stores/seed_language/seed_language_store.dart';
import 'package:oxen_wallet/src/screens/seed_language/widgets/seed_language_picker.dart';
import 'package:oxen_wallet/src/util/generate_name.dart';

class NewWalletPage extends BasePage {
  NewWalletPage(
      {required this.walletsService,
      required this.walletService,
      required this.sharedPreferences});

  final WalletListService walletsService;
  final WalletService walletService;
  final SharedPreferences sharedPreferences;

  @override
  String getTitle(AppLocalizations t) => t.new_wallet;

  @override
  Widget body(BuildContext context) => WalletNameForm();
}

class WalletNameForm extends StatefulWidget {
  @override
  _WalletNameFormState createState() => _WalletNameFormState();
}

class _WalletNameFormState extends State<WalletNameForm> {
  _WalletNameFormState() {
    setName();
  }

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  Future setName() async {
    final name = await generateName();
    nameController.text = name;
    print(name);
  }

  @override
  Widget build(BuildContext context) {
    final walletCreationStore = Provider.of<WalletCreationStore>(context);
    final seedLanguageStore = Provider.of<SeedLanguageStore>(context);

    reaction((_) => walletCreationStore.state, (WalletCreationState state) {
      if (state is WalletCreatedSuccessfully) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }

      if (state is WalletCreationFailure) {
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text(state.error),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(tr(context).ok),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                );
              });
        });
      }
    });

    return ScrollableWithBottomSection(
        content: Column(children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Image.asset('assets/images/oxen.png',
                height: 124, width: 400),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Form(
                key: _formKey,
                child: TextFormField(
                  style: TextStyle(
                      fontSize: 24.0,
                      color: Theme.of(context).accentTextTheme.subtitle2?.color),
                  controller: nameController,
                  decoration: InputDecoration(
                      hintStyle: TextStyle(
                          fontSize: 24.0, color: Theme.of(context).hintColor),
                      hintText: tr(context).wallet_name,
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: OxenPalette.teal, width: 2.0)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).focusColor,
                              width: 1.0))),
                  validator: (value) {
                    walletCreationStore.validateWalletName(value ?? '', tr(context));
                    return walletCreationStore.errorMessage;
                  },
                )),
          ),
          Padding(padding: EdgeInsets.only(bottom: 20),
            child: Text(
              tr(context).seed_language_choose,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: SeedLanguagePicker(),
          )
        ]),
        bottomSection: Observer(
          builder: (context) {
            return LoadingPrimaryButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  walletCreationStore.create(name: nameController.text,
                      language: seedLanguageStore.selectedSeedLanguage);
                }
              },
              text: tr(context).continue_text,
              color: Theme.of(context).primaryTextTheme.button?.backgroundColor,
              borderColor:
                  Theme.of(context).primaryTextTheme.button?.decorationColor,
              isLoading: walletCreationStore.state is WalletIsCreating,
            );
          },
        ));
  }
}
