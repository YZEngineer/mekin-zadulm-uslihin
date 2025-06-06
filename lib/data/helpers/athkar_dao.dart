import '../models/athkar.dart';
import '../database/database.dart';
import '../database/database_helper.dart';

/// فئة للتعامل مع بيانات الأذكار في قاعدة البيانات
class AthkarDao {
  final DatabaseHelper _dbHelper;

  AthkarDao(this._dbHelper);

  /// إدراج ذكر جديد
  Future<int> insert(Athkar athkar) async {
    final db = await _dbHelper.database;
    return await db.insert('athkar', athkar.toMap());
  }

  /// تحديث ذكر موجود
  Future<int> update(Athkar athkar) async {
    final db = await _dbHelper.database;
    return await db.update(
      'athkar',
      athkar.toMap(),
      where: 'id = ?',
      whereArgs: [athkar.id],
    );
  }

  /// حذف ذكر بواسطة المعرف
  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'athkar',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// الحصول على ذكر بواسطة المعرف
  Future<Athkar?> getById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'athkar',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return Athkar.fromMap(maps.first);
  }

  /// الحصول على جميع الأذكار
  Future<List<Athkar>> getAll() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('athkar');
    return List.generate(maps.length, (i) => Athkar.fromMap(maps[i]));
  }

  /// الحصول على الأذكار حسب العنوان
  Future<List<Athkar>> getByTitle(String title) async {
    final result = await _dbHelper
        .query('athkar', where: 'title LIKE ?', whereArgs: ['%$title%']);
    return result.map((map) => Athkar.fromMap(map)).toList();
  }
}
