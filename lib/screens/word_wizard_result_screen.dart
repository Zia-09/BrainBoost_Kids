import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:confetti/confetti.dart';
import '../providers/word_wizard_provider.dart';
import '../app_colors.dart';

class WordWizardResultScreen extends StatefulWidget {
  const WordWizardResultScreen({super.key});

  @override
  State<WordWizardResultScreen> createState() => _WordWizardResultScreenState();
}

class _WordWizardResultScreenState extends State<WordWizardResultScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 5),
    );
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WordWizardProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildTrophy(),
                    const SizedBox(height: 20),
                    Text(
                      "Awesome Job!",
                      style: GoogleFonts.fredoka(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "You're becoming a true Word Wizard!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildStatsGrid(provider),
                    const SizedBox(height: 32),
                    _buildMasteryCard(provider),
                    const SizedBox(height: 40),
                    _buildActionButtons(context, provider),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
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
                Colors.purple,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrophy() {
    return SizedBox(
      height: 200,
      child: Lottie.network(
        'https://assets2.lottiefiles.com/packages/lf20_tou9at9v.json', // Golden trophy
      ),
    );
  }

  Widget _buildStatsGrid(WordWizardProvider provider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.1),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDivider(),
          _buildStatRow(
            "Total Points",
            "${provider.globalScore}",
            "💎",
            Colors.cyanAccent,
          ),
          _buildDivider(),
          _buildStatRow(
            "Current Streak",
            "🔥 ${provider.currentStreak}",
            "⚡",
            Colors.orange,
          ),
          _buildDivider(),
          _buildStatRow(
            "Best Streak",
            "🏆 ${provider.bestStreak}",
            "👑",
            Colors.greenAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.white.withValues(alpha: 0.1),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, String icon, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.fredoka(fontSize: 18, color: Colors.white70),
            ),
          ],
        ),
        Text(
          value,
          style: GoogleFonts.fredoka(
            fontSize: 24,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMasteryCard(WordWizardProvider provider) {
    // Calculate a fake mastery based on score
    double progress = (provider.globalScore % 1000) / 1000;
    int level = (provider.globalScore / 1000).floor() + 1;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.indigo.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.indigo.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Wizard Level $level",
                style: GoogleFonts.fredoka(
                  fontSize: 20,
                  color: Colors.indigoAccent,
                ),
              ),
              Text(
                "${(progress * 100).toInt()}%",
                style: GoogleFonts.fredoka(
                  fontSize: 16,
                  color: Colors.indigoAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.white.withValues(alpha: 0.05),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Colors.indigoAccent,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Next Level: ${((1 - progress) * 1000).toInt()} points to go!",
            style: GoogleFonts.nunito(fontSize: 12, color: Colors.white38),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WordWizardProvider provider,
  ) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              provider.continueToNextRound();
              context.pushReplacement('/word-wizard/game');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              "Continue Round ${provider.currentRound + 1}",
              style: GoogleFonts.fredoka(fontSize: 22),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => context.go('/word-wizard'),
          child: Text(
            "Back to Categories",
            style: GoogleFonts.fredoka(fontSize: 18, color: Colors.white54),
          ),
        ),
      ],
    );
  }
}
