import 'package:flutter/material.dart';

class AppColors {
  // Global
  static const Color backgroundDark = Color(0xFF1E1A3C);
  static const Color backgroundLight = Color(0xFFF7F8FC);
  
  // Surfaces & Cards
  static const Color surfaceDark = Color(0xFF2D2852);
  static const Color surfaceLight = Colors.white;
  
  static const Color cardDark = Color(0xFF37316C);
  static const Color cardLight = Colors.white;

  // Text
  static const Color textPrimaryLight = Color(0xFF2D3142);
  static const Color textPrimaryDark = Colors.white;
  
  static const Color textSecondaryLight = Color(0xFF9098B1);
  static const Color textSecondaryDark = Colors.white70;

  // Accents
  static const Color primary = Color(0xFF4C2A85);
  static const Color secondary = Color(0xFF265089);
  static const Color accent = Color(0xFFAF52DE);

  // Default aliases
  static const Color textPrimary = textPrimaryLight;
  static const Color textSecondary = textSecondaryLight;
  static const Color surface = surfaceLight;

  // Splash
  static const Color splashBgStart = Color(0xFF4C2A85);
  static const Color splashBgEnd = Color(0xFF265089);
  
  // Home Cards
  static const Color cardMath = Color(0xFF4A89F3);
  static const Color cardEnglish = Color(0xFF34C759);
  static const Color cardScience = Color(0xFFAF52DE);
  static const Color cardGeneral = Color(0xFFFF9500);
  static const Color cardColors = Color(0xFFFF4081); // Pink
  static const Color cardBody = Color(0xFFFF5252); // Red
  static const Color cardAnimals = Color(0xFF795548); // Brown
  static const Color cardSpace = Color(0xFF303F9F); // Indigo
  static const Color cardNutrition = Color(0xFF8BC34A); // Light Green
  static const Color cardGeography = Color(0xFF03A9F4); // Light Blue
  static const Color cardDinosaurs = Color(0xFFFF9800); // Orange
  static const Color cardTechnology = Color(0xFF607D8B); // Blue Grey
  
  // Quiz Options
  static const Color optBlue = Color(0xFF3B82F6);
  static const Color optRed = Color(0xFFEF4444);
  static const Color optOrange = Color(0xFFF59E0B);
  static const Color optCyan = Color(0xFF06B6D4);
  
  // States
  static const Color correct = Color(0xFF10B981);
  static const Color wrong = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  // Helper methods
  static bool isDark(BuildContext context) => Theme.of(context).brightness == Brightness.dark;

  static Color getBackground(BuildContext context) => isDark(context) ? backgroundDark : backgroundLight;
  static Color getSurface(BuildContext context) => isDark(context) ? surfaceDark : surfaceLight;
  static Color getCard(BuildContext context) => isDark(context) ? cardDark : cardLight;
  static Color getTextPrimary(BuildContext context) => isDark(context) ? textPrimaryDark : textPrimaryLight;
  static Color getTextSecondary(BuildContext context) => isDark(context) ? textSecondaryDark : textSecondaryLight;

  // Glass effect helper
  static Color glass(BuildContext context, {double opacity = 0.1}) {
    return (isDark(context) ? Colors.white : primary).withValues(alpha: opacity);
  }
}

