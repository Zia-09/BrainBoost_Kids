import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_router.dart';
import 'providers/theme_provider.dart';
import 'services/score_service.dart';
import 'services/settings_service.dart';
import 'services/sound_service.dart';
import 'providers/match_provider.dart';
import 'providers/word_wizard_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  final scoreService = ScoreService();
  final settingsService = SettingsService();
  final soundService = SoundService();

  await scoreService.init();
  await settingsService.init();
  await soundService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider.value(value: scoreService),
        ChangeNotifierProvider.value(value: settingsService),
        ChangeNotifierProvider(create: (_) => MatchProvider()),
        ChangeNotifierProvider(create: (_) => WordWizardProvider()),
      ],
      child: const BrainBoostKidsApp(),
    ),
  );
}

class BrainBoostKidsApp extends StatelessWidget {
  const BrainBoostKidsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final lightTheme = ThemeData(
      fontFamily: GoogleFonts.nunito().fontFamily,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.splashBgStart,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      useMaterial3: true,
      textTheme: GoogleFonts.nunitoTextTheme(ThemeData.light().textTheme),
    );

    final darkTheme = ThemeData(
      fontFamily: GoogleFonts.nunito().fontFamily,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.splashBgStart,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      useMaterial3: true,
      textTheme: GoogleFonts.nunitoTextTheme(ThemeData.dark().textTheme)
          .copyWith(
            bodyLarge: const TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
          ),
    );

    return MaterialApp.router(
      title: 'BrainBoost Kids',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      routerConfig: AppRouter.router,
    );
  }
}
