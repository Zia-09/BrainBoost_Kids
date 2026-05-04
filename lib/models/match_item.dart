class MatchItem {
  final int id;
  final String name;
  final String urduName;
  final String emoji;
  final String category;
  final String funFact;
  bool isMatched;
  int attempts;

  MatchItem({
    required this.id,
    required this.name,
    required this.urduName,
    required this.emoji,
    required this.category,
    required this.funFact,
    this.isMatched = false,
    this.attempts = 0,
  });

  MatchItem copyWith({bool? isMatched, int? attempts}) {
    return MatchItem(
      id: id,
      name: name,
      urduName: urduName,
      emoji: emoji,
      category: category,
      funFact: funFact,
      isMatched: isMatched ?? this.isMatched,
      attempts: attempts ?? this.attempts,
    );
  }
}
