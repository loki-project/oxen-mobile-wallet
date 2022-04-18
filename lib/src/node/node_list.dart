import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:oxen_wallet/devtools.dart';
import 'package:oxen_wallet/src/node/node.dart';
import 'package:yaml/yaml.dart';

Future<List<Node>> loadDefaultNodes() async {
  final nodeListFileName =
      isTestnet ? 'testnet_node_list.yml' : 'node_list.yml';
  final nodesRaw = await rootBundle.loadString('assets/$nodeListFileName');
  final nodes = loadYaml(nodesRaw) as YamlList;

  final n = <Node>[];
  nodes.forEach((dynamic raw) {
    if (raw is Map)
      n.add(Node.fromMap(raw));
  });
  return n;
}

Future resetToDefault(Box<Node> nodeSource) async {
  final nodes = await loadDefaultNodes();
  final entities = <int, Node>{};

  await nodeSource.clear();

  for (var i = 0; i < nodes.length; i++) {
    entities[i] = nodes[i];
  }

  await nodeSource.putAll(entities);
}
