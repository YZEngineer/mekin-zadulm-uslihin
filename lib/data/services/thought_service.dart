import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/thought_model.dart';

class ThoughtService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'thoughts.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE thoughts(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            content TEXT NOT NULL,
            type INTEGER NOT NULL,
            createdAt TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertThought(Thought thought) async {
    final db = await database;
    return await db.insert('thoughts', thought.toMap());
  }

  Future<int> updateThought(Thought thought) async {
    final db = await database;
    return await db.update(
      'thoughts',
      thought.toMap(),
      where: 'id = ?',
      whereArgs: [thought.id],
    );
  }

  Future<int> deleteThought(int id) async {
    final db = await database;
    return await db.delete('thoughts', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Thought>> getAllThoughts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'thoughts',
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) => Thought.fromMap(maps[i]));
  }

  Future<List<Thought>> getThoughtsByType(ThoughtType type) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'thoughts',
      where: 'type = ?',
      whereArgs: [type.index],
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) => Thought.fromMap(maps[i]));
  }

  Future<Map<ThoughtType, int>> getThoughtTypeCounts() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT type, COUNT(*) as count
      FROM thoughts
      GROUP BY type
    ''');

    Map<ThoughtType, int> counts = {
      ThoughtType.worldly: 0,
      ThoughtType.hereafter: 0,
      ThoughtType.both: 0,
    };

    for (var row in result) {
      counts[ThoughtType.values[row['type'] as int]] = row['count'] as int;
    }

    return counts;
  }
}
