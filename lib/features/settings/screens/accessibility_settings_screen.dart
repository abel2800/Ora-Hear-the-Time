import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/settings_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/settings_provider.dart';

class AccessibilitySettingsScreen extends StatelessWidget {
  const AccessibilitySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.accessibility)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SettingsSwitchTile(
            title: l10n.touchToSpeak,
            subtitle: l10n.tapAnywhereToHear,
            value: settings.touchToSpeakEnabled,
            onChanged: settings.setTouchToSpeakEnabled,
          ),
          const SizedBox(height: 12),
          SettingsSwitchTile(
            title: l10n.vibrationFeedback,
            subtitle: l10n.feelVibration,
            value: settings.vibrationEnabled,
            onChanged: settings.setVibrationEnabled,
          ),
          const SizedBox(height: 12),
          SettingsSwitchTile(
            title: l10n.blockTouchDuringQuiet,
            subtitle: l10n.alsoDisableTapToSpeak,
            value: settings.blockTouchDuringQuiet,
            onChanged: settings.setBlockTouchDuringQuiet,
          ),
          const SizedBox(height: 12),
          SettingsSwitchTile(
            title: l10n.greetingAnnouncements,
            subtitle: l10n.greetingAnnouncementsDesc,
            value: settings.greetingOnLaunch,
            onChanged: settings.setGreetingOnLaunch,
          ),
          const SizedBox(height: 12),
          SettingsSwitchTile(
            title: l10n.dateAnnouncement,
            subtitle: l10n.dateAnnouncementDesc,
            value: settings.includeDateOnTap,
            onChanged: settings.setIncludeDateOnTap,
          ),
          const SizedBox(height: 12),
          SettingsSwitchTile(
            title: l10n.largeText,
            subtitle: l10n.largeText,
            value: settings.largeText,
            onChanged: settings.setLargeText,
          ),
          const SizedBox(height: 12),
          SettingsSwitchTile(
            title: l10n.highContrast,
            subtitle: l10n.highContrast,
            value: settings.highContrast,
            onChanged: settings.setHighContrast,
          ),
        ],
      ),
    );
  }
}
