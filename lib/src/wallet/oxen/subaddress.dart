import 'package:oxen_coin/oxen_coin_structs.dart';

class Subaddress {
  Subaddress({required this.id, required this.address, required this.label});

  Subaddress.fromMap(Map map)
      : id = map['id'] == null ? 0 : int.parse(map['id'] as String),
        address = (map['address'] ?? '') as String,
        label = (map['label'] ?? '') as String;

  Subaddress.fromRow(SubaddressRow row)
      : id = row.getId(),
        address = row.getAddress(),
        label = row.getLabel();

  final int id;
  final String address;
  final String label;
}
