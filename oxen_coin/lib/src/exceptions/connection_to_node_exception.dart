class ConnectionToNodeException implements Exception {
  ConnectionToNodeException({required this.message});

  final String message;

  @override
  String toString() => message;
}
