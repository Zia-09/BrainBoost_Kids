import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/match_item.dart';

class ImageDropTarget extends StatefulWidget {
  final MatchItem item;
  final Color categoryColor;
  final Function(String) onDrop;

  const ImageDropTarget({
    super.key,
    required this.item,
    required this.categoryColor,
    required this.onDrop,
  });

  @override
  State<ImageDropTarget> createState() => _ImageDropTargetState();
}

class _ImageDropTargetState extends State<ImageDropTarget>
    with TickerProviderStateMixin {
  bool _isHovering = false;
  bool _showWrong = false;

  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _onWrongDrop() {
    setState(() => _showWrong = true);
    _shakeController.forward(from: 0);
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _showWrong = false);
    });
  }

  void _onCorrectDrop() {
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return DragTarget<String>(
      onWillAcceptWithDetails: (details) => !item.isMatched,
      onAcceptWithDetails: (details) {
        setState(() => _isHovering = false);
        final dropped = details.data;
        if (dropped == item.name) {
          _onCorrectDrop();
          widget.onDrop(dropped);
        } else {
          _onWrongDrop();
          widget.onDrop(dropped); // provider handles incorrect
        }
      },
      onMove: (_) {
        if (!item.isMatched && !_isHovering) {
          setState(() => _isHovering = true);
        }
      },
      onLeave: (_) => setState(() => _isHovering = false),
      builder: (context, candidateData, rejectedData) {
        return AnimatedBuilder(
          animation: _shakeAnim,
          builder: (context, child) {
            double offset = 0;
            if (_showWrong) {
              offset = 8 * (0.5 - (_shakeAnim.value % 1.0)).abs() * 2;
            }
            return Transform.translate(
              offset: Offset(offset, 0),
              child: child,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 140,
            height: 130,
            decoration: BoxDecoration(
              color: item.isMatched
                  ? Colors.green.withValues(alpha: 0.15)
                  : _showWrong
                      ? Colors.red.withValues(alpha: 0.15)
                      : _isHovering
                          ? widget.categoryColor.withValues(alpha: 0.2)
                          : Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: item.isMatched
                    ? Colors.green
                    : _showWrong
                        ? Colors.red
                        : _isHovering
                            ? widget.categoryColor
                            : Colors.white.withValues(alpha: 0.2),
                width: item.isMatched || _isHovering ? 2.5 : 1.5,
              ),
              boxShadow: item.isMatched
                  ? [
                      BoxShadow(
                        color: Colors.green.withValues(alpha: 0.4),
                        blurRadius: 16,
                        spreadRadius: 2,
                      )
                    ]
                  : _isHovering
                      ? [
                          BoxShadow(
                            color: widget.categoryColor.withValues(alpha: 0.4),
                            blurRadius: 12,
                          )
                        ]
                      : [],
            ),
            child: Stack(
              children: [
                // Main emoji
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      item.category == "Colors"
                          ? Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: _getColorFromName(item.name),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.8), width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                            )
                          : Text(
                              item.emoji,
                              style: const TextStyle(fontSize: 52),
                            ),
                      if (item.isMatched) ...[
                        const SizedBox(height: 4),
                        Text(
                          item.name,
                          style: GoogleFonts.fredoka(
                            color: Colors.greenAccent,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Correct ✅ badge
                if (item.isMatched)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  )
                      .animate()
                      .scale(begin: const Offset(0, 0), end: const Offset(1, 1))
                      .then()
                      .shake(hz: 2, rotation: 0.05),

                // Hover hint
                if (_isHovering && !item.isMatched)
                  Positioned(
                    bottom: 6,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        'Drop here!',
                        style: TextStyle(
                          color: widget.categoryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                // Wrong X indicator
                if (_showWrong)
                  Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.85),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Color _getColorFromName(String name) {
  switch (name.toLowerCase()) {
    case 'red':
      return Colors.red;
    case 'blue':
      return Colors.blue;
    case 'green':
      return Colors.green;
    case 'yellow':
      return Colors.yellow;
    case 'orange':
      return Colors.orange;
    case 'purple':
      return Colors.purple;
    case 'pink':
      return Colors.pink;
    case 'brown':
      return Colors.brown;
    case 'black':
      return Colors.black;
    case 'white':
      return Colors.white;
    default:
      return Colors.transparent;
  }
}
