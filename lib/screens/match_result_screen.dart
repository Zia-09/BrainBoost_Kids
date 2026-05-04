import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/match_provider.dart';
import '../data/match_data.dart';

class MatchResultScreen extends StatefulWidget {
  final String category;

  const MatchResultScreen({super.key, required this.category});

  @override
  State<MatchResultScreen> createState() => _MatchResultScreenState();
}

class _MatchResultScreenState extends State<MatchResultScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 4));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<MatchProvider>();
      if (provider.stars >= 2) {
        _confettiController.play();
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Color get _categoryColor {
    final meta = matchCategoryMeta.firstWhere(
      (m) => m['name'] == widget.category,
      orElse: () => matchCategoryMeta.first,
    );
    return Color(meta['color'] as int);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MatchProvider>(
      builder: (context, provider, _) {
        final stars = provider.stars;
        final catColor = _categoryColor;
        final emoji = matchCategoryMeta
            .firstWhere((m) => m['name'] == widget.category,
                orElse: () => matchCategoryMeta.first)['emoji'] as String;
        final maxScore = provider.totalRounds * 4 * 10;
        final percentage = maxScore > 0
            ? ((provider.score / maxScore) * 100).round()
            : 0;

        return Scaffold(
          body: Stack(
            children: [
              // Background
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0F0E2E), Color(0xFF1A0A6E)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              // Confetti
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  particleDrag: 0.05,
                  emissionFrequency: 0.07,
                  numberOfParticles: 20,
                  gravity: 0.2,
                  colors: [
                    catColor,
                    Colors.yellow,
                    Colors.green,
                    Colors.pink,
                    Colors.cyan,
                  ],
                ),
              ),

              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Trophy / Emoji
                      const SizedBox(height: 20),
                      Text(
                        stars == 3 ? '🏆' : stars == 2 ? '🥈' : '🥉',
                        style: const TextStyle(fontSize: 80),
                      )
                          .animate()
                          .scale(
                              begin: const Offset(0, 0),
                              end: const Offset(1, 1),
                              curve: Curves.bounceOut,
                              duration: 700.ms)
                          .then()
                          .shake(hz: 2, rotation: 0.05),

                      const SizedBox(height: 12),

                      Text(
                        stars == 3
                            ? 'PERFECT! Amazing!'
                            : stars == 2
                                ? 'Great Job!'
                                : 'Keep Practicing!',
                        style: GoogleFonts.fredoka(
                          color: Colors.white,
                          fontSize: 28,
                        ),
                      ).animate().fadeIn(delay: 300.ms),

                      const SizedBox(height: 4),
                      Text(
                        '$emoji ${widget.category} Complete!',
                        style: GoogleFonts.nunito(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ).animate().fadeIn(delay: 400.ms),

                      const SizedBox(height: 24),

                      // Stars row
                      _buildStarsRow(stars)
                          .animate()
                          .fadeIn(delay: 500.ms)
                          .slideY(begin: 0.3, end: 0),

                      const SizedBox(height: 24),

                      // Score stats card
                      _buildStatsCard(provider, catColor, percentage)
                          .animate()
                          .fadeIn(delay: 600.ms)
                          .slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 20),

                      // Fun facts section
                      if (provider.learnedFacts.isNotEmpty)
                        _buildFunFactsSection(provider, catColor)
                            .animate()
                            .fadeIn(delay: 700.ms),

                      const SizedBox(height: 20),

                      // Progress section
                      _buildProgressSection(provider, catColor)
                          .animate()
                          .fadeIn(delay: 800.ms),

                      const SizedBox(height: 28),

                      // Action buttons
                      _buildActionButtons(context, provider)
                          .animate()
                          .fadeIn(delay: 900.ms)
                          .slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStarsRow(int stars) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final filled = i < stars;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Icon(
            filled ? Icons.star_rounded : Icons.star_outline_rounded,
            color: filled ? const Color(0xFFFFD700) : Colors.white24,
            size: 52,
          )
              .animate(delay: (600 + i * 150).ms)
              .scale(
                  begin: const Offset(0, 0),
                  end: const Offset(1, 1),
                  curve: Curves.bounceOut),
        );
      }),
    );
  }

  Widget _buildStatsCard(
      MatchProvider provider, Color catColor, int percentage) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          _statRow('🏆', 'Total Score',
              '${provider.score} / ${provider.totalRounds * 40} pts', catColor),
          const SizedBox(height: 12),
          _statRow('✅', 'Correct Matches',
              '${provider.correctCount}', Colors.greenAccent),
          const SizedBox(height: 12),
          _statRow('❌', 'Wrong Attempts',
              '${provider.wrongAttempts}', Colors.redAccent),
          const SizedBox(height: 12),
          _statRow('📊', 'Accuracy', '$percentage%', Colors.cyanAccent),
          const SizedBox(height: 16),
          // Accuracy bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: percentage / 100.0),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutCubic,
              builder: (_, v, _) => LinearProgressIndicator(
                value: v,
                minHeight: 12,
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(catColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statRow(String icon, String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.nunito(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: GoogleFonts.fredoka(color: color, fontSize: 18),
        ),
      ],
    );
  }

  Widget _buildFunFactsSection(MatchProvider provider, Color catColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📚 Fun Facts You Learned:',
          style: GoogleFonts.fredoka(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 12),
        ...provider.learnedFacts.asMap().entries.map((entry) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: catColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: catColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Text(
                  '${entry.key + 1}.',
                  style: GoogleFonts.fredoka(
                      color: catColor, fontSize: 16),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    entry.value,
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildProgressSection(MatchProvider provider, Color catColor) {
    final emoji = matchCategoryMeta
        .firstWhere((m) => m['name'] == widget.category,
            orElse: () => matchCategoryMeta.first)['emoji'] as String;
    final total = allMatchCategories[widget.category]?.length ?? 10;
    final learned = provider.learnedCount;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: catColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            '$emoji You have learned $learned/$total ${widget.category}!',
            style: GoogleFonts.fredoka(color: Colors.white, fontSize: 15),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: TweenAnimationBuilder<double>(
              tween: Tween(
                  begin: 0, end: total > 0 ? learned / total : 0.0),
              duration: const Duration(milliseconds: 1000),
              builder: (_, v, _) => LinearProgressIndicator(
                value: v,
                minHeight: 10,
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(catColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, MatchProvider provider) {
    return Column(
      children: [
        // Play Again
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: _categoryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 8,
              shadowColor: _categoryColor.withValues(alpha: 0.5),
            ),
            onPressed: () {
              provider.nextRound();
              context.pushReplacement(
                  '/match/game', extra: {'category': widget.category});
            },
            icon: const Icon(Icons.play_arrow_rounded, size: 24),
            label: Text('Next Round',
                style: GoogleFonts.fredoka(fontSize: 20)),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              side: BorderSide(
                  color: Colors.white.withValues(alpha: 0.3)),
              elevation: 0,
            ),
            onPressed: () {
              provider.resetCategory();
              context.pushReplacement(
                  '/match/game', extra: {'category': widget.category});
            },
            icon: const Icon(Icons.replay_rounded, size: 20),
            label: Text('Restart Category',
                style: GoogleFonts.fredoka(fontSize: 16)),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Change Category
            Expanded(
              child: SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.3)),
                    elevation: 0,
                  ),
                  onPressed: () => context.go('/match'),
                  icon: const Icon(Icons.grid_view_rounded, size: 18),
                  label: Text('Categories',
                      style: GoogleFonts.fredoka(fontSize: 15)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Home
            Expanded(
              child: SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.3)),
                    elevation: 0,
                  ),
                  onPressed: () => context.go('/home'),
                  icon: const Icon(Icons.home_rounded, size: 18),
                  label: Text('Home',
                      style: GoogleFonts.fredoka(fontSize: 15)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
