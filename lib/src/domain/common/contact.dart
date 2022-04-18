import 'package:hive/hive.dart';

part 'contact.g.dart';

@HiveType(typeId: 0)
class Contact extends HiveObject {
  Contact({required this.name, required this.address, this.raw = 0});

  static const boxName = 'Contacts';

  @HiveField(0)
  String name;

  @HiveField(1)
  String address;

  // unused
  @HiveField(2)
  int raw;
}
