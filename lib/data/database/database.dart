import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/lesson.dart';

/// تعريف جداول قاعدة البيانات وإصداراتها

class AppDatabase {
  static const String databaseName = 'zadulmuslihin.db';
  static const int databaseVersion = 1;

  // أسماء الجداول
  static const String tableCurrentLocation = 'current_location';
  static const String tableCurrentPrayer = 'current_prayer';
  static const String tableSettings = 'settings';
  static const String tableDailyTasks = 'daily_tasks';
  static const String tableDailyWorship = 'daily_worship';
  static const String tableIslamicInfo = 'islamic_info';
  static const String tableWorshipLog = 'worship_log';
  static const String tableThoughtsLog = 'thoughts_log';
  static const String tableThoughts = 'thoughts';
  static const String tableDailyMessages = 'daily_messages';
  static const String tableMyLibrary = 'my_library';
  static const String tablePrayerNotifications = 'prayer_notifications';
  static const String tableLessons = 'lessons';
  static const String tableNotes = 'notes';
  static const String tableAthkar = 'athkar';
  static const String tableHadiths = 'hadiths';
  static const String tableQuranDuas = 'quran_duas';

  /// إنشاء قاعدة البيانات
  static Future<Database> getDatabase() async {
    try {
      print("جاري فتح قاعدة البيانات...");
      return await openDatabase(
        join(await getDatabasesPath(), databaseName),
        onCreate: _onCreate,
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

      // إنشاء جدول الموقع الحالي
      await _createTable(
          db,
          '''
        CREATE TABLE IF NOT EXISTS $tableCurrentLocation (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          latitude REAL NOT NULL,
          longitude REAL NOT NULL,
          city TEXT NOT NULL,
          country TEXT NOT NULL
        )
      ''',
          'جدول الموقع الحالي');

      // إضافة الموقع الافتراضي
      await db.insert(tableCurrentLocation, {
        'latitude': 41.0082,
        'longitude': 28.9784,
        'city': 'x',
        'country': 'xx'
      });

      // إنشاء جدول الأذان الحالي
      await _createTable(
          db,
          '''
        CREATE TABLE IF NOT EXISTS $tableCurrentPrayer (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          location_id INTEGER NOT NULL,
          date TEXT NOT NULL,
          fajr_time TEXT NOT NULL DEFAULT '00:00',
          sunrise_time TEXT NOT NULL DEFAULT '00:00',
          dhuhr_time TEXT NOT NULL DEFAULT '00:00',
          asr_time TEXT NOT NULL DEFAULT '00:00',
          maghrib_time TEXT NOT NULL DEFAULT '00:00',
          isha_time TEXT NOT NULL DEFAULT '00:00')
      ''',
          'جدول الأذان الحالي');

      // إنشاء جدول الإعدادات
      await _createTable(
          db,
          '''
        CREATE TABLE IF NOT EXISTS $tableSettings (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          key TEXT NOT NULL,
          value TEXT NOT NULL
        )
      ''',
          'جدول الإعدادات');

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
      await _createTable(
          db,
          '''
        CREATE TABLE IF NOT EXISTS $tableDailyTasks (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          is_completed INTEGER NOT NULL,
          is_on_working INTEGER NOT NULL,
          category INTEGER NOT NULL
        )
      ''',
          'جدول المهام اليومية');

      // إضافة مهام يومية افتراضية
      print('جاري إضافة المهام اليومية الافتراضية...');
      List<Map<String, dynamic>> defaultTasks = [
        // العادات
        {
          'title': 'قراءة كتاب',
          'is_completed': 0,
          'is_on_working': 1,
          'category': 0, // العادات
        },
        {
          'title': 'صلة رحم',
          'is_completed': 0,
          'is_on_working': 1,
          'category': 0, // العادات
        },
        // الأهداف
        {
          'title': 'حفظ القرآن',
          'is_completed': 0,
          'is_on_working': 1,
          'category': 1, // الأهداف
        },

        {
          'title': 'بلانك',
          'is_completed': 0,
          'is_on_working': 1,
          'category': 2, // الأهداف
        },
        {
          'title': 'عقلة',
          'is_completed': 0,
          'is_on_working': 1,
          'category': 2, // الأهداف
        },
        {
          'title': 'ضغط',
          'is_completed': 0,
          'is_on_working': 1,
          'category': 2, // الأهداف
        },
        {
          'title': 'تمارين معدة',
          'is_completed': 0,
          'is_on_working': 1,
          'category': 2, // الأهداف
        },
      ];

      for (var task in defaultTasks) {
        await db.insert(tableDailyTasks, task);
      }
      print('تم إضافة المهام اليومية الافتراضية بنجاح');

      // جدول العبادات اليومية
      await _createTable(
          db,
          '''
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
      ''',
          'جدول العبادات اليومية');

      // جدول المعلومات الإسلامية
      await _createTable(
          db,
          '''
        CREATE TABLE IF NOT EXISTS $tableIslamicInfo (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          content TEXT NOT NULL,
          category TEXT NOT NULL
        )
      ''',
          'جدول المعلومات الإسلامية');

      // جدول سجل العبادات
      await _createTable(
          db,
          '''
        CREATE TABLE IF NOT EXISTS $tableWorshipLog (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          precentOf0 INTEGER NOT NULL,
          precentOf1 INTEGER NOT NULL,
          precentOf2 INTEGER NOT NULL,
          totalday INTEGER NOT NULL
        )
      ''',
          'جدول سجل العبادات');

      // جدول سجل الخواطر
      await _createTable(
          db,
          '''
        CREATE TABLE IF NOT EXISTS $tableThoughtsLog (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          precentOf0 INTEGER NOT NULL,
          precentOf1 INTEGER NOT NULL,
          precentOf2 INTEGER NOT NULL,
          totalday INTEGER NOT NULL
        )
      ''',
          'جدول سجل الخواطر');

      // جدول الخواطر
      await _createTable(
          db,
          '''
        CREATE TABLE IF NOT EXISTS $tableThoughts (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          content TEXT NOT NULL,
          category INTEGER NOT NULL,
          date TEXT NOT NULL
        )
      ''',
          'جدول الخواطر');

      // جدول الرسائل اليومية
      print('جاري إنشاء جدول الرسائل اليومية...');
      await _createTable(
          db,
          '''
        CREATE TABLE IF NOT EXISTS $tableDailyMessages (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          content TEXT NOT NULL,
          date TEXT NOT NULL,
          category TEXT NOT NULL,
          source TEXT
        )
      ''',
          'جدول الرسائل اليومية');
      print('تم إنشاء جدول الرسائل اليومية بنجاح');

      // إضافة رسائل يومية افتراضية
      print('جاري إضافة الرسائل الافتراضية...');
      List<Map<String, dynamic>> defaultMessages = [
        {
          'title': 'فضل الذكر',
          'content':
              'قال رسول الله ﷺ: «مثل الذي يذكر ربه والذي لا يذكر ربه مثل الحي والميت»',
          'category': 'الأذكار',
          'source': 'صحيح البخاري',
          'created_at': DateTime(2025, 6, 6),
        },
        {
          'title': 'فضل الصلاة',
          'content':
              'قال رسول الله ﷺ: «الصلوات الخمس، والجمعة إلى الجمعة، كفارة لما بينهن، ما لم تغش الكبائر»',
          'category': 'الصلاة',
          'source': 'صحيح مسلم',
          'created_at': DateTime(2025, 6, 7),
        },
        {
          'title': 'فضل الصيام',
          'content':
              'قال رسول الله ﷺ: «إذا كان يوم صوم أحدكم فلا يرفث ولا يصخب، فإن سابه أحد أو قاتله فليقل: إني صائم»',
          'category': 'الصيام',
          'source': 'سنن الترمذي',
          'created_at': DateTime(2025, 6, 8),
        },
        {
          'title': 'فضل الصدقة',
          'content':
              'قال رسول الله ﷺ: «الصدقة تطفئ الخطيئة كما يطفئ الماء النار»',
          'category': 'الصدقة',
          'source': 'سنن أبي داوود',
          'created_at': DateTime(2025, 6, 9),
        },
        {
          'title': 'آداب الحديث',
          'content':
              'قال رسول الله ﷺ: «من كان يؤمن بالله واليوم الآخر فليقل خيرًا أو ليصمت»',
          'category': 'الآداب',
          'source': 'صحيح البخاري',
          'created_at': DateTime(2025, 6, 10),
        },
        {
          'title': 'فضل الذكر',
          'content':
              'قال رسول الله ﷺ: «مثل الذي يذكر ربه والذي لا يذكر ربه مثل الحي والميت»',
          'category': 'الأذكار',
          'source': 'سنن أبي داوود',
          'created_at': DateTime(2025, 6, 11),
        },
        {
          'title': 'فضل الصلاة',
          'content':
              'قال رسول الله ﷺ: «الصلوات الخمس، والجمعة إلى الجمعة، كفارة لما بينهن، ما لم تغش الكبائر»',
          'category': 'الصلاة',
          'source': 'سنن الترمذي',
          'created_at': DateTime(2025, 6, 12),
        },
        {
          'title': 'فضل الصيام',
          'content':
              'قال رسول الله ﷺ: «إذا كان يوم صوم أحدكم فلا يرفث ولا يصخب، فإن سابه أحد أو قاتله فليقل: إني صائم»',
          'category': 'الصيام',
          'source': 'سنن أبي داوود',
          'created_at': DateTime(2025, 6, 13),
        },
        {
          'title': 'فضل الصدقة',
          'content':
              'قال رسول الله ﷺ: «الصدقة تطفئ الخطيئة كما يطفئ الماء النار»',
          'category': 'الصدقة',
          'source': 'صحيح البخاري',
          'created_at': DateTime(2025, 6, 14),
        },
        {
          'title': 'آداب الحديث',
          'content':
              'قال رسول الله ﷺ: «من كان يؤمن بالله واليوم الآخر فليقل خيرًا أو ليصمت»',
          'category': 'الآداب',
          'source': 'صحيح مسلم',
          'created_at': DateTime(2025, 6, 15),
        },
        {
          'title': 'فضل الذكر',
          'content':
              'قال رسول الله ﷺ: «مثل الذي يذكر ربه والذي لا يذكر ربه مثل الحي والميت»',
          'category': 'الأذكار',
          'source': 'سنن الترمذي',
          'created_at': DateTime(2025, 6, 16),
        },
        {
          'title': 'فضل الصلاة',
          'content':
              'قال رسول الله ﷺ: «الصلوات الخمس، والجمعة إلى الجمعة، كفارة لما بينهن، ما لم تغش الكبائر»',
          'category': 'الصلاة',
          'source': 'سنن أبي داوود',
          'created_at': DateTime(2025, 6, 17),
        },
        {
          'title': 'فضل الصيام',
          'content':
              'قال رسول الله ﷺ: «إذا كان يوم صوم أحدكم فلا يرفث ولا يصخب، فإن سابه أحد أو قاتله فليقل: إني صائم»',
          'category': 'الصيام',
          'source': 'صحيح البخاري',
          'created_at': DateTime(2025, 6, 18),
        },
        {
          'title': 'فضل الصدقة',
          'content':
              'قال رسول الله ﷺ: «الصدقة تطفئ الخطيئة كما يطفئ الماء النار»',
          'category': 'الصدقة',
          'source': 'صحيح مسلم',
          'created_at': DateTime(2025, 6, 19),
        },
        {
          'title': 'آداب الحديث',
          'content':
              'قال رسول الله ﷺ: «من كان يؤمن بالله واليوم الآخر فليقل خيرًا أو ليصمت»',
          'category': 'الآداب',
          'source': 'سنن الترمذي',
          'created_at': DateTime(2025, 6, 20),
        },
        {
          'title': 'فضل الذكر',
          'content':
              'قال رسول الله ﷺ: «مثل الذي يذكر ربه والذي لا يذكر ربه مثل الحي والميت»',
          'category': 'الأذكار',
          'source': 'سنن أبي داوود',
          'created_at': DateTime(2025, 6, 21),
        },
        {
          'title': 'فضل الصلاة',
          'content':
              'قال رسول الله ﷺ: «الصلوات الخمس، والجمعة إلى الجمعة، كفارة لما بينهن، ما لم تغش الكبائر»',
          'category': 'الصلاة',
          'source': 'صحيح البخاري',
          'created_at': DateTime(2025, 6, 22),
        },
        {
          'title': 'فضل الصيام',
          'content':
              'قال رسول الله ﷺ: «إذا كان يوم صوم أحدكم فلا يرفث ولا يصخب، فإن سابه أحد أو قاتله فليقل: إني صائم»',
          'category': 'الصيام',
          'source': 'صحيح مسلم',
          'created_at': DateTime(2025, 6, 23),
        },
        {
          'title': 'فضل الصدقة',
          'content':
              'قال رسول الله ﷺ: «الصدقة تطفئ الخطيئة كما يطفئ الماء النار»',
          'category': 'الصدقة',
          'source': 'سنن الترمذي',
          'created_at': DateTime(2025, 6, 24),
        },
        {
          'title': 'آداب الحديث',
          'content':
              'قال رسول الله ﷺ: «من كان يؤمن بالله واليوم الآخر فليقل خيرًا أو ليصمت»',
          'category': 'الآداب',
          'source': 'سنن أبي داوود',
          'created_at': DateTime(2025, 6, 25),
        },
        {
          'title': 'فضل الذكر',
          'content':
              'قال رسول الله ﷺ: «مثل الذي يذكر ربه والذي لا يذكر ربه مثل الحي والميت»',
          'category': 'الأذكار',
          'source': 'سنن الترمذي',
          'created_at': DateTime(2025, 6, 26),
        },
        {
          'title': 'فضل الصلاة',
          'content':
              'قال رسول الله ﷺ: «الصلوات الخمس، والجمعة إلى الجمعة، كفارة لما بينهن، ما لم تغش الكبائر»',
          'category': 'الصلاة',
          'source': 'سنن أبي داوود',
          'created_at': DateTime(2025, 6, 27),
        },
        {
          'title': 'فضل الصيام',
          'content':
              'قال رسول الله ﷺ: «إذا كان يوم صوم أحدكم فلا يرفث ولا يصخب، فإن سابه أحد أو قاتله فليقل: إني صائم»',
          'category': 'الصيام',
          'source': 'صحيح البخاري',
          'created_at': DateTime(2025, 6, 28),
        },
        {
          'title': 'فضل الصدقة',
          'content':
              'قال رسول الله ﷺ: «الصدقة تطفئ الخطيئة كما يطفئ الماء النار»',
          'category': 'الصدقة',
          'source': 'سنن أبي داوود',
          'created_at': DateTime(2025, 6, 29),
        },
        {
          'title': 'آداب الحديث',
          'content':
              'قال رسول الله ﷺ: «من كان يؤمن بالله واليوم الآخر فليقل خيرًا أو ليصمت»',
          'category': 'الآداب',
          'source': 'صحيح البخاري',
          'created_at': DateTime(2025, 6, 30),
        },
        {
          'title': 'فضل الذكر',
          'content':
              'قال رسول الله ﷺ: «مثل الذي يذكر ربه والذي لا يذكر ربه مثل الحي والميت»',
          'category': 'الأذكار',
          'source': 'صحيح مسلم',
          'created_at': DateTime(2025, 7, 1),
        },
        {
          'title': 'فضل الصلاة',
          'content':
              'قال رسول الله ﷺ: «الصلوات الخمس، والجمعة إلى الجمعة، كفارة لما بينهن، ما لم تغش الكبائر»',
          'category': 'الصلاة',
          'source': 'سنن الترمذي',
          'created_at': DateTime(2025, 7, 2),
        },
        {
          'title': 'فضل الصيام',
          'content':
              'قال رسول الله ﷺ: «إذا كان يوم صوم أحدكم فلا يرفث ولا يصخب، فإن سابه أحد أو قاتله فليقل: إني صائم»',
          'category': 'الصيام',
          'source': 'سنن أبي داوود',
          'created_at': DateTime(2025, 7, 3),
        },
        {
          'title': 'فضل الصدقة',
          'content':
              'قال رسول الله ﷺ: «الصدقة تطفئ الخطيئة كما يطفئ الماء النار»',
          'category': 'الصدقة',
          'source': 'صحيح البخاري',
          'created_at': DateTime(2025, 7, 4),
        },
        {
          'title': 'آداب الحديث',
          'content':
              'قال رسول الله ﷺ: «من كان يؤمن بالله واليوم الآخر فليقل خيرًا أو ليصمت»',
          'category': 'الآداب',
          'source': 'صحيح مسلم',
          'created_at': DateTime(2025, 7, 5),
        },
        {
          'title': 'فضل الذكر',
          'content':
              'قال رسول الله ﷺ: «مثل الذي يذكر ربه والذي لا يذكر ربه مثل الحي والميت»',
          'category': 'الأذكار',
          'source': 'سنن الترمذي',
          'created_at': DateTime(2025, 7, 6),
        },
        {
          'title': 'فضل الصلاة',
          'content':
              'قال رسول الله ﷺ: «الصلوات الخمس، والجمعة إلى الجمعة، كفارة لما بينهن، ما لم تغش الكبائر»',
          'category': 'الصلاة',
          'source': 'سنن أبي داوود',
          'created_at': DateTime(2025, 7, 7),
        },
        {
          'title': 'فضل الصيام',
          'content':
              'قال رسول الله ﷺ: «إذا كان يوم صوم أحدكم فلا يرفث ولا يصخب، فإن سابه أحد أو قاتله فليقل: إني صائم»',
          'category': 'الصيام',
          'source': 'صحيح البخاري',
          'created_at': DateTime(2025, 7, 8),
        },
        {
          'title': 'فضل الصدقة',
          'content':
              'قال رسول الله ﷺ: «الصدقة تطفئ الخطيئة كما يطفئ الماء النار»',
          'category': 'الصدقة',
          'source': 'صحيح مسلم',
          'created_at': DateTime(2025, 7, 9),
        },
        {
          'title': 'آداب الحديث',
          'content':
              'قال رسول الله ﷺ: «من كان يؤمن بالله واليوم الآخر فليقل خيرًا أو ليصمت»',
          'category': 'الآداب',
          'source': 'سنن الترمذي',
          'created_at': DateTime(2025, 7, 10),
        },
        {
          'title': 'فضل الذكر',
          'content':
              'قال رسول الله ﷺ: «مثل الذي يذكر ربه والذي لا يذكر ربه مثل الحي والميت»',
          'category': 'الأذكار',
          'source': 'سنن أبي داوود',
          'created_at': DateTime(2025, 7, 11),
        },
        {
          'title': 'فضل الصلاة',
          'content':
              'قال رسول الله ﷺ: «الصلوات الخمس، والجمعة إلى الجمعة، كفارة لما بينهن، ما لم تغش الكبائر»',
          'category': 'الصلاة',
          'source': 'صحيح البخاري',
          'created_at': DateTime(2025, 7, 12),
        },
        {
          'title': 'فضل الصيام',
          'content':
              'قال رسول الله ﷺ: «إذا كان يوم صوم أحدكم فلا يرفث ولا يصخب، فإن سابه أحد أو قاتله فليقل: إني صائم»',
          'category': 'الصيام',
          'source': 'صحيح مسلم',
          'created_at': DateTime(2025, 7, 13),
        },
        {
          'title': 'فضل الصدقة',
          'content':
              'قال رسول الله ﷺ: «الصدقة تطفئ الخطيئة كما يطفئ الماء النار»',
          'category': 'الصدقة',
          'source': 'سنن الترمذي',
          'created_at': DateTime(2025, 7, 14),
        },
        {
          'title': 'آداب الحديث',
          'content':
              'قال رسول الله ﷺ: «من كان يؤمن بالله واليوم الآخر فليقل خيرًا أو ليصمت»',
          'category': 'الآداب',
          'source': 'سنن أبي داوود',
          'created_at': DateTime(2025, 7, 15),
        },
        {
          'title': 'فضل الذكر',
          'content':
              'قال رسول الله ﷺ: «مثل الذي يذكر ربه والذي لا يذكر ربه مثل الحي والميت»',
          'category': 'الأذكار',
          'source': 'صحيح البخاري',
          'created_at': DateTime(2025, 7, 16),
        },
        {
          'title': 'فضل الصلاة',
          'content':
              'قال رسول الله ﷺ: «الصلوات الخمس، والجمعة إلى الجمعة، كفارة لما بينهن، ما لم تغش الكبائر»',
          'category': 'الصلاة',
          'source': 'صحيح مسلم',
          'created_at': DateTime(2025, 7, 17),
        },
        {
          'title': 'فضل الصيام',
          'content':
              'قال رسول الله ﷺ: «إذا كان يوم صوم أحدكم فلا يرفث ولا يصخب، فإن سابه أحد أو قاتله فليقل: إني صائم»',
          'category': 'الصيام',
          'source': 'سنن الترمذي',
          'created_at': DateTime(2025, 7, 18),
        },
        {
          'title': 'فضل الصدقة',
          'content':
              'قال رسول الله ﷺ: «الصدقة تطفئ الخطيئة كما يطفئ الماء النار»',
          'category': 'الصدقة',
          'source': 'سنن أبي داوود',
          'created_at': DateTime(2025, 7, 19),
        },
        {
          'title': 'آداب الحديث',
          'content':
              'قال رسول الله ﷺ: «من كان يؤمن بالله واليوم الآخر فليقل خيرًا أو ليصمت»',
          'category': 'الآداب',
          'source': 'صحيح البخاري',
          'created_at': DateTime(2025, 7, 20),
        },
        {
          'title': 'فضل الذكر',
          'content':
              'قال رسول الله ﷺ: «مثل الذي يذكر ربه والذي لا يذكر ربه مثل الحي والميت»',
          'category': 'الأذكار',
          'source': 'صحيح مسلم',
          'created_at': DateTime(2025, 7, 21),
        },
        {
          'title': 'فضل الصلاة',
          'content':
              'قال رسول الله ﷺ: «الصلوات الخمس، والجمعة إلى الجمعة، كفارة لما بينهن، ما لم تغش الكبائر»',
          'category': 'الصلاة',
          'source': 'سنن الترمذي',
          'created_at': DateTime(2025, 7, 22),
        },
        {
          'title': 'فضل الصيام',
          'content':
              'قال رسول الله ﷺ: «إذا كان يوم صوم أحدكم فلا يرفث ولا يصخب، فإن سابه أحد أو قاتله فليقل: إني صائم»',
          'category': 'الصيام',
          'source': 'سنن أبي داوود',
          'created_at': DateTime(2025, 7, 23),
        },
        {
          'title': 'فضل الصدقة',
          'content':
              'قال رسول الله ﷺ: «الصدقة تطفئ الخطيئة كما يطفئ الماء النار»',
          'category': 'الصدقة',
          'source': 'صحيح البخاري',
          'created_at': DateTime(2025, 7, 24),
        },
        {
          'title': 'آداب الحديث',
          'content':
              'قال رسول الله ﷺ: «من كان يؤمن بالله واليوم الآخر فليقل خيرًا أو ليصمت»',
          'category': 'الآداب',
          'source': 'صحيح مسلم',
          'created_at': DateTime(2025, 7, 25),
        },
        {
          'title': 'فضل الذكر',
          'content':
              'قال رسول الله ﷺ: «مثل الذي يذكر ربه والذي لا يذكر ربه مثل الحي والميت»',
          'category': 'الأذكار',
          'source': 'سنن الترمذي',
          'created_at': DateTime(2025, 7, 26),
        },
        {
          'title': 'فضل الصلاة',
          'content':
              'قال رسول الله ﷺ: «الصلوات الخمس، والجمعة إلى الجمعة، كفارة لما بينهن، ما لم تغش الكبائر»',
          'category': 'الصلاة',
          'source': 'سنن أبي داوود',
          'created_at': DateTime(2025, 7, 27),
        },
        {
          'title': 'فضل الصيام',
          'content':
              'قال رسول الله ﷺ: «إذا كان يوم صوم أحدكم فلا يرفث ولا يصخب، فإن سابه أحد أو قاتله فليقل: إني صائم»',
          'category': 'الصيام',
          'source': 'صحيح البخاري',
          'created_at': DateTime(2025, 7, 28),
        },
        {
          'title': 'فضل الصدقة',
          'content':
              'قال رسول الله ﷺ: «الصدقة تطفئ الخطيئة كما يطفئ الماء النار»',
          'category': 'الصدقة',
          'source': 'صحيح مسلم',
          'created_at': DateTime(2025, 7, 29),
        },
        {
          'title': 'آداب الحديث',
          'content':
              'قال رسول الله ﷺ: «من كان يؤمن بالله واليوم الآخر فليقل خيرًا أو ليصمت»',
          'category': 'الآداب',
          'source': 'سنن الترمذي',
          'created_at': DateTime(2025, 7, 30),
        },
        {
          'title': 'فضل الذكر',
          'content':
              'قال رسول الله ﷺ: «مثل الذي يذكر ربه والذي لا يذكر ربه مثل الحي والميت»',
          'category': 'الأذكار',
          'source': 'سنن أبي داوود',
          'created_at': DateTime(2025, 7, 31),
        },
        {
          'title': 'فضل الصلاة',
          'content':
              'قال رسول الله ﷺ: «الصلوات الخمس، والجمعة إلى الجمعة، كفارة لما بينهن، ما لم تغش الكبائر»',
          'category': 'الصلاة',
          'source': 'صحيح البخاري',
          'created_at': DateTime(2025, 8, 1),
        },
        {
          'title': 'فضل الصيام',
          'content':
              'قال رسول الله ﷺ: «إذا كان يوم صوم أحدكم فلا يرفث ولا يصخب، فإن سابه أحد أو قاتله فليقل: إني صائم»',
          'category': 'الصيام',
          'source': 'صحيح مسلم',
          'created_at': DateTime(2025, 8, 2),
        },
        {
          'title': 'فضل الصدقة',
          'content':
              'قال رسول الله ﷺ: «الصدقة تطفئ الخطيئة كما يطفئ الماء النار»',
          'category': 'الصدقة',
          'source': 'سنن الترمذي',
          'created_at': DateTime(2025, 8, 3),
        },
        {
          'title': 'آداب الحديث',
          'content':
              'قال رسول الله ﷺ: «من كان يؤمن بالله واليوم الآخر فليقل خيرًا أو ليصمت»',
          'category': 'الآداب',
          'source': 'سنن أبي داوود',
          'created_at': DateTime(2025, 8, 4),
        },
        {
          'title': 'فضل الذكر',
          'content':
              'قال رسول الله ﷺ: «مثل الذي يذكر ربه والذي لا يذكر ربه مثل الحي والميت»',
          'category': 'الأذكار',
          'source': 'صحيح البخاري',
          'created_at': DateTime(2025, 8, 5),
        },
        {
          'title': 'فضل الصلاة',
          'content':
              'قال رسول الله ﷺ: «الصلوات الخمس، والجمعة إلى الجمعة، كفارة لما بينهن، ما لم تغش الكبائر»',
          'category': 'الصلاة',
          'source': 'صحيح مسلم',
          'created_at': DateTime(2025, 8, 6),
        },
        {
          'title': 'فضل الصيام',
          'content':
              'قال رسول الله ﷺ: «إذا كان يوم صوم أحدكم فلا يرفث ولا يصخب، فإن سابه أحد أو قاتله فليقل: إني صائم»',
          'category': 'الصيام',
          'source': 'سنن الترمذي',
          'created_at': DateTime(2025, 8, 7),
        },
        {
          'title': 'فضل الصدقة',
          'content':
              'قال رسول الله ﷺ: «الصدقة تطفئ الخطيئة كما يطفئ الماء النار»',
          'category': 'الصدقة',
          'source': 'سنن أبي داوود',
          'created_at': DateTime(2025, 8, 8),
        },
        {
          'title': 'آداب الحديث',
          'content':
              'قال رسول الله ﷺ: «من كان يؤمن بالله واليوم الآخر فليقل خيرًا أو ليصمت»',
          'category': 'الآداب',
          'source': 'صحيح البخاري',
          'created_at': DateTime(2025, 8, 9),
        },
        {
          'title': 'فضل الذكر',
          'content':
              'قال رسول الله ﷺ: «مثل الذي يذكر ربه والذي لا يذكر ربه مثل الحي والميت»',
          'category': 'الأذكار',
          'source': 'صحيح مسلم',
          'created_at': DateTime(2025, 8, 10),
        },
        {
          'title': 'فضل الصلاة',
          'content':
              'قال رسول الله ﷺ: «الصلوات الخمس، والجمعة إلى الجمعة، كفارة لما بينهن، ما لم تغش الكبائر»',
          'category': 'الصلاة',
          'source': 'سنن الترمذي',
          'created_at': DateTime(2025, 8, 11),
        },
        {
          'title': 'فضل الصيام',
          'content':
              'قال رسول الله ﷺ: «إذا كان يوم صوم أحدكم فلا يرفث ولا يصخب، فإن سابه أحد أو قاتله فليقل: إني صائم»',
          'category': 'الصيام',
          'source': 'سنن أبي داوود',
          'created_at': DateTime(2025, 8, 12),
        },
        {
          'title': 'فضل الصدقة',
          'content':
              'قال رسول الله ﷺ: «الصدقة تطفئ الخطيئة كما يطفئ الماء النار»',
          'category': 'الصدقة',
          'source': 'صحيح البخاري',
          'created_at': DateTime(2025, 8, 13),
        },
        {
          'title': 'آداب الحديث',
          'content':
              'قال رسول الله ﷺ: «من كان يؤمن بالله واليوم الآخر فليقل خيرًا أو ليصمت»',
          'category': 'الآداب',
          'source': 'صحيح مسلم',
          'created_at': DateTime(2025, 8, 14),
        },
        {
          'title': 'فضل الذكر',
          'content':
              'قال رسول الله ﷺ: «مثل الذي يذكر ربه والذي لا يذكر ربه مثل الحي والميت»',
          'category': 'الأذكار',
          'source': 'سنن الترمذي',
          'created_at': DateTime(2025, 8, 15),
        },
        {
          'title': 'فضل الصلاة',
          'content':
              'قال رسول الله ﷺ: «الصلوات الخمس، والجمعة إلى الجمعة، كفارة لما بينهن، ما لم تغش الكبائر»',
          'category': 'الصلاة',
          'source': 'سنن أبي داوود',
          'created_at': DateTime(2025, 8, 16),
        },
        {
          'title': 'فضل الصيام',
          'content':
              'قال رسول الله ﷺ: «إذا كان يوم صوم أحدكم فلا يرفث ولا يصخب، فإن سابه أحد أو قاتله فليقل: إني صائم»',
          'category': 'الصيام',
          'source': 'صحيح البخاري',
          'created_at': DateTime(2025, 8, 17),
        },
        {
          'title': 'فضل الصدقة',
          'content':
              'قال رسول الله ﷺ: «الصدقة تطفئ الخطيئة كما يطفئ الماء النار»',
          'category': 'الصدقة',
          'source': 'صحيح مسلم',
          'created_at': DateTime(2025, 8, 18),
        },
        {
          'title': 'آداب الحديث',
          'content':
              'قال رسول الله ﷺ: «من كان يؤمن بالله واليوم الآخر فليقل خيرًا أو ليصمت»',
          'category': 'الآداب',
          'source': 'سنن الترمذي',
          'created_at': DateTime(2025, 8, 19),
        },
        {
          'title': 'فضل الذكر',
          'content':
              'قال رسول الله ﷺ: «مثل الذي يذكر ربه والذي لا يذكر ربه مثل الحي والميت»',
          'category': 'الأذكار',
          'source': 'سنن أبي داوود',
          'created_at': DateTime(2025, 8, 20),
        },
        {
          'title': 'فضل الصلاة',
          'content':
              'قال رسول الله ﷺ: «الصلوات الخمس، والجمعة إلى الجمعة، كفارة لما بينهن، ما لم تغش الكبائر»',
          'category': 'الصلاة',
          'source': 'صحيح البخاري',
          'created_at': DateTime(2025, 8, 21),
        },
        {
          'title': 'فضل الصيام',
          'content':
              'قال رسول الله ﷺ: «إذا كان يوم صوم أحدكم فلا يرفث ولا يصخب، فإن سابه أحد أو قاتله فليقل: إني صائم»',
          'category': 'الصيام',
          'source': 'صحيح مسلم',
          'created_at': DateTime(2025, 8, 22),
        },
        {
          'title': 'فضل الصدقة',
          'content':
              'قال رسول الله ﷺ: «الصدقة تطفئ الخطيئة كما يطفئ الماء النار»',
          'category': 'الصدقة',
          'source': 'سنن الترمذي',
          'created_at': DateTime(2025, 8, 23),
        },
        {
          'title': 'آداب الحديث',
          'content':
              'قال رسول الله ﷺ: «من كان يؤمن بالله واليوم الآخر فليقل خيرًا أو ليصمت»',
          'category': 'الآداب',
          'source': 'سنن أبي داوود',
          'created_at': DateTime(2025, 8, 24),
        },
        {
          'title': 'فضل الذكر',
          'content':
              'قال رسول الله ﷺ: «مثل الذي يذكر ربه والذي لا يذكر ربه مثل الحي والميت»',
          'category': 'الأذكار',
          'source': 'صحيح البخاري',
          'created_at': DateTime(2025, 8, 25),
        },
        {
          'title': 'فضل الصلاة',
          'content':
              'قال رسول الله ﷺ: «الصلوات الخمس، والجمعة إلى الجمعة، كفارة لما بينهن، ما لم تغش الكبائر»',
          'category': 'الصلاة',
          'source': 'صحيح مسلم',
          'created_at': DateTime(2025, 8, 26),
        },
        {
          'title': 'فضل الصيام',
          'content':
              'قال رسول الله ﷺ: «إذا كان يوم صوم أحدكم فلا يرفث ولا يصخب، فإن سابه أحد أو قاتله فليقل: إني صائم»',
          'category': 'الصيام',
          'source': 'سنن الترمذي',
          'created_at': DateTime(2025, 8, 27),
        },
        {
          'title': 'فضل الصدقة',
          'content':
              'قال رسول الله ﷺ: «الصدقة تطفئ الخطيئة كما يطفئ الماء النار»',
          'category': 'الصدقة',
          'source': 'سنن أبي داوود',
          'created_at': DateTime(2025, 8, 28),
        },
        {
          'title': 'آداب الحديث',
          'content':
              'قال رسول الله ﷺ: «من كان يؤمن بالله واليوم الآخر فليقل خيرًا أو ليصمت»',
          'category': 'الآداب',
          'source': 'صحيح البخاري',
          'created_at': DateTime(2025, 8, 29),
        },
        {
          'title': 'فضل الذكر',
          'content':
              'قال رسول الله ﷺ: «مثل الذي يذكر ربه والذي لا يذكر ربه مثل الحي والميت»',
          'category': 'الأذكار',
          'source': 'صحيح مسلم',
          'created_at': DateTime(2025, 8, 30),
        },
        {
          'title': 'فضل الصلاة',
          'content':
              'قال رسول الله ﷺ: «الصلوات الخمس، والجمعة إلى الجمعة، كفارة لما بينهن، ما لم تغش الكبائر»',
          'category': 'الصلاة',
          'source': 'سنن الترمذي',
          'created_at': DateTime(2025, 8, 31),
        },
        {
          'title': 'فضل الصيام',
          'content':
              'قال رسول الله ﷺ: «إذا كان يوم صوم أحدكم فلا يرفث ولا يصخب، فإن سابه أحد أو قاتله فليقل: إني صائم»',
          'category': 'الصيام',
          'source': 'سنن أبي داوود',
          'created_at': DateTime(2025, 9, 1),
        },
        {
          'title': 'فضل الصدقة',
          'content':
              'قال رسول الله ﷺ: «الصدقة تطفئ الخطيئة كما يطفئ الماء النار»',
          'category': 'الصدقة',
          'source': 'صحيح البخاري',
          'created_at': DateTime(2025, 9, 2),
        },
        {
          'title': 'آداب الحديث',
          'content':
              'قال رسول الله ﷺ: «من كان يؤمن بالله واليوم الآخر فليقل خيرًا أو ليصمت»',
          'category': 'الآداب',
          'source': 'صحيح مسلم',
          'created_at': DateTime(2025, 9, 3),
        },
        {
          'title': 'فضل الذكر',
          'content':
              'قال رسول الله ﷺ: «مثل الذي يذكر ربه والذي لا يذكر ربه مثل الحي والميت»',
          'category': 'الأذكار',
          'source': 'سنن الترمذي',
          'created_at': DateTime(2025, 9, 4),
        },
        {
          'title': 'فضل الصلاة',
          'content':
              'قال رسول الله ﷺ: «الصلوات الخمس، والجمعة إلى الجمعة، كفارة لما بينهن، ما لم تغش الكبائر»',
          'category': 'الصلاة',
          'source': 'سنن أبي داوود',
          'created_at': DateTime(2025, 9, 5),
        },
        {
          'title': 'فضل الصيام',
          'content':
              'قال رسول الله ﷺ: «إذا كان يوم صوم أحدكم فلا يرفث ولا يصخب، فإن سابه أحد أو قاتله فليقل: إني صائم»',
          'category': 'الصيام',
          'source': 'صحيح البخاري',
          'created_at': DateTime(2025, 9, 6),
        },
        {
          'title': 'فضل الصدقة',
          'content':
              'قال رسول الله ﷺ: «الصدقة تطفئ الخطيئة كما يطفئ الماء النار»',
          'category': 'الصدقة',
          'source': 'صحيح مسلم',
          'created_at': DateTime(2025, 9, 7),
        },
        {
          'title': 'آداب الحديث',
          'content':
              'قال رسول الله ﷺ: «من كان يؤمن بالله واليوم الآخر فليقل خيرًا أو ليصمت»',
          'category': 'الآداب',
          'source': 'سنن الترمذي',
          'created_at': DateTime(2025, 9, 8),
        },
        {
          'title': 'فضل الذكر',
          'content':
              'قال رسول الله ﷺ: «مثل الذي يذكر ربه والذي لا يذكر ربه مثل الحي والميت»',
          'category': 'الأذكار',
          'source': 'سنن أبي داوود',
          'created_at': DateTime(2025, 9, 9),
        },
        {
          'title': 'فضل الصلاة',
          'content':
              'قال رسول الله ﷺ: «الصلوات الخمس، والجمعة إلى الجمعة، كفارة لما بينهن، ما لم تغش الكبائر»',
          'category': 'الصلاة',
          'source': 'صحيح البخاري',
          'created_at': DateTime(2025, 9, 10),
        },
        {
          'title': 'فضل الصيام',
          'content':
              'قال رسول الله ﷺ: «إذا كان يوم صوم أحدكم فلا يرفث ولا يصخب، فإن سابه أحد أو قاتله فليقل: إني صائم»',
          'category': 'الصيام',
          'source': 'صحيح مسلم',
          'created_at': DateTime(2025, 9, 11),
        },
        {
          'title': 'فضل الصدقة',
          'content':
              'قال رسول الله ﷺ: «الصدقة تطفئ الخطيئة كما يطفئ الماء النار»',
          'category': 'الصدقة',
          'source': 'سنن الترمذي',
          'created_at': DateTime(2025, 9, 12),
        },
        {
          'title': 'آداب الحديث',
          'content':
              'قال رسول الله ﷺ: «من كان يؤمن بالله واليوم الآخر فليقل خيرًا أو ليصمت»',
          'category': 'الآداب',
          'source': 'سنن أبي داوود',
          'created_at': DateTime(2025, 9, 13),
        },
      ];

      for (var message in defaultMessages) {
        // تحويل DateTime إلى نص
        final messageMap = Map<String, dynamic>.from(message);
        messageMap['date'] = (messageMap['created_at'] as DateTime)
            .toIso8601String()
            .split('T')[0];
        messageMap.remove('created_at');
        await db.insert(tableDailyMessages, messageMap);
      }

      // جدول مكتبتي
      await _createTable(
          db,
          '''
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
      ''',
          'جدول مكتبتي');

      // جدول إشعارات الصلاة
      await _createTable(
          db,
          '''
        CREATE TABLE IF NOT EXISTS $tablePrayerNotifications (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          prayer_name TEXT NOT NULL,
          is_enabled INTEGER NOT NULL DEFAULT 1,
          minutes_before INTEGER NOT NULL DEFAULT 15,
          use_adhan INTEGER NOT NULL DEFAULT 1,
          custom_sound TEXT,
          vibration_pattern TEXT
        )
      ''',
          'جدول إشعارات الصلاة');

      // جدول الدروس
      await _createTable(
          db,
          '''
      CREATE TABLE IF NOT EXISTS $tableLessons (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
          category TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        video_id TEXT NOT NULL,
          type TEXT NOT NULL,
          is_completed INTEGER NOT NULL DEFAULT 0
      )
    ''',
          'جدول الدروس');

      // جدول الملاحظات
      await _createTable(
          db,
          '''
        CREATE TABLE IF NOT EXISTS $tableNotes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
          lesson_id INTEGER NOT NULL,
        content TEXT NOT NULL,
        created_at INTEGER NOT NULL,
          FOREIGN KEY (lesson_id) REFERENCES $tableLessons (id)
      )
    ''',
          'جدول الملاحظات');

      // جدول الأذكار
      await _createTable(
          db,
          '''
        CREATE TABLE IF NOT EXISTS $tableAthkar (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          content TEXT NOT NULL
        )
      ''',
          'جدول الأذكار');

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
          category:
              "خريطة العلوم م. أيمن + مدخل الى اللغة العربية ا. أحمد السيد ",
          title: "title1-890",
          description: "description1",
          videoId: "bVOrIqeJ3XE",
          type: "المقرر العلمي",
        ),
        Lesson(
          category:
              "خريطة العلوم م. أيمن + مدخل الى اللغة العربية ا. أحمد السيد ",
          title: "title1-345",
          description: "description1",
          videoId: "bVOrIqeJ3XE",
          type: "المقرر العلمي",
        ),
        Lesson(
          category:
              "خريطة العلوم م. أيمن + مدخل الى اللغة العربية ا. أحمد السيد ",
          title: "title1-678",
          description: "description1",
          videoId: "bVOrIqeJ3XE",
          type: "المقرر العلمي",
        ),
        Lesson(
          category:
              "خريطة العلوم م. أيمن + مدخل الى اللغة العربية ا. أحمد السيد ",
          title: "title1-901",
          description: "description1",
          videoId: "bVOrIqeJ3XE",
          type: "المقرر العلمي",
        ),
        Lesson(
          category:
              "خريطة العلوم م. أيمن + مدخل الى اللغة العربية ا. أحمد السيد ",
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

      for (var lesson in defaultLessons) {
        await db.insert(tableLessons, lesson.toMap());
      }

      // إضافة الأذكار الافتراضية
      final defaultAthkar = [
        {
          'title': 'أذكار الصباح',
          'content':
              'أَعُوذُ بِاللهِ مِنَ الشَّيْطَانِ الرَّجِيمِ\nاللّهُ لاَ إِلَـهَ إِلاَّ هُوَ الْحَيُّ الْقَيُّومُ لاَ تَأْخُذُهُ سِنَةٌ وَلاَ نَوْمٌ...'
        },
        {
          'title': 'أذكار المساء',
          'content':
              'أَعُوذُ بِاللهِ مِنَ الشَّيْطَانِ الرَّجِيمِ\nاللّهُ لاَ إِلَـهَ إِلاَّ هُوَ الْحَيُّ الْقَيُّومُ لاَ تَأْخُذُهُ سِنَةٌ وَلاَ نَوْمٌ...'
        },
        {
          'title': 'أذكار النوم',
          'content': 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا'
        },
        {
          'title': 'أذكار دخول المنزل',
          'content':
              'بِسْمِ اللهِ وَلَجْنَا، وَبِسْمِ اللهِ خَرَجْنَا، وَعَلَى رَبِّنَا تَوَكَّلْنَا'
        }
      ];

      for (var athkar in defaultAthkar) {
        await db.insert(tableAthkar, athkar);
      }

      await db.execute('''
        CREATE TABLE IF NOT EXISTS $tableHadiths (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          text TEXT NOT NULL,
          narrator TEXT NOT NULL,
          topic TEXT NOT NULL
        )
      ''');

      final defaultHadiths = [
        {
          'text':
              'إِنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ، وَإِنَّمَا لِكُلِّ امْرِئٍ مَا نَوَى',
          'narrator': 'عمر بن الخطاب',
          'topic': 'النية'
        },
        {
          'text':
              'مَنْ حَسَّنَ إِسْلَامَهُ، كَانَ لَهُ كَفَّارَةً لِمَا سَلَفَ',
          'narrator': 'أبو هريرة',
          'topic': 'الإسلام'
        }
      ];

      for (var hadith in defaultHadiths) {
        await db.insert(tableHadiths, hadith);
      }

      await db.execute('''
        CREATE TABLE IF NOT EXISTS $tableQuranDuas (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          text TEXT NOT NULL,
          source TEXT NOT NULL,
          theme TEXT NOT NULL
        )
      ''');

      final defaultQuranDuas = [
        {
          'text':
              'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
          'source': 'البقرة: 201',
          'theme': 'الدعاء'
        },
        {
          'text': 'رَبِّ اشْرَحْ لِي صَدْرِي * وَيَسِّرْ لِي أَمْرِي',
          'source': 'طه: 25-26',
          'theme': 'التيسير'
        }
      ];

      for (var dua in defaultQuranDuas) {
        await db.insert(tableQuranDuas, dua);
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
}
