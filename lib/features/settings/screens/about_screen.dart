import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../l10n/app_localizations.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.about)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GlassCard(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/app_icon.png',
                    width: 88,
                    height: 88,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  AppConstants.appName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  '${l10n.version} ${AppConstants.appVersion}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurface.withValues(alpha: 0.6),
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.madeWithLove,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _AboutTile(
            icon: PhosphorIconsRegular.heart,
            title: l10n.accessibilityMission,
            onTap: () => _showTextDialog(context, l10n.accessibilityMission, l10n.accessibilityMissionText),
          ),
          _AboutTile(
            icon: PhosphorIconsRegular.sparkle,
            title: l10n.whatsNew,
            onTap: () => _showTextDialog(context, l10n.whatsNew, l10n.whatsNewContent),
          ),
          _AboutTile(
            icon: PhosphorIconsRegular.shield,
            title: l10n.privacyPolicy,
            onTap: () => _showTextDialog(context, l10n.privacyPolicy, l10n.privacyPolicyText),
          ),
          _AboutTile(
            icon: PhosphorIconsRegular.code,
            title: l10n.openSourceLicenses,
            onTap: () => showLicensePage(context: context, applicationName: AppConstants.appName),
          ),
          _AboutTile(
            icon: PhosphorIconsRegular.shareNetwork,
            title: l10n.shareApp,
            onTap: () {
              Clipboard.setData(ClipboardData(text: l10n.shareMessage));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.shareApp)),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showTextDialog(BuildContext context, String title, String body) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(child: Text(body)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
        ],
      ),
    );
  }
}

class _AboutTile extends StatelessWidget {
  const _AboutTile({
    required this.icon,
    required this.title,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        child: ListTile(
          leading: Icon(icon, color: AppColors.accent),
          title: Text(title),
          trailing: onTap != null ? const Icon(PhosphorIconsRegular.caretRight) : null,
          onTap: onTap,
        ),
      ),
    );
  }
}
