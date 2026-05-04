import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_colors.dart';

class LetterBoxWidget extends StatelessWidget {
  final String? letter;
  final bool isMissing;
  final bool? isCorrect;
  final bool isHovered;

  const LetterBoxWidget({
    super.key,
    this.letter,
    required this.isMissing,
    this.isCorrect,
    this.isHovered = false,
  });

  @override
  Widget build(BuildContext context) {
    bool hasValue = letter != null && letter!.isNotEmpty;

    return Container(
      width: 52,
      height: 52,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: _getBgColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getBorderColor(),
          width: isHovered ? 3 : 2,
          style: isMissing && !hasValue ? BorderStyle.solid : BorderStyle.solid,
        ),
        boxShadow: isHovered
            ? [
                BoxShadow(
                  color: Colors.blue.withValues(alpha: 0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ]
            : null,
      ),
      child: Center(
        child: Text(
          letter ?? "",
          style: GoogleFonts.fredoka(
            fontSize: 28,
            color: _getTextColor(),
          ),
        ),
      ),
    )
    .animate(target: isCorrect == false ? 1 : 0)
    .shake(hz: 4, curve: Curves.easeInOut);
  }

  Color _getBgColor() {
    if (isCorrect == true) return AppColors.correct.withValues(alpha: 0.2);
    if (isCorrect == false) return AppColors.wrong.withValues(alpha: 0.2);
    if (isHovered) return Colors.blue.withValues(alpha: 0.1);
    if (isMissing) return Colors.transparent;
    return Colors.white.withValues(alpha: 0.1);
  }

  Color _getBorderColor() {
    if (isCorrect == true) return AppColors.correct;
    if (isCorrect == false) return AppColors.wrong;
    if (isHovered) return Colors.blue;
    if (isMissing) return Colors.white.withValues(alpha: 0.3);
    return Colors.white;
  }

  Color _getTextColor() {
    if (isCorrect == true) return AppColors.correct;
    if (isCorrect == false) return AppColors.wrong;
    return Colors.white;
  }
}
