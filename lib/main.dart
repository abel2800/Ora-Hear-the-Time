import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'services/alarm_service.dart';
import 'services/background_service.dart';
import 'services/settings_provider.dart';
import 'services/tts_service.dart';
import 'core/utils/tts_voice_utils.dart';
import 'features/home/screens/home_screen.dart';
import 'features/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await BackgroundService.initialize();
  }
  runApp(const OraApp());
}

class OraApp extends StatelessWidget {
  const OraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TtsService()),
        ChangeNotifierProvider(create: (_) => AlarmService()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const _OraRoot(),
    );
  }
}

class _OraRoot extends StatefulWidget {
  const _OraRoot();

  @override
  State<_OraRoot> createState() => _OraRootState();
}

class _OraRootState extends State<_OraRoot> with WidgetsBindingObserver {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeApp();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !kIsWeb) {
      BackgroundService.ensureServiceRunning();
    }
  }

  Future<void> _initializeApp() async {
    final settings = context.read<SettingsProvider>();
    final tts = context.read<TtsService>();

    await settings.loadSettings();
    final alarmService = context.read<AlarmService>();
    await alarmService.loadSettings();
    alarmService.onSpeak = tts.speak;

    await tts.refreshVoices();
    tts.loadSettings(
      volume: settings.volume,
      rate: settings.rate,
      pitch: settings.pitch,
      language: settings.language,
      voiceName: settings.voiceName,
      voiceLocale: settings.voiceLocale,
    );
    if (settings.voiceName == null || settings.voiceLocale == null) {
      final best = TtsVoiceUtils.bestVoiceForLanguage(tts.voices, settings.language);
      if (best != null) {
        settings.setVoice(name: best.name, locale: best.locale);
        await tts.setVoice(name: best.name, locale: best.locale);
      }
    }

    if (!kIsWeb) {
      await BackgroundService.startService();
      await BackgroundService.ensureServiceRunning();
    }

    if (mounted) setState(() => _isInitialized = true);
    WidgetsBinding.instance.addPostFrameCallback((_) => _requestPermissions());
  }

  Future<void> _requestPermissions() async {
    if (!mounted) return;
    if (!kIsWeb) {
      await BackgroundService.requestNotificationPermission();
      if (mounted) await BackgroundService.requestBatteryOptimization(context);
    }
  }

  Locale _localeFromLanguage(String language) {
    switch (language) {
      case 'am-ET':
        return const Locale('am');
      case 'es-ES':
        return const Locale('es', 'ES');
      case 'fr-FR':
        return const Locale('fr', 'FR');
      case 'de-DE':
        return const Locale('de', 'DE');
      case 'ar-SA':
        return const Locale('ar', 'SA');
      case 'zh-CN':
        return const Locale('zh', 'CN');
      case 'hi-IN':
        return const Locale('hi', 'IN');
      case 'ja-JP':
        return const Locale('ja', 'JP');
      case 'ko-KR':
        return const Locale('ko', 'KR');
      case 'pt-BR':
        return const Locale('pt', 'BR');
      case 'it-IT':
        return const Locale('it', 'IT');
      case 'en-GB':
      case 'en-US':
      default:
        return const Locale('en', 'US');
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        final dynamicScheme = settings.useDynamicColors
            ? (settings.darkMode ? darkDynamic : lightDynamic)
            : null;
        final theme = settings.getTheme(dynamicScheme: dynamicScheme);
        final darkTheme = settings.getTheme(dynamicScheme: darkDynamic);

        final app = MaterialApp(
          title: 'Ora',
          debugShowCheckedModeBanner: false,
          theme: theme,
          darkTheme: darkTheme,
          themeMode: settings.darkMode ? ThemeMode.dark : ThemeMode.light,
          locale: _isInitialized ? _localeFromLanguage(settings.language) : null,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: _isInitialized ? const HomeScreen() : const SplashScreen(),
        );

        return app;
      },
    );
  }
}
