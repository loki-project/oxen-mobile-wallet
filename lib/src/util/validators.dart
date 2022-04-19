import 'package:oxen_wallet/devtools.dart';

final _base58RE = RegExp('[1-9A-HJ-NP-Za-km-z]+\$');
const int _addrLen = isTestnet ? 97 : 95;
const int _addrLenIntegrated = _addrLen + 11;
final _regPrefixRE = isTestnet ? RegExp('^T6[STU]') : RegExp('^L[4-9A-E]');
final _intPrefixRE = isTestnet ? RegExp('^TG[89AB]') : RegExp('^L[E-HJ-NPQ]');
final _subPrefixRE = isTestnet ? RegExp('^TR[qrs]') : RegExp('^L[Q-Za]');

bool isValidOxenAddress(String? value) =>
  value != null && _base58RE.hasMatch(value) && (
      (value.length == _addrLen && (_regPrefixRE.hasMatch(value) || _subPrefixRE.hasMatch(value)))
      ||
      (value.length == _addrLenIntegrated && _intPrefixRE.hasMatch(value)));

final _hexKeyRE = RegExp('^[0-9a-fA-F]{64}\$');
bool isHexKey(String? value) => value != null && _hexKeyRE.hasMatch(value);

final _nonWhitespaceRE = RegExp('\\S');
bool hasNonWhitespace(String? value) => value != null && _nonWhitespaceRE.hasMatch(value);
