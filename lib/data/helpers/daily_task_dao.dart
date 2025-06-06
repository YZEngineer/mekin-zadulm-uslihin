import '../models/daily_task.dart';
import '../database/database.dart';
import '../database/database_helper.dart';
import 'package:intl/intl.dart';

/// فئة للتعامل مع بيانات المهام اليومية في قاعدة البيانات
class DailyTaskDao {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  final String _tableName = AppDatabase.tableDailyTasks;

  // Varsayılan görevler listesi
  static final List<Map<String, dynamic>> defaultTasksList = [
    {
      'title': 'قراءة القرآن',
      'category': 0,
      'is_completed': 0,
      'is_on_working': 0,
    },
    {
      'title': 'الأذكار الصباحية',
      'category': 0,
      'is_completed': 0,
      'is_on_working': 0,
    },
    {
      'title': 'الأذكار المسائية',
      'category': 0,
      'is_completed': 0,
      'is_on_working': 0,
    },
    {
      'title': 'صلاة الضحى',
      'category': 0,
      'is_completed': 0,
      'is_on_working': 0,
    },
    {
      'title': 'صلاة التهجد',
      'category': 2,
      'is_completed': 0,
      'is_on_working': 0,
    },
    {'title': 'الدعاء', 'category': 0, 'is_completed': 0, 'is_on_working': 0},
    {'title': 'التسبيح', 'category': 0, 'is_completed': 0, 'is_on_working': 0},
    {'title': 'الصدقة', 'category': 0, 'is_completed': 0, 'is_on_working': 0},
    {
      'title': 'بر الوالدين',
      'category': 1,
      'is_completed': 0,
      'is_on_working': 0,
    },
    {
      'title': 'صلة الرحم',
      'category': 0,
      'is_completed': 0,
      'is_on_working': 0,
    },
  ];

  Future<void> loadDefaultTasks() async {
    // Mevcut görevleri al
    List<DailyTask> existingTasks = await getAll();

    // Varsayılan görevlerden eksik olanları filtrele
    List<Map<String, dynamic>> tasksToAdd = defaultTasksList.where((
      defaultTask,
    ) {
      // Eğer bu görev veritabanında yoksa ekle
      return !existingTasks.any(
        (existingTask) => existingTask.title == defaultTask['title'],
      );
    }).toList();

    // Filtrelenmiş görevleri veritabanına ekle
    for (var task in tasksToAdd) {
      await _databaseHelper.insert(_tableName, task);
    }
  }

  /// إدراج مهمة جديدة
  Future<int> insert(DailyTask task) async {
    return await _databaseHelper.insert(_tableName, task.toMap());
  }

  /// تحديث مهمة موجودة
  Future<int> update(DailyTask task) async {
    if (task.id == null) {
      throw ArgumentError('لا يمكن تحديث مهمة بدون معرف');
    }
    return await _databaseHelper.update(_tableName, task.toMap(), 'id = ?', [
      task.id,
    ]);
  }

  /// حذف مهمة بواسطة المعرف
  Future<int> delete(int id) async {
    return await _databaseHelper.delete(_tableName, 'id = ?', [id]);
  }

  /// الحصول على جميع المهام
  Future<List<DailyTask>> getAll() async {
    final result = await _databaseHelper.query(_tableName);
    return result.map((map) => DailyTask.fromMap(map)).toList();
  }

  /// الحصول على عدد المهام
  Future<int> getCount() async {
    final result = await _databaseHelper.rawQuery(
      'SELECT COUNT(*) as count FROM $_tableName',
    );
    return result.first['count'] as int;
  }

  /// الحصول على المهام حسب الفئة
  Future<List<DailyTask>> getByCategory(String category) async {
    final result = await _databaseHelper.query(
      _tableName,
      where: 'category = ?',
      whereArgs: [category],
    );

    return result.map((map) => DailyTask.fromMap(map)).toList();
  }

  /// الحصول على المهام حسب التكرار
  Future<List<DailyTask>> getByRepeatType(String repeatType) async {
    final result = await _databaseHelper.query(
      _tableName,
      where: 'is_on_working = ?',
      whereArgs: [repeatType],
    );

    return result.map((map) => DailyTask.fromMap(map)).toList();
  }

  /// الحصول على المهام المكتملة
  Future<List<DailyTask>> getCompleted() async {
    final result = await _databaseHelper.query(
      _tableName,
      where: 'is_completed = ?',
      whereArgs: [1],
    );

    return result.map((map) => DailyTask.fromMap(map)).toList();
  }

  /// الحصول على المهام غير المكتملة
  Future<List<DailyTask>> getIncomplete() async {
    final result = await _databaseHelper.query(
      _tableName,
      where: 'is_completed = ?',
      whereArgs: [0],
    );

    return result.map((map) => DailyTask.fromMap(map)).toList();
  }

  /// الحصول على المهام حسب تاريخ الاستحقاق
  Future<List<DailyTask>> getByDueDate(DateTime date) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final result = await _databaseHelper.query(
      _tableName,
      where: 'due_date LIKE ?',
      whereArgs: ['$formattedDate%'],
      orderBy: 'due_date ASC',
    );

    return result.map((map) => DailyTask.fromMap(map)).toList();
  }

  /// تحديث حالة الإكمال للمهمة
  Future<int> updateCompletionStatus(int id, bool completed) async {
    return await _databaseHelper.update(
      _tableName,
      {'is_completed': completed ? 1 : 0},
      'id = ?',
      [id],
    );
  }

  /// البحث في المهام
  Future<List<DailyTask>> search(String query) async {
    final result = await _databaseHelper.query(
      _tableName,
      where: 'title LIKE ?',
      whereArgs: ['%$query%'],
    );

    return result.map((map) => DailyTask.fromMap(map)).toList();
  }

  /// الحصول على مهمة بواسطة المعرف
  Future<DailyTask?> getById(int id) async {
    final result = await _databaseHelper.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isEmpty) {
      return null;
    }

    return DailyTask.fromMap(result.first);
  }
}
