import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/tts_voice_utils.dart';
import '../../../core/widgets/settings_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/background_service.dart';
import '../../../services/settings_provider.dart';
import '../../../services/tts_service.dart';

class VoiceSettingsScreen extends StatelessWidget {
  const VoiceSettingsScreen({super.key});

  static void _syncVoiceToBackground(SettingsProvider settings) {
    BackgroundService.updateVoiceSettings(
      language: settings.language,
      volume: settings.volume,
      rate: settings.rate,
      pitch: settings.pitch,
      voiceName: settings.voiceName,
      voiceLocale: settings.voiceLocale,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = context.watch<SettingsProvider>();
    final tts = context.read<TtsService>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.voiceSettings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PremiumSliderCard(
            title: l10n.voiceVolume,
            value: settings.volume,
            valueLabel: '${(settings.volume * 100).round()}%',
            onChanged: (v) {
              settings.setVolume(v);
              tts.setVolume(v);
              _syncVoiceToBackground(settings);
            },
          ),
          const SizedBox(height: 12),
          PremiumSliderCard(
            title: l10n.voiceSpeed,
            value: settings.rate,
            min: 0.1,
            valueLabel: _speedLabel(settings.rate, l10n),
            onChanged: (v) {
              settings.setRate(v);
              tts.setRate(v);
              _syncVoiceToBackground(settings);
            },
          ),
          const SizedBox(height: 12),
          PremiumSliderCard(
            title: l10n.voicePitch,
            value: (settings.pitch - 0.5) / 1.5,
            min: 0,
            max: 1,
            valueLabel: settings.pitch.toStringAsFixed(1),
            onChanged: (v) {
              final pitch = 0.5 + v * 1.5;
              settings.setPitch(pitch);
              tts.setPitch(pitch);
              _syncVoiceToBackground(settings);
            },
          ),
          const SizedBox(height: 12),
          const _LanguageAndVoiceCard(),
          const SizedBox(height: 12),
          Semantics(
            button: true,
            label: l10n.testVoice,
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => tts.testVoice(),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(PhosphorIconsFill.play, color: Theme.of(context).colorScheme.secondary),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.testVoice, style: const TextStyle(fontWeight: FontWeight.w600)),
                            Text(l10n.tapToHearSample, style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                      Icon(PhosphorIconsRegular.caretRight),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _speedLabel(double rate, AppLocalizations l10n) {
    if (rate < 0.4) return l10n.slow;
    if (rate > 0.6) return l10n.fast;
    return l10n.normal;
  }
}

class _LanguageAndVoiceCard extends StatefulWidget {
  const _LanguageAndVoiceCard();

  @override
  State<_LanguageAndVoiceCard> createState() => _LanguageAndVoiceCardState();
}

class _LanguageAndVoiceCardState extends State<_LanguageAndVoiceCard> {
  bool _loadingVoices = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadVoices());
  }

  Future<void> _loadVoices() async {
    final tts = context.read<TtsService>();
    await tts.refreshVoices();
    if (mounted) setState(() => _loadingVoices = false);
  }

  Future<void> _onLanguageChanged(String value) async {
    final settings = context.read<SettingsProvider>();
    final tts = context.read<TtsService>();

    settings.setLanguage(value);
    await tts.setLanguage(value);
    final best = TtsVoiceUtils.bestVoiceForLanguage(tts.voices, value);
    if (best != null) {
      settings.setVoice(name: best.name, locale: best.locale);
      await tts.setVoice(name: best.name, locale: best.locale);
    } else {
      settings.setVoice(name: null, locale: null);
      await tts.setVoice(name: null, locale: null);
    }
    VoiceSettingsScreen._syncVoiceToBackground(settings);
    if (mounted) setState(() {});
  }

  Future<void> _onVoiceChanged(TtsVoiceOption? voice) async {
    final settings = context.read<SettingsProvider>();
    final tts = context.read<TtsService>();

    if (voice == null) {
      settings.setVoice(name: null, locale: null);
      await tts.setVoice(name: null, locale: null);
    } else {
      settings.setVoice(name: voice.name, locale: voice.locale);
      await tts.setVoice(name: voice.name, locale: voice.locale);
    }
    VoiceSettingsScreen._syncVoiceToBackground(settings);
  }

  IconData _toneIcon(String toneKey) {
    return switch (toneKey) {
      'male' => PhosphorIconsRegular.user,
      'female' => PhosphorIconsRegular.userCircle,
      _ => PhosphorIconsRegular.speakerHigh,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = context.watch<SettingsProvider>();
    final tts = context.watch<TtsService>();
    final languageVoices = tts.voicesForLanguage(settings.language);
    final selectedVoiceKey = settings.voiceName != null && settings.voiceLocale != null
        ? '${settings.voiceName}|${settings.voiceLocale}'
        : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.voiceLanguage, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            DropdownMenu<String>(
              width: double.infinity,
              initialSelection: settings.language,
              onSelected: (value) {
                if (value != null) _onLanguageChanged(value);
              },
              dropdownMenuEntries: AppConstants.supportedLanguages
                  .map((lang) => DropdownMenuEntry(
                        value: lang['code']!,
                        label: '${lang['flag']} ${lang['name']}',
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            Text(l10n.voiceChoice, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(
              l10n.voiceToneLabel,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
            ),
            const SizedBox(height: 12),
            if (_loadingVoices)
              const LinearProgressIndicator()
            else if (languageVoices.isEmpty)
              Text(l10n.noVoicesAvailable, style: Theme.of(context).textTheme.bodySmall)
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 320),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: languageVoices.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final voice = languageVoices[index];
                    final voiceKey = '${voice.name}|${voice.locale}';
                    final selected = selectedVoiceKey == voiceKey;

                    return Semantics(
                      selected: selected,
                      button: true,
                      label: voice.displayLabel(l10n),
                      child: Card(
                        color: selected
                            ? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.12)
                            : null,
                        child: ListTile(
                          leading: Icon(
                            selected
                                ? PhosphorIconsFill.checkCircle
                                : _toneIcon(voice.toneKey),
                            color: selected ? Theme.of(context).colorScheme.secondary : null,
                          ),
                          title: Text(
                            voice.name,
                            style: TextStyle(fontWeight: selected ? FontWeight.w700 : FontWeight.w500),
                          ),
                          subtitle: Text(voice.toneLabel(l10n)),
                          onTap: () async {
                            await _onVoiceChanged(voice);
                            if (mounted) setState(() {});
                            await context.read<TtsService>().testVoice();
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
