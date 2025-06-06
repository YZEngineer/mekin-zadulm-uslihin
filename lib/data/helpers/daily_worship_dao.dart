import 'package:sqflite/sqflite.dart';
import '../models/daily_worship.dart';
import '../database/database_helper.dart';

/// فئة للتعامل مع بيانات العبادات اليومية في قاعدة البيانات
class DailyWorshipDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// إدراج عبادة يومية جديدة أو تحديث القائمة
  Future<int> insert(DailyWorship worship) async {
    final db = await _dbHelper.database;
    return await db.insert(
      'daily_worship',
      worship.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// تحديث عبادة يومية موجودة
  Future<int> update(DailyWorship worship) async {
    final db = await _dbHelper.database;
    return await db.update(
      'daily_worship',
      worship.toMap(),
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  /// تحديث حالة صلاة معينة
  Future<int> updatePrayerStatus(String prayerName, bool completed) async {
    // تحديث حالة الصلاة المحددة
    final value = completed ? 1 : 0;

    ///final columnName = '${prayerName.toLowerCase()}_prayer'; /// ادخال الاسم بشكل صحيح بدل التغيير :)
    final result = await _dbHelper.update(
      'daily_worship',
      {prayerName: value},
      'id = ?',
      [1],
    ); // استخدام معرّف ثابت = 1
    return result;
  }

  /// حذف سجل عبادة بواسطة المعرف
  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('daily_worship', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> setAllWorship(int state) async {
    final db = await _dbHelper.database;
    return await db.update(
      'daily_worship',
      {
        'fajr_prayer': state,
        'dhuhr_prayer': state,
        'asr_prayer': state,
        'maghrib_prayer': state,
        'isha_prayer': state,
        'witr': state,
        'qiyam': state,
        'quran': state,
        'thikr': state,
      },
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  Future<DailyWorship?> getById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'daily_worship',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return DailyWorship.fromMap(maps.first);
    }
    return null;
  }
}
