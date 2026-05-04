import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/match_data.dart';
import '../providers/match_provider.dart';
import '../services/match_database_service.dart';

class MatchHomeScreen extends StatefulWidget {
  const MatchHomeScreen({super.key});

  @override
  State<MatchHomeScreen> createState() => _MatchHomeScreenState();
}

class _MatchHomeScreenState extends State<MatchHomeScreen> {
  Map<String, int> _learnedCounts = {};
  Map<String, int> _bestScores = {};

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final Map<String, int> learned = {};
    final Map<String, int> best = {};
    for (final meta in matchCategoryMeta) {
      final name = meta['name'] as String;
      learned[name] = await MatchDatabaseService.getLearnedCount(name);
      best[name] = await MatchDatabaseService.getBestScore(name);
    }
    if (mounted) {
      setState(() {
        _learnedCounts = learned;
        _bestScores = best;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A0A6E), Color(0xFF3B1FA8), Color(0xFF6A1B9A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          '🧩 Match It!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),

              // Subtitle
              Text(
                'Drag the name to match the picture!',
                style: GoogleFonts.nunito(
                  color: Colors.white70,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: 20),

              // Grid
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 0.85,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                        ),
                        itemCount: matchCategoryMeta.length,
                        itemBuilder: (context, index) {
                          final meta = matchCategoryMeta[index];
                          final name = meta['name'] as String;
                          final emoji = meta['emoji'] as String;
                          final color = Color(meta['color'] as int);
                          final bgColor = Color(meta['bgColor'] as int);
                          final learned = _learnedCounts[name] ?? 0;
                          final total = allMatchCategories[name]?.length ?? 10;
                          final best = _bestScores[name] ?? 0;

                          return _buildCategoryCard(
                            context,
                            name: name,
                            emoji: emoji,
                            color: color,
                            bgColor: bgColor,
                            learned: learned,
                            total: total,
                            best: best,
                            index: index,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8), // Reduced from 16 to prevent overflow
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required String name,
    required String emoji,
    required Color color,
    required Color bgColor,
    required int learned,
    required int total,
    required int best,
    required int index,
  }) {
    final fraction = total > 0 ? learned / total : 0.0;

    return GestureDetector(
      onTap: () {
        context.read<MatchProvider>().startCategory(name);
        context.push('/match/game', extra: {'category': name});
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, bgColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Best score badge
            if (best > 0)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded,
                          color: Color(0xFFFFD700), size: 12),
                      const SizedBox(width: 2),
                      Text(
                        '$best',
                        style: const TextStyle(
                          color: Color(0xFFFFD700),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 44)),
                  const SizedBox(height: 8),
                  Text(
                    name,
                    style: GoogleFonts.fredoka(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: fraction,
                      minHeight: 6,
                      backgroundColor: Colors.black.withValues(alpha: 0.25),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.white),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$learned/$total learned',
                    style: GoogleFonts.nunito(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
          .animate(delay: (index * 80).ms)
          .fadeIn()
          .slideY(begin: 0.2, end: 0)
          .then()
          .shimmer(duration: 1200.ms, color: Colors.white.withValues(alpha: 0.1)),
    );
  }
}
