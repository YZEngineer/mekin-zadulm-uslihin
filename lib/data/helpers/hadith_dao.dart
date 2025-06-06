import 'package:zadulmuslihin/data/database/database_helper.dart';
import 'package:zadulmuslihin/data/models/hadith.dart';

class HadithDao {
  final DatabaseHelper _dbHelper;

  HadithDao(this._dbHelper);

  Future<int> insert(Hadith hadith) async {
    final db = await _dbHelper.database;
    return await db.insert('hadiths', hadith.toMap());
  }

  Future<int> update(Hadith hadith) async {
    final db = await _dbHelper.database;
    return await db.update(
      'hadiths',
      hadith.toMap(),
      where: 'id = ?',
      whereArgs: [hadith.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'hadiths',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Hadith?> getById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'hadiths',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return Hadith.fromMap(maps.first);
  }

  Future<List<Hadith>> getAll() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('hadiths');
    return List.generate(maps.length, (i) => Hadith.fromMap(maps[i]));
  }
}
