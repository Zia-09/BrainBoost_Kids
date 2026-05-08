import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class SpeechService extends ChangeNotifier {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _lastWords = '';
  String _currentLocaleId = 'en_US';

  bool get isListening => _isListening;
  String get lastWords => _lastWords;

  Future<bool> initSpeech() async {
    bool hasPermission = await _checkPermission();
    if (!hasPermission) return false;

    bool available = await _speech.initialize(
      onStatus: (val) {
        if (val == 'done' || val == 'notListening') {
          _isListening = false;
          notifyListeners();
        }
      },
      onError: (val) {
        debugPrint('Speech recognition error: ${val.errorMsg}');
        _isListening = false;
        notifyListeners();
      },
    );

    if (available) {
      var locales = await _speech.locales();
      var englishLocale = locales.firstWhere(
        (locale) => locale.localeId.startsWith('en_'),
        orElse: () => stt.LocaleName('en_US', 'English (US)'),
      );
      _currentLocaleId = englishLocale.localeId;
    }

    return available;
  }

  Future<bool> _checkPermission() async {
    var status = await Permission.microphone.status;
    if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
      status = await Permission.microphone.request();
    }
    return status.isGranted;
  }

  void startListening(Function(String) onResult) async {
    if (!_speech.isAvailable) {
      bool initialized = await initSpeech();
      if (!initialized) return;
    }

    _lastWords = '';
    _isListening = true;
    notifyListeners();

    await _speech.listen(
      onResult: (result) {
        _lastWords = result.recognizedWords;
        onResult(_lastWords);
        notifyListeners();
      },
      localeId: _currentLocaleId,
      listenFor: const Duration(seconds: 10),
      pauseFor: const Duration(seconds: 3),
      listenOptions: stt.SpeechListenOptions(
        cancelOnError: true,
        listenMode: stt.ListenMode.dictation,
      ),
    );
  }

  void stopListening() async {
    await _speech.stop();
    _isListening = false;
    notifyListeners();
  }
}
