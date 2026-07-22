abstract final class AppConstants {
  static const String appName = 'Ora';
  static const String appVersion = '1.5.2';

  static const Duration clockTickInterval = Duration(seconds: 1);
  static const Duration announcementPollInterval = Duration(seconds: 5);
  static const Duration healthCheckInterval = Duration(minutes: 5);
  static const Duration repeatGap = Duration(milliseconds: 2500);
  static const Duration vibrationDuration = Duration(milliseconds: 200);
  static const Duration tapAnimationDuration = Duration(milliseconds: 200);
  static const Duration pageTransitionDuration = Duration(milliseconds: 350);

  static const double minTouchTarget = 48.0;
  static const double cardRadius = 20.0;
  static const double buttonRadius = 16.0;

  static const int minRepeatCount = 1;
  static const int maxRepeatCount = 5;

  static const List<int> announcementIntervals = [0, 15, 30, 60];

  static const List<Map<String, String>> supportedLanguages = [
    {'code': 'en-US', 'name': 'English (US)', 'flag': '🇺🇸'},
    {'code': 'es-ES', 'name': 'Español', 'flag': '🇪🇸'},
    {'code': 'fr-FR', 'name': 'Français', 'flag': '🇫🇷'},
    {'code': 'de-DE', 'name': 'Deutsch', 'flag': '🇩🇪'},
    {'code': 'it-IT', 'name': 'Italiano', 'flag': '🇮🇹'},
    {'code': 'pt-BR', 'name': 'Português', 'flag': '🇧🇷'},
    {'code': 'zh-CN', 'name': '中文', 'flag': '🇨🇳'},
    {'code': 'ja-JP', 'name': '日本語', 'flag': '🇯🇵'},
    {'code': 'ko-KR', 'name': '한국어', 'flag': '🇰🇷'},
    {'code': 'hi-IN', 'name': 'हिन्दी', 'flag': '🇮🇳'},
    {'code': 'am-ET', 'name': 'አማርኛ', 'flag': '🇪🇹'},
    {'code': 'ar-SA', 'name': 'العربية', 'flag': '🇸🇦'},
  ];
}
