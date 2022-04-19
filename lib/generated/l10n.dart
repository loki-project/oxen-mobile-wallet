// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `WELCOME\nTO OXEN WALLET`
  String get welcome {
    return Intl.message(
      'WELCOME\nTO OXEN WALLET',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Awesome wallet\nfor Oxen`
  String get first_wallet_text {
    return Intl.message(
      'Awesome wallet\nfor Oxen',
      name: 'first_wallet_text',
      desc: '',
      args: [],
    );
  }

  /// `Please make selection below to\ncreate or recover your wallet.`
  String get please_make_selection {
    return Intl.message(
      'Please make selection below to\ncreate or recover your wallet.',
      name: 'please_make_selection',
      desc: '',
      args: [],
    );
  }

  /// `Create new`
  String get create_new {
    return Intl.message(
      'Create new',
      name: 'create_new',
      desc: '',
      args: [],
    );
  }

  /// `Restore wallet`
  String get restore_wallet {
    return Intl.message(
      'Restore wallet',
      name: 'restore_wallet',
      desc: '',
      args: [],
    );
  }

  /// `Accounts`
  String get accounts {
    return Intl.message(
      'Accounts',
      name: 'accounts',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message(
      'Account',
      name: 'account',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Address Book`
  String get address_book {
    return Intl.message(
      'Address Book',
      name: 'address_book',
      desc: '',
      args: [],
    );
  }

  /// `Contact`
  String get contact {
    return Intl.message(
      'Contact',
      name: 'contact',
      desc: '',
      args: [],
    );
  }

  /// `Please select:`
  String get please_select {
    return Intl.message(
      'Please select:',
      name: 'please_select',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Contact Name`
  String get contact_name {
    return Intl.message(
      'Contact Name',
      name: 'contact_name',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get reset {
    return Intl.message(
      'Reset',
      name: 'reset',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Authenticated`
  String get authenticated {
    return Intl.message(
      'Authenticated',
      name: 'authenticated',
      desc: '',
      args: [],
    );
  }

  /// `Authentication`
  String get authentication {
    return Intl.message(
      'Authentication',
      name: 'authentication',
      desc: '',
      args: [],
    );
  }

  /// `Failed authentication. {state_error}`
  String failed_authentication(Object state_error) {
    return Intl.message(
      'Failed authentication. $state_error',
      name: 'failed_authentication',
      desc: '',
      args: [state_error],
    );
  }

  /// `Menu`
  String get wallet_menu {
    return Intl.message(
      'Menu',
      name: 'wallet_menu',
      desc: '',
      args: [],
    );
  }

  /// `{status} Blocks Remaining`
  String Blocks_remaining(Object status) {
    return Intl.message(
      '$status Blocks Remaining',
      name: 'Blocks_remaining',
      desc: '',
      args: [status],
    );
  }

  /// `Please try to connect to another node`
  String get please_try_to_connect_to_another_node {
    return Intl.message(
      'Please try to connect to another node',
      name: 'please_try_to_connect_to_another_node',
      desc: '',
      args: [],
    );
  }

  /// `OXEN Hidden`
  String get oxen_hidden {
    return Intl.message(
      'OXEN Hidden',
      name: 'oxen_hidden',
      desc: '',
      args: [],
    );
  }

  /// `OXEN Available Balance`
  String get oxen_available_balance {
    return Intl.message(
      'OXEN Available Balance',
      name: 'oxen_available_balance',
      desc: '',
      args: [],
    );
  }

  /// `OXEN Full Balance`
  String get oxen_full_balance {
    return Intl.message(
      'OXEN Full Balance',
      name: 'oxen_full_balance',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Receive`
  String get receive {
    return Intl.message(
      'Receive',
      name: 'receive',
      desc: '',
      args: [],
    );
  }

  /// `Transactions`
  String get transactions {
    return Intl.message(
      'Transactions',
      name: 'transactions',
      desc: '',
      args: [],
    );
  }

  /// `Incoming`
  String get incoming {
    return Intl.message(
      'Incoming',
      name: 'incoming',
      desc: '',
      args: [],
    );
  }

  /// `Outgoing`
  String get outgoing {
    return Intl.message(
      'Outgoing',
      name: 'outgoing',
      desc: '',
      args: [],
    );
  }

  /// `Transactions by date`
  String get transactions_by_date {
    return Intl.message(
      'Transactions by date',
      name: 'transactions_by_date',
      desc: '',
      args: [],
    );
  }

  /// `Filters`
  String get filters {
    return Intl.message(
      'Filters',
      name: 'filters',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `Yesterday`
  String get yesterday {
    return Intl.message(
      'Yesterday',
      name: 'yesterday',
      desc: '',
      args: [],
    );
  }

  /// `Received`
  String get received {
    return Intl.message(
      'Received',
      name: 'received',
      desc: '',
      args: [],
    );
  }

  /// `Sent`
  String get sent {
    return Intl.message(
      'Sent',
      name: 'sent',
      desc: '',
      args: [],
    );
  }

  /// ` (pending)`
  String get pending {
    return Intl.message(
      ' (pending)',
      name: 'pending',
      desc: '',
      args: [],
    );
  }

  /// `Rescan`
  String get rescan {
    return Intl.message(
      'Rescan',
      name: 'rescan',
      desc: '',
      args: [],
    );
  }

  /// `Reconnect`
  String get reconnect {
    return Intl.message(
      'Reconnect',
      name: 'reconnect',
      desc: '',
      args: [],
    );
  }

  /// `Wallets`
  String get wallets {
    return Intl.message(
      'Wallets',
      name: 'wallets',
      desc: '',
      args: [],
    );
  }

  /// `Show seed`
  String get show_seed {
    return Intl.message(
      'Show seed',
      name: 'show_seed',
      desc: '',
      args: [],
    );
  }

  /// `Show keys`
  String get show_keys {
    return Intl.message(
      'Show keys',
      name: 'show_keys',
      desc: '',
      args: [],
    );
  }

  /// `Address book`
  String get address_book_menu {
    return Intl.message(
      'Address book',
      name: 'address_book_menu',
      desc: '',
      args: [],
    );
  }

  /// `Reconnection`
  String get reconnection {
    return Intl.message(
      'Reconnection',
      name: 'reconnection',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to reconnect?`
  String get reconnect_alert_text {
    return Intl.message(
      'Are you sure to reconnect?',
      name: 'reconnect_alert_text',
      desc: '',
      args: [],
    );
  }

  /// `Reload Fiat data`
  String get reload_fiat {
    return Intl.message(
      'Reload Fiat data',
      name: 'reload_fiat',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message(
      'Clear',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Copied to Clipboard`
  String get copied_to_clipboard {
    return Intl.message(
      'Copied to Clipboard',
      name: 'copied_to_clipboard',
      desc: '',
      args: [],
    );
  }

  /// `Fetching`
  String get fetching {
    return Intl.message(
      'Fetching',
      name: 'fetching',
      desc: '',
      args: [],
    );
  }

  /// `ID: `
  String get id {
    return Intl.message(
      'ID: ',
      name: 'id',
      desc: '',
      args: [],
    );
  }

  /// `Amount: `
  String get amount {
    return Intl.message(
      'Amount: ',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// `Status: `
  String get status {
    return Intl.message(
      'Status: ',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Confirm sending`
  String get confirm_sending {
    return Intl.message(
      'Confirm sending',
      name: 'confirm_sending',
      desc: '',
      args: [],
    );
  }

  /// `Commit transaction\nAmount: {amount}\nFee: {fee}`
  String commit_transaction_amount_fee(Object amount, Object fee) {
    return Intl.message(
      'Commit transaction\nAmount: $amount\nFee: $fee',
      name: 'commit_transaction_amount_fee',
      desc: '',
      args: [amount, fee],
    );
  }

  /// `Sending`
  String get sending {
    return Intl.message(
      'Sending',
      name: 'sending',
      desc: '',
      args: [],
    );
  }

  /// `Transaction sent!`
  String get transaction_sent {
    return Intl.message(
      'Transaction sent!',
      name: 'transaction_sent',
      desc: '',
      args: [],
    );
  }

  /// `Send OXEN`
  String get send_oxen {
    return Intl.message(
      'Send OXEN',
      name: 'send_oxen',
      desc: '',
      args: [],
    );
  }

  /// `FAQ`
  String get faq {
    return Intl.message(
      'FAQ',
      name: 'faq',
      desc: '',
      args: [],
    );
  }

  /// `Changelog`
  String get changelog {
    return Intl.message(
      'Changelog',
      name: 'changelog',
      desc: '',
      args: [],
    );
  }

  /// `Enter your PIN`
  String get enter_your_pin {
    return Intl.message(
      'Enter your PIN',
      name: 'enter_your_pin',
      desc: '',
      args: [],
    );
  }

  /// `Loading your wallet`
  String get loading_your_wallet {
    return Intl.message(
      'Loading your wallet',
      name: 'loading_your_wallet',
      desc: '',
      args: [],
    );
  }

  /// `New Wallet`
  String get new_wallet {
    return Intl.message(
      'New Wallet',
      name: 'new_wallet',
      desc: '',
      args: [],
    );
  }

  /// `Wallet name`
  String get wallet_name {
    return Intl.message(
      'Wallet name',
      name: 'wallet_name',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continue_text {
    return Intl.message(
      'Continue',
      name: 'continue_text',
      desc: '',
      args: [],
    );
  }

  /// `New Node`
  String get node_new {
    return Intl.message(
      'New Node',
      name: 'node_new',
      desc: '',
      args: [],
    );
  }

  /// `Node Address`
  String get node_address {
    return Intl.message(
      'Node Address',
      name: 'node_address',
      desc: '',
      args: [],
    );
  }

  /// `Node port`
  String get node_port {
    return Intl.message(
      'Node port',
      name: 'node_port',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Nodes`
  String get nodes {
    return Intl.message(
      'Nodes',
      name: 'nodes',
      desc: '',
      args: [],
    );
  }

  /// `Reset settings`
  String get node_reset_settings_title {
    return Intl.message(
      'Reset settings',
      name: 'node_reset_settings_title',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure that you want to reset settings to default?`
  String get nodes_list_reset_to_default_message {
    return Intl.message(
      'Are you sure that you want to reset settings to default?',
      name: 'nodes_list_reset_to_default_message',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to change current node to {node}?`
  String change_current_node(Object node) {
    return Intl.message(
      'Are you sure to change current node to $node?',
      name: 'change_current_node',
      desc: '',
      args: [node],
    );
  }

  /// `Change`
  String get change {
    return Intl.message(
      'Change',
      name: 'change',
      desc: '',
      args: [],
    );
  }

  /// `Remove node`
  String get remove_node {
    return Intl.message(
      'Remove node',
      name: 'remove_node',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure that you want to remove selected node?`
  String get remove_node_message {
    return Intl.message(
      'Are you sure that you want to remove selected node?',
      name: 'remove_node_message',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get remove {
    return Intl.message(
      'Remove',
      name: 'remove',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Switch to `
  String get use {
    return Intl.message(
      'Switch to ',
      name: 'use',
      desc: '',
      args: [],
    );
  }

  /// `-digit PIN`
  String get digit_pin {
    return Intl.message(
      '-digit PIN',
      name: 'digit_pin',
      desc: '',
      args: [],
    );
  }

  /// `Share address`
  String get share_address {
    return Intl.message(
      'Share address',
      name: 'share_address',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get receive_amount {
    return Intl.message(
      'Amount',
      name: 'receive_amount',
      desc: '',
      args: [],
    );
  }

  /// `Subaddresses`
  String get subaddresses {
    return Intl.message(
      'Subaddresses',
      name: 'subaddresses',
      desc: '',
      args: [],
    );
  }

  /// `Restore Wallet`
  String get restore_restore_wallet {
    return Intl.message(
      'Restore Wallet',
      name: 'restore_restore_wallet',
      desc: '',
      args: [],
    );
  }

  /// `Restore from seed/keys`
  String get restore_title_from_seed_keys {
    return Intl.message(
      'Restore from seed/keys',
      name: 'restore_title_from_seed_keys',
      desc: '',
      args: [],
    );
  }

  /// `Get back your wallet from seed/keys that you've saved to secure place`
  String get restore_description_from_seed_keys {
    return Intl.message(
      'Get back your wallet from seed/keys that you\'ve saved to secure place',
      name: 'restore_description_from_seed_keys',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get restore_next {
    return Intl.message(
      'Next',
      name: 'restore_next',
      desc: '',
      args: [],
    );
  }

  /// `Restore from a back-up file`
  String get restore_title_from_backup {
    return Intl.message(
      'Restore from a back-up file',
      name: 'restore_title_from_backup',
      desc: '',
      args: [],
    );
  }

  /// `You can restore the whole Oxen Wallet app from your back-up file`
  String get restore_description_from_backup {
    return Intl.message(
      'You can restore the whole Oxen Wallet app from your back-up file',
      name: 'restore_description_from_backup',
      desc: '',
      args: [],
    );
  }

  /// `Seed/Keys Restore`
  String get restore_seed_keys_restore {
    return Intl.message(
      'Seed/Keys Restore',
      name: 'restore_seed_keys_restore',
      desc: '',
      args: [],
    );
  }

  /// `Restore from seed`
  String get restore_title_from_seed {
    return Intl.message(
      'Restore from seed',
      name: 'restore_title_from_seed',
      desc: '',
      args: [],
    );
  }

  /// `Restore your wallet from either the 25 word or 13 word combination code`
  String get restore_description_from_seed {
    return Intl.message(
      'Restore your wallet from either the 25 word or 13 word combination code',
      name: 'restore_description_from_seed',
      desc: '',
      args: [],
    );
  }

  /// `Restore from keys`
  String get restore_title_from_keys {
    return Intl.message(
      'Restore from keys',
      name: 'restore_title_from_keys',
      desc: '',
      args: [],
    );
  }

  /// `Restore your wallet from generated keystrokes saved from your private keys`
  String get restore_description_from_keys {
    return Intl.message(
      'Restore your wallet from generated keystrokes saved from your private keys',
      name: 'restore_description_from_keys',
      desc: '',
      args: [],
    );
  }

  /// `Wallet name`
  String get restore_wallet_name {
    return Intl.message(
      'Wallet name',
      name: 'restore_wallet_name',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get restore_address {
    return Intl.message(
      'Address',
      name: 'restore_address',
      desc: '',
      args: [],
    );
  }

  /// `View key (private)`
  String get restore_view_key_private {
    return Intl.message(
      'View key (private)',
      name: 'restore_view_key_private',
      desc: '',
      args: [],
    );
  }

  /// `Spend key (private)`
  String get restore_spend_key_private {
    return Intl.message(
      'Spend key (private)',
      name: 'restore_spend_key_private',
      desc: '',
      args: [],
    );
  }

  /// `Restore`
  String get restore_recover {
    return Intl.message(
      'Restore',
      name: 'restore_recover',
      desc: '',
      args: [],
    );
  }

  /// `Wallet restore description`
  String get restore_wallet_restore_description {
    return Intl.message(
      'Wallet restore description',
      name: 'restore_wallet_restore_description',
      desc: '',
      args: [],
    );
  }

  /// `Seed`
  String get seed_title {
    return Intl.message(
      'Seed',
      name: 'seed_title',
      desc: '',
      args: [],
    );
  }

  /// `Share seed`
  String get seed_share {
    return Intl.message(
      'Share seed',
      name: 'seed_share',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get copy {
    return Intl.message(
      'Copy',
      name: 'copy',
      desc: '',
      args: [],
    );
  }

  /// `Please choose seed language`
  String get seed_language_choose {
    return Intl.message(
      'Please choose seed language',
      name: 'seed_language_choose',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get seed_language_next {
    return Intl.message(
      'Next',
      name: 'seed_language_next',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get seed_language_english {
    return Intl.message(
      'English',
      name: 'seed_language_english',
      desc: '',
      args: [],
    );
  }

  /// `Chinese`
  String get seed_language_chinese {
    return Intl.message(
      'Chinese',
      name: 'seed_language_chinese',
      desc: '',
      args: [],
    );
  }

  /// `Dutch`
  String get seed_language_dutch {
    return Intl.message(
      'Dutch',
      name: 'seed_language_dutch',
      desc: '',
      args: [],
    );
  }

  /// `German`
  String get seed_language_german {
    return Intl.message(
      'German',
      name: 'seed_language_german',
      desc: '',
      args: [],
    );
  }

  /// `Japanese`
  String get seed_language_japanese {
    return Intl.message(
      'Japanese',
      name: 'seed_language_japanese',
      desc: '',
      args: [],
    );
  }

  /// `Portuguese`
  String get seed_language_portuguese {
    return Intl.message(
      'Portuguese',
      name: 'seed_language_portuguese',
      desc: '',
      args: [],
    );
  }

  /// `Russian`
  String get seed_language_russian {
    return Intl.message(
      'Russian',
      name: 'seed_language_russian',
      desc: '',
      args: [],
    );
  }

  /// `Spanish`
  String get seed_language_spanish {
    return Intl.message(
      'Spanish',
      name: 'seed_language_spanish',
      desc: '',
      args: [],
    );
  }

  /// `French`
  String get seed_language_french {
    return Intl.message(
      'French',
      name: 'seed_language_french',
      desc: '',
      args: [],
    );
  }

  /// `Italian`
  String get seed_language_italian {
    return Intl.message(
      'Italian',
      name: 'seed_language_italian',
      desc: '',
      args: [],
    );
  }

  /// `Send Oxen`
  String get send_title {
    return Intl.message(
      'Send Oxen',
      name: 'send_title',
      desc: '',
      args: [],
    );
  }

  /// `Your wallet`
  String get send_your_wallet {
    return Intl.message(
      'Your wallet',
      name: 'send_your_wallet',
      desc: '',
      args: [],
    );
  }

  /// `Oxen address`
  String get send_oxen_address {
    return Intl.message(
      'Oxen address',
      name: 'send_oxen_address',
      desc: '',
      args: [],
    );
  }

  /// `ALL`
  String get all {
    return Intl.message(
      'ALL',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Currency can only contain numbers`
  String get send_error_currency {
    return Intl.message(
      'Currency can only contain numbers',
      name: 'send_error_currency',
      desc: '',
      args: [],
    );
  }

  /// `Estimated fee:`
  String get send_estimated_fee {
    return Intl.message(
      'Estimated fee:',
      name: 'send_estimated_fee',
      desc: '',
      args: [],
    );
  }

  /// `Currently the fee is set at {transactionPriority} priority.\nTransaction priority can be adjusted in the settings`
  String send_priority(Object transactionPriority) {
    return Intl.message(
      'Currently the fee is set at $transactionPriority priority.\nTransaction priority can be adjusted in the settings',
      name: 'send_priority',
      desc: '',
      args: [transactionPriority],
    );
  }

  /// `Creating transaction`
  String get send_creating_transaction {
    return Intl.message(
      'Creating transaction',
      name: 'send_creating_transaction',
      desc: '',
      args: [],
    );
  }

  /// `Stakes`
  String get title_stakes {
    return Intl.message(
      'Stakes',
      name: 'title_stakes',
      desc: '',
      args: [],
    );
  }

  /// `New Stake`
  String get title_new_stake {
    return Intl.message(
      'New Stake',
      name: 'title_new_stake',
      desc: '',
      args: [],
    );
  }

  /// `Your Contributions`
  String get your_contributions {
    return Intl.message(
      'Your Contributions',
      name: 'your_contributions',
      desc: '',
      args: [],
    );
  }

  /// `Start staking`
  String get start_staking {
    return Intl.message(
      'Start staking',
      name: 'start_staking',
      desc: '',
      args: [],
    );
  }

  /// `Stake more`
  String get stake_more {
    return Intl.message(
      'Stake more',
      name: 'stake_more',
      desc: '',
      args: [],
    );
  }

  /// `Nothing staked yet`
  String get nothing_staked {
    return Intl.message(
      'Nothing staked yet',
      name: 'nothing_staked',
      desc: '',
      args: [],
    );
  }

  /// `Service Node Key`
  String get service_node_key {
    return Intl.message(
      'Service Node Key',
      name: 'service_node_key',
      desc: '',
      args: [],
    );
  }

  /// `Stake Oxen`
  String get stake_oxen {
    return Intl.message(
      'Stake Oxen',
      name: 'stake_oxen',
      desc: '',
      args: [],
    );
  }

  /// `Unlock Stake`
  String get title_confirm_unlock_stake {
    return Intl.message(
      'Unlock Stake',
      name: 'title_confirm_unlock_stake',
      desc: '',
      args: [],
    );
  }

  /// `Do you really want to unlock your stake from {serviceNodeKey}?`
  String body_confirm_unlock_stake(Object serviceNodeKey) {
    return Intl.message(
      'Do you really want to unlock your stake from $serviceNodeKey?',
      name: 'body_confirm_unlock_stake',
      desc: '',
      args: [serviceNodeKey],
    );
  }

  /// `Stake unlock requested`
  String get unlock_stake_requested {
    return Intl.message(
      'Stake unlock requested',
      name: 'unlock_stake_requested',
      desc: '',
      args: [],
    );
  }

  /// `Unable to unlock stake`
  String get unable_unlock_stake {
    return Intl.message(
      'Unable to unlock stake',
      name: 'unable_unlock_stake',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings_title {
    return Intl.message(
      'Settings',
      name: 'settings_title',
      desc: '',
      args: [],
    );
  }

  /// `Nodes`
  String get settings_nodes {
    return Intl.message(
      'Nodes',
      name: 'settings_nodes',
      desc: '',
      args: [],
    );
  }

  /// `Current node`
  String get settings_current_node {
    return Intl.message(
      'Current node',
      name: 'settings_current_node',
      desc: '',
      args: [],
    );
  }

  /// `Wallets`
  String get settings_wallets {
    return Intl.message(
      'Wallets',
      name: 'settings_wallets',
      desc: '',
      args: [],
    );
  }

  /// `Display balance as`
  String get settings_display_balance_as {
    return Intl.message(
      'Display balance as',
      name: 'settings_display_balance_as',
      desc: '',
      args: [],
    );
  }

  /// `Decimals`
  String get settings_balance_detail {
    return Intl.message(
      'Decimals',
      name: 'settings_balance_detail',
      desc: '',
      args: [],
    );
  }

  /// `Currency`
  String get settings_currency {
    return Intl.message(
      'Currency',
      name: 'settings_currency',
      desc: '',
      args: [],
    );
  }

  /// `Fee priority`
  String get settings_fee_priority {
    return Intl.message(
      'Fee priority',
      name: 'settings_fee_priority',
      desc: '',
      args: [],
    );
  }

  /// `Save recipient address`
  String get settings_save_recipient_address {
    return Intl.message(
      'Save recipient address',
      name: 'settings_save_recipient_address',
      desc: '',
      args: [],
    );
  }

  /// `Personal`
  String get settings_personal {
    return Intl.message(
      'Personal',
      name: 'settings_personal',
      desc: '',
      args: [],
    );
  }

  /// `Change PIN`
  String get settings_change_pin {
    return Intl.message(
      'Change PIN',
      name: 'settings_change_pin',
      desc: '',
      args: [],
    );
  }

  /// `Change language`
  String get settings_change_language {
    return Intl.message(
      'Change language',
      name: 'settings_change_language',
      desc: '',
      args: [],
    );
  }

  /// `Allow biometric authentication`
  String get settings_allow_biometric_authentication {
    return Intl.message(
      'Allow biometric authentication',
      name: 'settings_allow_biometric_authentication',
      desc: '',
      args: [],
    );
  }

  /// `Dark mode`
  String get settings_dark_mode {
    return Intl.message(
      'Dark mode',
      name: 'settings_dark_mode',
      desc: '',
      args: [],
    );
  }

  /// `Transactions`
  String get settings_transactions {
    return Intl.message(
      'Transactions',
      name: 'settings_transactions',
      desc: '',
      args: [],
    );
  }

  /// `Display on dashboard list`
  String get settings_display_on_dashboard_list {
    return Intl.message(
      'Display on dashboard list',
      name: 'settings_display_on_dashboard_list',
      desc: '',
      args: [],
    );
  }

  /// `ALL`
  String get settings_all {
    return Intl.message(
      'ALL',
      name: 'settings_all',
      desc: '',
      args: [],
    );
  }

  /// `None`
  String get settings_none {
    return Intl.message(
      'None',
      name: 'settings_none',
      desc: '',
      args: [],
    );
  }

  /// `Support`
  String get settings_support {
    return Intl.message(
      'Support',
      name: 'settings_support',
      desc: '',
      args: [],
    );
  }

  /// `Terms and conditions`
  String get settings_terms_and_conditions {
    return Intl.message(
      'Terms and conditions',
      name: 'settings_terms_and_conditions',
      desc: '',
      args: [],
    );
  }

  /// `Enable Fiat Currency conversion`
  String get settings_enable_fiat_currency {
    return Intl.message(
      'Enable Fiat Currency conversion',
      name: 'settings_enable_fiat_currency',
      desc: '',
      args: [],
    );
  }

  /// `PIN is incorrect`
  String get pin_is_incorrect {
    return Intl.message(
      'PIN is incorrect',
      name: 'pin_is_incorrect',
      desc: '',
      args: [],
    );
  }

  /// `9 - Ultra`
  String get amount_detail_ultra {
    return Intl.message(
      '9 - Ultra',
      name: 'amount_detail_ultra',
      desc: '',
      args: [],
    );
  }

  /// `0 - None`
  String get amount_detail_none {
    return Intl.message(
      '0 - None',
      name: 'amount_detail_none',
      desc: '',
      args: [],
    );
  }

  /// `4 - Detailed`
  String get amount_detail_detailed {
    return Intl.message(
      '4 - Detailed',
      name: 'amount_detail_detailed',
      desc: '',
      args: [],
    );
  }

  /// `2 - Normal`
  String get amount_detail_normal {
    return Intl.message(
      '2 - Normal',
      name: 'amount_detail_normal',
      desc: '',
      args: [],
    );
  }

  /// `Setup PIN`
  String get setup_pin {
    return Intl.message(
      'Setup PIN',
      name: 'setup_pin',
      desc: '',
      args: [],
    );
  }

  /// `Enter your pin again`
  String get enter_your_pin_again {
    return Intl.message(
      'Enter your pin again',
      name: 'enter_your_pin_again',
      desc: '',
      args: [],
    );
  }

  /// `Your PIN has been set up successfully!`
  String get setup_successful {
    return Intl.message(
      'Your PIN has been set up successfully!',
      name: 'setup_successful',
      desc: '',
      args: [],
    );
  }

  /// `Wallet keys`
  String get wallet_keys {
    return Intl.message(
      'Wallet keys',
      name: 'wallet_keys',
      desc: '',
      args: [],
    );
  }

  /// `View key (private)`
  String get view_key_private {
    return Intl.message(
      'View key (private)',
      name: 'view_key_private',
      desc: '',
      args: [],
    );
  }

  /// `View key (public)`
  String get view_key_public {
    return Intl.message(
      'View key (public)',
      name: 'view_key_public',
      desc: '',
      args: [],
    );
  }

  /// `Spend key (private)`
  String get spend_key_private {
    return Intl.message(
      'Spend key (private)',
      name: 'spend_key_private',
      desc: '',
      args: [],
    );
  }

  /// `Spend key (public)`
  String get spend_key_public {
    return Intl.message(
      'Spend key (public)',
      name: 'spend_key_public',
      desc: '',
      args: [],
    );
  }

  /// `Copied {key} to Clipboard`
  String copied_key_to_clipboard(Object key) {
    return Intl.message(
      'Copied $key to Clipboard',
      name: 'copied_key_to_clipboard',
      desc: '',
      args: [key],
    );
  }

  /// `New subaddress`
  String get new_subaddress_title {
    return Intl.message(
      'New subaddress',
      name: 'new_subaddress_title',
      desc: '',
      args: [],
    );
  }

  /// `Label name`
  String get new_subaddress_label_name {
    return Intl.message(
      'Label name',
      name: 'new_subaddress_label_name',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get new_subaddress_create {
    return Intl.message(
      'Create',
      name: 'new_subaddress_create',
      desc: '',
      args: [],
    );
  }

  /// `Subaddress list`
  String get subaddress_title {
    return Intl.message(
      'Subaddress list',
      name: 'subaddress_title',
      desc: '',
      args: [],
    );
  }

  /// `Transaction Details`
  String get transaction_details_title {
    return Intl.message(
      'Transaction Details',
      name: 'transaction_details_title',
      desc: '',
      args: [],
    );
  }

  /// `Transaction ID`
  String get transaction_details_transaction_id {
    return Intl.message(
      'Transaction ID',
      name: 'transaction_details_transaction_id',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get transaction_details_date {
    return Intl.message(
      'Date',
      name: 'transaction_details_date',
      desc: '',
      args: [],
    );
  }

  /// `Height`
  String get transaction_details_height {
    return Intl.message(
      'Height',
      name: 'transaction_details_height',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get transaction_details_amount {
    return Intl.message(
      'Amount',
      name: 'transaction_details_amount',
      desc: '',
      args: [],
    );
  }

  /// `{title} copied to Clipboard`
  String transaction_details_copied(Object title) {
    return Intl.message(
      '$title copied to Clipboard',
      name: 'transaction_details_copied',
      desc: '',
      args: [title],
    );
  }

  /// `Recipient address`
  String get transaction_details_recipient_address {
    return Intl.message(
      'Recipient address',
      name: 'transaction_details_recipient_address',
      desc: '',
      args: [],
    );
  }

  /// `Oxen Wallet`
  String get wallet_list_title {
    return Intl.message(
      'Oxen Wallet',
      name: 'wallet_list_title',
      desc: '',
      args: [],
    );
  }

  /// `Create New Wallet`
  String get wallet_list_create_new_wallet {
    return Intl.message(
      'Create New Wallet',
      name: 'wallet_list_create_new_wallet',
      desc: '',
      args: [],
    );
  }

  /// `Restore Wallet`
  String get wallet_list_restore_wallet {
    return Intl.message(
      'Restore Wallet',
      name: 'wallet_list_restore_wallet',
      desc: '',
      args: [],
    );
  }

  /// `Load wallet`
  String get wallet_list_load_wallet {
    return Intl.message(
      'Load wallet',
      name: 'wallet_list_load_wallet',
      desc: '',
      args: [],
    );
  }

  /// `Loading {wallet_name} wallet`
  String wallet_list_loading_wallet(Object wallet_name) {
    return Intl.message(
      'Loading $wallet_name wallet',
      name: 'wallet_list_loading_wallet',
      desc: '',
      args: [wallet_name],
    );
  }

  /// `Failed to load {wallet_name} wallet. {error}`
  String wallet_list_failed_to_load(Object wallet_name, Object error) {
    return Intl.message(
      'Failed to load $wallet_name wallet. $error',
      name: 'wallet_list_failed_to_load',
      desc: '',
      args: [wallet_name, error],
    );
  }

  /// `Removing {wallet_name} wallet`
  String wallet_list_removing_wallet(Object wallet_name) {
    return Intl.message(
      'Removing $wallet_name wallet',
      name: 'wallet_list_removing_wallet',
      desc: '',
      args: [wallet_name],
    );
  }

  /// `Failed to remove {wallet_name} wallet. {error}`
  String wallet_list_failed_to_remove(Object wallet_name, Object error) {
    return Intl.message(
      'Failed to remove $wallet_name wallet. $error',
      name: 'wallet_list_failed_to_remove',
      desc: '',
      args: [wallet_name, error],
    );
  }

  /// `Address`
  String get widgets_address {
    return Intl.message(
      'Address',
      name: 'widgets_address',
      desc: '',
      args: [],
    );
  }

  /// `Restore from blockheight`
  String get widgets_restore_from_blockheight {
    return Intl.message(
      'Restore from blockheight',
      name: 'widgets_restore_from_blockheight',
      desc: '',
      args: [],
    );
  }

  /// `Restore from date`
  String get widgets_restore_from_date {
    return Intl.message(
      'Restore from date',
      name: 'widgets_restore_from_date',
      desc: '',
      args: [],
    );
  }

  /// `or`
  String get widgets_or {
    return Intl.message(
      'or',
      name: 'widgets_or',
      desc: '',
      args: [],
    );
  }

  /// `Seed`
  String get widgets_seed {
    return Intl.message(
      'Seed',
      name: 'widgets_seed',
      desc: '',
      args: [],
    );
  }

  /// `No route defined for {name}`
  String router_no_route(Object name) {
    return Intl.message(
      'No route defined for $name',
      name: 'router_no_route',
      desc: '',
      args: [name],
    );
  }

  /// `Account name can only contain letters, numbers\nand must be between 1 and 15 characters long`
  String get error_text_account_name {
    return Intl.message(
      'Account name can only contain letters, numbers\nand must be between 1 and 15 characters long',
      name: 'error_text_account_name',
      desc: '',
      args: [],
    );
  }

  /// `Contact name can't contain ' , ' " symbols\nand must be between 1 and 32 characters long`
  String get error_text_contact_name {
    return Intl.message(
      'Contact name can\'t contain ` , \' " symbols\nand must be between 1 and 32 characters long',
      name: 'error_text_contact_name',
      desc: '',
      args: [],
    );
  }

  /// `Wallet address must correspond to the type\nof cryptocurrency`
  String get error_text_address {
    return Intl.message(
      'Wallet address must correspond to the type\nof cryptocurrency',
      name: 'error_text_address',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a iPv4 address`
  String get error_text_node_address {
    return Intl.message(
      'Please enter a iPv4 address',
      name: 'error_text_node_address',
      desc: '',
      args: [],
    );
  }

  /// `Node port can only contain numbers between 0 and 65535`
  String get error_text_node_port {
    return Intl.message(
      'Node port can only contain numbers between 0 and 65535',
      name: 'error_text_node_port',
      desc: '',
      args: [],
    );
  }

  /// `Payment ID can only contain from 16 to 64 chars in hex`
  String get error_text_payment_id {
    return Intl.message(
      'Payment ID can only contain from 16 to 64 chars in hex',
      name: 'error_text_payment_id',
      desc: '',
      args: [],
    );
  }

  /// `OXEN value can't exceed available balance.\nThe number of fraction digits must be less or equal to 12`
  String get error_text_oxen {
    return Intl.message(
      'OXEN value can\'t exceed available balance.\nThe number of fraction digits must be less or equal to 12',
      name: 'error_text_oxen',
      desc: '',
      args: [],
    );
  }

  /// `Value of amount can't exceed available balance.\nThe number of fraction digits must be less or equal to 2`
  String get error_text_fiat {
    return Intl.message(
      'Value of amount can\'t exceed available balance.\nThe number of fraction digits must be less or equal to 2',
      name: 'error_text_fiat',
      desc: '',
      args: [],
    );
  }

  /// `Subaddress name can't contain ' , ' " symbols\nand must be between 1 and 20 characters long`
  String get error_text_subaddress_name {
    return Intl.message(
      'Subaddress name can\'t contain ` , \' " symbols\nand must be between 1 and 20 characters long',
      name: 'error_text_subaddress_name',
      desc: '',
      args: [],
    );
  }

  /// `Amount can only contain numbers`
  String get error_text_amount {
    return Intl.message(
      'Amount can only contain numbers',
      name: 'error_text_amount',
      desc: '',
      args: [],
    );
  }

  /// `Wallet name can only contain letters, numbers\nand must be between 1 and 15 characters long`
  String get error_text_wallet_name {
    return Intl.message(
      'Wallet name can only contain letters, numbers\nand must be between 1 and 15 characters long',
      name: 'error_text_wallet_name',
      desc: '',
      args: [],
    );
  }

  /// `Wallet keys can only contain 64 chars in hex`
  String get error_text_keys {
    return Intl.message(
      'Wallet keys can only contain 64 chars in hex',
      name: 'error_text_keys',
      desc: '',
      args: [],
    );
  }

  /// `The number of fraction digits\nmust be less or equal to 12`
  String get error_text_crypto_currency {
    return Intl.message(
      'The number of fraction digits\nmust be less or equal to 12',
      name: 'error_text_crypto_currency',
      desc: '',
      args: [],
    );
  }

  /// `A Service Node key can only contain 64 chars in hex`
  String get error_text_service_node {
    return Intl.message(
      'A Service Node key can only contain 64 chars in hex',
      name: 'error_text_service_node',
      desc: '',
      args: [],
    );
  }

  /// `ban_timeout`
  String get auth_store_ban_timeout {
    return Intl.message(
      'ban_timeout',
      name: 'auth_store_ban_timeout',
      desc: '',
      args: [],
    );
  }

  /// `Banned for `
  String get auth_store_banned_for {
    return Intl.message(
      'Banned for ',
      name: 'auth_store_banned_for',
      desc: '',
      args: [],
    );
  }

  /// ` minutes`
  String get auth_store_banned_minutes {
    return Intl.message(
      ' minutes',
      name: 'auth_store_banned_minutes',
      desc: '',
      args: [],
    );
  }

  /// `Wrong PIN`
  String get auth_store_incorrect_password {
    return Intl.message(
      'Wrong PIN',
      name: 'auth_store_incorrect_password',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect seed length`
  String get wallet_restoration_store_incorrect_seed_length {
    return Intl.message(
      'Incorrect seed length',
      name: 'wallet_restoration_store_incorrect_seed_length',
      desc: '',
      args: [],
    );
  }

  /// `Full Balance`
  String get full_balance {
    return Intl.message(
      'Full Balance',
      name: 'full_balance',
      desc: '',
      args: [],
    );
  }

  /// `Available Balance`
  String get available_balance {
    return Intl.message(
      'Available Balance',
      name: 'available_balance',
      desc: '',
      args: [],
    );
  }

  /// `Hidden Balance`
  String get hidden_balance {
    return Intl.message(
      'Hidden Balance',
      name: 'hidden_balance',
      desc: '',
      args: [],
    );
  }

  /// `SYNCHRONIZING`
  String get sync_status_synchronizing {
    return Intl.message(
      'SYNCHRONIZING',
      name: 'sync_status_synchronizing',
      desc: '',
      args: [],
    );
  }

  /// `SYNCHRONIZED`
  String get sync_status_synchronized {
    return Intl.message(
      'SYNCHRONIZED',
      name: 'sync_status_synchronized',
      desc: '',
      args: [],
    );
  }

  /// `NOT CONNECTED`
  String get sync_status_not_connected {
    return Intl.message(
      'NOT CONNECTED',
      name: 'sync_status_not_connected',
      desc: '',
      args: [],
    );
  }

  /// `STARTING SYNC`
  String get sync_status_starting_sync {
    return Intl.message(
      'STARTING SYNC',
      name: 'sync_status_starting_sync',
      desc: '',
      args: [],
    );
  }

  /// `FAILED CONNECT TO THE NODE`
  String get sync_status_failed_connect {
    return Intl.message(
      'FAILED CONNECT TO THE NODE',
      name: 'sync_status_failed_connect',
      desc: '',
      args: [],
    );
  }

  /// `CONNECTING`
  String get sync_status_connecting {
    return Intl.message(
      'CONNECTING',
      name: 'sync_status_connecting',
      desc: '',
      args: [],
    );
  }

  /// `CONNECTED`
  String get sync_status_connected {
    return Intl.message(
      'CONNECTED',
      name: 'sync_status_connected',
      desc: '',
      args: [],
    );
  }

  /// `Slow`
  String get transaction_priority_slow {
    return Intl.message(
      'Slow',
      name: 'transaction_priority_slow',
      desc: '',
      args: [],
    );
  }

  /// `Blink`
  String get transaction_priority_blink {
    return Intl.message(
      'Blink',
      name: 'transaction_priority_blink',
      desc: '',
      args: [],
    );
  }

  /// `Change language`
  String get change_language {
    return Intl.message(
      'Change language',
      name: 'change_language',
      desc: '',
      args: [],
    );
  }

  /// `Change language to {language}?`
  String change_language_to(Object language) {
    return Intl.message(
      'Change language to $language?',
      name: 'change_language_to',
      desc: '',
      args: [language],
    );
  }

  /// `Paste`
  String get paste {
    return Intl.message(
      'Paste',
      name: 'paste',
      desc: '',
      args: [],
    );
  }

  /// `Please enter or paste your seed here`
  String get restore_from_seed_placeholder {
    return Intl.message(
      'Please enter or paste your seed here',
      name: 'restore_from_seed_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Add new word`
  String get add_new_word {
    return Intl.message(
      'Add new word',
      name: 'add_new_word',
      desc: '',
      args: [],
    );
  }

  /// `The text entered is not valid.`
  String get incorrect_seed {
    return Intl.message(
      'The text entered is not valid.',
      name: 'incorrect_seed',
      desc: '',
      args: [],
    );
  }

  /// `Scan your fingerprint to authenticate`
  String get biometric_auth_reason {
    return Intl.message(
      'Scan your fingerprint to authenticate',
      name: 'biometric_auth_reason',
      desc: '',
      args: [],
    );
  }

  /// `Version {currentVersion}`
  String version(Object currentVersion) {
    return Intl.message(
      'Version $currentVersion',
      name: 'version',
      desc: '',
      args: [currentVersion],
    );
  }

  /// `OXEN Recipient Detected`
  String get openalias_alert_title {
    return Intl.message(
      'OXEN Recipient Detected',
      name: 'openalias_alert_title',
      desc: '',
      args: [],
    );
  }

  /// `You will be sending funds to\n{recipient_name}`
  String openalias_alert_content(Object recipient_name) {
    return Intl.message(
      'You will be sending funds to\n$recipient_name',
      name: 'openalias_alert_content',
      desc: '',
      args: [recipient_name],
    );
  }

  /// `Dangerzone`
  String get dangerzone {
    return Intl.message(
      'Dangerzone',
      name: 'dangerzone',
      desc: '',
      args: [],
    );
  }

  /// `Yes, I'm sure!`
  String get yes_im_sure {
    return Intl.message(
      'Yes, I\'m sure!',
      name: 'yes_im_sure',
      desc: '',
      args: [],
    );
  }

  /// `NEVER give your Oxen wallet {item} to ANYONE!`
  String never_give_your(Object item) {
    return Intl.message(
      'NEVER give your Oxen wallet $item to ANYONE!',
      name: 'never_give_your',
      desc: '',
      args: [item],
    );
  }

  /// `NEVER input your Oxen wallet {item} into any software or website other than the OFFICIAL Oxen wallets downloaded directly from the {app_store}, the Oxen website, or the Oxen GitHub.\nAre you sure you want to access your wallet {item}?`
  String dangerzone_warning(Object item, Object app_store) {
    return Intl.message(
      'NEVER input your Oxen wallet $item into any software or website other than the OFFICIAL Oxen wallets downloaded directly from the $app_store, the Oxen website, or the Oxen GitHub.\nAre you sure you want to access your wallet $item?',
      name: 'dangerzone_warning',
      desc: '',
      args: [item, app_store],
    );
  }

  /// `Are you sure you want to delete this wallet?`
  String get remove_wallet_confirmation {
    return Intl.message(
      'Are you sure you want to delete this wallet?',
      name: 'remove_wallet_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this wallet? If you have not saved your seed phrase then any funds sent to this wallet will be lost forever!`
  String get dangerzone_remove_wallet_warning {
    return Intl.message(
      'If you have not saved your seed phrase then any funds sent to this wallet will be lost forever!',
      name: 'dangerzone_remove_wallet_warning',
      desc: '',
      args: [],
    );
  }

  /// `Keys`
  String get keys_title {
    return Intl.message(
      'Keys',
      name: 'keys_title',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}