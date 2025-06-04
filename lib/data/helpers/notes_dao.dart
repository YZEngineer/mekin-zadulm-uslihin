import '../models/note.dart';
import '../database/database_helper.dart';
import '../database/database.dart';

class NotesDao {
  final _databaseHelper = DatabaseHelper.instance;
  final String _tableName = AppDatabase.tableNotes;

  Future<int> insert(Note note) async {
    return await _databaseHelper.insert(_tableName, note.toMap());
  }

  Future<int> update(Note note) async {
    if (note.id == null) {
      throw ArgumentError('لا يمكن تحديث ملاحظة بدون معرف');
    }
    return await _databaseHelper.update(_tableName, note.toJson(), 'id = ?', [
      note.id,
    ]);
  }

  Future<int> delete(int id) async {
    return await _databaseHelper.delete(_tableName, 'id = ?', [id]);
  }

  Future<List<Note>> getNotesForLesson(int lessonId) async {
    try {
      final List<Map<String, dynamic>> maps = await _databaseHelper.query(
        _tableName,
        where: 'lesson_id = ?',
        whereArgs: [lessonId],
        orderBy: 'created_at DESC',
      );
      return List.generate(maps.length, (i) {
        return Note.fromJson(maps[i]);
      });
    } catch (e) {
      print('خطأ في الحصول على الملاحظات: $e');
      return [];
    }
  }

  Future<List<Note>> getAll() async {
    final result = await _databaseHelper.query(_tableName);
    return result.map((map) => Note.fromJson(map)).toList();
  }
}
