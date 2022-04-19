// ignore_for_file: camel_case_types

import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:oxen_coin/oxen_coin_structs.dart';
import 'package:oxen_coin/src/structs/status_and_error.dart';

typedef create_wallet = status_and_error Function(
    Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>, Int32);

typedef restore_wallet_from_seed = status_and_error Function(
    Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>, Int32, Int64);

typedef restore_wallet_from_keys = status_and_error Function(
    Pointer<Utf8>,
    Pointer<Utf8>,
    Pointer<Utf8>,
    Pointer<Utf8>,
    Pointer<Utf8>,
    Pointer<Utf8>,
    Int32,
    Int64);

typedef is_wallet_exist = Int8 Function(Pointer<Utf8>);

typedef load_wallet = Void Function(Pointer<Utf8>, Pointer<Utf8>, Int8);

typedef get_filename = Pointer<Utf8> Function();

typedef get_seed = Pointer<Utf8> Function();

typedef get_address = Pointer<Utf8> Function(Int32, Int32);

typedef get_full_balanace = Int64 Function(Int32);

typedef get_unlocked_balanace = Int64 Function(Int32);

typedef get_current_height = Int64 Function();

typedef get_node_height = Int64 Function();

typedef is_refreshing = Int8 Function();

typedef is_connected = Int8 Function();

typedef setup_node = status_and_error Function(
    Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>, Int8, Int8);

typedef start_refresh = Void Function();

typedef connect_to_node = status_and_error Function();

typedef set_refresh_from_block_height = Void Function(Int64);

typedef set_recovering_from_seed = Void Function(Int8);

typedef store_c = Void Function(Pointer<Utf8>);

typedef set_listener = Void Function();

typedef get_syncing_height = Int64 Function();

typedef is_needed_to_refresh = Int8 Function();

typedef is_new_transaction_exist = Int8 Function();

typedef subaddress_size = Int32 Function();

typedef subaddress_refresh = Void Function(Int32);

typedef subaddress_get_all = Pointer<Int64> Function();

typedef subaddress_add_new = Void Function(
    Int32 accountIndex, Pointer<Utf8> label);

typedef subaddress_set_label = Void Function(
    Int32 accountIndex, Int32 addressIndex, Pointer<Utf8> label);

typedef account_size = Int32 Function();

typedef account_refresh = Void Function();

typedef account_get_all = Pointer<Int64> Function();

typedef account_add_new = Void Function(Pointer<Utf8> label);

typedef account_set_label = Void Function(
    Int32 accountIndex, Pointer<Utf8> label);

typedef transactions_refresh = Void Function();

typedef transactions_count = Int64 Function();

typedef transactions_get_all = Pointer<Int64> Function();

typedef transaction_create = status_and_error Function(
    Pointer<Utf8> address,
    Pointer<Utf8> amount,
    Int8 priorityRaw,
    Int32 subaddrAccount,
    Pointer<PendingTransactionRaw> pendingTransaction);

typedef transaction_commit = status_and_error Function(Pointer<PendingTransactionRaw>);

typedef transaction_estimate_fee = Int64 Function(Int32, Int32);

typedef stake_count = Int32 Function();

typedef stake_get_all = Pointer<Int64> Function();

typedef stake_create = status_and_error Function(
    Pointer<Utf8> serviceNodeKey,
    Pointer<Utf8> amount,
    Pointer<PendingTransactionRaw> pendingTransaction);

typedef can_request_unstake = Int8 Function(Pointer<Utf8> serviceNodeKey);

typedef submit_stake_unlock = status_and_error Function(Pointer<Utf8> serviceNodeKey,
    Pointer<PendingTransactionRaw> pendingTransaction);

typedef secret_view_key = Pointer<Utf8> Function();

typedef public_view_key = Pointer<Utf8> Function();

typedef secret_spend_key = Pointer<Utf8> Function();

typedef public_spend_key = Pointer<Utf8> Function();

typedef close_current_wallet = Void Function();

typedef on_startup = Void Function();

typedef rescan_blockchain = Void Function();
