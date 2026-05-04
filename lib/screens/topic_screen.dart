import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../app_colors.dart';
import '../widgets/bottom_nav_bar.dart';
import '../services/score_service.dart';

class TopicScreen extends StatefulWidget {
  final String subject;
  final bool isChallengeMode;

  const TopicScreen({
    super.key,
    required this.subject,
    this.isChallengeMode = false,
  });

  @override
  State<TopicScreen> createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  Color get _subjectColor {
    switch (widget.subject) {
      case 'Math': return AppColors.cardMath;
      case 'English': return AppColors.cardEnglish;
      case 'Science': return AppColors.cardScience;
      case 'Colors': return AppColors.cardColors;
      case 'Human Body': return AppColors.cardBody;
      case 'Animals': return AppColors.cardAnimals;
      case 'Space': return AppColors.cardSpace;
      case 'Nutrition': return AppColors.cardNutrition;
      case 'Geography': return AppColors.cardGeography;
      case 'Dinosaurs': return AppColors.cardDinosaurs;
      case 'Technology': return AppColors.cardTechnology;
      default: return AppColors.cardGeneral;
    }
  }

  IconData get _mascotIcon {
    switch (widget.subject) {
      case 'Math': return Icons.calculate_rounded;
      case 'English': return Icons.menu_book_rounded;
      case 'Science': return Icons.science_rounded;
      case 'Colors': return Icons.palette_rounded;
      case 'Human Body': return Icons.accessibility_new_rounded;
      case 'Animals': return Icons.pets_rounded;
      case 'Space': return Icons.rocket_launch_rounded;
      case 'Nutrition': return Icons.apple_rounded;
      case 'Geography': return Icons.map_rounded;
      case 'Dinosaurs': return Icons.vibration_rounded;
      case 'Technology': return Icons.computer_rounded;
      default: return Icons.public_rounded;
    }
  }

  List<Map<String, dynamic>> _getTopics() {
    switch (widget.subject) {
      case 'Math':
        return [
          {'title': 'Addition', 'icon': Icons.add_circle_outline_rounded, 'color': const Color(0xFF673AB7)},
          {'title': 'Subtraction', 'icon': Icons.remove_circle_outline_rounded, 'color': const Color(0xFFE91E8C)},
          {'title': 'Multiplication', 'icon': Icons.close_rounded, 'color': const Color(0xFFD4AF37)},
          {'title': 'Division', 'icon': Icons.safety_divider_rounded, 'color': const Color(0xFF29B6F6)},
        ];
      case 'English':
        return [
          {'title': 'Vocabulary', 'icon': Icons.translate_rounded, 'color': const Color(0xFF43A047)},
          {'title': 'Grammar', 'icon': Icons.spellcheck_rounded, 'color': const Color(0xFF7E57C2)},
          {'title': 'Spelling', 'icon': Icons.sort_by_alpha_rounded, 'color': const Color(0xFFEF5350)},
          {'title': 'Comprehension', 'icon': Icons.chrome_reader_mode_rounded, 'color': const Color(0xFF00ACC1)},
        ];
      case 'Science':
        return [
          {'title': 'Plants', 'icon': Icons.eco_rounded, 'color': const Color(0xFF43A047)},
          {'title': 'Animals', 'icon': Icons.pets_rounded, 'color': const Color(0xFF8D6E63)},
          {'title': 'Solar System', 'icon': Icons.brightness_2_rounded, 'color': const Color(0xFF3F51B5)},
          {'title': 'Human Body', 'icon': Icons.accessible_forward_rounded, 'color': const Color(0xFFE91E63)},
        ];
      case 'Colors':
        return [
          {'title': 'Basic Colors', 'icon': Icons.color_lens_rounded, 'color': const Color(0xFFF44336)},
          {'title': 'Mixed Colors', 'icon': Icons.opacity_rounded, 'color': const Color(0xFFFF9800)},
          {'title': 'Rainbow Order', 'icon': Icons.looks_rounded, 'color': const Color(0xFF4CAF50)},
          {'title': 'Color of Objects', 'icon': Icons.image_search_rounded, 'color': const Color(0xFF2196F3)},
        ];
      case 'Human Body':
        return [
          {'title': 'Bones & Muscles', 'icon': Icons.fitness_center_rounded, 'color': const Color(0xFFE91E63)},
          {'title': 'Organs', 'icon': Icons.favorite_rounded, 'color': const Color(0xFFF44336)},
          {'title': 'Five Senses', 'icon': Icons.visibility_rounded, 'color': const Color(0xFF2196F3)},
          {'title': 'Healthy Teeth', 'icon': Icons.clean_hands_rounded, 'color': const Color(0xFF00BCD4)},
        ];
      case 'Animals':
        return [
          {'title': 'Wild Animals', 'icon': Icons.forest_rounded, 'color': const Color(0xFF5D4037)},
          {'title': 'Farm Animals', 'icon': Icons.agriculture_rounded, 'color': const Color(0xFF689F38)},
          {'title': 'Sea Creatures', 'icon': Icons.water_rounded, 'color': const Color(0xFF0288D1)},
          {'title': 'Birds', 'icon': Icons.flutter_dash_rounded, 'color': const Color(0xFFFBC02D)},
        ];
      case 'Space':
        return [
          {'title': 'Solar System', 'icon': Icons.brightness_2_rounded, 'color': const Color(0xFF3F51B5)},
          {'title': 'The Moon', 'icon': Icons.nightlight_round, 'color': const Color(0xFF9E9E9E)},
          {'title': 'Astronauts', 'icon': Icons.rocket_rounded, 'color': const Color(0xFFFF5722)},
          {'title': 'Stars & Galaxies', 'icon': Icons.auto_awesome_rounded, 'color': const Color(0xFFFFD700)},
        ];
      case 'Nutrition':
        return [
          {'title': 'Healthy Fruits', 'icon': Icons.apple_rounded, 'color': const Color(0xFFD32F2F)},
          {'title': 'Vegetables', 'icon': Icons.spa_rounded, 'color': const Color(0xFF388E3C)},
          {'title': 'Dairy & Protein', 'icon': Icons.egg_rounded, 'color': const Color(0xFFFFC107)},
          {'title': 'Junk Food vs Healthy', 'icon': Icons.fastfood_rounded, 'color': const Color(0xFF795548)},
        ];
      case 'Geography':
        return [
          {'title': 'Continents', 'icon': Icons.public_rounded, 'color': const Color(0xFF1976D2)},
          {'title': 'Oceans & Seas', 'icon': Icons.water_rounded, 'color': const Color(0xFF0288D1)},
          {'title': 'Mountains', 'icon': Icons.terrain_rounded, 'color': const Color(0xFF8D6E63)},
          {'title': 'Flags & Countries', 'icon': Icons.flag_rounded, 'color': const Color(0xFF43A047)},
        ];
      case 'Dinosaurs':
        return [
          {'title': 'T-Rex & Friends', 'icon': Icons.vibration_rounded, 'color': const Color(0xFFD32F2F)},
          {'title': 'Long Necks', 'icon': Icons.height_rounded, 'color': const Color(0xFF4CAF50)},
          {'title': 'Dino Eggs', 'icon': Icons.egg_rounded, 'color': const Color(0xFFFFC107)},
          {'title': 'The Dino Era', 'icon': Icons.history_rounded, 'color': const Color(0xFF795548)},
        ];
      case 'Technology':
        return [
          {'title': 'Computers', 'icon': Icons.computer_rounded, 'color': const Color(0xFF607D8B)},
          {'title': 'Gadgets', 'icon': Icons.smartphone_rounded, 'color': const Color(0xFF2196F3)},
          {'title': 'Robots', 'icon': Icons.smart_toy_rounded, 'color': const Color(0xFF9C27B0)},
          {'title': 'The Internet', 'icon': Icons.language_rounded, 'color': const Color(0xFF3F51B5)},
        ];
      default: // General
        return [
          {'title': 'World Facts', 'icon': Icons.public_rounded, 'color': const Color(0xFF1565C0)},
          {'title': 'History', 'icon': Icons.history_edu_rounded, 'color': const Color(0xFF6D4C41)},
          {'title': 'Sports', 'icon': Icons.sports_soccer_rounded, 'color': const Color(0xFF2E7D32)},
          {'title': 'Technology', 'icon': Icons.devices_rounded, 'color': const Color(0xFF37474F)},
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final topics = _getTopics();
    final subjectColor = widget.isChallengeMode ? const Color(0xFF2D1B72) : _subjectColor;

    return Scaffold(
      backgroundColor: subjectColor,
      body: SafeArea(
        child: Consumer<ScoreService>(
          builder: (context, scoreService, child) {
            return Column(
              children: [
                // AppBar
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
                            color: Colors.white.withValues(alpha: 0.25),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 22),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        widget.isChallengeMode ? 'TOPIC CHALLENGE' : widget.subject.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          letterSpacing: 1,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => context.push('/leaderboard'),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.emoji_events_outlined, color: Colors.white, size: 22),
                        ),
                      ),
                    ],
                  ),
                ),

                if (widget.isChallengeMode)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bolt_rounded, color: Color(0xFF2D1B72), size: 18),
                        SizedBox(width: 8),
                        Text(
                          'DOUBLE POINTS MODE ACTIVE!',
                          style: TextStyle(
                            color: Color(0xFF2D1B72),
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Header: mascot icon + tagline
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Mascot icon container (replaces missing image assets)
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                _mascotIcon,
                                size: 64,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: -5,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.yellow,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Text(
                                'FUN!',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  color: Color(0xFF2D1B72),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.isChallengeMode ? 'Can you handle it?' : 'Choose your quest!',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.isChallengeMode
                                ? 'Complete these topics to earn huge rewards!'
                                : 'Master the challenges\nand become a ${widget.subject} Legend!',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.85),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Topics list (white rounded container)
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.getBackground(context),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                      itemCount: topics.length,
                      itemBuilder: (context, i) {
                        final t = topics[i];
                        final title = t['title'] as String;
                        
                        // Real-time score check using synchronous getter
                        final hs = scoreService.getHighScore(widget.subject, title);
                        final stars = hs >= 900 ? 3 : hs >= 500 ? 2 : hs > 0 ? 1 : 0;
                        
                        return GestureDetector(
                          onTap: () {
                            context.push('/difficulty', extra: {
                              'subject': widget.subject,
                              'topic': title,
                              'isChallengeMode': widget.isChallengeMode,
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: AppColors.getCard(context),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: (t['color'] as Color).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(t['icon'] as IconData,
                                      color: t['color'] as Color, size: 28),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.getTextPrimary(context),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: (t['color'] as Color).withValues(alpha: 0.12),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              '10 Questions',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: t['color'] as Color,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          // Real stars from persisted scores
                                          Row(
                                            children: List.generate(3, (j) {
                                              return Icon(
                                                j < stars ? Icons.star_rounded : Icons.star_border_rounded,
                                                color: j < stars
                                                    ? const Color(0xFFFFD700)
                                                    : Colors.grey.shade400,
                                                size: 14,
                                              );
                                            }),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: (t['color'] as Color).withValues(alpha: 0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_rounded,
                                    color: t['color'] as Color,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}
