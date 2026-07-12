/// Amharic spoken time formatting for TTS announcements.
abstract final class AmharicTime {
  static const _hours = <int, String>{
    1: 'አንድ',
    2: 'ሁለት',
    3: 'ሶስት',
    4: 'አራት',
    5: 'አምስት',
    6: 'ስድስት',
    7: 'ሰባት',
    8: 'ስምንት',
    9: 'ዘጠኝ',
    10: 'አስር',
    11: 'አስራ አንድ',
    12: 'አስራ ሁለት',
  };

  static String formatTime(DateTime time) {
    final hour12 = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final hourWord = _hours[hour12]!;
    final period = _period(time.hour);
    final minutePhrase = _minutePhrase(time.minute);

    if (time.minute == 0) {
      return '$hourWord ሰዓት ቅጽብት $period';
    }
    return '$hourWord ሰዓት $minutePhrase $period';
  }

  static String _period(int hour24) {
    if (hour24 >= 5 && hour24 < 12) return 'ጠዋት';
    if (hour24 >= 12 && hour24 < 17) return 'ቀትር';
    if (hour24 >= 17 && hour24 < 22) return 'ማታ';
    return 'ሌሊት';
  }

  static String _minutePhrase(int minute) {
    if (minute == 0) return 'ቅጽብት';
    if (minute == 15) return 'ሩብ';
    if (minute == 30) return 'ግማሽ';
    if (minute == 45) return 'ሶስት ሩብ';
    return _number(minute);
  }

  static String _number(int value) {
    if (value <= 0 || value > 59) return value.toString();

    const ones = [
      '',
      'አንድ',
      'ሁለት',
      'ሶስት',
      'አራት',
      'አምስት',
      'ስድስት',
      'ሰባት',
      'ስምንት',
      'ዘጠኝ',
    ];

    if (value < 10) return ones[value];
    if (value < 20) {
      if (value == 10) return 'አስር';
      return 'አስራ ${ones[value - 10]}';
    }
    if (value < 40) {
      final tens = value ~/ 10;
      final unit = value % 10;
      final tensWord = tens == 2 ? 'ሀያ' : 'ሰላሳ';
      return unit == 0 ? tensWord : '$tensWord ${ones[unit]}';
    }
    if (value < 50) {
      final unit = value % 10;
      return unit == 0 ? 'አርባ' : 'አርባ ${ones[unit]}';
    }
    final unit = value % 10;
    return unit == 0 ? 'ሀምሳ' : 'ሀምሳ ${ones[unit]}';
  }
}
