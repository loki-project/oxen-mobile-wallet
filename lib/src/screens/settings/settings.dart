import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oxen_wallet/palette.dart';
import 'package:oxen_wallet/routes.dart';
import 'package:oxen_wallet/src/domain/common/balance_display_mode.dart';
import 'package:oxen_wallet/src/domain/common/fiat_currency.dart';
import 'package:oxen_wallet/src/screens/auth/auth_page.dart';
import 'package:oxen_wallet/src/screens/base_page.dart';
import 'package:oxen_wallet/src/screens/disclaimer/disclaimer_page.dart';
import 'package:oxen_wallet/src/screens/settings/attributes.dart';
import 'package:oxen_wallet/src/screens/settings/items/settings_item.dart';
import 'package:oxen_wallet/l10n.dart';

// Settings widgets
import 'package:oxen_wallet/src/screens/settings/widgets/settings_link_list_row.dart';
import 'package:oxen_wallet/src/screens/settings/widgets/settings_raw_widget_list_row.dart';
import 'package:oxen_wallet/src/screens/settings/widgets/settings_switch_list_row.dart';
import 'package:oxen_wallet/src/screens/settings/widgets/settings_text_list_row.dart';
import 'package:oxen_wallet/src/stores/settings/settings_store.dart';
import 'package:oxen_wallet/src/wallet/crypto_amount_format.dart';
import 'package:oxen_wallet/src/wallet/oxen/transaction/transaction_priority.dart';
import 'package:oxen_wallet/src/widgets/nav/nav_list_arrow.dart';
import 'package:oxen_wallet/src/widgets/nav/nav_list_header.dart';
import 'package:oxen_wallet/src/widgets/present_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends BasePage {
  @override
  String getTitle(AppLocalizations l10n) => l10n.settings_title;

  @override
  Color get backgroundColor => Palette.lightGrey2;

  @override
  Widget body(BuildContext context) {
    return SettingsForm();
  }
}

class SettingsForm extends StatefulWidget {
  @override
  SettingsFormState createState() => SettingsFormState();
}

class SettingsFormState extends State<SettingsForm> {
  final _sessionImage = Image.asset('assets/images/Session.png');
  final _telegramImage = Image.asset('assets/images/Telegram.png');
  final _twitterImage = Image.asset('assets/images/Twitter.png');

  final _emailText = 'team@oxen.io';
  final _sessionText = 'getsession.org';
  final _githubText = 'github.com/oxen-io';
  final _telegramText = 't.me/Oxen_Community';
  final _twitterText = 'twitter.com/Oxen_io';

  final _emailUrl = 'mailto:team@oxen.io';
  final _sessionUrl = 'https://getsession.org';
  final _githubUrl = 'https://github.com/oxen-io';
  final _telegramUrl = 'https://t.me/Oxen_Community';
  final _twitterUrl = 'https://twitter.com/Oxen_io';

  final _items = <SettingsItem>[];

  void _launchUrl(String url) async {
    if (await canLaunch(url)) await launch(url);
  }

  void _setSettingsList() {
    final settingsStore = context.read<SettingsStore>();
    final t = tr(context);
    _items.addAll([
      SettingsItem(
          title: t.settings_nodes, attribute: Attributes.header),
      SettingsItem(
          onTaped: () => Navigator.of(context).pushNamed(Routes.nodeList),
          title: t.settings_current_node,
          widget: Observer(
              builder: (_) => Text(
                    settingsStore.node?.uri ?? '',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: 16.0,
                        color:
                            Theme.of(context).primaryTextTheme.subtitle2?.color),
                  )),
          attribute: Attributes.widget),
      SettingsItem(
          title: t.settings_wallets, attribute: Attributes.header),
      SettingsItem(title: t.settings_show_full, attribute: Attributes.switcher),
      SettingsItem(title: t.settings_show_available, attribute: Attributes.switcher),
      SettingsItem(title: t.settings_show_pending, attribute: Attributes.switcher),
      SettingsItem(title: t.settings_full_incl_pending, attribute: Attributes.switcher),
      SettingsItem(
          onTaped: () => _setBalanceDetail(context),
          title: t.settings_balance_detail,
          widget: Observer(
              builder: (_) => Text(
                settingsStore.balanceDetail.getTitle(t),
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: 16.0,
                    color:
                    Theme.of(context).primaryTextTheme.subtitle2?.color),
              )),
          attribute: Attributes.widget),
      SettingsItem(
          title: t.settings_enable_fiat_currency,
          attribute: Attributes.switcher),
      SettingsItem(
          onTaped: () => _setCurrency(context),
          title: t.settings_currency,
          widget: Observer(
              builder: (_) => Text(
                    settingsStore.fiatCurrency.getTitle(t),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: 16.0,
                        color:
                            Theme.of(context).primaryTextTheme.subtitle2?.color),
                  )),
          attribute: Attributes.widget),
      SettingsItem(
          onTaped: () => _setTransactionPriority(context),
          title: t.settings_fee_priority,
          widget: Observer(
              builder: (_) => Text(
                    settingsStore.transactionPriority.getTitle(t),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: 16.0,
                        color:
                            Theme.of(context).primaryTextTheme.subtitle2?.color),
                  )),
          attribute: Attributes.widget),
      SettingsItem(
          title: t.settings_save_recipient_address,
          attribute: Attributes.switcher),
      SettingsItem(
          title: t.settings_personal, attribute: Attributes.header),
      SettingsItem(
          onTaped: () {
            Navigator.of(context).pushNamed(Routes.auth,
                arguments: (bool isAuthenticatedSuccessfully,
                        AuthPageState auth) =>
                    isAuthenticatedSuccessfully
                        ? Navigator.of(context).popAndPushNamed(Routes.setupPin,
                            arguments:
                                (BuildContext setupPinContext, String _) =>
                                    Navigator.of(context).pop())
                        : null);
          },
          title: t.settings_change_pin,
          attribute: Attributes.arrow),
      SettingsItem(
          onTaped: () => Navigator.pushNamed(context, Routes.changeLanguage),
          title: t.settings_change_language,
          attribute: Attributes.arrow),
      SettingsItem(
          title: t.settings_allow_biometric_authentication,
          attribute: Attributes.switcher),
      SettingsItem(
          title: t.settings_dark_mode, attribute: Attributes.switcher),
      SettingsItem(
          title: t.settings_support, attribute: Attributes.header),
      SettingsItem(
          onTaped: () => _launchUrl(_emailUrl),
          title: 'Email',
          link: _emailText,
          image: null,
          attribute: Attributes.link),
      SettingsItem(
          onTaped: () => _launchUrl(_githubUrl),
          title: 'Github',
          link: _githubText,
          image: null,
          attribute: Attributes.link),
      SettingsItem(
          onTaped: () => _launchUrl(_sessionUrl),
          title: 'Session',
          link: _sessionText,
          image: _sessionImage,
          attribute: Attributes.link),
      SettingsItem(
          onTaped: () => _launchUrl(_telegramUrl),
          title: 'Telegram',
          link: _telegramText,
          image: _telegramImage,
          attribute: Attributes.link),
      SettingsItem(
          onTaped: () => _launchUrl(_twitterUrl),
          title: 'Twitter',
          link: _twitterText,
          image: _twitterImage,
          attribute: Attributes.link),
      SettingsItem(
          onTaped: () {
            Navigator.push(
                context,
                CupertinoPageRoute<void>(
                    builder: (BuildContext context) => DisclaimerPage()));
          },
          title: t.settings_terms_and_conditions,
          attribute: Attributes.arrow),
      SettingsItem(
          onTaped: () => Navigator.pushNamed(context, Routes.faq),
          title: t.faq,
          attribute: Attributes.arrow),
      SettingsItem(
          onTaped: () => Navigator.pushNamed(context, Routes.changelog),
          title: t.changelog,
          attribute: Attributes.arrow)
    ]);
    setState(() {});
  }

  void _afterLayout(dynamic _) => _setSettingsList();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  Widget _getWidget(SettingsItem item) {
    switch (item.attribute) {
      case Attributes.arrow:
        return NavListArrow(
          onTap: item.onTaped,
          text: item.title,
        );
      case Attributes.header:
        return NavListHeader(title: item.title);
      case Attributes.link:
        return SettingsLinktListRow(
          onTaped: item.onTaped,
          title: item.title,
          link: item.link,
          image: item.image,
        );
      case Attributes.switcher:
        return SettingsSwitchListRow(
          title: item.title,
        );
      case Attributes.widget:
        return SettingsTextListRow(
          onTaped: item.onTaped,
          title: item.title,
          widget: item.widget ?? Offstage(),
        );
      case Attributes.rawWidget:
        return SettingRawWidgetListRow(widgetBuilder: item.widgetBuilder);
      default:
        return Offstage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsStore = Provider.of<SettingsStore>(context);

    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _items.length,
            itemBuilder: (context, index) {
              final item = _items[index];
              var _isDrawDivider = true;

              if (item.attribute == Attributes.header || item == _items.last) {
                _isDrawDivider = false;
              } else {
                if (_items[index + 1].attribute == Attributes.header) {
                  _isDrawDivider = false;
                }
              }

              return Column(
                children: <Widget>[
                  _getWidget(item),
                  _isDrawDivider
                      ? Container(
                          color: Theme.of(context)
                              .accentTextTheme
                              .headline5
                              ?.backgroundColor,
                          padding: EdgeInsets.only(
                            left: 20.0,
                            right: 20.0,
                          ),
                          child: Divider(
                            color: Theme.of(context).dividerColor,
                            height: 1.0,
                          ),
                        )
                      : Offstage()
                ],
              );
            }),
        ListTile(
          contentPadding: EdgeInsets.only(left: 20.0),
          title: Text(tr(context).version(settingsStore.currentVersion),
              style: TextStyle(fontSize: 14.0, color: Palette.wildDarkBlue)),
        )
      ],
    ));
  }

  Future<void> _setBalanceDetail(BuildContext context) async {
    final settingsStore = context.read<SettingsStore>();
    final balanceDetail = await presentPicker(context, AmountDetail.all, initial: settingsStore.balanceDetail);

    if (balanceDetail != null) {
      await settingsStore.setBalanceDetail(balanceDetail);
    }
  }

  Future<void> _setCurrency(BuildContext context) async {
    final settingsStore = context.read<SettingsStore>();
    final selectedCurrency = await presentPicker(context, FiatCurrency.all, initial: settingsStore.fiatCurrency);

    if (selectedCurrency != null) {
      await settingsStore.setCurrentFiatCurrency(selectedCurrency);
    }
  }

  Future<void> _setTransactionPriority(BuildContext context) async {
    final settingsStore = context.read<SettingsStore>();
    final selectedPriority =
        await presentPicker(context, OxenTransactionPriority.all, initial: settingsStore.transactionPriority);

    if (selectedPriority != null) {
      await settingsStore.setCurrentTransactionPriority(selectedPriority);
    }
  }
}
