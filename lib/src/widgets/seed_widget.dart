import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oxen_wallet/l10n.dart';
import 'package:oxen_wallet/palette.dart';
import 'package:oxen_wallet/src/wallet/mnemonic_item.dart';
import 'package:oxen_wallet/src/wallet/oxen/mnemonics/chinese_simplified.dart';
import 'package:oxen_wallet/src/wallet/oxen/mnemonics/dutch.dart';
import 'package:oxen_wallet/src/wallet/oxen/mnemonics/english.dart';
import 'package:oxen_wallet/src/wallet/oxen/mnemonics/english_old.dart';
import 'package:oxen_wallet/src/wallet/oxen/mnemonics/french.dart';
import 'package:oxen_wallet/src/wallet/oxen/mnemonics/german.dart';
import 'package:oxen_wallet/src/wallet/oxen/mnemonics/italian.dart';
import 'package:oxen_wallet/src/wallet/oxen/mnemonics/japanese.dart';
import 'package:oxen_wallet/src/wallet/oxen/mnemonics/portuguese.dart';
import 'package:oxen_wallet/src/wallet/oxen/mnemonics/russian.dart';
import 'package:oxen_wallet/src/wallet/oxen/mnemonics/spanish.dart';
import 'package:oxen_wallet/src/widgets/primary_button.dart';

final List<String> _englishWords =
    EnglishMnemonics.words + EnglishOldMnemonics.words;

class SeedWidget extends StatefulWidget {
  SeedWidget({required Key key, required this.onMnemonicChange, required this.onFinish, required this.seedLanguage})
      : super(key: key) {
    switch (seedLanguage) {
      case 'English':
        words = _englishWords;
        break;
      case 'Chinese (simplified)':
        words = ChineseSimplifiedMnemonics.words;
        break;
      case 'Dutch':
        words = DutchMnemonics.words;
        break;
      case 'German':
        words = GermanMnemonics.words;
        break;
      case 'Japanese':
        words = JapaneseMnemonics.words;
        break;
      case 'Portuguese':
        words = PortugueseMnemonics.words;
        break;
      case 'Russian':
        words = RussianMnemonics.words;
        break;
      case 'Spanish':
        words = SpanishMnemonics.words;
        break;
      case 'French':
        words = FrenchMnemonics.words;
        break;
      case 'Italian':
        words = ItalianMnemonics.words;
        break;
      default:
        words = _englishWords;
    }
  }

  final Function(List<MnemonicItem>) onMnemonicChange;
  final Function() onFinish;
  final String seedLanguage;
  late final List<String> words;

  @override
  SeedWidgetState createState() => SeedWidgetState();
}

class SeedWidgetState extends State<SeedWidget> {
  static const maxLength = 25;

  List<MnemonicItem> items = <MnemonicItem>[];
  final _seedController = TextEditingController();
  final _seedTextFieldKey = GlobalKey();
  MnemonicItem? selectedItem;

  List<MnemonicItem> currentMnemonics = [];
  bool isCurrentMnemonicValid = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    isCurrentMnemonicValid = false;
    _seedController
        .addListener(() => changeCurrentMnemonic(_seedController.text));
  }

  void addMnemonic(String text) {
    setState(() => items
        .add(MnemonicItem(text: text.trim(), dic: widget.words)));
    _seedController.text = '';

    widget.onMnemonicChange(items);
  }

  void mnemonicFromText(String text) {
    final splitted = text.split(' ');

    if (splitted.length >= 2) {
      for (final text in splitted) {
        if (text == ' ' || text.isEmpty) {
          continue;
        }

        if (selectedItem != null) {
          editTextOfSelectedMnemonic(text);
        } else {
          addMnemonic(text);
        }
      }
    }
  }

  void selectMnemonic(MnemonicItem item) {
    setState(() {
      selectedItem = item;
      currentMnemonics = [item];

      _seedController
        ..text = item.text
        ..selection = TextSelection.collapsed(offset: item.text.length);
    });
  }

  void onMnemonicTap(MnemonicItem item) {
    if (selectedItem == item) {
      setState(() => selectedItem = null);
      _seedController.text = '';
      return;
    }

    selectMnemonic(item);
  }

  void editTextOfSelectedMnemonic(String text) {
    setState(() => selectedItem?.changeText(text));
    selectedItem = null;
    _seedController.text = '';

    widget.onMnemonicChange(items);
  }

  void clear() {
    setState(() {
      items = [];
      selectedItem = null;
      _seedController.text = '';

      widget.onMnemonicChange(items);
    });
  }

  void replaceText(String text) {
    setState(() => items = []);
    mnemonicFromText(text);
  }

  void changeCurrentMnemonic(String text) {
    setState(() {
      final trimmedText = text.trim();
      final splitted = trimmedText.split(' ');
      _errorMessage = null;

      if (text.isEmpty) {
        currentMnemonics = [];
        isCurrentMnemonicValid = false;
        return;
      }

      currentMnemonics = splitted
          .map((text) => MnemonicItem(text: text, dic: widget.words))
          .toList();

      var isValid = true;

      for (final word in currentMnemonics) {
        isValid = word.isCorrect();

        if (!isValid) {
          break;
        }
      }

      isCurrentMnemonicValid = isValid;
    });
  }

  void saveCurrentMnemonicToItems() {
    setState(() {
      if (selectedItem != null) {
        selectedItem!.changeText(currentMnemonics.first.text.trim());
        selectedItem = null;
      } else {
        items.addAll(currentMnemonics);
      }

      currentMnemonics = [];
      _seedController.text = '';
    });
  }

  void showErrorIfExist(AppLocalizations t) {
    setState(() => _errorMessage =
        !isCurrentMnemonicValid ? t.incorrect_seed : null);
  }

  bool isSeedValid() {
    for (final item in items) {
      if (!item.isCorrect())
        return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final t = tr(context);
    return Container(
      child: Column(children: [
        Flexible(
            fit: FlexFit.tight,
            flex: 6,
            child: SingleChildScrollView(
              child: Wrap(
                  children: items.map((item) {
                final isValid = item.isCorrect();
                final isSelected = selectedItem == item;

                return InkWell(
                  onTap: () => onMnemonicTap(item),
                  child: Container(
                      decoration: BoxDecoration(
                          color:
                              isValid ? Colors.transparent : OxenPalette.red),
                      margin: EdgeInsets.only(right: 7, bottom: 8),
                      child: Text(
                        item.toString(),
                        style: TextStyle(
                            color:
                                isValid ? Palette.blueGrey : Palette.lightGrey,
                            fontSize: 18,
                            fontWeight:
                                isSelected ? FontWeight.w900 : FontWeight.w400,
                            decoration: isSelected
                                ? TextDecoration.underline
                                : TextDecoration.none),
                      )),
                );
              }).toList()),
            )),
        Flexible(
            fit: FlexFit.tight,
            flex: 8,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(children: <Widget>[
                    TextFormField(
                      key: _seedTextFieldKey,
                      onFieldSubmitted: (text) => isCurrentMnemonicValid
                          ? saveCurrentMnemonicToItems()
                          : null,
                      style: TextStyle(fontSize: 14.0),
                      controller: _seedController,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 145),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                      '${items.length}/${SeedWidgetState.maxLength}',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12)),
                                  SizedBox(width: 10),
                                  InkWell(
                                    onTap: () async =>
                                        Clipboard.getData('text/plain').then(
                                            (clipboard) => replaceText(clipboard?.text ?? '')),
                                    child: Container(
                                        height: 35,
                                        padding: EdgeInsets.all(7),
                                        decoration: BoxDecoration(
                                            color:
                                                Palette.wildDarkBlueWithOpacity,
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Text(t.paste)),
                                  )
                                ],
                              ),
                            ),
                          ),
                          hintStyle:
                              TextStyle(color: Theme.of(context).hintColor),
                          hintText: t.restore_from_seed_placeholder,
                          errorText: _errorMessage,
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: OxenPalette.teal, width: 2.0)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).focusColor,
                                  width: 1.0))),
                      enableInteractiveSelection: false,
                    ),
                  ]),
                  Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: (selectedItem == null && items.length == maxLength)
                          ? PrimaryButton(
                              text: t.restore_next,
                              isDisabled: !isSeedValid(),
                              onPressed: widget.onFinish,
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .button
                                  ?.backgroundColor,
                              borderColor: Theme.of(context)
                                  .primaryTextTheme
                                  .button
                                  ?.decorationColor)
                          : PrimaryButton(
                              text: selectedItem != null
                                  ? t.save
                                  : t.add_new_word,
                              onPressed: () => isCurrentMnemonicValid
                                  ? saveCurrentMnemonicToItems()
                                  : null,
                              onDisabledPressed: () => showErrorIfExist(t),
                              isDisabled: !isCurrentMnemonicValid,
                              color: PaletteDark.darkThemeBlueButton,
                              borderColor: Palette.brightBlue))
                ]))
      ]),
    );
  }
}
