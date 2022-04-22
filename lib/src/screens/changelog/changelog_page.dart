import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oxen_wallet/l10n.dart';
import 'package:oxen_wallet/src/screens/base_page.dart';
import 'package:yaml/yaml.dart';

class ChangelogPage extends BasePage {
  final String changelogPath = 'assets/changelog.yml';

  @override
  String getTitle(AppLocalizations t) => t.changelog;

  @override
  Widget body(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Container();
        final changelogs = loadYaml(snapshot.data.toString()) as YamlList;

        return ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            final versionTitle = changelogs[index]['version'].toString();
            final versionChanges = changelogs[index]['changes'] as YamlList;
            final versionChangesText = versionChanges
                .map((dynamic element) => '- $element')
                .join('\n');

            return ExpansionTile(
              title: Text(versionTitle),
              children: <Widget>[
                for (var e in versionChanges)
                  ListTile(
                    leading: Icon(Icons.arrow_right),
                    title: new Text(e),
                  )
              ],
            );
          },
          separatorBuilder: (_, __) =>
              Divider(color: Theme.of(context).dividerTheme.color, height: 1.0),
          itemCount: changelogs.length,
        );
      },
      future: rootBundle.loadString(changelogPath),
    );
  }
}
