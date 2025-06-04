import '../models/note.dart';
import '../database/database_helper.dart';
import '../database/database.dart';

/// فئة للتعامل مع بيانات الموقع الحالي في قاعدة البيانات
class NotesDao {
  final _databaseHelper = DatabaseHelper.instance;
  final String _tableName = AppDatabase.tableNotes;

  Future<int> insert(Note note) async {
    return await _databaseHelper.insert(_tableName, note.toMap());
  }

  /// تحديث بيانات فكرة موجودة
  Future<int> update(Note Note) async {
    if (Note.id == null) {
      throw ArgumentError('لا يمكن تحديث  بدون معرف');
    }
    return await _databaseHelper.update(_tableName, Note.toJson(), 'id = ?', [
      Note.id,
    ]);
  }

  Future<void> addNoteWithLessonId(Note note, int lessonId) async {
    //Note( lessonId: lessonId, content: content, createdAt: createdAt);
    //await insert(Note);
  }

  Future<int> delete(int id) async {
    return await _databaseHelper.delete(_tableName, 'id = ?', [id]);
  }

  Future<List<Note>> getNoteByLessonId(int id) async {
    try {
      final List<Map<String, dynamic>> maps = await _databaseHelper.query(
        _tableName,
        where: 'lessonId = ?',
        whereArgs: [id],
        orderBy: 'id DESC',
      );
      return List.generate(maps.length, (i) {
        return Note.fromJson(maps[i]);
      });
    } catch (e) {
      print('خطأ في الحصول على عناصر المكتبة حسب التصنيف: $e');
      return [];
    }
  }
}
