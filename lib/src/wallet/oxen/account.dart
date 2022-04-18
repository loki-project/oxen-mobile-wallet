import 'package:oxen_coin/oxen_coin_structs.dart';

class Account {
  Account({required this.id, this.label = ''});

  Account.fromMap(Map map)
      : id = map['id'] == null ? 0 : int.parse(map['id'] as String),
        label = (map['label'] ?? '') as String;

  Account.fromRow(AccountRow row)
      : id = row.getId(),
        label = row.getLabel();

  final int id;
  final String label;
}
