import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_colors.dart';
import '../widgets/bottom_nav_bar.dart';
import '../services/score_service.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  int _selectedTab = 0;

  static const _subjects = ['Math', 'English', 'Science', 'General'];
  static const _tabIcons = [
    Icons.calculate_rounded,
    Icons.menu_book_rounded,
    Icons.science_rounded,
    Icons.public_rounded,
  ];

  static const _subjectTopics = {
    'Math': ['Addition', 'Subtraction', 'Multiplication', 'Division'],
    'English': ['Vocabulary', 'Grammar', 'Spelling', 'Comprehension'],
    'Science': ['Plants', 'Animals', 'Solar System', 'Human Body'],
    'General': ['World Facts', 'History', 'Sports', 'Technology'],
  };

  Color _difficultyColor(String? d) {
    switch (d) {
      case 'HARD': return const Color(0xFFE53935);
      case 'MEDIUM': return const Color(0xFFF9A825);
      case 'EASY': return const Color(0xFF43A047);
      default: return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = AppColors.isDark(context);

    return Consumer<ScoreService>(
      builder: (context, scoreService, child) {
        final subject = _subjects[_selectedTab];
        final topics = _subjectTopics[subject] ?? [];

        return Scaffold(
          backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFF2D1B72),
          body: SafeArea(
            child: Column(
              children: [
                // AppBar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: Colors.white10,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person_rounded, color: Colors.white70, size: 24),
                      ),
                      const Spacer(),
                      const Row(
                        children: [
                          Icon(Icons.emoji_events_rounded, color: Color(0xFFFFD700), size: 22),
                          SizedBox(width: 8),
                          Text(
                            'WORLD RANKINGS',
                            style: TextStyle(
                              color: Color(0xFFFFD700),
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/settings'),
                        child: const Icon(Icons.settings_outlined, color: Colors.white54, size: 22),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Subject tab chips
                SizedBox(
                  height: 44,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: _subjects.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 10),
                    itemBuilder: (context, i) {
                      final active = i == _selectedTab;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedTab = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          decoration: BoxDecoration(
                            color: active ? const Color(0xFFFFD700) : Colors.white10,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _tabIcons[i],
                                size: 16,
                                color: active ? const Color(0xFF2D1B72) : Colors.white60,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _subjects[i],
                                style: TextStyle(
                                  color: active ? const Color(0xFF2D1B72) : Colors.white60,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Topic score rows
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: topics.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final topicName = topics[i];
                      final score = scoreService.getHighScore(subject, topicName);
                      final locked = score == 0;
                      
                      // Calculate stars based on score
                      int stars = 0;
                      if (score >= 900) { stars = 3; }
                      else if (score >= 600) { stars = 2; }
                      else if (score > 0) { stars = 1; }

                      // Difficulty mapping (for display)
                      String difficulty = 'EASY';
                      if (score >= 700) { difficulty = 'HARD'; }
                      else if (score >= 400) { difficulty = 'MEDIUM'; }

                      return _buildTopicRow(topicName, score, stars, difficulty, locked);
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // Weekly Master card
                _buildWeeklyMasterCard(subject, isDark, scoreService),

                const SizedBox(height: 12),
              ],
            ),
          ),
          bottomNavigationBar: const BottomNavBar(currentIndex: 1),
        );
      },
    );
  }

  Widget _buildWeeklyMasterCard(String subject, bool isDark, ScoreService scoreService) {
    final totalStars = scoreService.totalStars;
    final progress = (totalStars % 1000) / 1000;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : const Color(0xFF3D2A8A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.local_fire_department_rounded,
                      color: Color(0xFFFFD700), size: 18),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Your Progress',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "You've earned $totalStars stars so far! Keep mastering $subject topics to climb the ranks!",
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicRow(String topic, int score, int stars, String difficulty, bool locked) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: locked 
            ? (AppColors.isDark(context) ? AppColors.surfaceDark.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.05))
            : (AppColors.isDark(context) ? AppColors.surfaceDark : Colors.white.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      topic,
                      style: TextStyle(
                        color: locked ? Colors.white38 : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (!locked) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _difficultyColor(difficulty),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          difficulty,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                if (locked)
                  const Text(
                    'Not played yet',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                else
                  Row(
                    children: List.generate(3, (j) {
                      return Icon(
                        j < stars ? Icons.star_rounded : Icons.star_border_rounded,
                        color: j < stars ? const Color(0xFFFFD700) : Colors.white24,
                        size: 18,
                      );
                    }),
                  ),
              ],
            ),
          ),
          if (locked)
            const Icon(Icons.lock_outline_rounded, color: Colors.white24, size: 24)
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'HIGH SCORE',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45),
                    fontSize: 10,
                    letterSpacing: 0.8,
                  ),
                ),
                Text(
                  '$score',
                  style: const TextStyle(
                    color: Color(0xFFFFD700),
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
