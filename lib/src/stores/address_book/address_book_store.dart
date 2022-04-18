import 'package:mobx/mobx.dart';
import 'package:oxen_wallet/l10n.dart';
import 'package:oxen_wallet/src/domain/common/contact.dart';
import 'package:hive/hive.dart';
import 'package:oxen_wallet/src/util/validators.dart';

part 'address_book_store.g.dart';

class AddressBookStore = AddressBookStoreBase with _$AddressBookStore;

abstract class AddressBookStoreBase with Store {
  AddressBookStoreBase({required this.contacts}) {
    updateContactList();
  }

  @observable
  List<Contact> contactList = [];

  @observable
  String? errorMessage;

  Box<Contact> contacts;

  @action
  Future add({required Contact contact}) async => contacts.add(contact);

  @action
  Future updateContactList() async => contactList = contacts.values.toList();

  @action
  Future update({required Contact contact}) async => contact.save();

  @action
  Future delete({required Contact contact}) async => await contact.delete();

  void validateContactName(String? value, AppLocalizations l10n) {
    errorMessage = hasNonWhitespace(value) ? null : l10n.error_text_empty;
  }

  void validateAddress(String value, {required AppLocalizations l10n}) {
    errorMessage = isValidOxenAddress(value) ? null : l10n.error_text_address;
  }
}
