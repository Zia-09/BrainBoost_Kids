import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/topic_screen.dart';
import 'screens/difficulty_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/result_screen.dart';
import 'screens/topic_completed_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/store_screen.dart';
import 'screens/match_home_screen.dart';
import 'screens/match_game_screen.dart';
import 'screens/match_result_screen.dart';
import 'screens/word_wizard_home_screen.dart';
import 'screens/word_wizard_game_screen.dart';
import 'screens/word_wizard_result_screen.dart';
import 'screens/learn_everything/learn_home_screen.dart';
import 'screens/learn_everything/learn_game_screen.dart';
import 'models/learn_item.dart';
import 'screens/learn_speak/learn_speak_home_screen.dart';
import 'screens/learn_speak/learn_speak_game_screen.dart';
import 'models/learn_speak_item.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/topics/:subject',
        builder: (context, state) {
          final subject = state.pathParameters['subject']!;
          final isChallengeMode = state.uri.queryParameters['challenge'] == 'true';
          return TopicScreen(
            subject: subject,
            isChallengeMode: isChallengeMode,
          );
        },
      ),
      GoRoute(
        path: '/difficulty',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return DifficultyScreen(
            subject: extra['subject'],
            topic: extra['topic'],
            isChallengeMode: extra['isChallengeMode'] ?? false,
          );
        },
      ),
      GoRoute(
        path: '/quiz',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return QuizScreen(
            subject: extra['subject'],
            topic: extra['topic'],
            topicColor: extra['topicColor'] ?? Colors.blue,
            difficulty: extra['difficulty'],
            isChallengeMode: extra['isChallengeMode'] ?? false,
          );
        },
      ),
      GoRoute(
        path: '/result',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return ResultScreen(
            subject: extra['subject'],
            topic: extra['topic'],
            difficulty: extra['difficulty'],
            topicColor: extra['topicColor'],
            isChallengeMode: extra['isChallengeMode'] ?? false,
            result: extra['result'],
          );
        },
      ),
      GoRoute(
        path: '/topic-completed',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return TopicCompletedScreen(
            subject: extra['subject'],
            topic: extra['topic'],
            unlockedDifficulty: extra['unlockedDifficulty'] ?? 'Medium',
          );
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/leaderboard',
        builder: (context, state) => const LeaderboardScreen(),
      ),
      GoRoute(
        path: '/store',
        builder: (context, state) => const StoreScreen(),
      ),
      GoRoute(
        path: '/match',
        builder: (context, state) => const MatchHomeScreen(),
      ),
      GoRoute(
        path: '/match/game',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final category = extra?['category'] as String? ?? 'Animals';
          return MatchGameScreen(category: category);
        },
      ),
      GoRoute(
        path: '/match/result',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final category = extra?['category'] as String? ?? 'Animals';
          return MatchResultScreen(category: category);
        },
      ),
      GoRoute(
        path: '/word-wizard',
        builder: (context, state) => const WordWizardHomeScreen(),
      ),
      GoRoute(
        path: '/word-wizard/game',
        builder: (context, state) => const WordWizardGameScreen(),
      ),
      GoRoute(
        path: '/word-wizard/result',
        builder: (context, state) => const WordWizardResultScreen(),
      ),
      GoRoute(
        path: '/learn-everything',
        builder: (context, state) => const LearnEverythingHomeScreen(),
      ),
      GoRoute(
        path: '/learn-everything/game',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final category = extra['category'] as LearnCategory;
          return LearnEverythingGameScreen(category: category);
        },
      ),
      GoRoute(
        path: '/learn-speak',
        builder: (context, state) => const LearnSpeakHomeScreen(),
      ),
      GoRoute(
        path: '/learn-speak/game',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final category = extra['category'] as LearnSpeakCategory;
          return LearnSpeakGameScreen(category: category);
        },
      ),
    ],
  );
}
