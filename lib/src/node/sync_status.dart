import 'package:oxen_wallet/l10n.dart';
import 'dart:math';

abstract class SyncStatus {
  const SyncStatus(this.currHeight, this.targetHeight);

  final int currHeight;
  final int targetHeight;
  double progress() => targetHeight > 0 ? max(currHeight / targetHeight, 1.0) : 0.0;

  String title(AppLocalizations t);
}

class SyncingSyncStatus extends SyncStatus {
  const SyncingSyncStatus(int currHeight, int targetHeight) : super(currHeight, targetHeight);

  @override
  String title(AppLocalizations t) => t.sync_status_synchronizing(currHeight, targetHeight);
}

class SyncedSyncStatus extends SyncStatus {
  const SyncedSyncStatus(int height) : super(height, height);

  @override
  String title(AppLocalizations t) => t.sync_status_synchronized(currHeight);
}

class NotConnectedSyncStatus extends SyncStatus {
  const NotConnectedSyncStatus(int currHeight) : super(currHeight, 0);

  @override
  String title(AppLocalizations t) => t.sync_status_not_connected(currHeight);
}

class StartingSyncStatus extends SyncStatus {
  const StartingSyncStatus(int currHeight) : super(currHeight, 0);

  @override
  String title(AppLocalizations t) => t.sync_status_starting_sync(currHeight);
}

class FailedSyncStatus extends SyncStatus {
  const FailedSyncStatus(int currHeight) : super(currHeight, 0);

  @override
  String title(AppLocalizations t) => t.sync_status_failed_connect(currHeight);
}

class ConnectingSyncStatus extends SyncStatus {
  const ConnectingSyncStatus(int currHeight) : super(currHeight, 0);

  @override
  String title(AppLocalizations t) => t.sync_status_connecting(currHeight);
}

class ConnectedSyncStatus extends SyncStatus {
  const ConnectedSyncStatus(int currHeight) : super(currHeight, 0);

  @override
  String title(AppLocalizations t) => t.sync_status_connected(currHeight);
}
