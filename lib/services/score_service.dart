import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreService extends ChangeNotifier {
  static final ScoreService _instance = ScoreService._internal();
  factory ScoreService() => _instance;
  ScoreService._internal();

  static const String _highScoreKey = 'high_score';
  static const String _totalStarsKey = 'total_stars';
  static const String _quizzesPlayedKey = 'total_quizzes';
  static const String _unlockedItemsKey = 'unlocked_items';

  int _totalStars = 0;
  int _totalQuizzes = 0;
  List<String> _unlockedItems = [];
  // Cache for all high scores: {subject: {topic: score}}
  final Map<String, Map<String, int>> _topicHighScores = {};
  // Cache for overall subject high scores
  final Map<String, int> _subjectHighScores = {};

  int get totalStars => _totalStars;
  int get totalQuizzes => _totalQuizzes;
  List<String> get unlockedItems => _unlockedItems;

  bool hasItem(String item) => _unlockedItems.contains(item);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _totalStars = prefs.getInt(_totalStarsKey) ?? 0;
    _totalQuizzes = prefs.getInt(_quizzesPlayedKey) ?? 0;
    _unlockedItems = prefs.getStringList(_unlockedItemsKey) ?? [];
    
    // Load all keys to find high scores
    final keys = prefs.getKeys();
    for (String key in keys) {
      if (key.startsWith(_highScoreKey)) {
        final parts = key.split('_');
        if (parts.length == 3) {
          // Subject level: high_score_Subject
          final subject = parts[2];
          _subjectHighScores[subject] = prefs.getInt(key) ?? 0;
        } else if (parts.length == 4) {
          // Topic level: high_score_Subject_Topic
          final subject = parts[2];
          final topic = parts[3];
          _topicHighScores.putIfAbsent(subject, () => {})[topic] = prefs.getInt(key) ?? 0;
        }
      }
    }
    notifyListeners();
  }

  // Save High Score (Topic-specific and Subject-level)
  Future<void> saveHighScore(String subject, String topic, int score) async {
    final prefs = await SharedPreferences.getInstance();
    
    // 1. Save Topic-specific High Score
    final topicKey = '${_highScoreKey}_${subject}_$topic';
    final currentTopicHighScore = _topicHighScores[subject]?[topic] ?? 0;
    
    if (score > currentTopicHighScore) {
      await prefs.setInt(topicKey, score);
      _topicHighScores.putIfAbsent(subject, () => {})[topic] = score;
    }

    // 2. Save Subject-level High Score (Overall best in subject)
    final subjectKey = '${_highScoreKey}_$subject';
    final currentSubjectHighScore = _subjectHighScores[subject] ?? 0;
    if (score > currentSubjectHighScore) {
      await prefs.setInt(subjectKey, score);
      _subjectHighScores[subject] = score;
    }
    
    notifyListeners();
  }

  // Get High Score for a specific topic (Synchronous)
  int getHighScore(String subject, String topic) {
    return _topicHighScores[subject]?[topic] ?? 0;
  }

  // Get Overall High Score for a subject (Synchronous)
  int getSubjectHighScore(String subject) {
    return _subjectHighScores[subject] ?? 0;
  }

  // Save Stars
  Future<void> addStars(int stars) async {
    final prefs = await SharedPreferences.getInstance();
    _totalStars += stars;
    await prefs.setInt(_totalStarsKey, _totalStars);
    notifyListeners();
  }

  // Increment total quizzes played
  Future<void> incrementQuizzesPlayed() async {
    final prefs = await SharedPreferences.getInstance();
    _totalQuizzes += 1;
    await prefs.setInt(_quizzesPlayedKey, _totalQuizzes);
    notifyListeners();
  }

  // Spend Stars
  Future<bool> spendStars(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    if (_totalStars >= amount) {
      _totalStars -= amount;
      await prefs.setInt(_totalStarsKey, _totalStars);
      notifyListeners();
      return true;
    }
    return false;
  }

  // Unlock Item
  Future<void> unlockItem(String item) async {
    final prefs = await SharedPreferences.getInstance();
    if (!_unlockedItems.contains(item)) {
      _unlockedItems.add(item);
      await prefs.setStringList(_unlockedItemsKey, _unlockedItems);
      notifyListeners();
    }
  }

  // Remove Item (Consume)
  Future<void> removeItem(String item) async {
    final prefs = await SharedPreferences.getInstance();
    if (_unlockedItems.contains(item)) {
      _unlockedItems.remove(item);
      await prefs.setStringList(_unlockedItemsKey, _unlockedItems);
      notifyListeners();
    }
  }

  // Clear all scores and stars
  Future<void> clearAllScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _totalStars = 0;
    _totalQuizzes = 0;
    _topicHighScores.clear();
    _subjectHighScores.clear();
    notifyListeners();
  }
}

