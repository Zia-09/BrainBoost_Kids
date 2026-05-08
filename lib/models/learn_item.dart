class LearnItem {
  final String id;
  final String name;
  final String category;
  final String imagePath;
  final String description;

  const LearnItem({
    required this.id,
    required this.name,
    required this.category,
    required this.imagePath,
    this.description = '',
  });

  factory LearnItem.fromJson(Map<String, dynamic> json) {
    return LearnItem(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      imagePath: json['imagePath'],
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'imagePath': imagePath,
      'description': description,
    };
  }
}

class LearnCategory {
  final String name;
  final String icon;
  final List<LearnItem> items;
  final String backgroundPath;
  final bool isLocked;
  final int starsEarned;

  const LearnCategory({
    required this.name,
    required this.icon,
    required this.items,
    required this.backgroundPath,
    this.isLocked = true,
    this.starsEarned = 0,
  });
}
