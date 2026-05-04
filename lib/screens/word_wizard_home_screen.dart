import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/word_wizard_provider.dart';
import '../models/word_item.dart';
import '../app_colors.dart';

class WordWizardHomeScreen extends StatefulWidget {
  const WordWizardHomeScreen({super.key});

  @override
  State<WordWizardHomeScreen> createState() => _WordWizardHomeScreenState();
}

class _WordWizardHomeScreenState extends State<WordWizardHomeScreen> {
  late Timer _timer;
  Duration _timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calculateTimeLeft();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _calculateTimeLeft();
        });
      }
    });
  }

  void _calculateTimeLeft() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    _timeLeft = tomorrow.difference(now);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return "${twoDigits(d.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildHeader(context),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildDailyChallengeCard(context),
                  const SizedBox(height: 24),
                  _buildSectionTitle("Categories"),
                  const SizedBox(height: 12),
                ]),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: _buildCategoriesGrid(context),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 24),
                  _buildSpecialModes(context),
                  const SizedBox(height: 120),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final provider = context.watch<WordWizardProvider>();
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      expandedHeight: 120,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4C2A85), Color(0xFF265089)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("🧙", style: TextStyle(fontSize: 32)),
                  const SizedBox(width: 10),
                  Text(
                    "Word Wizard",
                    style: GoogleFonts.fredoka(
                      fontSize: 32,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatBadge(
                    "Score: ${provider.globalScore}",
                    Colors.amber,
                  ),
                  const SizedBox(width: 12),
                  _buildStatBadge(
                    "Streak: 🔥${provider.bestStreak}",
                    Colors.orange,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(text, style: GoogleFonts.fredoka(color: color, fontSize: 14)),
    );
  }

  Widget _buildDailyChallengeCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text("⭐", style: TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text(
                "Today's Challenge",
                style: GoogleFonts.fredoka(
                  fontSize: 22,
                  color: Colors.brown[900],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "New words every day! Resets in: ${_formatDuration(_timeLeft)}",
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: Colors.brown[800],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<WordWizardProvider>().startRound(
                category: "Daily",
                difficulty: "Mixed",
                mode: GameMode.daily,
              );
              context.push('/word-wizard/game');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.orange[900],
              shape: RoundedRectangle.circular(16),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text("Play Now", style: GoogleFonts.fredoka(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.fredoka(fontSize: 24, color: Colors.white),
    );
  }

  Widget _buildCategoriesGrid(BuildContext context) {
    final categories = [
      {"name": "Animals", "icon": "🐾", "color": Colors.purple},
      {"name": "Fruits", "icon": "🍎", "color": Colors.red},
      {"name": "Vegetables", "icon": "🥕", "color": Colors.orange},
      {"name": "Transport", "icon": "✈️", "color": Colors.blue},
      {"name": "Shapes", "icon": "📐", "color": Colors.teal},
      {"name": "Colors", "icon": "🎨", "color": Colors.pink},
    ];

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final cat = categories[index];
        return _buildCategoryCard(
          context,
          cat["name"] as String,
          cat["icon"] as String,
          cat["color"] as Color,
        );
      }, childCount: categories.length),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String name,
    String icon,
    Color color,
  ) {
    return InkWell(
      onTap: () => _showDifficultyDialog(context, name),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Center(
                child: Text(icon, style: const TextStyle(fontSize: 40)),
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              flex: 2,
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    name,
                    style: GoogleFonts.fredoka(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 6,
              width: 60,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: 0.6, // Fake progress
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showDifficultyDialog(BuildContext context, String category) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _DifficultySelectionSheet(category: category),
    );
  }

  Widget _buildSpecialModes(BuildContext context) {
    final provider = context.watch<WordWizardProvider>();
    return Column(
      children: [
        _buildModeCard(
          context,
          "Endless Mode",
          "Infinite words from all categories!",
          "♾️",
          Colors.indigo,
          () {
            context.read<WordWizardProvider>().startRound(
              category: "All",
              difficulty: "Mixed",
              mode: GameMode.endless,
            );
            context.push('/word-wizard/game');
          },
        ),
        const SizedBox(height: 16),
        _buildModeCard(
          context,
          "Prestige Mode (Level ${provider.prestigeLevel})",
          "The ultimate challenge for Word Wizards!",
          "💎",
          const Color(0xFFB8860B),
          () {
            context.read<WordWizardProvider>().startRound(
              category: "Prestige",
              difficulty: "Extreme",
              mode: GameMode.prestige,
            );
            context.push('/word-wizard/game');
          },
        ),
        const SizedBox(height: 16),
        _buildModeCard(
          context,
          "Quick Quiz (MCQ)",
          "Test your knowledge with word options!",
          "❓",
          Colors.orange,
          () {
            context.read<WordWizardProvider>().startRound(
              category: "All",
              difficulty: "Easy",
              mode: GameMode.mcq,
            );
            context.push('/word-wizard/game');
          },
        ),
      ],
    );
  }

  Widget _buildModeCard(
    BuildContext context,
    String title,
    String sub,
    String icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 40)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.fredoka(fontSize: 20, color: color),
                  ),
                  Text(
                    sub,
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white24),
          ],
        ),
      ),
    );
  }
}

class _DifficultySelectionSheet extends StatelessWidget {
  final String category;
  const _DifficultySelectionSheet({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF15152B),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 30),
          Text(
            "Choose Your Level!",
            style: GoogleFonts.fredoka(
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Ready to play with $category?",
            style: GoogleFonts.nunito(fontSize: 18, color: Colors.white60),
          ),
          const SizedBox(height: 32),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildOption(
                    context,
                    "Quick Quiz",
                    "Fun & Easy MCQ Game",
                    "❓",
                    Colors.amber,
                    "Easy",
                    GameMode.mcq,
                    0,
                  ),
                  _buildOption(
                    context,
                    "Starter",
                    "Find the missing letter",
                    "🌱",
                    Colors.greenAccent,
                    "Easy",
                    GameMode.normal,
                    1,
                  ),
                  _buildOption(
                    context,
                    "Intermediate",
                    "Fill 2 missing letters",
                    "🔥",
                    Colors.orangeAccent,
                    "Medium",
                    GameMode.normal,
                    2,
                  ),
                  _buildOption(
                    context,
                    "Challenger",
                    "3 letters are hidden!",
                    "⚡",
                    Colors.redAccent,
                    "Hard",
                    GameMode.normal,
                    3,
                  ),
                  _buildOption(
                    context,
                    "Grandmaster",
                    "Can you spell the whole word?",
                    "👑",
                    Colors.purpleAccent,
                    "Expert",
                    GameMode.normal,
                    4,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context,
    String title,
    String subtitle,
    String icon,
    Color color,
    String value,
    GameMode mode,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          context.read<WordWizardProvider>().startRound(
            category: category,
            difficulty: value,
            mode: mode,
          );
          Navigator.pop(context);
          context.push('/word-wizard/game');
        },
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.15),
                color.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.2),
                      blurRadius: 12,
                      spreadRadius: -2,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(icon, style: const TextStyle(fontSize: 32)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.fredoka(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: Colors.white54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension RoundedRectangle on RoundedRectangleBorder {
  static RoundedRectangleBorder circular(double radius) =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));
}
