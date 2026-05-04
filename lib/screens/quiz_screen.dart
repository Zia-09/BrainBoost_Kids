import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../models/question.dart';
import '../models/quiz_result.dart';
import '../services/sound_service.dart';
import '../services/score_service.dart';

import '../data/gk_questions.dart';
import '../data/english_questions.dart';
import '../data/science_questions.dart';
import '../data/colors_questions.dart';
import '../data/human_body_questions.dart';
import '../data/animals_questions.dart';
import '../data/space_questions.dart';
import '../data/nutrition_questions.dart';
import '../data/geography_questions.dart';
import '../data/dinosaurs_questions.dart';
import '../data/technology_questions.dart';
import '../utils/math_generator.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class QuizScreen extends StatefulWidget {
  final String subject;
  final String topic;
  final Color topicColor;
  final String difficulty;
  final int timeLimit;
  final bool isChallengeMode;

  const QuizScreen({
    super.key,
    required this.subject,
    required this.topic,
    required this.topicColor,
    this.difficulty = 'Medium',
    this.timeLimit = 10,
    this.isChallengeMode = false,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late int _timeLeft;
  int _hearts = 3;
  int _score = 0;
  int _correctAnswers = 0;
  int _wrongAnswers = 0;
  int _currentStreak = 0;
  int _bestStreak = 0;

  bool _isAnswered = false;
  int? _selectedOptionIndex;

  // Power-up states
  int _timeFreezeQuestions = 0;
  bool _hasShield = false;
  List<int> _hiddenOptionIndices = [];

  late List<Question> _questions;
  late Question _currentQuestion;
  Timer? _timer;
  late AnimationController _feedbackAnim;
  late Animation<double> _shakeAnim;
  late Animation<double> _scaleAnim;
  final SoundService _soundService = SoundService();

  // 4-color scheme for option buttons
  static const _optionColors = [
    Color(0xFF4F8EF7), // blue
    Color(0xFFFF5C8D), // pink/red
    Color(0xFFFFB347), // orange
    Color(0xFF4ECDC4), // teal/cyan
  ];

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.timeLimit;

    _feedbackAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _shakeAnim = TweenSequence<double>([
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0, end: 10.0), weight: 1),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 10.0, end: -10.0), weight: 2),
      TweenSequenceItem<double>(tween: Tween<double>(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 10.0, end: 0.0), weight: 1),
    ]).animate(_feedbackAnim);

    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.0, end: 1.2), weight: 1),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.2, end: 1.0), weight: 1),
    ]).animate(_feedbackAnim);

    _loadQuestions();
    _startTimer();
    _soundService.playBGM();
  }

  void _loadQuestions() {
    if (widget.subject == 'Math') {
      _questions = MathGenerator.generateQuestions(
        topic: widget.topic,
        difficulty: widget.difficulty,
        count: 10,
      );
    } else {
      List<Question> pool;
      switch (widget.subject) {
        case 'English':
          pool = englishQuestions;
          break;
        case 'Science':
          pool = scienceQuestions;
          break;
        case 'Colors':
          pool = colorsQuestions;
          break;
        case 'Human Body':
          pool = humanBodyQuestions;
          break;
        case 'Animals':
          pool = animalsQuestions;
          break;
        case 'Space':
          pool = spaceQuestions;
          break;
        case 'Nutrition':
          pool = nutritionQuestions;
          break;
        case 'Geography':
          pool = geographyQuestions;
          break;
        case 'Dinosaurs':
          pool = dinosaursQuestions;
          break;
        case 'Technology':
          pool = technologyQuestions;
          break;
        default:
          pool = gkQuestions;
      }
      
      // Filter by topic and difficulty
      var filtered = pool.where((q) => 
        q.topic == widget.topic && q.difficulty == widget.difficulty
      ).toList();
      
      if (filtered.isEmpty) {
        // Fallback to just topic if difficulty not found
        filtered = pool.where((q) => q.topic == widget.topic).toList();
      }
      
      if (filtered.isEmpty) {
        // Fallback to all for subject
        filtered = pool;
      }

      _questions = List.from(filtered)..shuffle();
      if (_questions.length > 10) _questions = _questions.sublist(0, 10);
    }
    
    if (_questions.isEmpty) {
      // Emergency fallback to avoid crash
      _questions = [
        Question(
          text: "Placeholder question for ${widget.topic}",
          options: ["A", "B", "C", "D"],
          correctOptionIndex: 0,
          topic: widget.topic,
          difficulty: widget.difficulty,
          subject: widget.subject,
        )
      ];
    }
    
    _currentQuestion = _questions[_currentIndex];
  }

  void _startTimer() {
    _timeLeft = widget.timeLimit;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_timeFreezeQuestions > 0) {
        return; // Time is frozen
      }
      if (_timeLeft > 0) {
        if (mounted) setState(() => _timeLeft--);
      } else {
        t.cancel();
        if (mounted) _onTimeUp();
      }
    });
  }

  void _onTimeUp() {
    _handleWrongAnswer();
    if (mounted) setState(() => _isAnswered = true);
    _moveToNextQuestion();
  }

  void _onOptionSelected(int index) {
    if (_isAnswered) return;
    _timer?.cancel();
    
    final bool isCorrect = index == _currentQuestion.correctOptionIndex;

    if (mounted) {
      setState(() {
        _isAnswered = true;
        _selectedOptionIndex = index;
        
        if (isCorrect) {
          int baseScore = 10 + _timeLeft;
          if (widget.isChallengeMode) baseScore *= 2; // Double points in challenge mode
          _score += baseScore;
          _correctAnswers++;
          _currentStreak++;
          if (_currentStreak > _bestStreak) _bestStreak = _currentStreak;
        } else {
          _wrongAnswers++;
          if (_hasShield) {
            _hasShield = false;
            _showPowerUpSnackbar('Shield protected your streak & heart!', const Color(0xFF29B6F6));
          } else {
            _currentStreak = 0;
            if (_hearts > 0) _hearts--;
          }
        }
      });
    }

    if (isCorrect) {
      _soundService.playCorrectSound();
      _feedbackAnim.forward(from: 0);
    } else {
      _soundService.playWrongSound();
      _feedbackAnim.forward(from: 0);
      if (_hearts == 0) _finishQuiz();
    }
    _moveToNextQuestion();
  }

  void _handleWrongAnswer() {
    _soundService.playWrongSound();
    if (mounted) {
      setState(() {
        _wrongAnswers++;
        if (_hasShield) {
          _hasShield = false;
          _showPowerUpSnackbar('Shield protected your streak & heart!', const Color(0xFF29B6F6));
        } else {
          _currentStreak = 0;
          if (_hearts > 0) _hearts--;
        }
      });
    }
    if (_hearts == 0) _finishQuiz();
  }

  void _moveToNextQuestion() {
    if (_hearts == 0) return;
    
    if (_timeFreezeQuestions > 0) {
      _timeFreezeQuestions--;
    }

    // Check if we are at the last question before delaying
    if (_currentIndex >= _questions.length - 1) {
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (mounted) _finishQuiz();
      });
      return;
    }

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      
      setState(() {
        _currentIndex++;
        // Safe check to avoid index out of bounds
        if (_currentIndex < _questions.length) {
          _currentQuestion = _questions[_currentIndex];
        }
        _isAnswered = false;
        _selectedOptionIndex = null;
        _hiddenOptionIndices = [];
      });
      
      _startTimer();
    });
  }

  void _finishQuiz() async {
    _timer?.cancel();
    if (!mounted) return;
    
    // Save quiz completion to ScoreService
    final scoreService = ScoreService();
    await scoreService.incrementQuizzesPlayed();
    
    if (!mounted) return;
    context.pushReplacement('/result', extra: {
      'subject': widget.subject,
      'topic': widget.topic,
      'difficulty': widget.difficulty,
      'topicColor': widget.topicColor,
      'isChallengeMode': widget.isChallengeMode,
      'result': QuizResult(
        score: _score,
        correctAnswers: _correctAnswers,
        wrongAnswers: _wrongAnswers,
        bestStreak: _bestStreak,
      ),
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _feedbackAnim.dispose();
    super.dispose();
  }

  Color _getOptionColor(int index) {
    final base = _optionColors[index];
    if (!_isAnswered) return base;
    if (index == _currentQuestion.correctOptionIndex) return const Color(0xFF34C759);
    if (index == _selectedOptionIndex) return const Color(0xFFFF3B30);
    return base.withValues(alpha: 0.35);
  }

  IconData _getSubjectIcon() {
    switch (widget.subject) {
      case 'Math': return Icons.calculate_rounded;
      case 'English': return Icons.menu_book_rounded;
      case 'Science': return Icons.science_rounded;
      case 'Colors': return Icons.palette_rounded;
      case 'Shapes': return Icons.category_rounded;
      case 'Time': return Icons.access_time_filled_rounded;
      case 'Animals': return Icons.pets_rounded;
      case 'Money': return Icons.payments_rounded;
      case 'Fruits': return Icons.egg_rounded;
      case 'Urdu': return Icons.translate_rounded;
      case 'Teasers': return Icons.psychology_rounded;
      default: return Icons.public_rounded;
    }
  }

  void _showPowerUpSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _applyClue() {
    List<int> wrongIndices = [];
    for (int i = 0; i < _currentQuestion.options.length; i++) {
      if (i != _currentQuestion.correctOptionIndex) {
        wrongIndices.add(i);
      }
    }
    wrongIndices.shuffle();
    setState(() {
      _hiddenOptionIndices = wrongIndices.take(2).toList();
    });
  }

  Widget _buildPowerUpIcon({
    required IconData icon,
    required Color color,
    required String itemId,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final scoreService = Provider.of<ScoreService>(context, listen: true);
    final hasItem = scoreService.hasItem(itemId);
    
    final displayColor = isActive ? color : (hasItem ? color.withValues(alpha: 0.8) : Colors.grey.shade400);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive ? color.withValues(alpha: 0.2) : AppColors.getCard(context),
          shape: BoxShape.circle,
          border: Border.all(
            color: isActive ? color : (hasItem ? color.withValues(alpha: 0.5) : Colors.grey.shade300),
            width: 2,
          ),
          boxShadow: isActive ? [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 8,
              spreadRadius: 2,
            )
          ] : null,
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Icon(icon, color: displayColor, size: 24),
            if (hasItem && !isActive)
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      body: SafeArea(
        child: Column(
          children: [
            // Top row: back + title + hearts + score
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _timer?.cancel();
                      context.pop();
                    },
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.getCard(context),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back_rounded,
                          size: 18, color: AppColors.splashBgStart),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.topic,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: AppColors.getTextPrimary(context),
                          ),
                        ),
                        Text(
                          '${widget.difficulty} • ${widget.subject}',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.getTextSecondary(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Hearts
                  Row(
                    children: List.generate(3, (i) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Icon(
                          i < _hearts ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: i < _hearts ? const Color(0xFFFF3B30) : Colors.grey.shade300,
                          size: 20,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(width: 8),
                  // Score chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.splashBgStart,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '$_score',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: AppColors.getCard(context),
                        valueColor: AlwaysStoppedAnimation<Color>(widget.topicColor),
                        minHeight: 8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${_currentIndex + 1}/${_questions.length}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Power-Up Bar
            Consumer<ScoreService>(
              builder: (context, scoreService, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPowerUpIcon(
                      icon: Icons.timer_rounded,
                      color: const Color(0xFF00BFA5),
                      itemId: 'power_time_freeze',
                      isActive: _timeFreezeQuestions > 0,
                      onTap: () {
                        if (_timeFreezeQuestions > 0) return;
                        if (scoreService.hasItem('power_time_freeze')) {
                          scoreService.removeItem('power_time_freeze');
                          setState(() {
                            _timeFreezeQuestions = 3;
                          });
                          _showPowerUpSnackbar('Time Freeze Activated! (3 questions)', const Color(0xFF00BFA5));
                        } else {
                          _showPowerUpSnackbar('Buy Time Freeze in the store!', Colors.grey);
                        }
                      },
                    ),
                    const SizedBox(width: 20),
                    _buildPowerUpIcon(
                      icon: Icons.security_rounded,
                      color: const Color(0xFF29B6F6),
                      itemId: 'power_shield',
                      isActive: _hasShield,
                      onTap: () {
                        if (_hasShield) return;
                        if (scoreService.hasItem('power_shield')) {
                          scoreService.removeItem('power_shield');
                          setState(() {
                            _hasShield = true;
                          });
                          _showPowerUpSnackbar('Shield Activated!', const Color(0xFF29B6F6));
                        } else {
                          _showPowerUpSnackbar('Buy Shield in the store!', Colors.grey);
                        }
                      },
                    ),
                    const SizedBox(width: 20),
                    _buildPowerUpIcon(
                      icon: Icons.lightbulb_rounded,
                      color: const Color(0xFFD4AF37),
                      itemId: 'power_clue',
                      isActive: false,
                      onTap: () {
                        if (_hiddenOptionIndices.isNotEmpty || _isAnswered) return;
                        if (scoreService.hasItem('power_clue')) {
                          scoreService.removeItem('power_clue');
                          _applyClue();
                          _showPowerUpSnackbar('Clue Activated!', const Color(0xFFD4AF37));
                        } else {
                          _showPowerUpSnackbar('Buy Clue in the store!', Colors.grey);
                        }
                      },
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 12),

            // Circular timer + question card
            Expanded(
              flex: 5,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // Question card (with top padding for the timer)
                  AnimatedBuilder(
                    animation: _feedbackAnim,
                    builder: (context, child) {
                      final isCorrect = _isAnswered && _selectedOptionIndex == _currentQuestion.correctOptionIndex;
                      final isWrong = _isAnswered && _selectedOptionIndex != null && _selectedOptionIndex != _currentQuestion.correctOptionIndex;
                      
                      return Transform.translate(
                        offset: Offset(isWrong ? _shakeAnim.value : 0, 0),
                        child: Transform.scale(
                          scale: isCorrect ? _scaleAnim.value : 1.0,
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                            decoration: BoxDecoration(
                              color: AppColors.getCard(context),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: _isAnswered 
                                  ? (isCorrect 
                                      ? const Color(0xFF34C759).withValues(alpha: 0.5) 
                                      : const Color(0xFFFF3B30).withValues(alpha: 0.5))
                                  : Colors.transparent,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _isAnswered 
                                    ? (isCorrect ? const Color(0xFF34C759) : const Color(0xFFFF3B30)).withValues(alpha: 0.15)
                                    : Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 60), // space for timer overlap
                                // Subject icon
                                Container(
                                  padding: const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    color: widget.topicColor.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(
                                    _getSubjectIcon(),
                                    size: 52,
                                    color: widget.topicColor,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                  child: Text(
                                    _currentQuestion.text,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.getTextPrimary(context),
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // Circular timer (top center)
                  _buildCircularTimer(),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Options grid (2x2)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildOption(0)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildOption(1)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildOption(2)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildOption(3)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularTimer() {
    final fraction = _timeLeft / widget.timeLimit;
    final bool isFrozen = _timeFreezeQuestions > 0;
    
    final Color timerColor = isFrozen
        ? const Color(0xFF00BFA5) // Ice blue
        : (fraction > 0.5
            ? const Color(0xFF34C759)
            : fraction > 0.25
                ? const Color(0xFFFFB347)
                : const Color(0xFFFF3B30));

    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.getCard(context),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: timerColor.withValues(alpha: 0.3),
                  blurRadius: isFrozen ? 16 : 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
          // Arc painter
          CustomPaint(
            size: const Size(80, 80),
            painter: _TimerArcPainter(fraction: isFrozen ? 1.0 : fraction, color: timerColor),
          ),
          // Time text
          Text(
            isFrozen ? '❄️' : '$_timeLeft',
            style: TextStyle(
              fontSize: isFrozen ? 28 : 22,
              fontWeight: FontWeight.w900,
              color: timerColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(int index) {
    final color = _getOptionColor(index);
    final isCorrect = _isAnswered && index == _currentQuestion.correctOptionIndex;
    final isWrong = _isAnswered &&
        index == _selectedOptionIndex &&
        index != _currentQuestion.correctOptionIndex;

    return Visibility(
      visible: !_hiddenOptionIndices.contains(index),
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: GestureDetector(
        onTap: () => _onOptionSelected(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: _isAnswered
                      ? (isCorrect || isWrong)
                          ? Icon(
                              isCorrect ? Icons.check_rounded : Icons.close_rounded,
                              color: Colors.white,
                              size: 16,
                            )
                          : const Text('')
                      : Text(
                          ['A', 'B', 'C', 'D'][index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _currentQuestion.options[index],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimerArcPainter extends CustomPainter {
  final double fraction;
  final Color color;

  const _TimerArcPainter({required this.fraction, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 5;

    final bgPaint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    // Background arc
    canvas.drawCircle(center, radius, bgPaint);

    // Foreground arc
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * fraction;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_TimerArcPainter old) =>
      old.fraction != fraction || old.color != color;
}
