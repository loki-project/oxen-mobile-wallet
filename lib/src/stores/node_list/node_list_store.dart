import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:hive/hive.dart';
import 'package:oxen_wallet/src/node/node.dart';
import 'package:oxen_wallet/src/node/node_list.dart';
import 'package:oxen_wallet/l10n.dart';

part 'node_list_store.g.dart';

class NodeListStore = NodeListBase with _$NodeListStore;

abstract class NodeListBase with Store {
  NodeListBase({required this.nodesSource}) :
      nodes = ObservableList<Node>() {
    _onNodesChangeSubscription = nodesSource.watch().listen((e) => update());
    update();
  }

  @observable
  ObservableList<Node> nodes;

  @observable
  bool isValid = false;

  @observable
  String? errorMessage;

  Box<Node> nodesSource;

  late StreamSubscription<BoxEvent> _onNodesChangeSubscription;

//  @override
//  void dispose() {
//    super.dispose();
//
//    if (_onNodesChangeSubscription != null) {
//      _onNodesChangeSubscription.cancel();
//    }
//  }

  @action
  void update() =>
      nodes.replaceRange(0, nodes.length, nodesSource.values.toList());

  @action
  Future addNode(
      {required String address, String? port, required String login, required String password}) async {
    var uri = address;

    if (port != null && port.isNotEmpty)
      uri += ':' + port;

    final node = Node(uri: uri, login: login, password: password);
    await nodesSource.add(node);
  }

  @action
  Future remove({required Node node}) async => await node.delete();

  @action
  Future reset() async => await resetToDefault(nodesSource);

  Future<bool> isNodeOnline(Node node) async {
    try {
      return await node.isOnline();
    } catch (e) {
      return false;
    }
  }

  static final nodeAddrRE = RegExp('^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\$|^[-0-9a-zA-Z.]{1,253}\$');
  static final nodePortRE = RegExp('^([1-9][0-9]{0,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$');

  void validateNodeAddress(String value, AppLocalizations l10n) {
    isValid = nodeAddrRE.hasMatch(value);
    errorMessage = isValid ? null : l10n.error_text_node_address;
  }

  void validateNodePort(String value, AppLocalizations l10n) {
    if (nodePortRE.hasMatch(value)) {
      try {
        final intValue = int.parse(value);
        isValid = (intValue > 0 && intValue <= 65535);
      } catch (e) {
        isValid = false;
      }
    } else {
      isValid = false;
    }

    errorMessage = isValid ? null : l10n.error_text_node_port;
  }
}
