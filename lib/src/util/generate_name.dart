import 'dart:math';

import 'package:flutter/services.dart';

extension StringExtension on String {
  String capitalized() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

Future<List<String>> loadWordList(String path) async {
  final raw = await rootBundle.loadString(path);
  final list = List<String>.from(raw.split(RegExp(' *\n *')));
  list.removeWhere((i) => i.isEmpty);
  return list;
}

Future<String> generateName() async {
  final randomThing = Random();
  final adjectives = await loadWordList('assets/text/Wallet_Adjectives.txt');
  final nouns = await loadWordList('assets/text/Wallet_Nouns.txt');
  return adjectives[randomThing.nextInt(adjectives.length)].capitalized() +
    nouns[randomThing.nextInt(nouns.length)].capitalized();
}
