import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../../app_colors.dart';
import '../../models/learn_speak_item.dart';
import '../../services/score_service.dart';
import '../../services/sound_service.dart';
import '../../services/tts_service.dart';
import '../../services/speech_service.dart';

class LearnSpeakGameScreen extends StatefulWidget {
  final LearnSpeakCategory category;

  const LearnSpeakGameScreen({
    super.key,
    required this.category,
  });

  @override
  State<LearnSpeakGameScreen> createState() => _LearnSpeakGameScreenState();
}

class _LearnSpeakGameScreenState extends State<LearnSpeakGameScreen> {
  final SoundService _soundService = SoundService();
  final SpeechService _speechService = SpeechService();
  late ConfettiController _confettiController;
  
  int _currentIndex = 0;
  bool _isQuizTime = false;
  
  // Quiz state
  LearnSpeakSentence? _currentQuizQuestion;
  List<LearnSpeakSentence> _quizOptions = [];
  
  // Game complete state
  bool _isGameComplete = false;
  int _starsEarned = 0;
  int _quizCorrectCount = 0;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _speechService.addListener(_onSpeechStateChanged);
    _speechService.initSpeech();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _speechService.removeListener(_onSpeechStateChanged);
    super.dispose();
  }

  void _onSpeechStateChanged() {
    setState(() {});
  }

  void _listenEnglish() {
    TtsService.speakText(widget.category.sentences[_currentIndex].english, language: 'en-US');
  }

  void _listenUrdu() {
    TtsService.speakText(widget.category.sentences[_currentIndex].urdu, language: 'ur-PK');
  }

  void _startSpeaking() {
    _soundService.playClickSound();
    _speechService.startListening((recognized) {
      // Called when new words are recognized
    });
  }

  void _stopSpeaking() {
    _speechService.stopListening();
    _checkSpokenWords();
  }

  void _checkSpokenWords() {
    String spoken = _speechService.lastWords.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '');
    String target = widget.category.sentences[_currentIndex].english.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '');
    
    if (spoken.isNotEmpty) {
      if (spoken.contains(target) || target.contains(spoken) || _levenshteinDistance(spoken, target) < 3) {
        // Success
        _soundService.playCorrectSound();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Excellent pronunciation!', style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // Retry
        _soundService.playError();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You said: "${_speechService.lastWords}". Try again!'),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  int _levenshteinDistance(String a, String b) {
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;
    List<List<int>> d = List.generate(a.length + 1, (i) => List.filled(b.length + 1, 0), growable: false);
    for (int i = 0; i <= a.length; i++) { d[i][0] = i; }
    for (int j = 0; j <= b.length; j++) { d[0][j] = j; }
    for (int i = 1; i <= a.length; i++) {
      for (int j = 1; j <= b.length; j++) {
        int cost = a[i - 1] == b[j - 1] ? 0 : 1;
        d[i][j] = min(min(d[i - 1][j] + 1, d[i][j - 1] + 1), d[i - 1][j - 1] + cost);
      }
    }
    return d[a.length][b.length];
  }

  void _nextSentence() {
    _soundService.playClickSound();
    
    // Check if it's quiz time (every 5 sentences)
    if ((_currentIndex + 1) % 5 == 0 && !_isQuizTime) {
      _prepareQuiz();
      return;
    }
    
    setState(() {
      _isQuizTime = false;
      if (_currentIndex < widget.category.sentences.length - 1) {
        _currentIndex++;
      } else {
        _finishGame();
      }
    });
  }

  void _prepareQuiz() {
    setState(() {
      _isQuizTime = true;
      _currentQuizQuestion = widget.category.sentences[_currentIndex];
      
      // Generate options
      _quizOptions = [_currentQuizQuestion!];
      final random = Random();
      
      while (_quizOptions.length < 3) {
        final option = widget.category.sentences[random.nextInt(widget.category.sentences.length)];
        if (!_quizOptions.contains(option)) {
          _quizOptions.add(option);
        }
      }
      _quizOptions.shuffle();
    });
  }

  void _checkQuizAnswer(LearnSpeakSentence selectedOption) {
    if (selectedOption.id == _currentQuizQuestion!.id) {
      _soundService.playCorrectSound();
      _quizCorrectCount++;
      
      // Move to next sentence or finish
      setState(() {
        _isQuizTime = false;
        if (_currentIndex < widget.category.sentences.length - 1) {
          _currentIndex++;
        } else {
          _finishGame();
        }
      });
    } else {
      _soundService.playError();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Oops, try again!'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _finishGame() {
    setState(() {
      _isGameComplete = true;
      
      // Calculate stars based on quiz correct count
      int totalQuizzes = (widget.category.sentences.length / 5).floor();
      if (_quizCorrectCount == totalQuizzes) {
        _starsEarned = 3;
      } else if (_quizCorrectCount >= totalQuizzes / 2) {
        _starsEarned = 2;
      } else {
        _starsEarned = 1;
      }
      
      _confettiController.play();
      TtsService.speakWin();
      
      // Save score
      final scoreService = context.read<ScoreService>();
      scoreService.saveHighScore(
        'LearnSpeak',
        widget.category.id,
        _starsEarned,
      );
      scoreService.addStars(_starsEarned);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.splashBgStart, AppColors.splashBgEnd],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  _buildAppBar(),
                  Expanded(
                    child: _isGameComplete
                        ? _buildCompletionScreen()
                        : _isQuizTime
                            ? _buildQuizScreen()
                            : _buildLearningScreen(),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.close_rounded, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white24,
              padding: const EdgeInsets.all(12),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_currentIndex + 1} / ${widget.category.sentences.length}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearningScreen() {
    final sentence = widget.category.sentences[_currentIndex];
    
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.category.iconEmoji,
            style: const TextStyle(fontSize: 80),
          ),
          const SizedBox(height: 32),
          
          // English Container
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  sentence.english,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                IconButton(
                  onPressed: _listenEnglish,
                  icon: const Icon(Icons.volume_up_rounded, size: 32, color: Colors.blue),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.blue.withValues(alpha: 0.1),
                    padding: const EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Urdu Container
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Text(
                  sentence.urdu,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontFamily: 'JameelNoori', // If available, otherwise default
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  sentence.romanUrdu,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 16),
                IconButton(
                  onPressed: _listenUrdu,
                  icon: const Icon(Icons.volume_up_rounded, size: 32, color: Colors.green),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.green.withValues(alpha: 0.1),
                    padding: const EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
          ),
          
          const Spacer(),
          
          // Mic and Next controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onLongPressStart: (_) => _startSpeaking(),
                onLongPressEnd: (_) => _stopSpeaking(),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _speechService.isListening ? Colors.redAccent : Colors.orange,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    _speechService.isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _nextSentence,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 4,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Next', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Hold the mic and say the English sentence',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizScreen() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Mini Quiz Time!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                const Text(
                  'What is the meaning of:',
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
                const SizedBox(height: 8),
                Text(
                  _currentQuizQuestion!.english,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          ..._quizOptions.map((option) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () => _checkQuizAnswer(option),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          option.urdu,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          option.romanUrdu,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildCompletionScreen() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Amazing!',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'You finished the category!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.star_rounded,
                    color: index < _starsEarned ? Colors.amber : Colors.grey.withValues(alpha: 0.2),
                    size: 64,
                  ),
                );
              }),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () => context.pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 4,
              ),
              child: const Text(
                'Continue',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
