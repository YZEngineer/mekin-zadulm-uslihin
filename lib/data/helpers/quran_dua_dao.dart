import 'package:zadulmuslihin/data/database/database_helper.dart';
import 'package:zadulmuslihin/data/models/quran_dua.dart';

class QuranDuaDao {
  final DatabaseHelper _dbHelper;

  QuranDuaDao(this._dbHelper);

  Future<int> insert(QuranDua dua) async {
    final db = await _dbHelper.database;
    return await db.insert('quran_duas', dua.toMap());
  }

  Future<int> update(QuranDua dua) async {
    final db = await _dbHelper.database;
    return await db.update(
      'quran_duas',
      dua.toMap(),
      where: 'id = ?',
      whereArgs: [dua.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'quran_duas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<QuranDua?> getById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'quran_duas',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return QuranDua.fromMap(maps.first);
  }

  Future<List<QuranDua>> getAll() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('quran_duas');
    return List.generate(maps.length, (i) => QuranDua.fromMap(maps[i]));
  }
}
