import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:confetti/confetti.dart';
import '../app_colors.dart';
import '../models/quiz_result.dart';
import '../services/score_service.dart';

class ResultScreen extends StatefulWidget {
  final QuizResult result;
  final String subject;
  final String topic;
  final String difficulty;
  final Color topicColor;
  final bool isChallengeMode;

  const ResultScreen({
    super.key,
    required this.result,
    required this.subject,
    required this.topic,
    this.difficulty = 'Medium',
    this.topicColor = Colors.blue,
    this.isChallengeMode = false,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with SingleTickerProviderStateMixin {
  final ScoreService _scoreService = ScoreService();
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late ConfettiController _confettiController;
  bool _isNewHighScore = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _saveScore();
  }

  Future<void> _saveScore() async {
    final prevBest = _scoreService.getHighScore(widget.subject, widget.topic);
    await _scoreService.saveHighScore(widget.subject, widget.topic, widget.result.score);
    
    int starsToAdd = widget.isChallengeMode ? widget.result.correctAnswers * 2 : widget.result.correctAnswers;
    if (_scoreService.hasItem('power_double_stars')) {
      starsToAdd *= 2;
      await _scoreService.removeItem('power_double_stars');
      if (mounted) setState(() {}); // To trigger rebuild for double stars UI
    }
    await _scoreService.addStars(starsToAdd);
    
    final total = widget.result.correctAnswers + widget.result.wrongAnswers;
    final pct = total > 0 ? widget.result.correctAnswers / total : 0.0;

    if (mounted) {
      if (widget.result.score > prevBest) {
        setState(() => _isNewHighScore = true);
      }
      
      // Celebrate if score is good (e.g., > 70%) or challenge mode completed
      if (pct >= 0.7 || widget.isChallengeMode) {
        _confettiController.play();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Stars: 0–3 based on percentage
    final total = widget.result.correctAnswers + widget.result.wrongAnswers;
    final pct = total > 0 ? widget.result.correctAnswers / total : 0.0;
    final int stars = pct >= 0.8 ? 3 : pct >= 0.5 ? 2 : pct >= 0.2 ? 1 : 0;
    final scoreText =
        '${widget.result.score}/${total * 10}';

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // AppBar row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.go('/home'),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppColors.isDark(context) 
                                ? Colors.white.withValues(alpha: 0.12)
                                : AppColors.splashBgStart.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.close_rounded, 
                              color: AppColors.isDark(context) ? Colors.white : AppColors.splashBgStart, 
                              size: 20),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'QUIZ MASTER',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.getTextPrimary(context),
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 38),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Score display
                Text(
                  'YOUR FINAL SCORE',
                  style: TextStyle(
                    color: AppColors.getTextSecondary(context),
                    fontSize: 13,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 6),
                ScaleTransition(
                  scale: _scaleAnim,
                  child: Text(
                    scoreText,
                    style: TextStyle(
                      color: AppColors.getTextPrimary(context),
                      fontSize: 52,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Stars row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(
                        i < stars ? Icons.star_rounded : Icons.star_border_rounded,
                        color: i < stars ? const Color(0xFFFFD700) : Colors.grey.shade600,
                        size: 42,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),

                // NEW HIGH SCORE banner
                if (widget.isChallengeMode)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.yellow.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.auto_awesome_rounded, color: Color(0xFF2D1B72), size: 32),
                        const SizedBox(height: 8),
                        const Text(
                          'CHALLENGE COMPLETED!',
                          style: TextStyle(
                            color: Color(0xFF2D1B72),
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'DOUBLE REWARDS EARNED: ${widget.result.correctAnswers * 2} STARS!',
                          style: const TextStyle(
                            color: Color(0xFF2D1B72),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  )
                else if (_isNewHighScore)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.splashBgStart, width: 2),
                      borderRadius: BorderRadius.circular(14),
                      color: AppColors.splashBgStart.withValues(alpha: 0.15),
                    ),
                    child: Center(
                      child: Text(
                        'NEW HIGH SCORE!',
                        style: TextStyle(
                          color: AppColors.isDark(context) ? Colors.white : AppColors.splashBgStart,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),

                // Double stars message
                if (pct > 0 && !_scoreService.hasItem('power_double_stars') && 
                    (widget.isChallengeMode ? widget.result.correctAnswers * 4 : widget.result.correctAnswers * 2) == 
                    (widget.isChallengeMode ? widget.result.correctAnswers * 2 : widget.result.correctAnswers) * 2) // Check if double stars was just used
                  Container(
                    margin: const EdgeInsets.only(top: 8, left: 32, right: 32),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9500).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.bolt_rounded, color: Color(0xFFFF9500), size: 16),
                        SizedBox(width: 6),
                        Text(
                          'DOUBLE STARS POWER-UP USED!',
                          style: TextStyle(
                            color: Color(0xFFFF9500),
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),

                // Stat cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.check_circle_rounded,
                          iconColor: AppColors.correct,
                          value: '${widget.result.correctAnswers}',
                          label: 'CORRECT',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.cancel_rounded,
                          iconColor: AppColors.wrong,
                          value: '${widget.result.wrongAnswers}',
                          label: 'WRONG',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.local_fire_department_rounded,
                          iconColor: AppColors.optOrange,
                          value: '${widget.result.bestStreak}',
                          label: 'BEST STREAK',
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Action buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      // Play Again
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: AppColors.splashBgStart,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.refresh_rounded, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                'TRY AGAIN',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Change Topic
                      GestureDetector(
                        onTap: () => context.go('/topics/${widget.subject}'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Text(
                              'CHANGE TOPIC',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Bottom Nav
                _buildBottomNav(context),
              ],
            ),
          ),
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.getCard(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              color: AppColors.getTextPrimary(context),
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.getTextSecondary(context),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(context, Icons.home_rounded, 'HOME', () => context.go('/home')),
          _navItem(context, Icons.grid_view_rounded, 'TOPICS', null, active: true),
          _navItem(context, Icons.person_outline_rounded, 'PROFILE', () => context.go('/profile')),
        ],
      ),
    );
  }

  Widget _navItem(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback? onTap, {
    bool active = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: active
                ? const EdgeInsets.symmetric(horizontal: 16, vertical: 6)
                : null,
            decoration: active
                ? BoxDecoration(
                    color: AppColors.splashBgStart,
                    borderRadius: BorderRadius.circular(20),
                  )
                : null,
            child: Row(
              children: [
                Icon(
                  icon,
                  color: active ? Colors.white : Colors.white54,
                  size: 20,
                ),
                if (active) ...[
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (!active)
            Text(
              label,
              style: const TextStyle(color: Colors.white54, fontSize: 10),
            ),
        ],
      ),
    );
  }
}
