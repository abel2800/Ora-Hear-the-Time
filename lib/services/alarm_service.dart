import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/announcement_scheduler.dart';
import '../core/utils/time_utils.dart';
import 'background_service.dart';

class AlarmService extends ChangeNotifier {
  Timer? _uiRefreshTimer;
  Timer? _announcementTimer;
  DateTime? _lastAnnouncementTime;

  int _intervalMinutes = 0;
  bool _quietModeEnabled = false;
  int _quietStartHour = 22;
  int _quietStartMinute = 0;
  int _quietEndHour = 7;
  int _quietEndMinute = 0;
  DateTime? _nextAnnouncementTime;
  String? _lastAnnouncementText;

  Future<void> Function(String timeText)? onSpeak;

  int get intervalMinutes => _intervalMinutes;
  bool get quietModeEnabled => _quietModeEnabled;
  int get quietStartHour => _quietStartHour;
  int get quietStartMinute => _quietStartMinute;
  int get quietEndHour => _quietEndHour;
  int get quietEndMinute => _quietEndMinute;
  bool get isScheduled => _intervalMinutes > 0;
  DateTime? get nextAnnouncementTime => _nextAnnouncementTime;
  String? get lastAnnouncementText => _lastAnnouncementText;

  bool get _usesLocalAnnouncer => kIsWeb;

  Future<void> setInterval(int minutes) async {
    _intervalMinutes = minutes;
    await _saveSettings();

    if (!kIsWeb) {
      await BackgroundService.updateInterval(minutes);
    }

    if (minutes > 0) {
      _nextAnnouncementTime =
          AnnouncementScheduler.nextAnnouncementTime(minutes, DateTime.now());
      await _persistNextAnnouncementTime();
    } else {
      _nextAnnouncementTime = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('next_announcement_time');
    }

    _restartTimers();
    notifyListeners();
  }

  void setQuietModeEnabled(bool enabled) {
    _quietModeEnabled = enabled;
    _saveSettings();
    if (!kIsWeb) _updateQuietHours();
    notifyListeners();
  }

  void setQuietStartTime(int hour, int minute) {
    _quietStartHour = hour;
    _quietStartMinute = minute;
    _saveSettings();
    if (!kIsWeb) _updateQuietHours();
    notifyListeners();
  }

  void setQuietEndTime(int hour, int minute) {
    _quietEndHour = hour;
    _quietEndMinute = minute;
    _saveSettings();
    if (!kIsWeb) _updateQuietHours();
    notifyListeners();
  }

  void _updateQuietHours() {
    BackgroundService.updateQuietHours(
      enabled: _quietModeEnabled,
      startHour: _quietStartHour,
      startMinute: _quietStartMinute,
      endHour: _quietEndHour,
      endMinute: _quietEndMinute,
    );
  }

  bool isCurrentlyQuiet() {
    if (!_quietModeEnabled) return false;
    return TimeUtils.isQuietTime(
      DateTime.now(),
      _quietStartHour,
      _quietStartMinute,
      _quietEndHour,
      _quietEndMinute,
    );
  }

  String get quietStartTimeString =>
      TimeUtils.formatPickerTime(_quietStartHour, _quietStartMinute);

  String get quietEndTimeString =>
      TimeUtils.formatPickerTime(_quietEndHour, _quietEndMinute);

  void _restartTimers() {
    _uiRefreshTimer?.cancel();
    _announcementTimer?.cancel();

    if (_intervalMinutes <= 0) return;

    if (_usesLocalAnnouncer) {
      _startAnnouncementTimer();
    } else {
      _startUiRefreshTimer();
    }
  }

  void _startAnnouncementTimer() {
    _announcementTimer = Timer.periodic(
      AppConstants.announcementPollInterval,
      (_) => _checkAndAnnounce(),
    );
  }

  Future<void> _checkAndAnnounce() async {
    if (_intervalMinutes <= 0 || _nextAnnouncementTime == null) return;

    final now = DateTime.now();
    if (now.isBefore(_nextAnnouncementTime!)) return;

    if (_lastAnnouncementTime != null &&
        now.difference(_lastAnnouncementTime!).inSeconds < 30) {
      return;
    }

    if (_quietModeEnabled && isCurrentlyQuiet()) {
      _nextAnnouncementTime =
          AnnouncementScheduler.nextAnnouncementTime(_intervalMinutes, now);
      await _persistNextAnnouncementTime();
      notifyListeners();
      return;
    }

    _nextAnnouncementTime =
        AnnouncementScheduler.nextAnnouncementTime(_intervalMinutes, now);
    _lastAnnouncementTime = now;

    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();

    final language = prefs.getString('language') ?? 'en-US';
    final repeatCount = prefs.getInt('repeatCount') ?? 2;
    final vibrationEnabled = prefs.getBool('vibrationEnabled') ?? true;
    final timeText = TimeUtils.formatTimeForSpeech(now, language: language);

    await prefs.setString('last_announcement_text', timeText);
    _lastAnnouncementText = timeText;
    await _persistNextAnnouncementTime();
    notifyListeners();

    if (vibrationEnabled && !kIsWeb) {
      final hasVibrator = await Vibration.hasVibrator() ?? false;
      if (hasVibrator) {
        await Vibration.vibrate(duration: AppConstants.vibrationDuration.inMilliseconds);
      }
    }

    for (var i = 0; i < repeatCount; i++) {
      await onSpeak?.call(timeText);
      if (i < repeatCount - 1) {
        await Future.delayed(AppConstants.repeatGap);
      }
    }
  }

  void _startUiRefreshTimer() {
    _uiRefreshTimer = Timer.periodic(
      AppConstants.announcementPollInterval,
      (_) => _refreshFromPrefs(),
    );
  }

  Future<void> _refreshFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();

    final storedNext = prefs.getInt('next_announcement_time');
    final lastSpoken = prefs.getString('last_announcement_text');

    if (storedNext != null) {
      _nextAnnouncementTime = DateTime.fromMillisecondsSinceEpoch(storedNext);
    }
    if (lastSpoken != _lastAnnouncementText) {
      _lastAnnouncementText = lastSpoken;
      notifyListeners();
    } else if (storedNext != null) {
      notifyListeners();
    }
  }

  Future<void> _persistNextAnnouncementTime() async {
    if (_nextAnnouncementTime == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      'next_announcement_time',
      _nextAnnouncementTime!.millisecondsSinceEpoch,
    );
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('intervalMinutes', _intervalMinutes);
    await prefs.setBool('quietModeEnabled', _quietModeEnabled);
    await prefs.setInt('quietStartHour', _quietStartHour);
    await prefs.setInt('quietStartMinute', _quietStartMinute);
    await prefs.setInt('quietEndHour', _quietEndHour);
    await prefs.setInt('quietEndMinute', _quietEndMinute);
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _intervalMinutes = prefs.getInt('intervalMinutes') ?? 0;
    _quietModeEnabled = prefs.getBool('quietModeEnabled') ?? false;
    _quietStartHour = prefs.getInt('quietStartHour') ?? 22;
    _quietStartMinute = prefs.getInt('quietStartMinute') ?? 0;
    _quietEndHour = prefs.getInt('quietEndHour') ?? 7;
    _quietEndMinute = prefs.getInt('quietEndMinute') ?? 0;
    _lastAnnouncementText = prefs.getString('last_announcement_text');

    final storedNextTime = prefs.getInt('next_announcement_time');
    if (_intervalMinutes > 0) {
      if (storedNextTime != null) {
        _nextAnnouncementTime = DateTime.fromMillisecondsSinceEpoch(storedNextTime);
        if (_nextAnnouncementTime!.isBefore(DateTime.now())) {
          _nextAnnouncementTime = AnnouncementScheduler.nextAnnouncementTime(
            _intervalMinutes,
            DateTime.now(),
          );
          await _persistNextAnnouncementTime();
        }
      } else {
        _nextAnnouncementTime = AnnouncementScheduler.nextAnnouncementTime(
          _intervalMinutes,
          DateTime.now(),
        );
        await _persistNextAnnouncementTime();
      }
      _restartTimers();
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _uiRefreshTimer?.cancel();
    _announcementTimer?.cancel();
    super.dispose();
  }
}
