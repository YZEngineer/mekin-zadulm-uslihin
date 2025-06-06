import '../models/lesson.dart';
import '../database/database_helper.dart';
import '../database/database.dart';

/// فئة للتعامل مع بيانات الموقع الحالي في قاعدة البيانات
class LessonsDao {
  final _databaseHelper = DatabaseHelper.instance;
  final String _tableName = AppDatabase.tableLessons;

  Future<int> insert(Lesson lesson) async {
    print("added");
    print(lesson.title);
    return await _databaseHelper.insert(_tableName, lesson.toMap());
  }

  /// تحديث بيانات فكرة موجودة
  Future<int> update(Lesson lesson) async {
    if (lesson.id == null) {
      throw ArgumentError('لا يمكن تحديث  بدون معرف');
    }
    return await _databaseHelper.update(_tableName, lesson.toJson(), 'id = ?', [
      lesson.id,
    ]);
  }

  Future<void> deleteCategory(String category) async {
    List<Lesson> lessons = await getAll();
    for (var lesson in lessons) {
      if (lesson.category == category) {
        await delete(lesson.id!);
      }
    }
  }

  Future<int> delete(int id) async {
    return await _databaseHelper.delete(_tableName, 'id = ?', [id]);
  }

  Future<List<Lesson>> getLessonByCategory(String category) async {
    try {
      final List<Map<String, dynamic>> maps = await _databaseHelper.query(
        _tableName,
        where: 'category = ?',
        whereArgs: [category],
        orderBy: 'id DESC',
      );
      return List.generate(maps.length, (i) {
        return Lesson.fromJson(maps[i]);
      });
    } catch (e) {
      print('خطأ في الحصول على  الدروس حسب التصنيف: $e');
      return [];
    }
  }

  Future<List<Lesson>> getLessonByType(String type) async {
    try {
      final List<Map<String, dynamic>> maps = await _databaseHelper.query(
        _tableName,
        where: 'type = ?',
        whereArgs: [type],
        orderBy: 'id DESC',
      );
      return List.generate(maps.length, (i) {
        return Lesson.fromJson(maps[i]);
      });
    } catch (e) {
      print('خطأ في الحصول على عناصر المكتبة حسب التصنيف: $e');
      return [];
    }
  }

  Future<List<Lesson>> getAll() async {
    final result = await _databaseHelper.query(_tableName);
    print(result);
    return result.map((map) => Lesson.fromJson(map)).toList();
  }

  Future<void> reloadeDeletedLesson() async {
    // Get all existing lessons
    List<Lesson> existingLessons = await getAll();

    // Filter default lessons that don't exist in the database
    List<Lesson> lessonsToAdd = defaultLessons.where((defaultLesson) {
      // Check if this category exists in the database

      // If title exists, check if this exact lesson exists
      return !existingLessons.any(
        (existingLesson) => existingLesson.title == defaultLesson.title,
      );
    }).toList();

    // Add filtered lessons to database
    for (var lesson in lessonsToAdd) {
      await insert(lesson);
    }
  }

  // Define default categories and lessons
  // إضافة الدروس الافتراضية
  final defaultLessons = [
    Lesson(
      category: "حقيقة طلب العلم، يجب معرفتها قبل السير",
      title: "title1-123",
      description: "description1",
      videoId: "bVOrIqeJ3XE",
      type: "المقرر العلمي",
    ),
    Lesson(
      category: "حقيقة طلب العلم، يجب معرفتها قبل السير",
      title: "title1-456",
      description: "description1",
      videoId: "bVOrIqeJ3XE",
      type: "المقرر العلمي",
    ),
    Lesson(
      category: "نظرية المعرفة ومصادر التلقي ا. أحمد السيد",
      title: "title1-789",
      description: "description1",
      videoId: "bVOrIqeJ3XE",
      type: "المقرر العلمي",
    ),
    Lesson(
      category: "نظرية المعرفة ومصادر التلقي ا. أحمد السيد",
      title: "title1-234",
      description: "description1",
      videoId: "bVOrIqeJ3XE",
      type: "المقرر العلمي",
    ),
    Lesson(
      category: "نظرية المعرفة ومصادر التلقي ا. أحمد السيد",
      title: "title1-567",
      description: "description1",
      videoId: "bVOrIqeJ3XE",
      type: "المقرر العلمي",
    ),
    Lesson(
      category: "خريطة العلوم م. أيمن + مدخل الى اللغة العربية ا. أحمد السيد ",
      title: "title1-890",
      description: "description1",
      videoId: "bVOrIqeJ3XE",
      type: "المقرر العلمي",
    ),
    Lesson(
      category: "خريطة العلوم م. أيمن + مدخل الى اللغة العربية ا. أحمد السيد ",
      title: "title1-345",
      description: "description1",
      videoId: "bVOrIqeJ3XE",
      type: "المقرر العلمي",
    ),
    Lesson(
      category: "خريطة العلوم م. أيمن + مدخل الى اللغة العربية ا. أحمد السيد ",
      title: "title1-678",
      description: "description1",
      videoId: "bVOrIqeJ3XE",
      type: "المقرر العلمي",
    ),
    Lesson(
      category: "خريطة العلوم م. أيمن + مدخل الى اللغة العربية ا. أحمد السيد ",
      title: "title1-901",
      description: "description1",
      videoId: "bVOrIqeJ3XE",
      type: "المقرر العلمي",
    ),
    Lesson(
      category: "خريطة العلوم م. أيمن + مدخل الى اللغة العربية ا. أحمد السيد ",
      title: "title1-432",
      description: "description1",
      videoId: "bVOrIqeJ3XE",
      type: "المقرر العلمي",
    ),
    Lesson(
      category: "مهارة إدارة الوقت",
      title: "title1-765",
      description: "description1",
      videoId: "bVOrIqeJ3XE",
      type: "المقرر المهاري",
    ),
    Lesson(
      category: "مهارة إدارة الوقت",
      title: "title1-098",
      description: "description1",
      videoId: "bVOrIqeJ3XE",
      type: "المقرر المهاري",
    ),
    Lesson(
      category: "مهارة إدارة الوقت",
      title: "title1-321",
      description: "description1",
      videoId: "bVOrIqeJ3XE",
      type: "المقرر المهاري",
    ),
    Lesson(
      category: "العادات الذرية",
      title: "title1-654",
      description: "description1",
      videoId: "bVOrIqeJ3XE",
      type: "المقرر المهاري",
    ),
    Lesson(
      category: "مهارة البحث وهندسة الأوامر ",
      title: "title1-987",
      description: "description1",
      videoId: "bVOrIqeJ3XE",
      type: "المقرر المهاري",
    ),
    Lesson(
      category: "مهارة البحث",
      title: "title1-210",
      description: "description1",
      videoId: "bVOrIqeJ3XE",
      type: "المقرر المهاري",
    ),
    Lesson(
      category: "مهارة القراءة ",
      title: "title1-543",
      description: "description1",
      videoId: "bVOrIqeJ3XE",
      type: "المقرر المهاري",
    ),
  ];

  static Future<void> updateLessonCompletion(int? id, bool newValue) async {}
}
