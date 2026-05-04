import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app_colors.dart';
import '../services/score_service.dart';
import '../services/settings_service.dart';

class DifficultyScreen extends StatefulWidget {
  final String subject;
  final String topic;
  final Color? topicColor;
  final bool isChallengeMode;

  const DifficultyScreen({
    super.key,
    required this.subject,
    required this.topic,
    this.topicColor,
    this.isChallengeMode = false,
  });

  @override
  State<DifficultyScreen> createState() => _DifficultyScreenState();
}

class _DifficultyScreenState extends State<DifficultyScreen> {
  final ScoreService _scoreService = ScoreService();
  final SettingsService _settingsService = SettingsService();
  int _highScore = 0;
  int _baseTimer = 10;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final hs = _scoreService.getHighScore(widget.subject, widget.topic);
    final timer = await _settingsService.getTimerDuration();
    if (mounted) {
      setState(() {
        _highScore = hs;
        _baseTimer = timer;
      });
    }
  }

  Color get _effectiveTopicColor => widget.topicColor ?? const Color(0xFF673AB7);

  IconData get _mascotIcon {
    switch (widget.subject) {
      case 'Math': return Icons.calculate_rounded;
      case 'English': return Icons.menu_book_rounded;
      case 'Science': return Icons.science_rounded;
      default: return Icons.public_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.isDark(context)
                ? [const Color(0xFF2D1B72), const Color(0xFF1A0A4F)]
                : [AppColors.splashBgStart, AppColors.splashBgEnd],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.getSurface(context),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: AppColors.getTextPrimary(context),
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.topic,
                          style: TextStyle(
                            color: AppColors.getTextPrimary(context),
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          widget.subject,
                          style: TextStyle(
                            color: AppColors.getTextSecondary(context),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (widget.isChallengeMode)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.yellow.withValues(alpha: 0.5), width: 1.5),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.lock_clock_rounded, color: Colors.yellow, size: 24),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'CHALLENGE MODE: Easy is locked! Only Medium and Hard are available for double points.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Top trophy + high score
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD700).withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.emoji_events_rounded,
                        color: Color(0xFFFFD700),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PERSONAL BEST',
                          style: TextStyle(
                            color: AppColors.getTextSecondary(context),
                            fontSize: 11,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          '$_highScore pts',
                          style: const TextStyle(
                            color: Color(0xFFFFD700),
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Mascot Illustration
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      _mascotIcon,
                      size: 72,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // Difficulty heading
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  'Choose Difficulty',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

              // Difficulty cards
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildDifficultyCard(
                      difficulty: 'Easy',
                      subtitle: '10 Questions • ${(_baseTimer * 1.5).round()}s each',
                      icon: Icons.sentiment_satisfied_rounded,
                      cardColor: const Color(0xFF43A047),
                      accentColor: const Color(0xFF66BB6A),
                      timeLimit: (_baseTimer * 1.5).round(),
                      isLocked: widget.isChallengeMode,
                    ),
                    const SizedBox(height: 16),
                    _buildDifficultyCard(
                      difficulty: 'Medium',
                      subtitle: '10 Questions • $_baseTimer s each',
                      icon: Icons.sentiment_neutral_rounded,
                      cardColor: const Color(0xFFF9A825),
                      accentColor: const Color(0xFFFFCA28),
                      timeLimit: _baseTimer,
                    ),
                    const SizedBox(height: 16),
                    _buildDifficultyCard(
                      difficulty: 'Hard',
                      subtitle: '10 Questions • ${(_baseTimer * 0.7).round().clamp(3, 20)}s each',
                      icon: Icons.whatshot_rounded,
                      cardColor: const Color(0xFFE53935),
                      accentColor: const Color(0xFFEF5350),
                      timeLimit: (_baseTimer * 0.7).round().clamp(3, 20),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyCard({
    required String difficulty,
    required String subtitle,
    required IconData icon,
    required Color cardColor,
    required Color accentColor,
    required int timeLimit,
    bool isLocked = false,
  }) {
    return GestureDetector(
      onTap: isLocked 
        ? null 
        : () {
            context.push('/quiz', extra: {
              'subject': widget.subject,
              'topic': widget.topic,
              'difficulty': difficulty,
              'timeLimit': timeLimit,
              'topicColor': _effectiveTopicColor,
              'isChallengeMode': widget.isChallengeMode,
            });
          },
      child: Container(
        padding: const EdgeInsets.all(24),
        foregroundDecoration: isLocked ? BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(22),
        ) : null,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [cardColor, accentColor.withValues(alpha: 0.7)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: cardColor.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    difficulty.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isLocked ? Icons.lock_rounded : Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
