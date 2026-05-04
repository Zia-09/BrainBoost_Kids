import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../app_colors.dart';
import '../services/score_service.dart';
import '../services/settings_service.dart';
import '../widgets/bottom_nav_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<IconData> _avatars = [
    Icons.person_rounded,
    Icons.face_rounded,
    Icons.sentiment_very_satisfied_rounded,
    Icons.child_care_rounded,
    Icons.pets_rounded,
    Icons.rocket_rounded,
  ];

  Future<void> _pickImage(SettingsService settings) async {
    final ImagePicker picker = ImagePicker();
    
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.getBackground(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'SELECT PHOTO',
              style: TextStyle(
                color: AppColors.getTextPrimary(context),
                fontWeight: FontWeight.w900,
                fontSize: 18,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPickerOption(
                  icon: Icons.camera_alt_rounded,
                  label: 'Camera',
                  color: Colors.blue,
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
                _buildPickerOption(
                  icon: Icons.photo_library_rounded,
                  label: 'Gallery',
                  color: Colors.purple,
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );

    if (source != null) {
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      
      if (image != null) {
        await settings.setProfilePicPath(image.path);
      }
    }
  }

  Widget _buildPickerOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 36),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: AppColors.getTextPrimary(context),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfile(BuildContext context, SettingsService settings) {
    final nameController = TextEditingController(text: settings.userName);
    int selectedAvatar = settings.avatarIndex;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 20,
            left: 20,
            right: 20,
          ),
          decoration: BoxDecoration(
            color: AppColors.getBackground(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              Text('EDIT PROFILE', style: TextStyle(color: AppColors.getTextPrimary(context), fontWeight: FontWeight.w900, fontSize: 18)),
              const SizedBox(height: 20),
              
              // Avatar Selector
              SizedBox(
                height: 70,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _avatars.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => setModalState(() => selectedAvatar = index),
                    child: Container(
                      width: 60,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: selectedAvatar == index ? const Color(0xFFFFD700) : AppColors.getSurface(context),
                        shape: BoxShape.circle,
                        border: Border.all(color: selectedAvatar == index ? Colors.white : Colors.transparent, width: 2),
                      ),
                      child: Icon(_avatars[index], color: selectedAvatar == index ? const Color(0xFF1A0A4F) : AppColors.getTextSecondary(context)),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Your Name',
                  labelStyle: TextStyle(color: AppColors.getTextSecondary(context)),
                  filled: true,
                  fillColor: AppColors.getSurface(context),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
                style: TextStyle(color: AppColors.getTextPrimary(context)),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.splashBgStart,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () async {
                    await settings.setUserName(nameController.text);
                    await settings.setAvatarIndex(selectedAvatar);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('SAVE CHANGES', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ScoreService, SettingsService>(
      builder: (context, scoreService, settingsService, child) {
        final totalStars = scoreService.totalStars;
        final totalQuizzes = scoreService.totalQuizzes;
        final userName = settingsService.userName;
        final avatarIndex = settingsService.avatarIndex;
        final profilePicPath = settingsService.profilePicPath;
        
        final level = (totalStars / 500).floor() + 1;
        
        int rankVal = 5000 - (totalStars * 5);
        if (rankVal < 1) rankVal = 1;
        final globalRank = '#$rankVal';

        final highScores = {
          'Math': scoreService.getSubjectHighScore('Math'),
          'English': scoreService.getSubjectHighScore('English'),
          'Science': scoreService.getSubjectHighScore('Science'),
          'General': scoreService.getSubjectHighScore('General'),
        };

        return Scaffold(
          backgroundColor: AppColors.getBackground(context),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // AppBar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        const SizedBox(width: 44), 
                        const Spacer(),
                        Text(
                          'MY PROFILE',
                          style: TextStyle(
                            color: AppColors.getTextPrimary(context),
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/settings'),
                          child: Icon(Icons.settings_outlined, color: AppColors.getTextSecondary(context), size: 24),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Avatar & Name
                  Column(
                    children: [
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () => _pickImage(settingsService),
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFFFFD700), width: 4),
                                gradient: profilePicPath == null ? const LinearGradient(
                                  colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                                ) : null,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF2575FC).withValues(alpha: 0.4),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                                image: profilePicPath != null 
                                  ? DecorationImage(
                                      image: FileImage(File(profilePicPath)),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                              ),
                              child: profilePicPath == null 
                                ? Icon(_avatars[avatarIndex], size: 80, color: Colors.white)
                                : null,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => _showEditProfile(context, settingsService),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFD700),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.edit_rounded, size: 16, color: Color(0xFF1A0A4F)),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => _pickImage(settingsService),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.splashBgStart,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(Icons.camera_alt_rounded, size: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        userName,
                        style: TextStyle(
                          color: AppColors.getTextPrimary(context),
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'Level $level Explorer',
                        style: const TextStyle(
                          color: Color(0xFFFFD700),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Stats Row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _statItem('TOTAL STARS', '$totalStars', Icons.star_rounded, const Color(0xFFFFD700)),
                        _statItem('GLOBAL RANK', globalRank, Icons.emoji_events_rounded, const Color(0xFFFF9500)),
                        _statItem('QUIZZES', '$totalQuizzes', Icons.quiz_rounded, const Color(0xFF00BFA5)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // High Scores Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BEST SCORES',
                          style: TextStyle(
                            color: AppColors.getTextPrimary(context),
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...highScores.entries.map((e) => _scoreRow(e.key, e.value)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          bottomNavigationBar: const BottomNavBar(currentIndex: 3),
        );
      }
    );
  }

  Widget _statItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: TextStyle(
            color: AppColors.getTextPrimary(context),
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColors.getTextSecondary(context),
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _scoreRow(String subject, int score) {
    Color color;
    IconData icon;
    switch (subject) {
      case 'Math':
        color = AppColors.cardMath;
        icon = Icons.calculate_rounded;
        break;
      case 'English':
        color = AppColors.cardEnglish;
        icon = Icons.menu_book_rounded;
        break;
      case 'Science':
        color = AppColors.cardScience;
        icon = Icons.science_rounded;
        break;
      default:
        color = AppColors.cardGeneral;
        icon = Icons.public_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.getTextSecondary(context).withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Text(
            subject,
            style: TextStyle(
              color: AppColors.getTextPrimary(context),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(
            '$score pts',
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
