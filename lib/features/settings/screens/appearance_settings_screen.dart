import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/settings_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/settings_provider.dart';

class AppearanceSettingsScreen extends StatelessWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appearance)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SettingsSwitchTile(
            title: l10n.darkMode,
            subtitle: l10n.usesDarkTheme,
            value: settings.darkMode,
            onChanged: settings.setDarkMode,
          ),
          const SizedBox(height: 12),
          SettingsSwitchTile(
            title: l10n.dynamicColors,
            subtitle: l10n.useDynamicColors,
            value: settings.useDynamicColors,
            onChanged: settings.setUseDynamicColors,
          ),
        ],
      ),
    );
  }
}
