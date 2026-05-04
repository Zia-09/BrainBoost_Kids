import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends ChangeNotifier {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  static const String _keySound = 'sound_enabled';
  static const String _keyMusic = 'music_enabled';
  static const String _keyTimer = 'timer_duration';
  static const String _keyAgeGroup = 'age_group_index';
  static const String _keyPin = 'parental_pin';
  static const String _keyDarkMode = 'dark_mode';
  static const String _keyUserName = 'user_name';
  static const String _keyAvatarIndex = 'avatar_index';
  static const String _keyProfilePicPath = 'profile_pic_path';

  String _userName = 'Super Kid';
  int _avatarIndex = 0;
  String? _profilePicPath;
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  bool _darkMode = false;

  String get userName => _userName;
  int get avatarIndex => _avatarIndex;
  String? get profilePicPath => _profilePicPath;
  bool get soundEnabled => _soundEnabled;
  bool get musicEnabled => _musicEnabled;
  bool get darkMode => _darkMode;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString(_keyUserName) ?? 'Super Kid';
    _avatarIndex = prefs.getInt(_keyAvatarIndex) ?? 0;
    _profilePicPath = prefs.getString(_keyProfilePicPath);
    _soundEnabled = prefs.getBool(_keySound) ?? true;
    _musicEnabled = prefs.getBool(_keyMusic) ?? true;
    _darkMode = prefs.getBool(_keyDarkMode) ?? false;
    notifyListeners();
  }

  Future<void> setUserName(String value) async {
    final prefs = await SharedPreferences.getInstance();
    _userName = value;
    await prefs.setString(_keyUserName, value);
    notifyListeners();
  }

  Future<void> setAvatarIndex(int value) async {
    final prefs = await SharedPreferences.getInstance();
    _avatarIndex = value;
    await prefs.setInt(_keyAvatarIndex, value);
    notifyListeners();
  }

  Future<void> setProfilePicPath(String? value) async {
    final prefs = await SharedPreferences.getInstance();
    _profilePicPath = value;
    if (value == null) {
      await prefs.remove(_keyProfilePicPath);
    } else {
      await prefs.setString(_keyProfilePicPath, value);
    }
    notifyListeners();
  }

  Future<void> setSoundEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    _soundEnabled = value;
    await prefs.setBool(_keySound, value);
    notifyListeners();
  }

  Future<void> setMusicEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    _musicEnabled = value;
    await prefs.setBool(_keyMusic, value);
    notifyListeners();
  }

  Future<int> getTimerDuration() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyTimer) ?? 10;
  }

  Future<void> setTimerDuration(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyTimer, value);
    notifyListeners();
  }

  Future<int> getAgeGroupIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyAgeGroup) ?? 1; // Default to 7-9
  }

  Future<void> setAgeGroupIndex(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyAgeGroup, value);
    notifyListeners();
  }

  Future<String> getParentalPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPin) ?? '1234';
  }

  Future<void> setParentalPin(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPin, value);
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    _darkMode = value;
    await prefs.setBool(_keyDarkMode, value);
    notifyListeners();
  }
}
