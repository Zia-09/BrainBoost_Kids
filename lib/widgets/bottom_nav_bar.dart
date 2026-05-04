import 'package:flutter/material.dart';
import '../app_colors.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
  });

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/leaderboard');
        break;
      case 2:
        context.go('/store');
        break;
      case 3:
        context.go('/profile');
        break;
      default:
        context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = AppColors.isDark(context);
    
    // Background color: Theme-aware surface color
    final bgColor = isDark ? const Color(0xFF1E1155) : Colors.white;
    
    // Active Item Colors: Theme-aware primary colors
    final activeBgColor = isDark ? const Color(0xFFFFD700) : AppColors.splashBgStart;
    final activeContentColor = isDark ? const Color(0xFF2D1B72) : Colors.white;
    
    // Inactive Item Colors: Theme-aware secondary text colors
    final inactiveColor = isDark ? Colors.white38 : AppColors.textSecondaryLight;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(context, 0, Icons.rocket_launch_rounded, 'PLAY', activeBgColor, activeContentColor, inactiveColor),
              _navItem(context, 1, Icons.emoji_events_rounded, 'WORLD', activeBgColor, activeContentColor, inactiveColor),
              _navItem(context, 2, Icons.star_rounded, 'PRIZES', activeBgColor, activeContentColor, inactiveColor),
              _navItem(context, 3, Icons.person_rounded, 'ME', activeBgColor, activeContentColor, inactiveColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(
    BuildContext context,
    int index,
    IconData icon,
    String label,
    Color activeBgColor,
    Color activeContentColor,
    Color inactiveColor,
  ) {
    final active = index == currentIndex;
    
    return GestureDetector(
      onTap: () => _onTap(context, index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (active)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: activeBgColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(icon, color: activeContentColor, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      color: activeContentColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            )
          else ...[
            Icon(icon, color: inactiveColor, size: 24),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: inactiveColor,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
