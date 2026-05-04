import 'package:flutter/material.dart';
import 'topic_screen.dart';
import '../app_colors.dart';
import '../services/sound_service.dart';

class TopicCompletedScreen extends StatefulWidget {
  final String subject;
  final String topic;
  final String unlockedDifficulty;

  const TopicCompletedScreen({
    super.key,
    required this.subject,
    required this.topic,
    required this.unlockedDifficulty,
  });

  @override
  State<TopicCompletedScreen> createState() => _TopicCompletedScreenState();
}

class _TopicCompletedScreenState extends State<TopicCompletedScreen> with SingleTickerProviderStateMixin {
  final SoundService _soundService = SoundService();
  late AnimationController _controller;
  late Animation<double> _confettiAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();
    _confettiAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _soundService.playSound('success.mp3'); // Play success sound
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _shareAchievement() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Achievement Shared! 🚀'),
        backgroundColor: AppColors.splashBgStart,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDD835),
      body: SafeArea(
        child: Stack(
          children: [
            // Confetti effect (simulated with particles)
            ...List.generate(20, (index) {
              return AnimatedBuilder(
                animation: _confettiAnim,
                builder: (context, child) {
                  return Positioned(
                    top: -20 + (_confettiAnim.value * 800 * (index % 5 + 1) / 5),
                    left: (index * 20.0) % MediaQuery.of(context).size.width,
                    child: Transform.rotate(
                      angle: _confettiAnim.value * 6,
                      child: Container(
                        width: 10,
                        height: 10,
                        color: [Colors.red, Colors.blue, Colors.green, Colors.purple, Colors.orange][index % 5],
                      ),
                    ),
                  );
                },
              );
            }),

            Column(
              children: [
                const SizedBox(height: 40),

                // Title
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  builder: (context, value, child) => Transform.scale(
                    scale: value,
                    child: Opacity(
                      opacity: value,
                      child: const Column(
                        children: [
                          Text(
                            'TOPIC',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF4A2B8C),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          Text(
                            'COMPLETED!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF4A2B8C),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Trophy
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) => Transform.translate(
                    offset: Offset(0, (1 - value) * 100),
                    child: Transform.rotate(
                      angle: (1 - value) * 0.5,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A2B8C).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.emoji_events_rounded,
                            size: 140,
                            color: Color(0xFFFFD700),
                            shadows: [
                              Shadow(color: Colors.orange, offset: Offset(0, 4), blurRadius: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Badge
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutBack,
                  builder: (context, value, child) => Transform.scale(
                    scale: value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFD4A017), Color(0xFFF5C518)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.brown.withValues(alpha: 0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFF4A2B8C), size: 36),
                          const SizedBox(height: 2),
                          Text(
                            widget.topic.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF4A2B8C),
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  "You've unlocked ${widget.unlockedDifficulty} difficulty!",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A2B8C),
                  ),
                ),

                const Spacer(),

                // Continue button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: GestureDetector(
                    onTap: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TopicScreen(subject: widget.subject),
                      ),
                      (r) => r.isFirst,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5E35B1),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4A2B8C).withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'CONTINUE',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              letterSpacing: 1.5,
                            ),
                          ),
                          SizedBox(width: 12),
                          Icon(Icons.arrow_forward_rounded, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Share Achievement button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: TextButton.icon(
                    onPressed: _shareAchievement,
                    icon: const Icon(Icons.share_rounded, color: Color(0xFF4A2B8C)),
                    label: const Text(
                      'SHARE ACHIEVEMENT',
                      style: TextStyle(
                        color: Color(0xFF4A2B8C),
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
