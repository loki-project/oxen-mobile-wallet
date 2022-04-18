import 'package:flutter/material.dart';
import 'package:oxen_wallet/l10n.dart';
import 'package:oxen_wallet/palette.dart';
import 'package:oxen_wallet/routes.dart';
import 'package:oxen_wallet/src/domain/common/contact.dart';
import 'package:oxen_wallet/src/domain/common/qr_scanner.dart';
import 'package:oxen_wallet/src/wallet/oxen/subaddress.dart';
import 'package:oxen_wallet/src/widgets/oxen_text_field.dart';

enum AddressTextFieldOption { qrCode, addressBook, subaddressList }

class AddressTextField extends StatelessWidget {
  AddressTextField(
      {required this.controller,
      this.isActive = true,
      this.placeholder,
      this.options = const [
        AddressTextFieldOption.qrCode,
        AddressTextFieldOption.addressBook
      ],
      this.onURIScanned,
      this.focusNode,
      required this.validator});

  static const prefixIconWidth = 34.0;
  static const prefixIconHeight = 34.0;
  static const spaceBetweenPrefixIcons = 10.0;

  final TextEditingController controller;
  final bool isActive;
  final String? placeholder;
  final Function(Uri)? onURIScanned;
  final List<AddressTextFieldOption> options;
  final FormFieldValidator<String> validator;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return OxenTextField(
      enabled: isActive,
      controller: controller,
      focusNode: focusNode,
      suffixIcon: Padding(
        padding: EdgeInsets.only(right: 10),
        child: SizedBox(
          width: prefixIconWidth * options.length + spaceBetweenPrefixIcons * options.length,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 5),
              if (options.contains(AddressTextFieldOption.qrCode)) ...[
                Container(
                  width: prefixIconWidth,
                  height: prefixIconHeight,
                  child: InkWell(
                    onTap: () async => _presentQRScanner(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Palette.wildDarkBlueWithOpacity,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Icon(Icons.qr_code_outlined)
                    ),
                  ),
                ),
              ],
              if (options.contains(AddressTextFieldOption.addressBook)) ...[
                Container(
                  width: prefixIconWidth,
                  height: prefixIconHeight,
                  child: InkWell(
                    onTap: () async => _presetAddressBookPicker(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Palette.wildDarkBlueWithOpacity,
                        borderRadius: BorderRadius.all(Radius.circular(8))
                      ),
                      child: Icon(Icons.contacts_rounded),
                    ),
                  ),
                ),
              ],
              if (options.contains(AddressTextFieldOption.subaddressList)) ...[
                Container(
                  width: prefixIconWidth,
                  height: prefixIconHeight,
                  child: InkWell(
                    onTap: () async => _presetSubaddressListPicker(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Palette.wildDarkBlueWithOpacity,
                        borderRadius: BorderRadius.all(Radius.circular(8))
                      ),
                      child: Icon(Icons.arrow_downward_rounded)
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      hintText: placeholder ?? tr(context).widgets_address,
      validator: validator,
    );
  }

  Future<void> _presentQRScanner(BuildContext context) async {
    try {
      final code = await presentQRScanner();
      if (code == null) // Cancelled, do nothing.
        return;

      final Uri uri;
      try {
        uri = Uri.parse(code);
      } catch (e) {
        controller.text = code;
        return;
      }
      controller.text = uri.path;

      if (onURIScanned != null) {
        onURIScanned!(uri);
      }
    } catch (e) {
      print('Error $e');
    }
  }

  Future<void> _presetAddressBookPicker(BuildContext context) async {
    final contact = await Navigator.of(context, rootNavigator: true)
        .pushNamed(Routes.pickerAddressBook);

    if (contact is Contact)
      controller.text = contact.address;
  }

  Future<void> _presetSubaddressListPicker(BuildContext context) async {
    final subaddress = await Navigator.of(context, rootNavigator: true)
        .pushNamed(Routes.subaddressList);

    if (subaddress is Subaddress)
      controller.text = subaddress.address;
  }
}
