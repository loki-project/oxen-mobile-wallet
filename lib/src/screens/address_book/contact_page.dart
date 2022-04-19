import 'package:flutter/material.dart';
import 'package:oxen_wallet/l10n.dart';
import 'package:oxen_wallet/src/domain/common/contact.dart';
import 'package:oxen_wallet/src/screens/base_page.dart';
import 'package:oxen_wallet/src/stores/address_book/address_book_store.dart';
import 'package:oxen_wallet/src/widgets/address_text_field.dart';
import 'package:oxen_wallet/src/widgets/oxen_text_field.dart';
import 'package:oxen_wallet/src/widgets/primary_button.dart';
import 'package:oxen_wallet/src/widgets/scollable_with_bottom_section.dart';
import 'package:provider/provider.dart';

class ContactPage extends BasePage {
  ContactPage({this.contact});

  final Contact? contact;

  @override
  String getTitle(AppLocalizations t) => t.contact;

  @override
  Widget body(BuildContext context) => ContactForm(contact);
}

class ContactForm extends StatefulWidget {
  ContactForm(this.contact);

  final Contact? contact;

  @override
  State<ContactForm> createState() => ContactFormState();
}

class ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _contactNameController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      _contactNameController.text = widget.contact!.name;
      _addressController.text = widget.contact!.address;
    }
  }

  @override
  void dispose() {
    _contactNameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addressBookStore = Provider.of<AddressBookStore>(context);

    return ScrollableWithBottomSection(
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              OxenTextField(
                hintText: tr(context).contact_name,
                controller: _contactNameController,
                validator: (value) {
                  addressBookStore.validateContactName(value ?? '', tr(context));
                  return addressBookStore.errorMessage;
                },
              ),
              SizedBox(height: 14.0),
              AddressTextField(
                controller: _addressController,
                options: [AddressTextFieldOption.qrCode],
                validator: (value) {
                  addressBookStore.validateAddress(value ?? '',
                      l10n: tr(context));
                  return addressBookStore.errorMessage;
                },
              )
            ],
          ),
        ),
        bottomSection: Row(
          children: <Widget>[
            Expanded(
              child: PrimaryButton(
                  onPressed: () {
                    setState(() {
                      _contactNameController.text = '';
                      _addressController.text = '';
                    });
                  },
                  text: tr(context).reset,
                  color:
                      Theme.of(context).accentTextTheme.button?.backgroundColor,
                  borderColor:
                      Theme.of(context).accentTextTheme.button?.decorationColor),
            ),
            SizedBox(width: 20),
            Expanded(
                child: PrimaryButton(
                    onPressed: () async {
                      if (!(_formKey.currentState?.validate() ?? false)) return;

                      try {
                        if (widget.contact == null) {
                          final newContact = Contact(
                              name: _contactNameController.text,
                              address: _addressController.text);

                          await addressBookStore.add(contact: newContact);
                        } else {
                          widget.contact!.name = _contactNameController.text;
                          widget.contact!.address = _addressController.text;

                          await addressBookStore.update(contact: widget.contact!);
                        }
                        Navigator.pop(context);
                      } catch (e) {
                        await showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  e.toString(),
                                  textAlign: TextAlign.center,
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text(tr(context).ok))
                                ],
                              );
                            });
                      }
                    },
                    text: tr(context).save,
                    color: Theme.of(context)
                        .primaryTextTheme
                        .button
                        ?.backgroundColor,
                    borderColor: Theme.of(context)
                        .primaryTextTheme
                        .button
                        ?.decorationColor))
          ],
        ));
  }
}
