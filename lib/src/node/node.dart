import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

part 'node.g.dart';

@HiveType(typeId: 1)
class Node extends HiveObject {
  Node({required this.uri, this.login, this.password});

  Node.fromMap(Map map)
      : uri = (map['uri'] ?? '') as String,
        login = map['login'] as String?,
        password = map['password'] as String?;

  static const boxName = 'Nodes';

  @HiveField(0)
  String uri;

  @HiveField(1)
  String? login;

  @HiveField(2)
  String? password;

  Future<bool> isOnline() async {
    final resBody = await sendRPCRequest('get_info');
    return !(resBody['result']['offline'] as bool);
  }

  Future<Map<String, dynamic>> sendRPCRequest(String method,
      {Map? params}) async {
    Map<String, dynamic> resultBody;

    final requestBody = params != null
        ? {'jsonrpc': '2.0', 'id': '0', 'method': method, 'params': params}
        : {'jsonrpc': '2.0', 'id': '0', 'method': method};

    // Disable: the auth code was removed as it only supported Digest-MD5 auth, which is insecure and deprecated.
    /*
    if (login != null && password != null) {
      final digestRequest = DigestRequest();
      final response = await digestRequest.request(
          uri: uri, login: login!, password: password!, requestBody: requestBody);
      resultBody = response.data as Map<String, dynamic>;
    } else */ {
      final url = Uri.http(uri, '/json_rpc');
      final headers = {'Content-type': 'application/json'};
      final body = json.encode(requestBody);
      final response =
          await http.post(url, headers: headers, body: body);
      resultBody = json.decode(response.body) as Map<String, dynamic>;
    }

    return resultBody;
  }
}
