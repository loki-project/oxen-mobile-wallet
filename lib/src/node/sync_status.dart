import 'package:oxen_wallet/l10n.dart';

abstract class SyncStatus {
  const SyncStatus();

  double progress();

  String title(AppLocalizations t);
}

class SyncingSyncStatus extends SyncStatus {
  SyncingSyncStatus(this.blocksLeft, this.ptc);

  final double ptc;
  final int blocksLeft;

  @override
  double progress() => ptc;

  @override
  String title(AppLocalizations t) => t.blocks_remaining('$blocksLeft');

  @override
  String toString() => '$blocksLeft';
}

class SyncedSyncStatus extends SyncStatus {
  @override
  double progress() => 1.0;

  @override
  String title(AppLocalizations t) => t.sync_status_synchronized;
}

class NotConnectedSyncStatus extends SyncStatus {
  const NotConnectedSyncStatus();

  @override
  double progress() => 0.0;

  @override
  String title(AppLocalizations t) => t.sync_status_not_connected;
}

class StartingSyncStatus extends SyncStatus {
  @override
  double progress() => 0.0;

  @override
  String title(AppLocalizations t) => t.sync_status_starting_sync;
}

class FailedSyncStatus extends SyncStatus {
  @override
  double progress() => 1.0;

  @override
  String title(AppLocalizations t) => t.sync_status_failed_connect;
}

class ConnectingSyncStatus extends SyncStatus {
  @override
  double progress() => 0.0;

  @override
  String title(AppLocalizations t) => t.sync_status_connecting;
}

class ConnectedSyncStatus extends SyncStatus {
  @override
  double progress() => 0.0;

  @override
  String title(AppLocalizations t) => t.sync_status_connected;
}
