import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';
import '../core/utils/time_utils.dart';
import '../core/utils/tts_voice_utils.dart';

/// In-app Text-to-Speech for tap-to-speak and settings preview.
class TtsService extends ChangeNotifier {
  final FlutterTts _flutterTts = FlutterTts();

  double _volume = 1.0;
  double _rate = 0.5;
  double _pitch = 1.0;
  String _language = 'en-US';
  String? _voiceName;
  String? _voiceLocale;
  List<TtsVoiceOption> _voices = [];
  bool _isInitialized = false;
  bool _isSpeaking = false;

  double get volume => _volume;
  double get rate => _rate;
  double get pitch => _pitch;
  String get language => _language;
  String? get voiceName => _voiceName;
  String? get voiceLocale => _voiceLocale;
  List<TtsVoiceOption> get voices => _voices;
  bool get isInitialized => _isInitialized;
  bool get isSpeaking => _isSpeaking;

  TtsService() {
    _initTts();
  }

  List<TtsVoiceOption> voicesForLanguage(String languageCode) {
    return TtsVoiceUtils.filterByLanguage(_voices, languageCode);
  }

  Future<void> _initTts() async {
    try {
      _flutterTts.setStartHandler(() {
        _isSpeaking = true;
        notifyListeners();
      });

      _flutterTts.setCompletionHandler(() {
        _isSpeaking = false;
        notifyListeners();
      });

      _flutterTts.setErrorHandler((msg) {
        _isSpeaking = false;
        debugPrint('TTS Error: $msg');
      });

      await refreshVoices();
      await _applyAllSettings();
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('TTS init error: $e');
    }
  }

  Future<void> refreshVoices() async {
    try {
      for (var attempt = 0; attempt < 3; attempt++) {
        final rawVoices = await _flutterTts.getVoices;
        if (rawVoices is List && rawVoices.isNotEmpty) {
          _voices = rawVoices
              .map(TtsVoiceUtils.parseVoice)
              .whereType<TtsVoiceOption>()
              .toList();
          notifyListeners();
          return;
        }
        await Future.delayed(Duration(milliseconds: 400 * (attempt + 1)));
      }
    } catch (e) {
      debugPrint('TTS getVoices error: $e');
    }
  }

  Future<void> _applyAllSettings() async {
    await _flutterTts.setVolume(_volume);
    await _flutterTts.setSpeechRate(_rate);
    await _flutterTts.setPitch(_pitch);
    await _applyLanguageAndVoice();
  }

  Future<void> _applyLanguageAndVoice() async {
    await _flutterTts.setLanguage(_language);
    if (_voiceName != null && _voiceLocale != null) {
      await _flutterTts.setVoice({
        'name': _voiceName!,
        'locale': _voiceLocale!,
      });
    }
  }

  Future<void> speak(String text) async {
    if (!_isInitialized) await _initTts();

    try {
      await _applyLanguageAndVoice();
      await _flutterTts.speak(text);
    } catch (e) {
      debugPrint('TTS speak error: $e');
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
    _isSpeaking = false;
    notifyListeners();
  }

  Future<void> setVolume(double value) async {
    _volume = value.clamp(0.0, 1.0);
    await _flutterTts.setVolume(_volume);
    notifyListeners();
  }

  Future<void> setRate(double value) async {
    _rate = value.clamp(0.0, 1.0);
    await _flutterTts.setSpeechRate(_rate);
    notifyListeners();
  }

  Future<void> setPitch(double value) async {
    _pitch = value.clamp(0.5, 2.0);
    await _flutterTts.setPitch(_pitch);
    notifyListeners();
  }

  Future<void> setLanguage(String languageCode, {bool autoPickVoice = true}) async {
    _language = languageCode;
    try {
      await _flutterTts.stop();
      await _flutterTts.setLanguage(languageCode);
      if (autoPickVoice) {
        final best = TtsVoiceUtils.bestVoiceForLanguage(_voices, languageCode);
        if (best != null) {
          _voiceName = best.name;
          _voiceLocale = best.locale;
          await _flutterTts.setVoice(best.toVoiceMap());
        }
      }
    } catch (e) {
      debugPrint('TTS setLanguage error: $e');
    }
    notifyListeners();
  }

  Future<void> setVoice({String? name, String? locale}) async {
    _voiceName = name;
    _voiceLocale = locale;
    try {
      if (name != null && locale != null) {
        await _flutterTts.setVoice({'name': name, 'locale': locale});
      }
    } catch (e) {
      debugPrint('TTS setVoice error: $e');
    }
    notifyListeners();
  }

  Future<void> testVoice() async {
    final sampleTime = DateTime(2024, 1, 1, 14, 30);
    await speak(TimeUtils.formatTimeForSpeech(sampleTime, language: _language));
  }

  Future<void> speakGreeting(String greeting) async {
    await speak(greeting);
  }

  void loadSettings({
    required double volume,
    required double rate,
    required double pitch,
    required String language,
    String? voiceName,
    String? voiceLocale,
  }) {
    _volume = volume;
    _rate = rate;
    _pitch = pitch;
    _language = language;
    _voiceName = voiceName;
    _voiceLocale = voiceLocale;
    _applyAllSettings();
    notifyListeners();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }
}
