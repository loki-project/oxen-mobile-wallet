import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:oxen_wallet/src/node/sync_status.dart';
import 'package:oxen_wallet/src/wallet/wallet.dart';
import 'package:oxen_wallet/src/domain/services/wallet_service.dart';

part 'sync_store.g.dart';

class SyncStore = SyncStoreBase with _$SyncStore;

abstract class SyncStoreBase with Store {
  SyncStoreBase(
      {SyncStatus syncStatus = const NotConnectedSyncStatus(),
      required WalletService walletService})
  : status = syncStatus
  {
    if (walletService.currentWallet != null) {
      _onWalletChanged(walletService.currentWallet!);
    }

    _onWalletChangeSubscription =
        walletService.onWalletChange.listen(_onWalletChanged);
  }

  @observable
  SyncStatus status;

  late StreamSubscription<Wallet> _onWalletChangeSubscription;
  StreamSubscription<SyncStatus>? _onSyncStatusChangeSubscription;

//  @override
//  void dispose() {
//    if (_onSyncStatusChangeSubscription != null) {
//      _onSyncStatusChangeSubscription.cancel();
//    }
//
//    _onWalletChangeSubscription.cancel();
//    super.dispose();
//  }

  void _onWalletChanged(Wallet wallet) {
    if (_onSyncStatusChangeSubscription != null) {
      _onSyncStatusChangeSubscription!.cancel();
    }

    _onSyncStatusChangeSubscription =
        wallet.syncStatus.listen((status) => this.status = status);
  }
}
