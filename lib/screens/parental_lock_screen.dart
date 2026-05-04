import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../services/settings_service.dart';
import 'settings_screen.dart';

class ParentalLockScreen extends StatefulWidget {
  const ParentalLockScreen({super.key});

  @override
  State<ParentalLockScreen> createState() => _ParentalLockScreenState();
}

class _ParentalLockScreenState extends State<ParentalLockScreen> {
  final SettingsService _settingsService = SettingsService();
  String _correctPin = '1234';
  String _entered = '';
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadPin();
  }

  Future<void> _loadPin() async {
    final pin = await _settingsService.getParentalPin();
    setState(() => _correctPin = pin);
  }

  void _onKey(String digit) {
    if (_entered.length >= 4) return;
    setState(() {
      _entered += digit;
      _hasError = false;
    });
    if (_entered.length == 4) {
      _verify();
    }
  }

  void _onDelete() {
    if (_entered.isEmpty) return;
    setState(() {
      _entered = _entered.substring(0, _entered.length - 1);
      _hasError = false;
    });
  }

  void _verify() {
    if (_entered == _correctPin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SettingsScreen()),
      );
    } else {
      setState(() {
        _hasError = true;
        _entered = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = AppColors.isDark(context);

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Parent Zone',
          style: TextStyle(
            color: AppColors.getTextPrimary(context),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'BRAINBOOST',
                style: TextStyle(
                  color: AppColors.splashBgStart,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          // Lock icon
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.splashBgStart.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              size: 36,
              color: AppColors.splashBgStart,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Parental Lock',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: AppColors.splashBgStart,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _hasError
                ? 'Incorrect PIN. Try again.'
                : 'Enter your 4-digit PIN to access parent\nsettings.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: _hasError ? AppColors.wrong : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 40),
          // PIN dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (i) {
              final filled = i < _entered.length;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: filled
                      ? AppColors.splashBgStart.withValues(alpha: 0.18)
                      : (isDark ? AppColors.surfaceDark : Colors.grey.shade200),
                  border: Border.all(
                    color: filled
                        ? AppColors.splashBgStart
                        : (isDark ? Colors.white10 : Colors.grey.shade300),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: filled
                      ? Container(
                          width: 14,
                          height: 14,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.splashBgStart,
                          ),
                        )
                      : null,
                ),
              );
            }),
          ),
          const Spacer(),
          // Keypad
          _buildKeypad(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildKeypad() {
    const keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          for (final row in keys)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: row.map((d) => _buildKey(d)).toList(),
              ),
            ),
          // Bottom row: delete | 0 | confirm
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildIconKey(
                Icons.backspace_outlined,
                onTap: _onDelete,
              ),
              _buildKey('0'),
              _buildIconKey(
                Icons.check_circle_outline_rounded,
                onTap: _verify,
                color: AppColors.splashBgStart,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKey(String digit) {
    return GestureDetector(
      onTap: () => _onKey(digit),
      child: Container(
        width: 80,
        height: 72,
        decoration: BoxDecoration(
          color: AppColors.isDark(context) ? AppColors.surfaceDark : const Color(0xFFCEE9F4),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.isDark(context) ? Colors.black26 : Colors.teal.withValues(alpha: 0.25),
              blurRadius: 0,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            digit,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.isDark(context) ? Colors.white : const Color(0xFF1A4A6B),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconKey(IconData icon, {required VoidCallback onTap, Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 72,
        decoration: BoxDecoration(
          color: AppColors.isDark(context) ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.isDark(context) ? Colors.black26 : Colors.grey.withValues(alpha: 0.2),
              blurRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 28,
          color: color ?? AppColors.textSecondary,
        ),
      ),
    );
  }
}
