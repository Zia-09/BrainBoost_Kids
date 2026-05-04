import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_colors.dart';
import '../services/score_service.dart';
import '../services/settings_service.dart';
import '../widgets/bottom_nav_bar.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  int _currentTabIndex = 0; // 0 = POWER-UPS, 1 = AVATARS, 2 = THEMES

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      body: SafeArea(
        child: Consumer2<ScoreService, SettingsService>(
          builder: (context, scoreService, settingsService, child) {
            return Column(
              children: [
                // AppBar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.getSurface(context),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.arrow_back_rounded, color: AppColors.getTextPrimary(context), size: 24),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'PRIZES & SHOP',
                        style: TextStyle(
                          color: AppColors.getTextPrimary(context),
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD700).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFFFD700).withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 18),
                            const SizedBox(width: 6),
                            Text(
                              '${scoreService.totalStars}',
                              style: const TextStyle(
                                color: Color(0xFFFFD700),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Banner
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6A11CB).withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'UNLEASH POWER!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Spend your stars to unlock amazing power-ups and prizes!',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 12,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 50),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Store Categories (Tabs)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _categoryChip('POWER-UPS', _currentTabIndex == 0, 0),
                        const SizedBox(width: 10),
                        _categoryChip('AVATARS', _currentTabIndex == 1, 1),
                        const SizedBox(width: 10),
                        _categoryChip('THEMES', _currentTabIndex == 2, 2),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Store Items Grid
                Expanded(
                  child: GridView.count(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.72,
                    children: _buildGridItems(scoreService, settingsService),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }

  Future<void> _purchaseItem(String id, String title, int price, ScoreService scoreService, SettingsService settingsService, {bool isAvatar = false, int? avatarIndex, bool isTheme = false, bool? isDark}) async {
    // If already unlocked, just equip
    if (scoreService.hasItem(id)) {
      if (isAvatar && avatarIndex != null) {
        settingsService.setAvatarIndex(avatarIndex);
        _showSnackbar('Equipped $title!');
      } else if (isTheme && isDark != null) {
        settingsService.setDarkMode(isDark);
        _showSnackbar('Equipped $title!');
      } else {
        _showSnackbar('$title activated!');
      }
      return;
    }

    final success = await scoreService.spendStars(price);
    if (mounted) {
      if (success) {
        scoreService.unlockItem(id);
        if (isAvatar && avatarIndex != null) {
          settingsService.setAvatarIndex(avatarIndex);
        } else if (isTheme && isDark != null) {
          settingsService.setDarkMode(isDark);
        }
        _showSnackbar('Yay! You unlocked $title!', isSuccess: true);
      } else {
        _showSnackbar('Not enough stars! Play more quizzes to earn more.', isSuccess: false);
      }
    }
  }

  void _showSnackbar(String message, {bool isSuccess = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _categoryChip(String label, bool active, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFFFD700) : AppColors.getSurface(context),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? const Color(0xFF1A0A4F) : AppColors.getTextSecondary(context),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildGridItems(ScoreService scoreService, SettingsService settingsService) {
    if (_currentTabIndex == 0) {
      return [
        _storeCard('power_double_stars', 'Double Stars', 'Earn 2x stars for the next 10 mins!', 500, Icons.bolt_rounded, const Color(0xFFFF9500), scoreService, settingsService),
        _storeCard('power_time_freeze', 'Time Freeze', 'Stop the clock for 3 questions.', 300, Icons.timer_rounded, const Color(0xFF00BFA5), scoreService, settingsService),
        _storeCard('power_shield', 'Shield', 'Protects your streak once.', 400, Icons.security_rounded, const Color(0xFF29B6F6), scoreService, settingsService),
        _storeCard('power_clue', 'Clue', 'Removes 2 wrong answers.', 250, Icons.lightbulb_rounded, const Color(0xFFD4AF37), scoreService, settingsService),
      ];
    } else if (_currentTabIndex == 1) {
      return [
        _storeCard('avatar_0', 'Classic User', 'Standard avatar.', 0, Icons.person_rounded, Colors.grey, scoreService, settingsService, isAvatar: true, avatarIndex: 0),
        _storeCard('avatar_1', 'Happy Face', 'A very happy face.', 100, Icons.face_rounded, Colors.orange, scoreService, settingsService, isAvatar: true, avatarIndex: 1),
        _storeCard('avatar_2', 'Big Smile', 'Smiling wide!', 150, Icons.sentiment_very_satisfied_rounded, Colors.yellow, scoreService, settingsService, isAvatar: true, avatarIndex: 2),
        _storeCard('avatar_3', 'Baby', 'Cute baby face.', 200, Icons.child_care_rounded, Colors.pink, scoreService, settingsService, isAvatar: true, avatarIndex: 3),
        _storeCard('avatar_4', 'Pet Dog', 'Your loyal companion.', 300, Icons.pets_rounded, Colors.brown, scoreService, settingsService, isAvatar: true, avatarIndex: 4),
        _storeCard('avatar_5', 'Rocket', 'Blast off!', 500, Icons.rocket_rounded, Colors.blue, scoreService, settingsService, isAvatar: true, avatarIndex: 5),
      ];
    } else {
      return [
        _storeCard('theme_light', 'Light Theme', 'Bright and clean.', 0, Icons.light_mode_rounded, Colors.orangeAccent, scoreService, settingsService, isTheme: true, isDark: false),
        _storeCard('theme_dark', 'Dark Theme', 'Easy on the eyes.', 200, Icons.dark_mode_rounded, Colors.deepPurple, scoreService, settingsService, isTheme: true, isDark: true),
      ];
    }
  }

  Widget _storeCard(String id, String title, String desc, int price, IconData icon, Color color, ScoreService scoreService, SettingsService settingsService, {bool isAvatar = false, int? avatarIndex, bool isTheme = false, bool? isDark}) {
    final bool isUnlocked = price == 0 || scoreService.hasItem(id);
    
    bool isEquipped = false;
    if (isAvatar && avatarIndex != null) {
      isEquipped = settingsService.avatarIndex == avatarIndex;
    } else if (isTheme && isDark != null) {
      isEquipped = settingsService.darkMode == isDark;
    }

    return GestureDetector(
      onTap: () {
        if (isUnlocked) {
          _purchaseItem(id, title, price, scoreService, settingsService, isAvatar: isAvatar, avatarIndex: avatarIndex, isTheme: isTheme, isDark: isDark);
        } else {
          _showPurchaseConfirmation(id, title, price, scoreService, settingsService, isAvatar, avatarIndex, isTheme, isDark);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12), // Reduced padding slightly
        decoration: BoxDecoration(
          color: AppColors.getSurface(context),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.getTextSecondary(context).withValues(alpha: 0.05)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.getTextPrimary(context),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Text(
                desc,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.getTextSecondary(context),
                  fontSize: 10,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isEquipped ? Colors.green : (isUnlocked ? Colors.blue : const Color(0xFFFFD700)),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isUnlocked)
                    const Icon(Icons.star_rounded, color: Color(0xFF1A0A4F), size: 12),
                  if (!isUnlocked)
                    const SizedBox(width: 4),
                  Text(
                    isEquipped ? 'EQUIPPED' : (isUnlocked ? 'USE' : '$price'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPurchaseConfirmation(String id, String title, int price, ScoreService scoreService, SettingsService settingsService, bool isAvatar, int? avatarIndex, bool isTheme, bool? isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.isDark(context) ? const Color(0xFF2D1B72) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Unlock $title?',
          style: TextStyle(color: AppColors.getTextPrimary(context), fontWeight: FontWeight.bold),
        ),
        content: Text(
          'This will cost $price stars. Are you sure?',
          style: TextStyle(color: AppColors.getTextSecondary(context)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColors.getTextSecondary(context))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD700),
              foregroundColor: const Color(0xFF1A0A4F),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(context);
              _purchaseItem(id, title, price, scoreService, settingsService, isAvatar: isAvatar, avatarIndex: avatarIndex, isTheme: isTheme, isDark: isDark);
            },
            child: const Text('Unlock', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
