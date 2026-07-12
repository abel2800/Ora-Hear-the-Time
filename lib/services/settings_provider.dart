import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/theme/app_theme.dart';

class SettingsProvider extends ChangeNotifier {
  bool _touchToSpeakEnabled = true;
  bool _vibrationEnabled = true;
  bool _blockTouchDuringQuiet = false;
  bool _darkMode = true;
  bool _useDynamicColors = true;
  bool _largeText = false;
  bool _highContrast = false;
  bool _greetingOnLaunch = false;
  bool _includeDateOnTap = false;

  double _volume = 1.0;
  double _rate = 0.5;
  double _pitch = 1.0;
  String _language = 'en-US';
  String? _voiceName;
  String? _voiceLocale;
  int _repeatCount = 2;

  bool get touchToSpeakEnabled => _touchToSpeakEnabled;
  bool get vibrationEnabled => _vibrationEnabled;
  bool get blockTouchDuringQuiet => _blockTouchDuringQuiet;
  bool get darkMode => _darkMode;
  bool get useDynamicColors => _useDynamicColors;
  bool get largeText => _largeText;
  bool get highContrast => _highContrast;
  bool get greetingOnLaunch => _greetingOnLaunch;
  bool get includeDateOnTap => _includeDateOnTap;
  double get volume => _volume;
  double get rate => _rate;
  double get pitch => _pitch;
  String get language => _language;
  String? get voiceName => _voiceName;
  String? get voiceLocale => _voiceLocale;
  int get repeatCount => _repeatCount;

  void setTouchToSpeakEnabled(bool value) {
    _touchToSpeakEnabled = value;
    notifyListeners();
    _saveSettings();
  }

  void setVibrationEnabled(bool value) {
    _vibrationEnabled = value;
    notifyListeners();
    _saveSettings();
  }

  void setBlockTouchDuringQuiet(bool value) {
    _blockTouchDuringQuiet = value;
    notifyListeners();
    _saveSettings();
  }

  void setDarkMode(bool value) {
    _darkMode = value;
    notifyListeners();
    _saveSettings();
  }

  void setUseDynamicColors(bool value) {
    _useDynamicColors = value;
    notifyListeners();
    _saveSettings();
  }

  void setLargeText(bool value) {
    _largeText = value;
    notifyListeners();
    _saveSettings();
  }

  void setHighContrast(bool value) {
    _highContrast = value;
    notifyListeners();
    _saveSettings();
  }

  void setGreetingOnLaunch(bool value) {
    _greetingOnLaunch = value;
    notifyListeners();
    _saveSettings();
  }

  void setIncludeDateOnTap(bool value) {
    _includeDateOnTap = value;
    notifyListeners();
    _saveSettings();
  }

  void setVolume(double value) {
    _volume = value.clamp(0.0, 1.0);
    notifyListeners();
    _saveSettings();
  }

  void setRate(double value) {
    _rate = value.clamp(0.1, 1.0);
    notifyListeners();
    _saveSettings();
  }

  void setPitch(double value) {
    _pitch = value.clamp(0.5, 2.0);
    notifyListeners();
    _saveSettings();
  }

  void setLanguage(String value) {
    _language = value;
    notifyListeners();
    _saveSettings();
  }

  void setVoice({String? name, String? locale}) {
    _voiceName = name;
    _voiceLocale = locale;
    notifyListeners();
    _saveSettings();
  }

  void setRepeatCount(int value) {
    _repeatCount = value.clamp(1, 5);
    notifyListeners();
    _saveSettings();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('touchToSpeakEnabled', _touchToSpeakEnabled);
    await prefs.setBool('vibrationEnabled', _vibrationEnabled);
    await prefs.setBool('blockTouchDuringQuiet', _blockTouchDuringQuiet);
    await prefs.setBool('darkMode', _darkMode);
    await prefs.setBool('useDynamicColors', _useDynamicColors);
    await prefs.setBool('largeText', _largeText);
    await prefs.setBool('highContrast', _highContrast);
    await prefs.setBool('greetingOnLaunch', _greetingOnLaunch);
    await prefs.setBool('includeDateOnTap', _includeDateOnTap);
    await prefs.setDouble('volume', _volume);
    await prefs.setDouble('rate', _rate);
    await prefs.setDouble('pitch', _pitch);
    await prefs.setString('language', _language);
    if (_voiceName != null) {
      await prefs.setString('voiceName', _voiceName!);
    } else {
      await prefs.remove('voiceName');
    }
    if (_voiceLocale != null) {
      await prefs.setString('voiceLocale', _voiceLocale!);
    } else {
      await prefs.remove('voiceLocale');
    }
    await prefs.setInt('repeatCount', _repeatCount);
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _touchToSpeakEnabled = prefs.getBool('touchToSpeakEnabled') ?? true;
    _vibrationEnabled = prefs.getBool('vibrationEnabled') ?? true;
    _blockTouchDuringQuiet = prefs.getBool('blockTouchDuringQuiet') ?? false;
    _darkMode = prefs.getBool('darkMode') ?? true;
    _useDynamicColors = prefs.getBool('useDynamicColors') ?? true;
    _largeText = prefs.getBool('largeText') ?? false;
    _highContrast = prefs.getBool('highContrast') ?? false;
    _greetingOnLaunch = prefs.getBool('greetingOnLaunch') ?? false;
    _includeDateOnTap = prefs.getBool('includeDateOnTap') ?? false;
    _volume = prefs.getDouble('volume') ?? 1.0;
    _rate = prefs.getDouble('rate') ?? 0.5;
    _pitch = prefs.getDouble('pitch') ?? 1.0;
    _language = prefs.getString('language') ?? 'en-US';
    _voiceName = prefs.getString('voiceName');
    _voiceLocale = prefs.getString('voiceLocale');
    _repeatCount = prefs.getInt('repeatCount') ?? 2;
    notifyListeners();
  }

  ThemeData getTheme({ColorScheme? dynamicScheme}) {
    final base = _darkMode
        ? AppTheme.dark(dynamicScheme: dynamicScheme)
        : AppTheme.light(dynamicScheme: dynamicScheme);

    if (!_largeText && !_highContrast) return base;

    var theme = base;
    if (_largeText) {
      theme = theme.copyWith(
        textTheme: theme.textTheme.apply(fontSizeFactor: 1.15),
      );
    }
    if (_highContrast) {
      final scheme = theme.colorScheme.copyWith(
        onSurface: _darkMode ? Colors.white : Colors.black,
        outline: _darkMode ? Colors.white54 : Colors.black54,
      );
      theme = theme.copyWith(colorScheme: scheme);
    }
    return theme;
  }
}
