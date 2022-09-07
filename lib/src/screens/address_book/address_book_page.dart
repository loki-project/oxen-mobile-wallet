import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:oxen_wallet/l10n.dart';
import 'package:oxen_wallet/palette.dart';
import 'package:oxen_wallet/routes.dart';
import 'package:oxen_wallet/src/screens/base_page.dart';
import 'package:oxen_wallet/src/stores/address_book/address_book_store.dart';
import 'package:oxen_wallet/src/widgets/oxen_dialog.dart';
import 'package:provider/provider.dart';

class AddressBookPage extends BasePage {
  AddressBookPage({this.isEditable = true});

  final bool isEditable;

  @override
  String getTitle(AppLocalizations t) => t.address_book;

  @override
  Widget? trailing(BuildContext context) {
    if (!isEditable) return null;

    final addressBookStore = Provider.of<AddressBookStore>(context);

    return Container(
        width: 28.0,
        height: 28.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Theme.of(context).selectedRowColor),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Icon(Icons.add, color: OxenPalette.teal, size: 22.0),
            ButtonTheme(
              minWidth: 28.0,
              height: 28.0,
              child: TextButton(
                  style: TextButton.styleFrom(shape: CircleBorder()),
                  onPressed: () async {
                    await Navigator.of(context)
                        .pushNamed(Routes.addressBookAddContact);
                    await addressBookStore.updateContactList();
                  },
                  child: Offstage()),
            )
          ],
        ));
  }

  @override
  Widget body(BuildContext context) {
    final addressBookStore = Provider.of<AddressBookStore>(context);

    return Container(
        padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: Observer(
          builder: (_) => ListView.separated(
              separatorBuilder: (_, __) => Divider(
                    color: Theme.of(context).dividerTheme.color,
                    height: 1.0,
                  ),
              itemCount: addressBookStore.contactList.length,
              itemBuilder: (BuildContext context, int index) {
                final contact = addressBookStore.contactList[index];

                final content = ListTile(
                  onTap: () async {
                    if (!isEditable) {
                      Navigator.of(context).pop(contact);
                      return;
                    }

                    final isCopied = await showNameAndAddressDialog(
                        context, contact.name, contact.address);

                    if (isCopied) {
                      await Clipboard.setData(
                          ClipboardData(text: contact.address));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Copied to Clipboard'),
                          backgroundColor: Colors.green,
                          duration: Duration(milliseconds: 1500),
                        ),
                      );
                    }
                  },
                  leading: Container(
                    height: 25.0,
                    width: 48.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: OxenPalette.tealWithOpacity,
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Text(
                      'OXEN',
                      style: TextStyle(
                        fontSize: 11.0,
                        color: OxenPalette.teal,
                      ),
                    ),
                  ),
                  title: Text(
                    contact.name,
                    style: TextStyle(
                        fontSize: 16.0,
                        color:
                            Theme.of(context).primaryTextTheme.headline6?.color),
                  ),
                );

                return !isEditable
                    ? content
                    : Slidable(
                        key: Key('${contact.key}'),
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          children: [
                            SlidableAction(
                              label: 'Edit',
                              backgroundColor: Colors.blue,
                              icon: Icons.edit,
                              onPressed: (context) async {
                                await Navigator.of(context).pushNamed(
                                    Routes.addressBookAddContact,
                                    arguments: contact);
                                await addressBookStore.updateContactList();
                              },
                            ),
                            SlidableAction(
                              label: 'Delete',
                              backgroundColor: Colors.red,
                              icon: CupertinoIcons.delete,
                              onPressed: (context) async {
                                await showAlertDialog(context).then(
                                    (isDelete) async {
                                      if (isDelete) {
                                        await addressBookStore.delete(contact: contact);
                                        await addressBookStore.updateContactList();
                                      }
                                    });
                              },
                            ),
                          ]
                        ),
                        startActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          dismissible: DismissiblePane(
                            onDismissed: () async {
                              await addressBookStore.delete(contact: contact);
                              await addressBookStore.updateContactList();
                            },
                            confirmDismiss: () async {
                              return await showAlertDialog(context);
                            },
                          ),
                          children: [],
                        ),
                        child: content,
                      );
              }),
        ));
  }

  Future<bool> showAlertDialog(BuildContext context) async {
    var result = false;
    await showConfirmOxenDialog(context, tr(context).remove_contact,
        tr(context).remove_contact_confirm,
        onDismiss: (context) => Navigator.pop(context, false),
        onConfirm: (context) {
          result = true;
          Navigator.pop(context, true);
        });
    return result;
  }

  Future<bool> showNameAndAddressDialog(
      BuildContext context, String name, String address) async {
    var result = false;
    await showSimpleOxenDialog(
      context,
      name,
      address,
      buttonText: 'Copy',
      onPressed: (context) {
        result = true;
        Navigator.of(context).pop(true);
      },
    );
    return result;
  }
}
