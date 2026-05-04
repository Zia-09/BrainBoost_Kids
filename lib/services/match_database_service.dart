import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MatchDatabaseService {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'brainboost_match.db');
    return openDatabase(path, version: 1, onCreate: _createDB);
  }

  static Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE match_progress (
        id          INTEGER PRIMARY KEY,
        category    TEXT NOT NULL,
        item_name   TEXT NOT NULL,
        is_learned  INTEGER DEFAULT 0,
        attempts    INTEGER DEFAULT 0,
        last_played TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE category_scores (
        id           INTEGER PRIMARY KEY AUTOINCREMENT,
        category     TEXT NOT NULL,
        round        INTEGER NOT NULL,
        score        INTEGER DEFAULT 0,
        stars        INTEGER DEFAULT 0,
        completed_at TEXT
      )
    ''');
  }

  static Future<void> markLearned(String category, String itemName) async {
    try {
      final db = await database;
      await db.insert(
        'match_progress',
        {
          'category': category,
          'item_name': itemName,
          'is_learned': 1,
          'last_played': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (_) {}
  }

  static Future<int> getLearnedCount(String category) async {
    try {
      final db = await database;
      final result = await db.query(
        'match_progress',
        where: 'category = ? AND is_learned = 1',
        whereArgs: [category],
      );
      return result.length;
    } catch (_) {
      return 0;
    }
  }

  static Future<void> saveScore(
      String category, int round, int score, int stars) async {
    try {
      final db = await database;
      await db.insert('category_scores', {
        'category': category,
        'round': round,
        'score': score,
        'stars': stars,
        'completed_at': DateTime.now().toIso8601String(),
      });
    } catch (_) {}
  }

  static Future<int> getBestScore(String category) async {
    try {
      final db = await database;
      final result = await db.rawQuery(
        'SELECT MAX(score) as best FROM category_scores WHERE category = ?',
        [category],
      );
      return result.first['best'] as int? ?? 0;
    } catch (_) {
      return 0;
    }
  }

  static Future<void> resetAll() async {
    try {
      final db = await database;
      await db.delete('match_progress');
      await db.delete('category_scores');
    } catch (_) {}
  }
}
