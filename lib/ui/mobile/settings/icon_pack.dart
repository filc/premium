import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel_button.dart';
import 'package:filcnaplo_mobile_ui/screens/settings/settings_helper.dart';
import 'package:filcnaplo_premium/models/premium_scopes.dart';
import 'package:filcnaplo_premium/providers/premium_provider.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo_mobile_ui/screens/settings/settings_screen.i18n.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:filcnaplo/utils/format.dart';

class PremiumIconPackSelector extends StatelessWidget {
  const PremiumIconPackSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Provider.of<PremiumProvider>(context).hasScope(PremiumScopes.customIcons)) {
      return const SizedBox(); // TODO: premium upsell
    }

    final settings = Provider.of<SettingsProvider>(context);

    return PanelButton(
      onPressed: () {
        SettingsHelper.iconPack(context);
      },
      title: Text("icon_pack".i18n),
      leading: const Icon(FeatherIcons.grid),
      trailing: Text(settings.iconPack.name.capital()),
    );
  }
}
