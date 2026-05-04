class WordItem {
  final int id;
  final String word;
  final String imagePath;
  final String category;
  final String urduName;
  final String hint;
  final String funFact;
  final String difficulty;
  final List<int> missingIndexes;
  bool isCompleted;
  int attempts;

  WordItem({
    required this.id,
    required this.word,
    required this.imagePath,
    required this.category,
    required this.urduName,
    required this.hint,
    required this.funFact,
    required this.difficulty,
    required this.missingIndexes,
    this.isCompleted = false,
    this.attempts = 0,
  });

  String get displayWord {
    List<String> letters = word.split('');
    for (int i in missingIndexes) {
      if (i < letters.length) {
        letters[i] = '_';
      }
    }
    return letters.join('');
  }

  List<String> get missingLetters =>
      missingIndexes.map((i) => word[i]).toList();
}

// Game modes enum
enum GameMode {
  normal,      // category + difficulty
  endless,     // all categories mixed forever
  daily,       // todays challenge
  prestige,    // ultra hard mixed mode
  mcq,         // multiple choice mode
}

// Drop result enum
enum DropResult { correct, wrong, alreadyFilled }
