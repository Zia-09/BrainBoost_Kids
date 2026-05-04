import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MatchProgressBar extends StatelessWidget {
  final int current;
  final int total;
  final Color color;
  final String label;

  const MatchProgressBar({
    super.key,
    required this.current,
    required this.total,
    required this.color,
    this.label = '',
  });

  @override
  Widget build(BuildContext context) {
    final fraction = total > 0 ? (current / total).clamp(0.0, 1.0) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(
            label,
            style: GoogleFonts.nunito(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: fraction),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return LinearProgressIndicator(
                value: value,
                minHeight: 10,
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              );
            },
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '$current / $total matched',
          style: GoogleFonts.nunito(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
