import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../../../core/widgets/settings_widgets.dart';
import '../../../l10n/app_localizations.dart';
import 'about_screen.dart';
import 'accessibility_settings_screen.dart';
import 'announcements_settings_screen.dart';
import 'appearance_settings_screen.dart';
import 'voice_settings_screen.dart';

/// Settings hub with categorized navigation.
class SettingsHubScreen extends StatelessWidget {
  const SettingsHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsHub),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SettingsCategoryTile(
            icon: PhosphorIconsRegular.microphone,
            title: l10n.voiceSettings,
            subtitle: l10n.categoryVoiceDesc,
            onTap: () => _push(context, const VoiceSettingsScreen()),
          ),
          const SizedBox(height: 12),
          SettingsCategoryTile(
            icon: PhosphorIconsRegular.bell,
            title: l10n.announcements,
            subtitle: l10n.categoryAnnouncementsDesc,
            onTap: () => _push(context, const AnnouncementsSettingsScreen()),
          ),
          const SizedBox(height: 12),
          SettingsCategoryTile(
            icon: PhosphorIconsRegular.wheelchair,
            title: l10n.accessibility,
            subtitle: l10n.categoryAccessibilityDesc,
            onTap: () => _push(context, const AccessibilitySettingsScreen()),
          ),
          const SizedBox(height: 12),
          SettingsCategoryTile(
            icon: PhosphorIconsRegular.palette,
            title: l10n.appearance,
            subtitle: l10n.categoryAppearanceDesc,
            onTap: () => _push(context, const AppearanceSettingsScreen()),
          ),
          const SizedBox(height: 12),
          SettingsCategoryTile(
            icon: PhosphorIconsRegular.info,
            title: l10n.about,
            subtitle: l10n.categoryAboutDesc,
            onTap: () => _push(context, const AboutScreen()),
          ),
        ],
      ),
    );
  }

  void _push(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }
}
