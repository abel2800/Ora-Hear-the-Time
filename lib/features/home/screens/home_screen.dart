import 'dart:async';
import 'dart:ui' show FontFeature;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/time_utils.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/alarm_service.dart';
import '../../../services/settings_provider.dart';
import '../../../services/tts_service.dart';
import '../../settings/screens/settings_hub_screen.dart';
import '../widgets/analog_clock.dart';
import '../widgets/home_widgets.dart';

/// Premium home dashboard with greeting, clocks, and status cards.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  DateTime _currentTime = DateTime.now();
  Timer? _timer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _greetingSpoken = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(AppConstants.clockTickInterval, (_) {
      setState(() => _currentTime = DateTime.now());
    });

    _pulseController = AnimationController(
      duration: AppConstants.tapAnimationDuration,
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeSpeakGreeting());
  }

  Future<void> _maybeSpeakGreeting() async {
    if (_greetingSpoken || !mounted) return;
    final settings = context.read<SettingsProvider>();
    if (!settings.greetingOnLaunch) return;

    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    if (prefs.getString('last_greeting_date') == today) return;

    await prefs.setString('last_greeting_date', today);
    _greetingSpoken = true;

    final greeting = greetingForTime(context, _currentTime);
    await context.read<TtsService>().speakGreeting(greeting);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _speakTime({bool includeDate = false}) async {
    final settings = context.read<SettingsProvider>();
    final alarmService = context.read<AlarmService>();
    final tts = context.read<TtsService>();

    if (!settings.touchToSpeakEnabled) return;
    if (settings.blockTouchDuringQuiet && alarmService.isCurrentlyQuiet()) return;

    if (settings.vibrationEnabled) {
      final hasVibrator = await Vibration.hasVibrator() ?? false;
      if (hasVibrator) await Vibration.vibrate(duration: 200);
    }

    final timeText = TimeUtils.formatTimeForSpeech(_currentTime, language: settings.language);
    await tts.speak(timeText);

    if (includeDate || settings.includeDateOnTap) {
      await Future.delayed(const Duration(milliseconds: 800));
      final dateText = TimeUtils.formatDateForSpeech(_currentTime, language: settings.language);
      await tts.speak(dateText);
    }
  }

  void _openSettings() {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const SettingsHubScreen(),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero)
                .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: child,
          ),
        ),
        transitionDuration: AppConstants.pageTransitionDuration,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final alarm = context.watch<AlarmService>();
    final l10n = AppLocalizations.of(context);
    final isDark = settings.darkMode;
    final isQuiet = alarm.isCurrentlyQuiet();
    final screen = MediaQuery.of(context).size;
    final clockSize = (screen.width * 0.78).clamp(220.0, 380.0);

    final gradient = isDark ? AppColors.darkGradient : AppColors.lightGradient;
    final greeting = greetingForTime(context, _currentTime);

    return Scaffold(
      body: Semantics(
        label: '${l10n.tapToHearTime}. ${TimeUtils.formatTimeForSpeech(_currentTime, language: settings.language)}',
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => _pulseController.forward(),
          onTapUp: (_) {
            _pulseController.reverse();
            _speakTime();
          },
          onTapCancel: () => _pulseController.reverse(),
          onLongPress: () => _speakTime(includeDate: true),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradient,
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 400),
                                    child: Text(
                                      greeting,
                                      key: ValueKey(greeting),
                                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    TimeUtils.formatDateDisplay(_currentTime, language: settings.language),
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Semantics(
                              button: true,
                              label: l10n.settings,
                              child: IconButton.filledTonal(
                                onPressed: _openSettings,
                                icon: Icon(PhosphorIconsRegular.gear, size: 24),
                                style: IconButton.styleFrom(
                                  minimumSize: const Size(AppConstants.minTouchTarget, AppConstants.minTouchTarget),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: GlassCard(
                            key: ValueKey(TimeUtils.formatTimeDigital(_currentTime)),
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                            semanticsLabel:
                                'Digital time ${TimeUtils.formatTimeForSpeech(_currentTime, language: settings.language)}',
                            child: Center(
                              child: Text(
                                TimeUtils.formatTimeDigital(_currentTime),
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                      fontWeight: FontWeight.w300,
                                      letterSpacing: 3,
                                      fontFeatures: const [FontFeature.tabularFigures()],
                                      color: isDark ? AppColors.accent : AppColors.primary,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: [
                            if (isQuiet)
                              StatusChip(
                                icon: PhosphorIconsFill.moon,
                                label: l10n.quietMode,
                                color: AppColors.primary,
                              ),
                            if (alarm.intervalMinutes > 0)
                              StatusChip(
                                icon: PhosphorIconsRegular.timer,
                                label: '${l10n.every} ${alarm.intervalMinutes}${l10n.minutes}',
                                color: AppColors.accent,
                              ),
                            StatusChip(
                              icon: alarm.isScheduled ? PhosphorIconsFill.broadcast : PhosphorIconsRegular.broadcast,
                              label: alarm.isScheduled ? l10n.active : l10n.announcementsOff,
                              color: alarm.isScheduled ? AppColors.success : Theme.of(context).colorScheme.outline,
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        Center(
                          child: AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) => Transform.scale(
                              scale: _pulseAnimation.value,
                              child: child,
                            ),
                            child: Semantics(
                              label:
                                  'Analog clock. ${TimeUtils.formatTimeForSpeech(_currentTime, language: settings.language)}',
                              child: AnalogClock(
                                time: _currentTime,
                                size: clockSize,
                                isDarkMode: isDark,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        Row(
                          children: [
                            Expanded(
                              child: DashboardInfoCard(
                                icon: PhosphorIconsRegular.clockCountdown,
                                title: l10n.nextAnnouncement,
                                value: alarm.nextAnnouncementTime != null
                                    ? TimeUtils.formatTimeShort(alarm.nextAnnouncementTime!)
                                    : l10n.notScheduled,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DashboardInfoCard(
                                icon: PhosphorIconsRegular.translate,
                                title: l10n.languageLabel,
                                value: languageDisplayName(settings.language),
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (alarm.lastAnnouncementText != null)
                          DashboardInfoCard(
                            icon: PhosphorIconsRegular.speakerHigh,
                            title: l10n.lastAnnouncement,
                            value: alarm.lastAnnouncementText!,
                          ),
                        const SizedBox(height: 20),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                PhosphorIconsRegular.handTap,
                                size: 20,
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  l10n.tapToHearTime,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
