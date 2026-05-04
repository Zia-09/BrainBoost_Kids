class QuizResult {
  final int score;
  final int correctAnswers;
  final int wrongAnswers;
  final int bestStreak;

  QuizResult({
    required this.score,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.bestStreak,
  });
}
