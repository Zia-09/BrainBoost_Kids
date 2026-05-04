import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/match_provider.dart';
import '../models/match_item.dart';
import '../widgets/draggable_name_card.dart';
import '../widgets/image_drop_target.dart';
import '../data/match_data.dart';

class MatchGameScreen extends StatefulWidget {
  final String category;

  const MatchGameScreen({super.key, required this.category});

  @override
  State<MatchGameScreen> createState() => _MatchGameScreenState();
}

class _MatchGameScreenState extends State<MatchGameScreen>
    with TickerProviderStateMixin {
  late AnimationController _scorePopController;
  late AnimationController _roundBannerController;
  MatchItem? _factItem;
  bool _showFunFact = false;

  Color get _categoryColor {
    final meta = matchCategoryMeta.firstWhere(
      (m) => m['name'] == widget.category,
      orElse: () => matchCategoryMeta.first,
    );
    return Color(meta['color'] as int);
  }

  @override
  void initState() {
    super.initState();
    _scorePopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _roundBannerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _scorePopController.dispose();
    _roundBannerController.dispose();
    super.dispose();
  }

  void _onDrop(MatchProvider provider, int imageId, String droppedName) {
    final wasCorrect = provider.checkMatch(imageId, droppedName);

    if (wasCorrect) {
      // Score pop animation
      _scorePopController.forward(from: 0);

      // Show fun fact
      final matched = provider.currentRoundItems
          .firstWhere((e) => e.id == imageId, orElse: () => provider.currentRoundItems.first);
      setState(() {
        _factItem = matched;
        _showFunFact = true;
      });
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _showFunFact = false);
      });

      // Check round complete
      if (provider.isRoundComplete) {
        _roundBannerController.forward(from: 0);
        Future.delayed(const Duration(seconds: 2), () {
          if (!mounted) return;
          if (provider.isCategoryComplete) {
            context.pushReplacement('/match/result',
                extra: {'category': widget.category});
          } else {
            provider.nextRound();
            _roundBannerController.reverse();
          }
        });
      }
    } else {
      // Vibrate on wrong
      HapticFeedback.mediumImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MatchProvider>(
      builder: (context, provider, _) {
        if (provider.currentRoundItems.isEmpty) {
          return const Scaffold(
            backgroundColor: Color(0xFF1A0A6E),
            body: Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }

        final catColor = _categoryColor;
        final emoji = matchCategoryMeta
            .firstWhere((m) => m['name'] == widget.category,
                orElse: () => matchCategoryMeta.first)['emoji'] as String;

        return Scaffold(
          body: Stack(
            children: [
              // Background gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF1A0A6E),
                      Color(matchCategoryMeta
                              .firstWhere(
                                (m) => m['name'] == widget.category,
                                orElse: () => matchCategoryMeta.first,
                              )['bgColor'] as int)
                          .withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              SafeArea(
                child: Column(
                  children: [
                    // ── Header ──────────────────────────────────────────────
                    _buildHeader(context, provider, catColor, emoji),

                    // ── Progress bar ────────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: Row(
                        children: List.generate(
                          provider.currentRoundItems.length,
                          (i) => Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              height: 8,
                              decoration: BoxDecoration(
                                color: provider.currentRoundItems[i].isMatched
                                    ? Colors.greenAccent
                                    : Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ── Score ──────────────────────────────────────────────
                    _buildScoreRow(provider),

                    const SizedBox(height: 8),

                    // ── Game Area ──────────────────────────────────────────
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _buildGameArea(provider, catColor),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),
                  ],
                ),
              ),

              // ── Fun Fact Popup ─────────────────────────────────────────
              if (_showFunFact && _factItem != null)
                _buildFunFactBanner(_factItem!, catColor),

              // ── Round Complete Banner ─────────────────────────────────
              if (provider.isRoundComplete)
                _buildRoundBanner(provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, MatchProvider provider,
      Color catColor, String emoji) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$emoji ${widget.category}',
              style: GoogleFonts.fredoka(
                color: Colors.white,
                fontSize: 18,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: catColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: catColor.withValues(alpha: 0.6), width: 1.2),
            ),
            child: Text(
              'Round ${provider.currentRound}',
              style: GoogleFonts.fredoka(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreRow(MatchProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: CurvedAnimation(
              parent: _scorePopController,
              curve: Curves.elasticOut,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star_rounded,
                      color: Color(0xFFFFD700), size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${provider.score} pts',
                    style: GoogleFonts.fredoka(
                      color: const Color(0xFFFFD700),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          if (provider.wrongAttempts > 0)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: Colors.red.withValues(alpha: 0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.close_rounded,
                      color: Colors.redAccent, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    '${provider.wrongAttempts}',
                    style: GoogleFonts.fredoka(
                      color: Colors.redAccent,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGameArea(MatchProvider provider, Color catColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── LEFT: Image drop targets ───────────────────────────────────
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: provider.currentRoundItems.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: ImageDropTarget(
                  key: ValueKey('img_${item.id}'),
                  item: item,
                  categoryColor: catColor,
                  onDrop: (dropped) {
                    _onDrop(provider, item.id, dropped);
                  },
                ),
              );
            }).toList(),
          ),
        ),

        // ── CENTER: Arrow guide ────────────────────────────────────────
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            ...List.generate(
              provider.currentRoundItems.length,
              (i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 22.5),
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white.withValues(alpha: 0.2),
                  size: 18,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(width: 4),

        // ── RIGHT: Draggable name cards ────────────────────────────────
        SizedBox(
          width: 130,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Show name cards for unmatched items (same count as left)
              ..._buildNameCardSlots(provider, catColor),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildNameCardSlots(MatchProvider provider, Color catColor) {
    final slots = <Widget>[];
    // We always show 4 slots aligned with the 4 images
    for (int i = 0; i < provider.currentRoundItems.length; i++) {
      final image = provider.currentRoundItems[i];
      // Find the namecard at position i, or null if already matched
      final nameCard = i < provider.nameCards.length
          ? provider.nameCards[i]
          : null;

      slots.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: SizedBox(
            height: 110, // Reduced from 130
            child: Center(
              child: nameCard != null
                  ? DraggableNameCard(
                      key: ValueKey('card_${nameCard.id}'),
                      name: nameCard.name,
                      urduName: nameCard.urduName,
                      color: catColor,
                      category: widget.category, // Added category
                      isMatched: nameCard.isMatched,
                    )
                      .animate()
                      .fadeIn(delay: (i * 100).ms)
                      .slideX(begin: 0.3, end: 0)
                  : (image.isMatched
                      ? Container(
                          width: 120,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.green),
                          ),
                          child: Center(
                            child: Text(
                              '✅ ${image.name}',
                              style: GoogleFonts.fredoka(
                                color: Colors.greenAccent,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink()),
            ),
          ),
        ),
      );
    }
    return slots;
  }

  Widget _buildFunFactBanner(MatchItem item, Color catColor) {
    return Positioned(
      bottom: 30,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A0A6E).withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: catColor, width: 2),
            boxShadow: [
              BoxShadow(
                color: catColor.withValues(alpha: 0.4),
                blurRadius: 16,
              )
            ],
          ),
          child: Row(
            children: [
              Text(item.emoji, style: const TextStyle(fontSize: 30)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '✨ Fun Fact!',
                      style: GoogleFonts.fredoka(
                        color: const Color(0xFFFFD700),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.funFact,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
            .animate()
            .slideY(begin: 1, end: 0, curve: Curves.easeOutBack)
            .fadeIn(),
      ),
    );
  }

  Widget _buildRoundBanner(MatchProvider provider) {
    return Positioned(
      top: 80,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF00C853), Color(0xFF1B5E20)],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withValues(alpha: 0.5),
                blurRadius: 20,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                provider.isCategoryComplete
                    ? '🏆 All Done!'
                    : '🎉 Round Complete!',
                style: GoogleFonts.fredoka(
                  color: Colors.white,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                provider.isCategoryComplete
                    ? 'Amazing! You matched everything!'
                    : 'Next round loading...',
                style: GoogleFonts.nunito(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        )
            .animate()
            .slideY(begin: -1, end: 0, curve: Curves.bounceOut)
            .fadeIn(),
      ),
    );
  }
}
