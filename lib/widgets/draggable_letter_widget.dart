import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DraggableLetterWidget extends StatelessWidget {
  final String letter;
  final Color color;

  const DraggableLetterWidget({
    super.key,
    required this.letter,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      data: letter,
      feedback: Transform.rotate(
        angle: 0.1,
        child: _buildLetterCard(letter, color, true),
      ),
      childWhenDragging: Opacity(
        opacity: 0.2,
        child: _buildLetterCard(letter, color, false),
      ),
      child: _buildLetterCard(letter, color, false),
    );
  }

  Widget _buildLetterCard(String letter, Color color, bool isDragging) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: DefaultTextStyle(
          style: GoogleFonts.fredoka(
            fontSize: 32,
            color: Colors.white,
          ),
          child: Text(letter),
        ),
      ),
    );
  }
}
