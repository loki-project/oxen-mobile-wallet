import 'package:oxen_wallet/l10n.dart';

abstract class EnumerableItem<T> {
  const EnumerableItem({required this.raw});

  final T raw;

  String getTitle(AppLocalizations t);
}

mixin Serializable<T> on EnumerableItem<T> {
  static Serializable? deserialize<T>({required T raw}) => null;

  T serialize() => raw;
}
