import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_colors.dart';
import '../providers/theme_provider.dart';
import '../services/score_service.dart';
import '../services/settings_service.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsService _settingsService = SettingsService();
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  bool _darkMode = false;
  double _customTimer = 10;
  int _selectedAgeGroup = 1; // 0 = 4-6, 1 = 7-9, 2 = 10-12

  static const _ageGroups = ['4–6', '7–9', '10–12'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    // Use synchronous getters — SettingsService is a singleton populated at app start.
    // Only getTimerDuration and getAgeGroupIndex need async prefs reads.
    final timer = await _settingsService.getTimerDuration();
    final age = await _settingsService.getAgeGroupIndex();
    
    if (mounted) {
      setState(() {
        _soundEnabled = _settingsService.soundEnabled;
        _musicEnabled = _settingsService.musicEnabled;
        _customTimer = timer.toDouble();
        _selectedAgeGroup = age;
        _darkMode = _settingsService.darkMode;
      });
    }
  }

  void _resetScores() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Reset All Scores?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('All high scores and progress will be permanently deleted. This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              final scoreService = ScoreService();
              await scoreService.clearAllScores();
              if (context.mounted) Navigator.pop(context);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All scores have been reset.')),
                );
              }
            },
            child: const Text('Reset', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _changePin() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Change Parental PIN', style: TextStyle(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          maxLength: 4,
          decoration: const InputDecoration(
            labelText: 'Enter new 4-digit PIN',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.length == 4) {
                await _settingsService.setParentalPin(controller.text);
                if (context.mounted) Navigator.pop(context);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('PIN updated successfully!')),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFEFECF8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: AppColors.splashBgStart),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Parent Zone',
          style: TextStyle(
            color: AppColors.isDark(context) ? Colors.white : AppColors.splashBgStart,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        children: [
          Text(
            'Settings',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppColors.getTextPrimary(context),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Configure your child's learning experience.",
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),

          // Sound Effects toggle
          _buildToggleTile(
            icon: Icons.volume_up_rounded,
            title: 'Sound Effects',
            value: _soundEnabled,
            onChanged: (v) async {
              setState(() => _soundEnabled = v);
              await _settingsService.setSoundEnabled(v);
            },
          ),
          const SizedBox(height: 12),

          // Background Music toggle
          _buildToggleTile(
            icon: Icons.music_note_rounded,
            title: 'Background Music',
            value: _musicEnabled,
            onChanged: (v) async {
              setState(() => _musicEnabled = v);
              await _settingsService.setMusicEnabled(v);
            },
          ),
          const SizedBox(height: 12),

          // Custom Timer slider
          _buildCardContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.timer_outlined, color: AppColors.splashBgStart, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Custom Timer',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.getTextPrimary(context),
                        ),
                      ),
                    ),
                    Text(
                      '${_customTimer.toInt()}s',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.splashBgStart,
                      ),
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.splashBgStart,
                    inactiveTrackColor: Colors.grey.shade200,
                    thumbColor: AppColors.splashBgStart,
                    overlayColor: AppColors.splashBgStart.withValues(alpha: 0.1),
                    trackHeight: 4,
                  ),
                  child: Slider(
                    value: _customTimer,
                    min: 3,
                    max: 20,
                    divisions: 17,
                    onChanged: (v) => setState(() => _customTimer = v),
                    onChangeEnd: (v) async {
                      await _settingsService.setTimerDuration(v.toInt());
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('3s', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    Text('20s', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Age Group selector
          _buildCardContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.face_rounded, color: AppColors.splashBgStart, size: 22),
                    const SizedBox(width: 12),
                    Text(
                      'Age Group',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: List.generate(_ageGroups.length, (i) {
                    final selected = i == _selectedAgeGroup;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          setState(() => _selectedAgeGroup = i);
                          await _settingsService.setAgeGroupIndex(i);
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: selected ? AppColors.splashBgStart : const Color(0xFFEFECF8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              _ageGroups[i],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: selected ? Colors.white : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Dark Mode toggle
          _buildToggleTile(
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            value: _darkMode,
            onChanged: (v) async {
              setState(() => _darkMode = v);
              await _settingsService.setDarkMode(v);
              // Update global theme
              if (context.mounted) {
                Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
              }
            },
          ),
          const SizedBox(height: 12),

          // About tile
          _buildCardContainer(
            child: Row(
              children: [
                const Icon(Icons.help_outline_rounded, color: AppColors.splashBgStart, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'About',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),
                ),
                Text(
                  'v1.0.0',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
              ],
            ),
          ),
          // Change PIN tile
          GestureDetector(
            onTap: _changePin,
            child: _buildCardContainer(
              child: Row(
                children: [
                  const Icon(Icons.lock_reset_rounded, color: AppColors.splashBgStart, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Change Parental PIN',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.getTextPrimary(context),
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Reset button
          GestureDetector(
            onTap: _resetScores,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: const Color(0xFFD32F2F),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  'Reset All High Scores',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              'Warning: This action cannot be undone.',
              style: TextStyle(
                color: Color(0xFFD32F2F),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildToggleTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return _buildCardContainer(
      child: Row(
        children: [
          Icon(icon, color: AppColors.splashBgStart, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.getTextPrimary(context),
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.splashBgStart,
          ),
        ],
      ),
    );
  }

  Widget _buildCardContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.getBackground(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.gamepad_outlined, 'PLAY', false, () => context.go('/home')),
              _buildNavItem(Icons.bar_chart_rounded, 'PROGRESS', false, () => context.go('/profile')),
              _buildNavItem(Icons.family_restroom_rounded, 'PARENTS', true, () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: active ? const EdgeInsets.symmetric(horizontal: 16, vertical: 6) : EdgeInsets.zero,
            decoration: active
                ? BoxDecoration(
                    color: AppColors.splashBgStart,
                    borderRadius: BorderRadius.circular(20),
                  )
                : null,
            child: Row(
              children: [
                Icon(icon, size: 20, color: active ? Colors.white : AppColors.textSecondary),
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
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }
}
