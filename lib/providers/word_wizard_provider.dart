import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/word_item.dart';
import '../data/word_wizard_data.dart';
import '../services/tts_service.dart';

class WordWizardProvider extends ChangeNotifier {
  WordItem? currentWord;
  List<WordItem> roundWords = [];
  int currentWordIndex = 0;
  Map<int, String?> filledLetters = {};
  Map<int, bool> letterCorrectness = {};
  List<String> availableLetters = [];
  int score = 0;
  int totalScore = 0;
  int globalScore = 0; // NEVER resets — saves to shared_preferences
  int wrongAttempts = 0;
  int currentStreak = 0;
  int bestStreak = 0;
  int globalStreak = 0; // NEVER resets — lifetime streak
  int currentRound = 1; // increments forever
  int prestigeLevel = 0; // increments after all categories done
  bool isWordComplete = false;
  bool isRoundComplete = false;
  GameMode currentMode = GameMode.normal;
  String currentCategory = "";
  String currentDifficulty = "";
  int hintsUsed = 0;
  List<String> mcqOptions = [];

  WordWizardProvider() {
    loadGlobalData();
  }

  // UNLIMITED round starter — never dead ends
  void startRound({
    required String category,
    required String difficulty,
    required GameMode mode,
    int round = 1,
  }) {
    currentMode = mode;
    currentCategory = category;
    currentDifficulty = difficulty;
    currentRound = round;

    switch (mode) {
      case GameMode.normal:
        // Uses recycler — round 1,2,3,4,5+ all different!
        roundWords = getRecycledRound(
          category: category,
          difficulty: difficulty,
          roundNumber: round,
        );
        break;
      case GameMode.endless:
        // Infinite — new mix every call
        roundWords = generateEndlessRound(count: 10, roundNumber: round);
        break;
      case GameMode.daily:
        // Auto fresh every day
        roundWords = getDailyChallenge();
        break;
      case GameMode.prestige:
        // Infinite prestige levels
        roundWords = generatePrestigeRound(
          prestigeLevel: prestigeLevel,
          count: 10,
        );
        break;
      case GameMode.mcq:
        // Quiz mode — pulls from all categories
        roundWords = generateEndlessRound(count: 10, roundNumber: round);
        break;
    }

    currentWordIndex = 0;
    score = 0;
    wrongAttempts = 0;
    isRoundComplete = false;
    if (roundWords.isNotEmpty) {
      loadWord(roundWords[0]);
    }
    notifyListeners();
  }

  void loadWord(WordItem word) {
    currentWord = word;
    filledLetters = {};
    letterCorrectness = {};
    hintsUsed = 0;
    if (currentMode == GameMode.mcq) {
      mcqOptions = _generateMcqOptions(word).toList();
      // Shuffle options to randomize position
      mcqOptions.shuffle();
    } else {
      // Generate letter options: correct + confusable wrongs
      availableLetters = _generateLetterOptions(word);
    }
    notifyListeners();
  }

  List<String> _generateMcqOptions(WordItem word) {
    try {
      String correctAnswer = word.word.toUpperCase().trim();
      Set<String> options = {correctAnswer};
      List<WordItem> allWords = [];

      // Collect all words from all categories
      allWordCategories.forEach((_, words) {
        for (var w in words) {
          if (w.word.isNotEmpty) {
            allWords.add(w);
          }
        }
      });

      if (allWords.isEmpty) {
        debugPrint('Warning: No words available in allWordCategories');
        // Fallback: return 4 copies of correct answer with variations
        return [
          correctAnswer,
          '${correctAnswer}_2',
          '${correctAnswer}_3',
          '${correctAnswer}_4',
        ];
      }

      // Shuffle to get random words
      allWords.shuffle(Random());

      // Add unique words as wrong options
      for (var w in allWords) {
        if (options.length >= 4) break;
        String candidate = w.word.toUpperCase().trim();
        if (candidate != correctAnswer && candidate.isNotEmpty) {
          options.add(candidate);
        }
      }

      // If we still don't have 4 options, generate plausible fake words
      if (options.length < 4) {
        debugPrint(
          'Warning: Only ${options.length} unique options found. Adding generated words.',
        );
        List<String> alternativeWords = [];

        // Generate plausible alternatives based on word structure
        for (var w in allWords) {
          String candidate = w.word.toUpperCase().trim();
          if (candidate != correctAnswer && candidate.isNotEmpty) {
            alternativeWords.add(candidate);
          }
        }

        alternativeWords.shuffle(Random());
        int needed = 4 - options.length;
        for (int i = 0; i < needed && i < alternativeWords.length; i++) {
          options.add(alternativeWords[i]);
        }
      }

      // Final safety: ensure exactly 4 options
      List<String> finalOptions = options.toList();
      while (finalOptions.length < 4) {
        // Generate synthetic options by appending a suffix
        finalOptions.add('WORD_${finalOptions.length}');
      }

      // Shuffle to randomize position of correct answer
      finalOptions.shuffle(Random());

      debugPrint(
        'MCQ Options generated: $finalOptions (correct: $correctAnswer)',
      );
      return finalOptions.take(4).toList();
    } catch (e) {
      debugPrint('CRITICAL ERROR in _generateMcqOptions: $e');
      // Absolute fallback - ensure we return exactly 4 items
      String correctAnswer = word.word.toUpperCase().trim();
      return [correctAnswer, 'OPTION_B', 'OPTION_C', 'OPTION_D']
        ..shuffle(Random());
    }
  }

  List<String> _generateLetterOptions(WordItem word) {
    Set<String> letters = {};
    for (int i in word.missingIndexes) {
      if (i < word.word.length) {
        String correct = word.word[i];
        letters.add(correct);
        letters.addAll(getWrongLetters(correct));
      }
    }

    // Add some random letters if we don't have enough
    const allAlphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    final random = Random();
    while (letters.length < 6) {
      letters.add(allAlphabet[random.nextInt(allAlphabet.length)]);
    }

    List<String> result = letters.toList()..shuffle();
    return result.take(6).toList(); // max 6 letter options shown
  }

  DropResult dropLetter(String letter, int boxIndex) {
    if (currentWord == null) {
      debugPrint('Error: currentWord is null in dropLetter');
      return DropResult.wrong;
    }

    if (filledLetters[boxIndex] != null) return DropResult.alreadyFilled;

    if (boxIndex >= currentWord!.word.length) {
      debugPrint(
        'Error: boxIndex $boxIndex out of bounds for word ${currentWord!.word}',
      );
      return DropResult.wrong;
    }

    String correct = currentWord!.word[boxIndex].toUpperCase();
    if (letter.toUpperCase() == correct) {
      filledLetters[boxIndex] = letter;
      letterCorrectness[boxIndex] = true;

      // Check if there are other boxes needing this letter
      bool stillNeeded = false;
      for (int i in currentWord!.missingIndexes) {
        if (filledLetters[i] == null &&
            currentWord!.word[i].toUpperCase() == letter.toUpperCase()) {
          stillNeeded = true;
          break;
        }
      }
      if (!stillNeeded) {
        availableLetters.remove(letter);
      }

      currentStreak++;
      globalStreak++;
      if (currentStreak > bestStreak) bestStreak = currentStreak;
      _saveGlobalStreak();

      bool complete = _checkWordComplete();
      if (complete) {
        int wordScore = _calculateWordScore();
        score += wordScore;
        totalScore += wordScore;
        globalScore += wordScore;
        _saveGlobalScore();
        isWordComplete = true;
        TtsService.speakName(currentWord!.word);
        Future.delayed(const Duration(milliseconds: 1200), () {
          TtsService.speakFact(currentWord!.funFact);
        });
      }
      notifyListeners();
      return DropResult.correct;
    } else {
      // Wrong — flash red then reset
      letterCorrectness[boxIndex] = false;
      wrongAttempts++;
      currentStreak = 0; // streak breaks on wrong
      notifyListeners();
      Future.delayed(const Duration(milliseconds: 800), () {
        letterCorrectness.remove(boxIndex);
        notifyListeners();
      });
      return DropResult.wrong;
    }
  }

  bool checkMcqAnswer(String selectedWord) {
    try {
      if (currentWord == null) {
        debugPrint('ERROR: currentWord is null when checking MCQ answer');
        return false;
      }

      final selectedUpper = selectedWord.toUpperCase().trim();
      final correctUpper = currentWord!.word.toUpperCase().trim();

      if (selectedUpper.isEmpty) {
        debugPrint('ERROR: selectedWord is empty');
        return false;
      }

      if (selectedUpper == correctUpper) {
        debugPrint('✓ MCQ CORRECT: $selectedUpper == $correctUpper');

        int wordScore = _calculateWordScore();
        score += wordScore;
        totalScore += wordScore;
        globalScore += wordScore;
        currentStreak++;
        globalStreak++;
        if (currentStreak > bestStreak) bestStreak = currentStreak;
        _saveGlobalScore();
        _saveGlobalStreak();

        isWordComplete = true;
        TtsService.speakName(currentWord!.word);
        Future.delayed(const Duration(milliseconds: 1200), () {
          TtsService.speakFact(currentWord!.funFact);
        });
        notifyListeners();
        return true;
      } else {
        debugPrint('✗ MCQ WRONG: $selectedUpper != $correctUpper');
        wrongAttempts++;
        currentStreak = 0;
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('CRITICAL ERROR in checkMcqAnswer: $e');
      return false;
    }
  }

  bool _checkWordComplete() {
    if (currentWord == null) return false;
    for (int i in currentWord!.missingIndexes) {
      if (filledLetters[i] == null) return false;
    }
    return true;
  }

  int _calculateWordScore() {
    if (wrongAttempts == 0) return 30;
    if (wrongAttempts == 1) return 20;
    if (wrongAttempts == 2) return 10;
    return 5;
  }

  // UNLIMITED next word — never a dead end
  void nextWord() {
    try {
      currentWordIndex++;
      wrongAttempts = 0;
      isWordComplete = false;
      debugPrint(
        'nextWord: currentWordIndex=$currentWordIndex, roundWords.length=${roundWords.length}',
      );
      if (currentWordIndex >= roundWords.length) {
        // Round complete — but DON'T stop. Start next round automatically!
        debugPrint('Round Complete! Showing results...');
        isRoundComplete = true;
        notifyListeners();
        // Auto-start next round after result screen
        // Round number keeps incrementing forever → getRecycledRound handles it
      } else {
        if (currentWordIndex < roundWords.length) {
          loadWord(roundWords[currentWordIndex]);
        } else {
          debugPrint('ERROR: currentWordIndex out of bounds');
          isRoundComplete = true;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('ERROR in nextWord: $e');
      isRoundComplete = true;
      notifyListeners();
    }
  }

  // Called from result screen "Play More" button
  // Starts next round — never ends
  void continueToNextRound() {
    String nextDifficulty = currentDifficulty;

    // Auto-advance difficulty every 2 rounds if not already Expert
    if (currentRound % 2 == 0) {
      if (currentDifficulty == "Easy") {
        nextDifficulty = "Medium";
      } else if (currentDifficulty == "Medium") {
        nextDifficulty = "Hard";
      } else if (currentDifficulty == "Hard") {
        nextDifficulty = "Expert";
      }
    }

    startRound(
      category: currentCategory,
      difficulty: nextDifficulty,
      mode: currentMode,
      round: currentRound + 1, // always +1 → recycler handles variety
    );
  }

  // Hint system
  void useHint() {
    if (currentWord == null || isWordComplete) return;

    // Find first missing index that isn't filled
    int? nextIndex;
    for (int i in currentWord!.missingIndexes) {
      if (filledLetters[i] == null) {
        nextIndex = i;
        break;
      }
    }

    if (nextIndex != null) {
      if (hintsUsed > 0) {
        score = (score - 5).clamp(0, 999999);
      }
      hintsUsed++;

      // Auto-fill the correct letter for them? Or just highlight?
      // Let's just highlight it for now by shaking the correct letter in options?
      // Or actually fill it to make it easier for kids.
      String correct = currentWord!.word[nextIndex].toUpperCase();
      dropLetter(correct, nextIndex);
    }
    notifyListeners();
  }

  // Global score/streak persistence (never resets)
  Future<void> _saveGlobalScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('ww_global_score', globalScore);
  }

  Future<void> _saveGlobalStreak() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('ww_best_streak', bestStreak);
    await prefs.setInt('ww_global_streak', globalStreak);
  }

  Future<void> loadGlobalData() async {
    final prefs = await SharedPreferences.getInstance();
    globalScore = prefs.getInt('ww_global_score') ?? 0;
    bestStreak = prefs.getInt('ww_best_streak') ?? 0;
    globalStreak = prefs.getInt('ww_global_streak') ?? 0;
    notifyListeners();
  }
}
