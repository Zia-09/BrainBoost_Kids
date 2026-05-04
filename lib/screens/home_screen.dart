import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../app_colors.dart';
import '../widgets/bottom_nav_bar.dart';
import '../services/score_service.dart';
import '../services/sound_service.dart';
import '../services/settings_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SoundService _soundService = SoundService();

  @override
  Widget build(BuildContext context) {
    return Consumer2<ScoreService, SettingsService>(
      builder: (context, scoreService, settingsService, child) {
        final totalStars = scoreService.totalStars;
        final level = (totalStars ~/ 100) + 1;
        final xp = totalStars % 100;
        const xpForNext = 100;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: AppColors.getBackground(context),
            elevation: 0,
            titleSpacing: 16,
            title: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: AppColors.textPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.smart_toy_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'BrainBoost Kids',
                  style: TextStyle(
                    color: AppColors.isDark(context)
                        ? Colors.white
                        : AppColors.splashBgStart,
                    fontWeight: FontWeight.w900,
                    fontSize: 19,
                  ),
                ),
              ],
            ),
            actions: [
              // Stars chip in AppBar
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFFD700).withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '$totalStars',
                      style: const TextStyle(
                        color: Color(0xFFFFD700),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.settings_rounded,
                  color: AppColors.cardGeneral,
                ),
                onPressed: () {
                  _soundService.playClickSound();
                  context.push('/settings');
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Welcome card with mascot
                _buildWelcomeCard(settingsService.userName),
                const SizedBox(height: 24),

                // Subject grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.0,
                  children: [
                    _buildSubjectCard(
                      context,
                      subject: 'Math',
                      icon: Icons.calculate_rounded,
                      color: AppColors.cardMath,
                      score: scoreService.getSubjectHighScore('Math'),
                    ),
                    _buildSubjectCard(
                      context,
                      subject: 'English',
                      icon: Icons.menu_book_rounded,
                      color: AppColors.cardEnglish,
                      score: scoreService.getSubjectHighScore('English'),
                    ),
                    _buildSubjectCard(
                      context,
                      subject: 'Science',
                      icon: Icons.science_rounded,
                      color: AppColors.cardScience,
                      score: scoreService.getSubjectHighScore('Science'),
                    ),
                    _buildSubjectCard(
                      context,
                      subject: 'General',
                      icon: Icons.public_rounded,
                      color: AppColors.cardGeneral,
                      score: scoreService.getSubjectHighScore('General'),
                    ),
                    _buildSubjectCard(
                      context,
                      subject: 'Colors',
                      icon: Icons.palette_rounded,
                      color: AppColors.cardColors,
                      score: scoreService.getSubjectHighScore('Colors'),
                    ),
                    _buildSubjectCard(
                      context,
                      subject: 'Human Body',
                      icon: Icons.accessibility_new_rounded,
                      color: AppColors.cardBody,
                      score: scoreService.getSubjectHighScore('Human Body'),
                    ),
                    _buildSubjectCard(
                      context,
                      subject: 'Animals',
                      icon: Icons.pets_rounded,
                      color: AppColors.cardAnimals,
                      score: scoreService.getSubjectHighScore('Animals'),
                    ),
                    _buildSubjectCard(
                      context,
                      subject: 'Space',
                      icon: Icons.rocket_launch_rounded,
                      color: AppColors.cardSpace,
                      score: scoreService.getSubjectHighScore('Space'),
                    ),
                    _buildSubjectCard(
                      context,
                      subject: 'Nutrition',
                      icon: Icons.apple_rounded,
                      color: AppColors.cardNutrition,
                      score: scoreService.getSubjectHighScore('Nutrition'),
                    ),
                    _buildSubjectCard(
                      context,
                      subject: 'Geography',
                      icon: Icons.map_rounded,
                      color: AppColors.cardGeography,
                      score: scoreService.getSubjectHighScore('Geography'),
                    ),
                    _buildSubjectCard(
                      context,
                      subject: 'Dinosaurs',
                      icon: Icons.vibration_rounded, // Best fit for "rumbly" dinosaurs or use a custom icon if available
                      color: AppColors.cardDinosaurs,
                      score: scoreService.getSubjectHighScore('Dinosaurs'),
                    ),
                    _buildSubjectCard(
                      context,
                      subject: 'Technology',
                      icon: Icons.computer_rounded,
                      color: AppColors.cardTechnology,
                      score: scoreService.getSubjectHighScore('Technology'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Match It Game Banner
                _buildMatchBanner(context),
                const SizedBox(height: 16),

                // Word Wizard Banner
                _buildWordWizardBanner(context),
                const SizedBox(height: 24),

                // Topic Challenge Button
                _buildChallengeButton(context),
                const SizedBox(height: 24),

                // Daily Boost card
                _buildDailyBoostCard(context),
                const SizedBox(height: 16),

                // Current rank card (real data)
                _buildRankCard(level, xp, xpForNext),
                const SizedBox(height: 16),
              ],
            ),
          ),
          bottomNavigationBar: const BottomNavBar(currentIndex: 0),
        );
      },
    );
  }

  Widget _buildMatchBanner(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _soundService.playClickSound();
        context.push('/match');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00C9FF), Color(0xFF92FE9D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00C9FF).withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: const Text('🧩', style: TextStyle(fontSize: 28)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Match It! Game',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Drag & drop to match pictures!',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.play_circle_fill_rounded,
              color: Colors.white,
              size: 44,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _soundService.playClickSound();
        context.push('/topics/Math?challenge=true');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6A11CB).withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOPIC CHALLENGE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    'Earn double points & streaks!',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(String userName) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFB347), Color(0xFFFF7B00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi $userName! 👋',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'What do you want to learn today?',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Mascot
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.child_care_rounded,
              size: 60,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectCard(
    BuildContext context, {
    required String subject,
    required IconData icon,
    required Color color,
    required int score,
  }) {
    return GestureDetector(
      onTap: () {
        _soundService.playClickSound();
        context.push('/topics/$subject');
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12), // Slightly reduced
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: Colors.white, size: 32), // Slightly reduced
            ),
            const SizedBox(height: 10),
            Text(
              subject,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Best: $score',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyBoostCard(BuildContext context) {
    final bool isDark = AppColors.isDark(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.splashBgStart.withValues(alpha: 0.2) : const Color(0xFFF0ECFF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.splashBgStart,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'DAILY BOOST',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: AppColors.splashBgStart,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '"Mistakes are proof that you are trying! Keep going, superstar!"',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : AppColors.textPrimary,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '❝',
            style: TextStyle(
              fontSize: 40,
              color: AppColors.textSecondary.withValues(alpha: 0.2),
              height: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankCard(int level, int xp, int xpForNext) {
    final xpFraction = xpForNext > 0 ? (xp / xpForNext).clamp(0.0, 1.0) : 0.0;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.splashBgStart,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CURRENT RANK',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.65),
              fontSize: 11,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Level $level',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Row(
                children: [
                  Text(
                    '$xp',
                    style: const TextStyle(
                      color: Color(0xFFFFD700),
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    ' / $xpForNext XP',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // XP bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: xpFraction,
              minHeight: 10,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordWizardBanner(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _soundService.playClickSound();
        context.push('/word-wizard');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF512F), Color(0xFFDD2476)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF512F).withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: const Text('🪄', style: TextStyle(fontSize: 28)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Word Wizard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Spell words to become a wizard!',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.stars_rounded,
              color: Colors.white,
              size: 44,
            ),
          ],
        ),
      ),
    );
  }
}

