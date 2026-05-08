class LearnSpeakSentence {
  final String id;
  final String english;
  final String urdu;
  final String romanUrdu;

  const LearnSpeakSentence({
    required this.id,
    required this.english,
    required this.urdu,
    required this.romanUrdu,
  });
}

class LearnSpeakCategory {
  final String id;
  final String title;
  final String iconEmoji;
  final List<LearnSpeakSentence> sentences;

  const LearnSpeakCategory({
    required this.id,
    required this.title,
    required this.iconEmoji,
    required this.sentences,
  });
}
