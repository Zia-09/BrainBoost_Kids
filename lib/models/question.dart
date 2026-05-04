class Question {
  final String text;
  final List<String> options; // always exactly 4
  final int correctOptionIndex;
  final String topic;
  final String difficulty; // "Easy" / "Medium" / "Hard"
  final String subject;    // "Math" / "Science" / "English" / "GK"

  const Question({
    required this.text,
    required this.options,
    required this.correctOptionIndex,
    required this.topic,
    required this.difficulty,
    required this.subject,
  });
}
