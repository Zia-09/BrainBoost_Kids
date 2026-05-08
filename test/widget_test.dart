import 'package:flutter_test/flutter_test.dart';
import 'package:brainboost_kids/main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:brainboost_kids/providers/theme_provider.dart';
import 'package:brainboost_kids/services/score_service.dart';
import 'package:brainboost_kids/services/settings_service.dart';
import 'package:brainboost_kids/services/sound_service.dart';
import 'package:brainboost_kids/providers/match_provider.dart';
import 'package:brainboost_kids/providers/word_wizard_provider.dart';

void main() {
  testWidgets('App builds successfully smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    
    final scoreService = ScoreService();
    final settingsService = SettingsService();
    final soundService = SoundService();

    await scoreService.init();
    await settingsService.init();
    await soundService.init();

    await tester.pumpWidget(
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

    await tester.pumpAndSettle();
    
    expect(find.byType(BrainBoostKidsApp), findsOneWidget);
  });
}
