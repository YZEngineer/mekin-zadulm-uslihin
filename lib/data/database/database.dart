import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/lesson.dart';

/// تعريف جداول قاعدة البيانات وإصداراتها

class AppDatabase {
  static const String databaseName = 'zadulmuslihin.db';
  static const int databaseVersion = 1;

  // أسماء الجداول
  static const String tableAdhanTimes = 'adhan_times';
  static const String tableCurrentAdhan = 'current_adhan';
  static const String tableCurrentLocation = 'current_location';
  static const String tableDailyTask = 'daily_tasks';
  static const String tableDailyWorship = 'daily_worship';
  static const String tableIslamicInformation = 'islamic_information';
  static const String tableLocation = 'locations';
  static const String tableWorshipHistory = 'worship_history';
  static const String tableThoughtHistory = 'thought_history';
  static const String tableThought = 'thought';
  static const String tableDailyMessage = 'daily_message';
  static const String tableMyLibrary = 'my_library';
  static const String tableSettings = 'settings';
  static const String tablePrayerNotifications = 'prayer_notifications';
  static const String tableLessons = 'lessons';
  static const String tableNotes = 'notes';

  /// إنشاء قاعدة البيانات
  static Future<Database> getDatabase() async {
    try {
      print("جاري فتح قاعدة البيانات...");
      return await openDatabase(
        join(await getDatabasesPath(), databaseName),
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        version: databaseVersion,
      );
    } catch (e) {
      print("خطأ في فتح قاعدة البيانات: $e");
      rethrow;
    }
  }

  /// إنشاء جداول قاعدة البيانات
  static Future<void> _onCreate(Database db, int version) async {
    try {
      print("بدء إنشاء جداول قاعدة البيانات");

      // ١. أولاً: إنشاء جدول المواقع
      await _createTable(db, '''
        CREATE TABLE IF NOT EXISTS $tableLocation (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          latitude REAL NOT NULL,
          longitude REAL NOT NULL,
          city TEXT,
          country TEXT,
          timezone TEXT,
          madhab TEXT,
          method_id INTEGER NOT NULL)
      ''', 'جدول المواقع');

      // ٢. ثانياً: إنشاء جدول الموقع الحالي
      await _createTable(db, '''
        CREATE TABLE IF NOT EXISTS $tableCurrentLocation (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          location_id INTEGER NOT NULL DEFAULT 1,
          FOREIGN KEY (location_id) REFERENCES $tableLocation (id)
        )
      ''', 'جدول الموقع الحالي');

      // إنشاء سجل للموقع الحالي بقيمة افتراضية 1
      await db.insert(tableCurrentLocation, {'location_id': 1});

      // ٣. ثالثاً: إنشاء جدول أوقات الأذان
      await _createTable(db, '''
        CREATE TABLE IF NOT EXISTS $tableAdhanTimes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          location_id INTEGER NOT NULL,
          date TEXT NOT NULL,
          fajr_time TEXT NOT NULL DEFAULT '00:00',
          sunrise_time TEXT NOT NULL DEFAULT '00:00',
          dhuhr_time TEXT NOT NULL DEFAULT '00:00',
          asr_time TEXT NOT NULL DEFAULT '00:00',
          maghrib_time TEXT NOT NULL DEFAULT '00:00',
          isha_time TEXT NOT NULL DEFAULT '00:00',
          UNIQUE(location_id, date),
          FOREIGN KEY (location_id) REFERENCES $tableLocation (id)
        )
      ''', 'جدول أوقات الأذان');

      // ٤. رابعاً: إنشاء جدول الأذان الحالي
      await _createTable(db, '''
        CREATE TABLE IF NOT EXISTS $tableCurrentAdhan (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          location_id INTEGER NOT NULL,
          date TEXT NOT NULL,
          fajr_time TEXT NOT NULL DEFAULT '00:00',
          sunrise_time TEXT NOT NULL DEFAULT '00:00',
          dhuhr_time TEXT NOT NULL DEFAULT '00:00',
          asr_time TEXT NOT NULL DEFAULT '00:00',
          maghrib_time TEXT NOT NULL DEFAULT '00:00',
          isha_time TEXT NOT NULL DEFAULT '00:00',
          FOREIGN KEY (location_id) REFERENCES $tableLocation (id)
        )
      ''', 'جدول الأذان الحالي');

      // ٥. خامساً: إنشاء جدول الإعدادات
      await _createTable(db, '''
        CREATE TABLE IF NOT EXISTS $tableSettings (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          key TEXT NOT NULL,
          value TEXT NOT NULL
        )
      ''', 'جدول الإعدادات');

      // إضافة إعدادات افتراضية
      List<Map<String, dynamic>> defaultSettings = [
        {'key': 'notification_enabled', 'value': 'true'},
        {'key': 'prayer_alert', 'value': 'true'},
        {'key': 'dark_mode', 'value': 'false'},
      ];

      for (var setting in defaultSettings) {
        await db.insert(tableSettings, setting);
      }

      // جدول المهام اليومية
      await _createTable(db, '''
        CREATE TABLE IF NOT EXISTS $tableDailyTask (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          is_completed INTEGER NOT NULL,
          is_on_working INTEGER NOT NULL,
          category INTEGER NOT NULL
        )
      ''', 'جدول المهام اليومية');

      // جدول العبادات اليومية
      await _createTable(db, '''
        CREATE TABLE IF NOT EXISTS $tableDailyWorship (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          fajr_prayer INTEGER NOT NULL,
          dhuhr_prayer INTEGER NOT NULL,
          asr_prayer INTEGER NOT NULL,
          maghrib_prayer INTEGER NOT NULL,
          isha_prayer INTEGER NOT NULL,
          thikr INTEGER NOT NULL,
          qiyam INTEGER NOT NULL,
          witr INTEGER NOT NULL,
          quran_reading INTEGER NOT NULL
        )
      ''', 'جدول العبادات اليومية');

      // جدول المعلومات الإسلامية
      await _createTable(db, '''
        CREATE TABLE IF NOT EXISTS $tableIslamicInformation (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          content TEXT NOT NULL,
          category TEXT NOT NULL
        )
      ''', 'جدول المعلومات الإسلامية');

      // جدول سجل العبادات
      await _createTable(db, '''
        CREATE TABLE IF NOT EXISTS $tableWorshipHistory (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          precentOf0 INTEGER NOT NULL,
          precentOf1 INTEGER NOT NULL,
          precentOf2 INTEGER NOT NULL,
          totalday INTEGER NOT NULL
        )
      ''', 'جدول سجل العبادات');

      // جدول سجل الخواطر
      await _createTable(db, '''
        CREATE TABLE IF NOT EXISTS $tableThoughtHistory (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          precentOf0 INTEGER NOT NULL,
          precentOf1 INTEGER NOT NULL,
          precentOf2 INTEGER NOT NULL,
          totalday INTEGER NOT NULL
        )
      ''', 'جدول سجل الخواطر');

      // جدول الخواطر
      await _createTable(db, '''
        CREATE TABLE IF NOT EXISTS $tableThought (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          content TEXT NOT NULL,
          category INTEGER NOT NULL,
          date TEXT NOT NULL
        )
      ''', 'جدول الخواطر');

      // جدول الرسائل اليومية
      await _createTable(db, '''
        CREATE TABLE IF NOT EXISTS $tableDailyMessage (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          content TEXT NOT NULL,
          date TEXT NOT NULL,
          category INTEGER NOT NULL,
          source TEXT NOT NULL
        )
      ''', 'جدول الرسائل اليومية');

      // جدول مكتبتي
      await _createTable(db, '''
        CREATE TABLE IF NOT EXISTS $tableMyLibrary (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          content TEXT NOT NULL,
          source TEXT,
          tabName TEXT NOT NULL,
          links TEXT,
          type TEXT NOT NULL,
          category TEXT
        )
      ''', 'جدول مكتبتي');

      // جدول إشعارات الصلاة
      await _createTable(db, '''
        CREATE TABLE IF NOT EXISTS $tablePrayerNotifications (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          prayer_name TEXT NOT NULL,
          is_enabled INTEGER NOT NULL DEFAULT 1,
          minutes_before INTEGER NOT NULL DEFAULT 15,
          use_adhan INTEGER NOT NULL DEFAULT 1,
          custom_sound TEXT,
          vibration_pattern TEXT
        )
      ''', 'جدول إشعارات الصلاة');

      // جدول الدروس
      await _createTable(db, '''
        CREATE TABLE IF NOT EXISTS $tableLessons (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          category TEXT NOT NULL,
          title TEXT NOT NULL,
          description TEXT NOT NULL,
          video_id TEXT NOT NULL,
          type TEXT NOT NULL,
          is_completed INTEGER NOT NULL DEFAULT 0
        )
      ''', 'جدول الدروس');

      // جدول الملاحظات
      await _createTable(db, '''
        CREATE TABLE IF NOT EXISTS $tableNotes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          lesson_id INTEGER NOT NULL,
          content TEXT NOT NULL,
          created_at INTEGER NOT NULL,
          FOREIGN KEY (lesson_id) REFERENCES $tableLessons (id)
        )
      ''', 'جدول الملاحظات');

      // إضافة إشعارات افتراضية للصلوات الخمس
      List<Map<String, dynamic>> defaultPrayerNotifications = [
        {
          'prayer_name': 'فجر',
          'is_enabled': 1,
          'minutes_before': 15,
          'use_adhan': 1,
        },
        {
          'prayer_name': 'ظهر',
          'is_enabled': 1,
          'minutes_before': 15,
          'use_adhan': 1,
        },
        {
          'prayer_name': 'عصر',
          'is_enabled': 1,
          'minutes_before': 15,
          'use_adhan': 1,
        },
        {
          'prayer_name': 'مغرب',
          'is_enabled': 1,
          'minutes_before': 15,
          'use_adhan': 1,
        },
        {
          'prayer_name': 'عشاء',
          'is_enabled': 1,
          'minutes_before': 15,
          'use_adhan': 1,
        },
      ];

      for (var notification in defaultPrayerNotifications) {
        await db.insert(tablePrayerNotifications, notification);
      }

      // إضافة الدروس الافتراضية
      final defaultLessons = [
        Lesson(
          category: "cat1",
          title: "title1-123",
          description: "description1",
          videoId: "bVOrIqeJ3XE",
          type: "t1",
        ),
        Lesson(
          category: "cat1",
          title: "title1-456",
          description: "description1",
          videoId: "bVOrIqeJ3XE",
          type: "t1",
        ),
        Lesson(
          category: "cat2",
          title: "title1-789",
          description: "description1",
          videoId: "bVOrIqeJ3XE",
          type: "t1",
        ),
        Lesson(
          category: "cat2",
          title: "title1-234",
          description: "description1",
          videoId: "bVOrIqeJ3XE",
          type: "t1",
        ),
        Lesson(
          category: "cat2",
          title: "title1-567",
          description: "description1",
          videoId: "bVOrIqeJ3XE",
          type: "t1",
        ),
        Lesson(
          category: "cat3",
          title: "title1-890",
          description: "description1",
          videoId: "bVOrIqeJ3XE",
          type: "t1",
        ),
        Lesson(
          category: "cat3",
          title: "title1-345",
          description: "description1",
          videoId: "bVOrIqeJ3XE",
          type: "t1",
        ),
        Lesson(
          category: "cat3",
          title: "title1-678",
          description: "description1",
          videoId: "bVOrIqeJ3XE",
          type: "t1",
        ),
        Lesson(
          category: "cat3",
          title: "title1-901",
          description: "description1",
          videoId: "bVOrIqeJ3XE",
          type: "t1",
        ),
        Lesson(
          category: "cat3",
          title: "title1-432",
          description: "description1",
          videoId: "bVOrIqeJ3XE",
          type: "t1",
        ),
        Lesson(
          category: "cat4",
          title: "title1-765",
          description: "description1",
          videoId: "bVOrIqeJ3XE",
          type: "t2",
        ),
        Lesson(
          category: "cat4",
          title: "title1-098",
          description: "description1",
          videoId: "bVOrIqeJ3XE",
          type: "t2",
        ),
        Lesson(
          category: "cat4",
          title: "title1-321",
          description: "description1",
          videoId: "bVOrIqeJ3XE",
          type: "t2",
        ),
        Lesson(
          category: "cat5",
          title: "title1-654",
          description: "description1",
          videoId: "bVOrIqeJ3XE",
          type: "t2",
        ),
        Lesson(
          category: "cat6",
          title: "title1-987",
          description: "description1",
          videoId: "bVOrIqeJ3XE",
          type: "t2",
        ),
        Lesson(
          category: "cat7",
          title: "title1-210",
          description: "description1",
          videoId: "bVOrIqeJ3XE",
          type: "t2",
        ),
        Lesson(
          category: "cat8",
          title: "title1-543",
          description: "description1",
          videoId: "bVOrIqeJ3XE",
          type: "t2",
        ),
        Lesson(
          category: "cat9",
          title: "title1-876",
          description: "description1",
          videoId: "bVOrIqeJ3XE",
          type: "t2",
        ),
        Lesson(
          category: "cat9",
          title: "title1-109",
          description: "description1",
          videoId: "bVOrIqeJ3XE",
          type: "t2",
        ),
        Lesson(
          category: "cat10",
          title: "title1-432",
          description: "description1",
          videoId: "bVOrIqeJ3XE",
          type: "t2",
        ),
      ];

      for (var lesson in defaultLessons) {
        await db.insert(tableLessons, lesson.toMap());
      }

      print("تم إنشاء جميع الجداول بنجاح");
    } catch (e) {
      print("خطأ في إنشاء جداول قاعدة البيانات: $e");
      rethrow;
    }
  }

  /// إنشاء جدول واحد مع معالجة الأخطاء
  static Future<void> _createTable(
    Database db,
    String sql,
    String tableName,
  ) async {
    try {
      print("جاري إنشاء $tableName...");
      await db.execute(sql);
      print("تم إنشاء $tableName بنجاح");
    } catch (e) {
      print("خطأ في إنشاء $tableName: $e");
      rethrow;
    }
  }

  /// ترقية قاعدة البيانات
  static Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    try {
      print("جاري تحديث قاعدة البيانات من الإصدار $oldVersion إلى $newVersion");
      // سيتم تنفيذ هذا عند ترقية الإصدار في المستقبل
      print("تم تحديث قاعدة البيانات بنجاح");
    } catch (e) {
      print("خطأ في تحديث قاعدة البيانات: $e");
      rethrow;
    }
  }
}
