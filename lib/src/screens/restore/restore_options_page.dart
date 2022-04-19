import 'package:flutter/material.dart';
import 'package:oxen_wallet/palette.dart';
import 'package:oxen_wallet/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:oxen_wallet/src/screens/restore/widgets/restore_button.dart';
import 'package:oxen_wallet/src/screens/restore/widgets/image_widget.dart';
import 'package:oxen_wallet/src/screens/restore/widgets/base_restore_widget.dart';
import 'package:oxen_wallet/src/screens/base_page.dart';
import 'package:oxen_wallet/l10n.dart';

class RestoreOptionsPage extends BasePage {
  static const _aspectRatioImage = 2.086;

  @override
  String getTitle(AppLocalizations t) => t.restore_restore_wallet;

  @override
  Color get backgroundColor => Palette.creamyGrey;

  final _imageSeedKeys = Image.asset('assets/images/seedKeys.png');
  final _imageRestoreSeed = Image.asset('assets/images/restoreSeed.png');

  @override
  Widget body(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.height > largeHeight;

    final t = tr(context);

    return BaseRestoreWidget(
      firstRestoreButton: RestoreButton(
        onPressed: () =>
          Navigator.pushNamed(
              context, Routes.restoreWalletOptionsFromWelcome),
        imageWidget: ImageWidget(
          image: _imageSeedKeys,
          aspectRatioImage: _aspectRatioImage,
          isLargeScreen: isLargeScreen,
        ),
        titleColor: Palette.lightViolet,
        color: Palette.lightViolet,
        title: t.restore_title_from_seed_keys,
        description: t.restore_description_from_seed_keys,
        textButton: t.restore_next,
      ),
      secondRestoreButton: RestoreButton(
        onPressed: () {},
        imageWidget: ImageWidget(
          image: _imageRestoreSeed,
          aspectRatioImage: _aspectRatioImage,
          isLargeScreen: isLargeScreen,
        ),
        titleColor: OxenPalette.teal,
        color: OxenPalette.teal,
        title: t.restore_title_from_backup,
        description: t.restore_description_from_backup,
        textButton: t.restore_next,
      ),
      isLargeScreen: isLargeScreen,
    );
  }
}
