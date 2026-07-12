/// Shared scheduling logic for precise interval-aligned announcements.
/// Used by both [AlarmService] (UI state) and [BackgroundService] (isolate).
abstract final class AnnouncementScheduler {
  /// Minutes in a day.
  static const int minutesPerDay = 1440;

  /// Calculate the next announcement aligned to interval boundaries.
  /// e.g. 15 min → :00, :15, :30, :45
  static DateTime nextAnnouncementTime(int intervalMinutes, DateTime fromTime) {
    if (intervalMinutes <= 0) {
      return fromTime.add(const Duration(days: 365));
    }

    final minutesSinceMidnight = fromTime.hour * 60 + fromTime.minute;
    final completedIntervals = minutesSinceMidnight ~/ intervalMinutes;
    final nextIntervalMinutes = (completedIntervals + 1) * intervalMinutes;

    if (nextIntervalMinutes >= minutesPerDay) {
      final tomorrow = DateTime(fromTime.year, fromTime.month, fromTime.day + 1);
      final adjustedMinutes = nextIntervalMinutes % minutesPerDay;
      return tomorrow.add(Duration(minutes: adjustedMinutes));
    }

    final nextHour = nextIntervalMinutes ~/ 60;
    final nextMinute = nextIntervalMinutes % 60;
    return DateTime(fromTime.year, fromTime.month, fromTime.day, nextHour, nextMinute);
  }

  /// Whether [now] falls within quiet hours (supports overnight ranges).
  static bool isQuietTime(
    DateTime now,
    int startHour,
    int startMinute,
    int endHour,
    int endMinute,
  ) {
    final nowMinutes = now.hour * 60 + now.minute;
    final startMinutes = startHour * 60 + startMinute;
    final endMinutes = endHour * 60 + endMinute;

    if (startMinutes <= endMinutes) {
      return nowMinutes >= startMinutes && nowMinutes < endMinutes;
    }
    return nowMinutes >= startMinutes || nowMinutes < endMinutes;
  }
}
