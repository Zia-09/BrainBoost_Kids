import 'package:flutter/material.dart';
import '../services/settings_service.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  final SettingsService _settingsService = SettingsService();

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    // SettingsService.darkMode is a synchronous getter populated after init()
    _themeMode = _settingsService.darkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await _settingsService.setDarkMode(_themeMode == ThemeMode.dark);
    notifyListeners();
  }
}
