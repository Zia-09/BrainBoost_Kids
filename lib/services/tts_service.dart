import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final FlutterTts _tts = FlutterTts();
  static bool _isEnabled = true;
  static bool _isInitialized = false;

  static Future<void> init() async {
    if (_isInitialized) return;
    try {
      await _tts.setLanguage("en-US");
      await _tts.setSpeechRate(0.45);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.2);
      _isInitialized = true;
    } catch (_) {}
  }

  static Future<void> speakName(String name) async {
    if (!_isEnabled) return;
    try {
      await _tts.stop();
      await _tts.speak("This is a $name!");
    } catch (_) {}
  }

  static Future<void> speakFact(String fact) async {
    if (!_isEnabled) return;
    try {
      await _tts.stop();
      await _tts.speak(fact);
    } catch (_) {}
  }

  static Future<void> speakWin() async {
    if (!_isEnabled) return;
    try {
      await _tts.speak("Amazing job! You matched all of them!");
    } catch (_) {}
  }

  static Future<void> speakWrong() async {
    if (!_isEnabled) return;
    try {
      await _tts.speak("Try again! You can do it!");
    } catch (_) {}
  }

  static Future<void> speakRoundComplete() async {
    if (!_isEnabled) return;
    try {
      await _tts.speak("Great job! Round complete!");
    } catch (_) {}
  }

  static Future<void> speakText(String text, {String language = 'en-US'}) async {
    if (!_isEnabled) return;
    try {
      await _tts.setLanguage(language);
      await _tts.stop();
      await _tts.speak(text);
      // Reset back to default
      await _tts.setLanguage("en-US");
    } catch (_) {}
  }

  static void setEnabled(bool value) => _isEnabled = value;

  static Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }
}
