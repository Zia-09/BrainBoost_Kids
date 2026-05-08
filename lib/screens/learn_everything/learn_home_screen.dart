import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../app_colors.dart';
import '../../data/learn_everything_data.dart';
import '../../models/learn_item.dart';
import '../../services/score_service.dart';
import '../../services/sound_service.dart';

class LearnEverythingHomeScreen extends StatefulWidget {
  const LearnEverythingHomeScreen({super.key});

  @override
  State<LearnEverythingHomeScreen> createState() => _LearnEverythingHomeScreenState();
}

class _LearnEverythingHomeScreenState extends State<LearnEverythingHomeScreen> {
  final SoundService _soundService = SoundService();
  late List<LearnCategory> _categories;

  @override
  void initState() {
    super.initState();
    _categories = LearnEverythingData.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ScoreService>(
      builder: (context, scoreService, child) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.splashBgStart,
                  AppColors.splashBgEnd,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildAppBar(context, scoreService.totalStars),
                  Expanded(
                    child: _buildCategoryGrid(context, scoreService),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context, int totalStars) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white24,
              padding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Learn Everything!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'Pick a category to start!',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  '$totalStars',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context, ScoreService scoreService) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        // The first one is always unlocked. Others are unlocked if the previous one is completed (stars > 0)
        // For simplicity, let's say a category is unlocked if scoreService has an entry for it or if it's the first one.
        // Actually, the user says "Stars earned per category unlock the next one".
        final isUnlocked = index == 0 || scoreService.getHighScore('LearnEverything', _categories[index - 1].name) > 0;
        
        return _buildCategoryCard(context, category, isUnlocked, scoreService);
      },
    );
  }

  Widget _buildCategoryCard(BuildContext context, LearnCategory category, bool isUnlocked, ScoreService scoreService) {
    final stars = scoreService.getHighScore('LearnEverything', category.name);

    return GestureDetector(
      onTap: () {
        if (isUnlocked) {
          _soundService.playClickSound();
          context.push('/learn-everything/game', extra: {'category': category});
        } else {
          _soundService.playError();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Complete the previous category to unlock this one!'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isUnlocked ? Colors.white : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(24),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  category.icon,
                  style: TextStyle(
                    fontSize: 48,
                    color: isUnlocked ? null : Colors.grey.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    category.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: isUnlocked ? AppColors.textPrimary : Colors.white24,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                if (isUnlocked)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return Icon(
                        Icons.star_rounded,
                        color: index < stars ? Colors.amber : Colors.grey.withValues(alpha: 0.3),
                        size: 20,
                      );
                    }),
                  ),
              ],
            ),
            if (!isUnlocked)
              const Center(
                child: Icon(Icons.lock_rounded, color: Colors.white, size: 40),
              ),
          ],
        ),
      ),
    );
  }
}
