import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import '../../app_colors.dart';
import '../../models/learn_item.dart';
import '../../services/score_service.dart';
import '../../services/sound_service.dart';

class LearnEverythingGameScreen extends StatefulWidget {
  final LearnCategory category;

  const LearnEverythingGameScreen({super.key, required this.category});

  @override
  State<LearnEverythingGameScreen> createState() => _LearnEverythingGameScreenState();
}

class _LearnEverythingGameScreenState extends State<LearnEverythingGameScreen> with TickerProviderStateMixin {
  final SoundService _soundService = SoundService();
  late ConfettiController _confettiController;
  
  List<LearnItem> _remainingItems = [];
  List<LearnItem> _displayedItems = [];
  LearnItem? _currentItem;
  
  int _score = 0;
  int _mistakes = 0;
  bool _showHint = false;
  bool _isGameOver = false;
  bool _isShaking = false;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _remainingItems = List.from(widget.category.items)..shuffle();
    _startNextRound();
  }

  void _startNextRound() {
    if (_remainingItems.isEmpty) {
      _finishGame();
      return;
    }

    setState(() {
      _currentItem = _remainingItems.removeLast();
      // Show 4 options: current item + 3 random ones from the category
      final otherItems = widget.category.items
          .where((item) => item.id != _currentItem!.id)
          .toList()
        ..shuffle();
      
      _displayedItems = [_currentItem!, ...otherItems.take(3)]..shuffle();
      _mistakes = 0;
      _showHint = false;
      _isSuccess = false;
    });
  }

  void _handleDrop(LearnItem item) {
    if (_isSuccess) return; // Prevent multiple drops
    
    if (item.id == _currentItem!.id) {
      _onCorrect();
    } else {
      _onWrong();
    }
  }

  void _onCorrect() {
    _soundService.playSuccess();
    setState(() {
      _score++;
      _isSuccess = true;
    });
    
    _confettiController.play();
    
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _startNextRound();
      }
    });
  }

  void _onWrong() {
    _soundService.playError();
    setState(() {
      _isShaking = true;
      _mistakes++;
      if (_mistakes >= 3) {
        _showHint = true;
      }
    });
    
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isShaking = false;
        });
      }
    });
  }

  void _finishGame() {
    setState(() {
      _isGameOver = true;
    });
    
    final stars = _calculateStars();
    context.read<ScoreService>().saveHighScore('LearnEverything', widget.category.name, stars);
    context.read<ScoreService>().addStars(stars * 10);
  }

  int _calculateStars() {
    if (_score == widget.category.items.length) return 3;
    if (_score >= widget.category.items.length * 0.7) return 2;
    return 1;
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isGameOver) {
      return _buildResultView();
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.getBackground(context),
          image: DecorationImage(
            image: AssetImage(widget.category.backgroundPath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.4),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Center(
                  child: _buildObjectArea(),
                ),
              ),
              _buildLabelArea(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.close_rounded, color: Colors.white),
            style: IconButton.styleFrom(backgroundColor: Colors.white24),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Item ${_score + 1}/${widget.category.items.length}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
          ),
        ],
      ),
    );
  }

  Widget _buildObjectArea() {
    if (_currentItem == null) return const SizedBox();

    Widget dragTarget = DragTarget<LearnItem>(
      onWillAcceptWithDetails: (details) => true,
      onAcceptWithDetails: (details) => _handleDrop(details.data),
      builder: (context, candidateData, rejectedData) {
        final isHighlighted = candidateData.isNotEmpty || _showHint;
        
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            color: _isSuccess 
                ? Colors.green.withValues(alpha: 0.3) 
                : (isHighlighted ? Colors.white30 : Colors.white10),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: _isSuccess 
                  ? Colors.green 
                  : (isHighlighted ? Colors.white70 : Colors.white24),
              width: 6,
              style: BorderStyle.solid,
            ),
            boxShadow: _showHint ? [
              BoxShadow(
                color: Colors.yellow.withValues(alpha: 0.5),
                blurRadius: 30,
                spreadRadius: 10,
              )
            ] : null,
          ),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Show actual image or fallback
              ClipRRect(
                borderRadius: BorderRadius.circular(34),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Image.asset(
                    _currentItem!.imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback if image not found
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.category.icon, style: const TextStyle(fontSize: 80)),
                          const SizedBox(height: 16),
                          Text(
                            _currentItem!.name,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              
              if (_isSuccess)
                Center(
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.greenAccent,
                    size: 120,
                  ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
                ),
              
              if (_showHint && !_isSuccess)
                Animate(
                  effects: [
                    const ShimmerEffect(duration: Duration(seconds: 1)),
                  ],
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.yellow, width: 4),
                    ),
                    width: 200,
                    height: 200,
                  ),
                ),
              
              if (!_isSuccess)
                Positioned(
                  bottom: -50,
                  child: Text(
                    'Drop the label here!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      shadows: [
                        Shadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 4, offset: const Offset(0, 2)),
                      ]
                    ),
                  ).animate(onPlay: (controller) => controller.repeat(reverse: true)).moveY(begin: -5, end: 5, duration: 1.seconds),
                ),
            ],
          ),
        );
      },
    );

    if (_isShaking) {
      dragTarget = dragTarget.animate().shake(hz: 8, duration: 400.ms);
    }
    
    if (_isSuccess) {
      dragTarget = dragTarget.animate().scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 200.ms).then().scale(begin: const Offset(1.1, 1.1), end: const Offset(1, 1), duration: 200.ms);
    }

    return dragTarget;
  }

  Widget _buildLabelArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Match the correct name',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: _displayedItems.map((item) {
              return Draggable<LearnItem>(
                data: item,
                feedback: _buildLabel(item, isFeedback: true),
                childWhenDragging: Opacity(
                  opacity: 0.3,
                  child: _buildLabel(item),
                ),
                child: _buildLabel(item),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.5, end: 0);
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLabel(LearnItem item, {bool isFeedback = false}) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isFeedback 
                ? [AppColors.secondary, AppColors.secondary.withValues(alpha: 0.8)]
                : [Colors.white, Colors.white.withValues(alpha: 0.9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isFeedback ? Colors.white : AppColors.primary.withValues(alpha: 0.2),
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isFeedback ? 0.4 : 0.15),
              blurRadius: isFeedback ? 15 : 8,
              offset: Offset(0, isFeedback ? 8 : 4),
            ),
          ],
        ),
        child: Text(
          item.name,
          style: TextStyle(
            color: isFeedback ? Colors.white : AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildResultView() {
    final stars = _calculateStars();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.splashBgStart, AppColors.splashBgEnd],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: true,
                colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
              ),
              const Text(
                'Category Completed!',
                style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900),
              ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.5, end: 0),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Icon(
                    Icons.star_rounded,
                    color: index < stars ? Colors.amber : Colors.white24,
                    size: 80,
                  ).animate(delay: Duration(milliseconds: 400 + (300 * index))).scale(
                    begin: const Offset(0, 0),
                    end: const Offset(1, 1),
                    curve: Curves.elasticOut,
                    duration: 800.ms,
                  );
                }),
              ),
              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.splashBgStart,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 8,
                ),
                child: const Text('Unlock Next Category', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              ).animate(delay: 1500.ms).fadeIn().slideY(begin: 0.5, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}
