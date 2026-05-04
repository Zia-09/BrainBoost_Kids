import 'package:flutter/foundation.dart';
import '../models/match_item.dart';
import '../data/match_data.dart';
import '../services/match_database_service.dart';
import '../services/tts_service.dart';

class MatchProvider extends ChangeNotifier {
  List<MatchItem> _currentRoundItems = [];
  List<MatchItem> _nameCards = [];
  int _score = 0;
  int _currentRound = 1;
  int _wrongAttempts = 0;
  int _correctCount = 0;
  String _currentCategory = "";
  bool _isRoundComplete = false;
  bool _isCategoryComplete = false;
  List<MatchItem> _allCategoryItems = [];
  List<MatchItem> _unseenItems = [];
  List<String> _learnedFacts = [];
  int _bestScore = 0;
  int _learnedCount = 0;
  int _totalItems = 0;

  // Last matched item (for fun fact popup)
  MatchItem? _lastMatchedItem;

  // Getters
  List<MatchItem> get currentRoundItems => _currentRoundItems;
  List<MatchItem> get nameCards => _nameCards;
  int get score => _score;
  int get currentRound => _currentRound;
  int get totalRounds => _currentRound;
  int get wrongAttempts => _wrongAttempts;
  int get correctCount => _correctCount;
  String get currentCategory => _currentCategory;
  bool get isRoundComplete => _isRoundComplete;
  bool get isCategoryComplete => _isCategoryComplete;
  List<String> get learnedFacts => _learnedFacts;
  int get bestScore => _bestScore;
  int get learnedCount => _learnedCount;
  int get totalItems => _totalItems;
  MatchItem? get lastMatchedItem => _lastMatchedItem;

  int get stars => calculateStars(_score, _currentRound * 4 * 10);

  Future<void> startCategory(String category) async {
    _currentCategory = category;
    _allCategoryItems = List<MatchItem>.from(allMatchCategories[category] ?? [])
        .map(
          (e) => MatchItem(
            id: e.id,
            name: e.name,
            urduName: e.urduName,
            emoji: e.emoji,
            category: e.category,
            funFact: e.funFact,
          ),
        )
        .toList();

    _totalItems = _allCategoryItems.length;
    _score = 0;
    _wrongAttempts = 0;
    _correctCount = 0;
    _currentRound = 1;
    _isRoundComplete = false;
    _isCategoryComplete = false;
    _learnedFacts = [];
    _unseenItems = List.from(_allCategoryItems)..shuffle();
    _lastMatchedItem = null;

    _bestScore = await MatchDatabaseService.getBestScore(category);
    _learnedCount = await MatchDatabaseService.getLearnedCount(category);

    loadRound(_currentRound);
  }

  void loadRound(int round) {
    List<MatchItem> roundItems = [];

    // Ensure we have enough items by recycling if necessary
    if (_unseenItems.length < 4) {
      // Add more items from the full pool, but avoid duplicates in the same round if possible
      List<MatchItem> additional = List.from(_allCategoryItems)..shuffle();
      for (var item in additional) {
        if (!_unseenItems.any((e) => e.name == item.name)) {
          _unseenItems.insert(0, item);
        }
        if (_unseenItems.length >= 8) break; // Buffer
      }
    }

    while (roundItems.length < 4 && _unseenItems.isNotEmpty) {
      final item = _unseenItems.removeLast();
      roundItems.add(
        MatchItem(
          id: item.id * 1000 + roundItems.length + (round * 10),
          name: item.name,
          urduName: item.urduName,
          emoji: item.emoji,
          category: item.category,
          funFact: item.funFact,
        ),
      );
    }

    _currentRoundItems = roundItems;
    _nameCards = List<MatchItem>.from(_currentRoundItems)..shuffle();
    _isRoundComplete = false;
    _lastMatchedItem = null;
    notifyListeners();
  }

  bool checkMatch(int imageId, String droppedName) {
    try {
      final index = _currentRoundItems.indexWhere((e) => e.id == imageId);
      if (index == -1) {
        debugPrint('Error: Image ID $imageId not found in current round items');
        return false;
      }

      final item = _currentRoundItems[index];
      if (item.isMatched) return false;

      if (item.name == droppedName) {
        // Correct match
        item.attempts++;
        item.isMatched = true;

        final pts = _calculatePoints(item.attempts);
        _score += pts;
        _correctCount++;
        _lastMatchedItem = item;

        if (!_learnedFacts.contains(item.funFact)) {
          _learnedFacts.add(item.funFact);
        }

        // Remove matched card from name cards
        _nameCards.removeWhere((e) => e.name == droppedName);

        // Save to DB
        MatchDatabaseService.markLearned(_currentCategory, item.name);

        // TTS
        TtsService.speakName(item.name);

        // Check round complete
        if (_currentRoundItems.every((e) => e.isMatched)) {
          _isRoundComplete = true;

          // In unlimited mode, we don't strictly end the category, but we can track mastery
          if (_correctCount >= _totalItems && !_isCategoryComplete) {
            // Marking as complete once but allowing continuation
            _isCategoryComplete =
                false; // Keep it false to stay in "play" mode, or use it for UI
          }

          MatchDatabaseService.saveScore(
            _currentCategory,
            _currentRound,
            _score,
            calculateStars(_score, _currentRound * 4 * 10),
          );
          TtsService.speakRoundComplete();
        }

        notifyListeners();
        return true;
      } else {
        // Wrong match
        _wrongAttempts++;
        final itemIdx = _currentRoundItems.indexWhere((e) => e.id == imageId);
        if (itemIdx != -1) {
          _currentRoundItems[itemIdx].attempts++;
        } else {
          debugPrint('Error: Could not update attempts for item ID $imageId');
        }
        TtsService.speakWrong();
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('Error in checkMatch: $e');
      return false;
    }
  }

  int _calculatePoints(int attempts) {
    if (attempts <= 1) return 10;
    if (attempts == 2) return 5;
    return 2;
  }

  int calculateStars(int score, int maxScore) {
    if (maxScore == 0) return 1;
    final pct = score / maxScore;
    if (pct >= 0.9) return 3;
    if (pct >= 0.6) return 2;
    return 1;
  }

  Future<void> nextRound() async {
    _currentRound++;
    loadRound(_currentRound);
  }

  void resetCategory() {
    if (_currentCategory.isNotEmpty) {
      startCategory(_currentCategory);
    }
  }

  void clearLastMatched() {
    _lastMatchedItem = null;
    notifyListeners();
  }

  Future<void> refreshStats() async {
    _bestScore = await MatchDatabaseService.getBestScore(_currentCategory);
    _learnedCount = await MatchDatabaseService.getLearnedCount(
      _currentCategory,
    );
    notifyListeners();
  }
}
