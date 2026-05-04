import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'settings_service.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();

  factory SoundService() {
    return _instance;
  }

  SoundService._internal() {
    // Initialize players
    _effectPlayer.setReleaseMode(ReleaseMode.stop);
    _correctPlayer.setReleaseMode(ReleaseMode.stop);
    _wrongPlayer.setReleaseMode(ReleaseMode.stop);
    _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    _clickPlayer.setReleaseMode(ReleaseMode.stop);
  }

  final AudioPlayer _effectPlayer = AudioPlayer();
  final AudioPlayer _correctPlayer = AudioPlayer();
  final AudioPlayer _wrongPlayer = AudioPlayer();
  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _clickPlayer = AudioPlayer(); // Separate player for clicks
  final SettingsService _settings = SettingsService();
  bool _isBgmPlaying = false;
  
  bool _soundEnabled = true;
  bool _musicEnabled = true;

  Future<void> init() async {
    _soundEnabled = _settings.soundEnabled;
    _musicEnabled = _settings.musicEnabled;
    
    // Preload sounds for zero-latency playback
    try {
      await _bgmPlayer.setSource(AssetSource('sounds/bgm.wav'));
      await _bgmPlayer.setVolume(_musicEnabled ? 0.5 : 0.0);
      await _correctPlayer.setSource(AssetSource('sounds/correct.mp3'));
      await _wrongPlayer.setSource(AssetSource('sounds/wrong.mp3'));
      await _clickPlayer.setSource(AssetSource('sounds/click.wav'));
    } catch (e) {
      debugPrint('Error preloading sounds: $e');
    }

    if (_musicEnabled) {
      await playBGM();
    }
  }

  Future<void> playBGM() async {
    if (!_musicEnabled) {
      await stopBGM();
      return;
    }
    if (_isBgmPlaying) return;
    try {
      await _bgmPlayer.resume();
      _isBgmPlaying = true;
    } catch (e) {
      // If resume fails, try play
      try {
        await _bgmPlayer.play(AssetSource('sounds/bgm.wav'));
        _isBgmPlaying = true;
      } catch (e2) {
        debugPrint('Error playing BGM: $e2');
      }
    }
  }

  Future<void> stopBGM() async {
    try {
      await _bgmPlayer.pause();
      _isBgmPlaying = false;
    } catch (e) {
      debugPrint('Error stopping BGM: $e');
    }
  }

  void updateSettings({bool? sound, bool? music}) {
    if (sound != null) _soundEnabled = sound;
    if (music != null) {
      _musicEnabled = music;
      if (music) {
        _bgmPlayer.setVolume(0.5);
        playBGM();
      } else {
        _bgmPlayer.setVolume(0.0);
        stopBGM();
      }
    }
  }

  Future<void> playCorrectSound() async {
    if (!_soundEnabled) return;
    await _correctPlayer.stop();
    await _correctPlayer.play(AssetSource('sounds/correct.mp3'), mode: PlayerMode.lowLatency);
  }

  Future<void> playWrongSound() async {
    if (!_soundEnabled) return;
    await _wrongPlayer.stop();
    await _wrongPlayer.play(AssetSource('sounds/wrong.mp3'), mode: PlayerMode.lowLatency);
  }

  Future<void> playClickSound() async {
    if (!_soundEnabled) return;
    await _clickPlayer.stop();
    await _clickPlayer.play(AssetSource('sounds/click.wav'), mode: PlayerMode.lowLatency);
  }

  Future<void> playSound(String path) async {
    if (!_soundEnabled) return;
    try {
      await _effectPlayer.stop();
      final String fullPath = path.startsWith('sounds/') ? path : 'sounds/$path';
      _effectPlayer.play(AssetSource(fullPath), mode: PlayerMode.lowLatency);
    } catch (e) {
      debugPrint('Error playing sound $path: $e');
    }
  }

  Future<void> playSuccess() => playSound('success.wav');
  Future<void> playError() => playSound('error.wav');
}


