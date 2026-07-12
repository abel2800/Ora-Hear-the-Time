import 'package:intl/intl.dart';
import 'amharic_time.dart';

/// Time formatting and greeting utilities.
abstract final class TimeUtils {
  static String formatTimeForSpeech(DateTime time, {String language = 'en-US'}) {
    if (language == 'am-ET' || language.startsWith('am')) {
      return AmharicTime.formatTime(time);
    }

    try {
      final locale = language.replaceAll('-', '_');
      return DateFormat.jm(locale).format(time);
    } catch (_) {
      return DateFormat.jm('en_US').format(time);
    }
  }

  static String formatDateForSpeech(DateTime time, {String language = 'en-US'}) {
    if (language == 'am-ET' || language.startsWith('am')) {
      try {
        return DateFormat.yMMMMEEEEd('am_ET').format(time);
      } catch (_) {
        return DateFormat.yMMMMEEEEd('en_US').format(time);
      }
    }

    try {
      final locale = language.replaceAll('-', '_');
      return DateFormat.yMMMMEEEEd(locale).format(time);
    } catch (_) {
      return DateFormat.yMMMMEEEEd('en_US').format(time);
    }
  }

  static String formatTimeDigital(DateTime time) {
    var hour = time.hour;
    final minute = time.minute;
    final second = time.second;
    final period = hour >= 12 ? 'PM' : 'AM';

    if (hour == 0) {
      hour = 12;
    } else if (hour > 12) {
      hour -= 12;
    }

    return '$hour:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')} $period';
  }

  static String formatTimeShort(DateTime time) {
    try {
      return DateFormat.jm().format(time);
    } catch (_) {
      return formatTimeDigital(time);
    }
  }

  static String formatDateDisplay(DateTime time, {String language = 'en-US'}) {
    try {
      final locale = language.replaceAll('-', '_');
      return DateFormat.yMMMEd(locale).format(time);
    } catch (_) {
      return DateFormat.yMMMEd('en_US').format(time);
    }
  }

  static bool isQuietTime(
    DateTime now,
    int quietStartHour,
    int quietStartMinute,
    int quietEndHour,
    int quietEndMinute,
  ) {
    final currentMinutes = now.hour * 60 + now.minute;
    final startMinutes = quietStartHour * 60 + quietStartMinute;
    final endMinutes = quietEndHour * 60 + quietEndMinute;

    if (startMinutes > endMinutes) {
      return currentMinutes >= startMinutes || currentMinutes < endMinutes;
    }
    return currentMinutes >= startMinutes && currentMinutes < endMinutes;
  }

  static String formatPickerTime(int hour, int minute) {
    final period = hour >= 12 ? 'PM' : 'AM';
    var displayHour = hour;
    if (displayHour == 0) {
      displayHour = 12;
    } else if (displayHour > 12) {
      displayHour -= 12;
    }
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  static String greetingKey(DateTime time) {
    final hour = time.hour;
    if (hour >= 5 && hour < 12) return 'goodMorning';
    if (hour >= 12 && hour < 17) return 'goodAfternoon';
    if (hour >= 17 && hour < 22) return 'goodEvening';
    return 'goodNight';
  }
}
