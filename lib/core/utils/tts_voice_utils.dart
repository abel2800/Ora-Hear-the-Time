import '../../l10n/app_localizations.dart';

/// Helpers for matching and labeling TTS voices.
class TtsVoiceOption {
  const TtsVoiceOption({
    required this.name,
    required this.locale,
    this.gender,
  });

  final String name;
  final String locale;
  final String? gender;

  String get toneKey {
    final inferred = gender ?? TtsVoiceUtils.inferToneKey(name);
    return inferred;
  }

  String toneLabel(AppLocalizations l10n) {
    return switch (toneKey) {
      'male' => l10n.voiceToneMale,
      'female' => l10n.voiceToneFemale,
      _ => l10n.voiceToneNeutral,
    };
  }

  String displayLabel(AppLocalizations l10n) => '$name · ${toneLabel(l10n)}';

  Map<String, String> toVoiceMap() => {
        'name': name,
        'locale': locale,
      };
}

abstract final class TtsVoiceUtils {
  static const _maleHints = [
    'male',
    'man',
    'david',
    'james',
    'mark',
    'george',
    'guy',
    'ryan',
    'brian',
    'eric',
    'steffan',
    'christopher',
    'richard',
    'thomas',
    'daniel',
    'liam',
    'aaron',
  ];

  static const _femaleHints = [
    'female',
    'woman',
    'zira',
    'susan',
    'samantha',
    'hazel',
    'karen',
    'victoria',
    'linda',
    'aria',
    'jenny',
    'michelle',
    'heera',
    'sonia',
    'natasha',
    'emma',
    'laura',
    'sara',
    'anna',
    'catherine',
    'helen',
  ];

  static String languagePrefix(String languageCode) {
    return languageCode.split('-').first.toLowerCase();
  }

  static String inferToneKey(String voiceName) {
    final lower = voiceName.toLowerCase();
    for (final hint in _femaleHints) {
      if (lower.contains(hint)) return 'female';
    }
    for (final hint in _maleHints) {
      if (lower.contains(hint)) return 'male';
    }
    return 'neutral';
  }

  static int toneSortOrder(String toneKey) {
    return switch (toneKey) {
      'female' => 0,
      'male' => 1,
      _ => 2,
    };
  }

  static bool voiceMatchesLanguage(String voiceLocale, String languageCode) {
    final voicePrefix = languagePrefix(voiceLocale.replaceAll('_', '-'));
    final langPrefix = languagePrefix(languageCode);
    return voicePrefix == langPrefix;
  }

  static List<TtsVoiceOption> filterByLanguage(
    List<TtsVoiceOption> voices,
    String languageCode,
  ) {
    return voices
        .where((voice) => voiceMatchesLanguage(voice.locale, languageCode))
        .toList()
      ..sort((a, b) {
        final toneCompare =
            toneSortOrder(a.toneKey).compareTo(toneSortOrder(b.toneKey));
        if (toneCompare != 0) return toneCompare;
        return a.name.compareTo(b.name);
      });
  }

  static TtsVoiceOption? bestVoiceForLanguage(
    List<TtsVoiceOption> voices,
    String languageCode, {
    String preferredTone = 'female',
  }) {
    final filtered = filterByLanguage(voices, languageCode);
    if (filtered.isEmpty) return null;

    final exact = filtered.where((voice) {
      final normalizedVoice = voice.locale.replaceAll('_', '-').toLowerCase();
      return normalizedVoice == languageCode.toLowerCase();
    }).toList();

    final pool = exact.isNotEmpty ? exact : filtered;
    final preferred = pool.where((voice) => voice.toneKey == preferredTone).toList();
    if (preferred.isNotEmpty) return preferred.first;

    return pool.first;
  }

  static TtsVoiceOption? parseVoice(dynamic raw) {
    if (raw is! Map) return null;
    final name = raw['name']?.toString();
    final locale = raw['locale']?.toString();
    if (name == null || name.isEmpty || locale == null || locale.isEmpty) {
      return null;
    }
    final gender = raw['gender']?.toString();
    return TtsVoiceOption(name: name, locale: locale, gender: gender);
  }
}
