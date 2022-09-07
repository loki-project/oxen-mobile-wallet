import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:oxen_wallet/palette.dart';
import 'package:oxen_wallet/src/stores/settings/settings_store.dart';
import 'package:oxen_wallet/l10n.dart';

abstract class PinCodeWidget extends StatefulWidget {
  PinCodeWidget({Key? key, this.onPinCodeEntered, required this.hasLengthSwitcher})
      : super(key: key);

  final Function(List<int> pin, PinCodeState state)? onPinCodeEntered;
  final bool hasLengthSwitcher;
}

class PinCode extends PinCodeWidget {
  PinCode(Function(List<int> pin, PinCodeState state) onPinCodeEntered,
      bool hasLengthSwitcher, Key key)
      : super(
            key: key,
            onPinCodeEntered: onPinCodeEntered,
            hasLengthSwitcher: hasLengthSwitcher);

  @override
  PinCodeState createState() => PinCodeState();
}

class PinCodeState<T extends PinCodeWidget> extends State<T> {
  static const defaultPinLength = 4;
  static final deleteIcon = Icon(Icons.backspace, color: Palette.blueGrey);
  final _gridViewKey = GlobalKey();

  int pinLength = defaultPinLength;
  List<int> pin = <int>[];
  String title = '';
  double _aspectRatio = 0;

  void setTitle(String title) => setState(() => this.title = title);

  void clear() => setState(() => pin.clear());

  void onPinCodeEntered(PinCodeState state) => widget.onPinCodeEntered?.call(state.pin, this);

  void changePinLength(int length) {
    setState(() {
      pinLength = length;
      pin.clear();
    });
  }

  void setDefaultPinLength() {
    final settingsStore = context.read<SettingsStore>();

    pinLength = settingsStore.defaultPinLength;
    changePinLength(pinLength);
  }

  void calculateAspectRatio() {
    if (_gridViewKey.currentContext == null) {
      _aspectRatio = 0;
      return;
    }
    final renderBox =
        _gridViewKey.currentContext!.findRenderObject() as RenderBox;
    final cellWidth = renderBox.size.width / 3;
    final cellHeight = renderBox.size.height / 4;

    if (cellWidth > 0 && cellHeight > 0) {
      _aspectRatio = cellWidth / cellHeight;
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(afterLayout);
  }

  void afterLayout(dynamic _) {
    setDefaultPinLength();
    calculateAspectRatio();
  }

  @override
  Widget build(BuildContext context) => Scaffold(body: body(context));

  Widget body(BuildContext context) {
    return SafeArea(
        child: Container(
      color: Theme.of(context).backgroundColor,
      padding: EdgeInsets.only(left: 40.0, right: 40.0, bottom: 40.0),
      child: Column(children: <Widget>[
        Spacer(flex: 2),
        Text(title.isNotEmpty ? title : tr(context).enter_your_pin,
            style: TextStyle(fontSize: 24, color: Palette.wildDarkBlue)),
        Spacer(flex: 3),
        Container(
          width: 180,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(pinLength, (index) {
              const size = 10.0;
              final isFilled = index < pin.length;

              return Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFilled ? OxenPalette.teal : Colors.transparent,
                    border: Border.all(color: Palette.wildDarkBlue),
                  ));
            }),
          ),
        ),
        Spacer(flex: 2),
        if (widget.hasLengthSwitcher) ...[
          TextButton(
              onPressed: () {
                changePinLength(pinLength == 4 ? 6 : 4);
              },
              child: Text(
                _changePinLengthText(tr(context)),
                style: TextStyle(fontSize: 16.0, color: Palette.wildDarkBlue),
              ))
        ],
        Spacer(flex: 1),
        Flexible(
            flex: 24,
            child: Container(
                key: _gridViewKey,
                child: _aspectRatio > 0
                    ? GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        childAspectRatio: _aspectRatio,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(12, (index) {
                          const marginRight = 15.0;
                          const marginLeft = 15.0;

                          if (index == 9) {
                            return Container(
                              margin: EdgeInsets.only(
                                  left: marginLeft, right: marginRight),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                              ),
                            );
                          } else if (index == 10) {
                            index = 0;
                          } else if (index == 11) {
                            return Container(
                              margin: EdgeInsets.only(
                                  left: marginLeft, right: marginRight),
                              child: TextButton(
                                onPressed: () => _pop(),
                                style: TextButton.styleFrom(
                                    primary: Colors.transparent,
                                    shape: CircleBorder()),
                                child: deleteIcon,
                              ),
                            );
                          } else {
                            index++;
                          }

                          return Container(
                            margin: EdgeInsets.only(
                                left: marginLeft, right: marginRight),
                            child: TextButton(
                              onPressed: () => _push(index),
                              style: TextButton.styleFrom(
                                  primary: Colors.transparent,
                                  shape: CircleBorder()),
                              child: Text('$index',
                                  style: TextStyle(
                                      fontSize: 23.0, color: Palette.blueGrey)),
                            ),
                          );
                        }),
                      )
                    : null))
      ]),
    ));
  }

  void _push(int num) {
    if (pin.length >= pinLength)
      return;

    setState(() => pin.add(num));

    // ignore: invariant_booleans
    if (pin.length == pinLength)
      onPinCodeEntered(this);
  }

  void _pop() {
    if (pin.isEmpty)
      return;

    pin.removeLast();
  }

  String _changePinLengthText(AppLocalizations l10n) {
    return l10n.use_n_digit_pin(pinLength == 4 ? '6' : '4');
  }
}
