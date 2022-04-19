import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oxen_wallet/l10n.dart';
import 'package:oxen_wallet/src/screens/base_page.dart';

class FaqPage extends BasePage {
  @override
  String getTitle(AppLocalizations t) => t.faq;

  @override
  Widget body(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return SizedBox.shrink();
        final faqItems = jsonDecode(snapshot.data.toString()) as List;

        return ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            final itemTitle = faqItems[index]['question'].toString();
            final itemChild = faqItems[index]['answer'].toString() + '\n';

            return ExpansionTile(
              title: Text(itemTitle),
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Text(
                        itemChild,
                      ),
                    ))
                  ],
                )
              ],
            );
          },
          separatorBuilder: (_, __) =>
              Divider(color: Theme.of(context).dividerTheme.color, height: 1.0),
          itemCount: faqItems.length,
        );
      },
      future: rootBundle.loadString(getFaqPath(context)),
    );
  }

  String getFaqPath(BuildContext context) {
    switch (tr(context).localeName) {
      case 'de':
        return 'assets/faq/faq_de.json';
      case 'en':
      default:
        return 'assets/faq/faq_en.json';
    }
  }
}
