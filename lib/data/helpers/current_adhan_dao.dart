import '../models/current_adhan.dart';
import '../database/database.dart';
import '../database/database_helper.dart';
import 'current_location_dao.dart';

/// فئة للتعامل مع بيانات الصلاة الحالية في قاعدة البيانات
class CurrentAdhanDao {
  final _databaseHelper = DatabaseHelper.instance;
  final String _tableName = AppDatabase.tableCurrentPrayer;
  final CurrentLocationDao _currentLocationDao = CurrentLocationDao();

  /// تحديث بيانات الصلاة الحالية
  Future<int> ChangeCurrentAdhan(CurrentAdhan updatedAdhan) async {
    try {
      print('جاري تحديث أوقات الصلاة: ${updatedAdhan.toString()}');
      final result = await _databaseHelper.update(
        _tableName,
        updatedAdhan.toMap(),
        'id = ?',
        [1],
      );
      print('تم تحديث أوقات الصلاة بنجاح: $result');
      return result;
    } catch (e) {
      print('خطأ في تحديث أوقات الصلاة: $e');
      rethrow;
    }
  }

  /// إصلاح جدول الأذان الحالي إذا كان فارغاً
  Future<void> fixEmptyCurrentAdhanTable() async {
    try {
      final db = await _databaseHelper.database;

      // الحصول على التاريخ الحالي
      final now = DateTime.now();
      final formattedDate = now.toIso8601String().split('T')[0];

      // التحقق من وجود سجلات
      final existingRecords = await db.query(_tableName);
      if (existingRecords.isNotEmpty) {
        print('جدول الأذان الحالي يحتوي على سجلات: ${existingRecords.length}');
        return;
      }

      print('جاري إنشاء سجل جديد في جدول الأذان الحالي...');
      // إنشاء سجل جديد في جدول الأذان الحالي بأوقات افتراضية
      await db.insert(_tableName, {
        'id': 1,
        'location_id': 1,
        'date': formattedDate,
        'fajr_time': '00:00',
        'sunrise_time': '00:00',
        'dhuhr_time': '00:00',
        'asr_time': '00:00',
        'maghrib_time': '00:00',
        'isha_time': '00:00',
      });

      print('تم إنشاء سجل جديد في جدول الأذان الحالي بنجاح');
    } catch (e) {
      print('خطأ في إصلاح جدول الأذان الحالي: $e');
      rethrow;
    }
  }

  /// الحصول على أوقات الأذان الحالية للموقع المحدد
  Future<CurrentAdhan?> getCurrentAdhanTimes() async {
    try {
      print('جاري البحث عن أوقات الصلاة الحالية...');
      final db = await _databaseHelper.database;
      final result = await db.query(
        _tableName,
        where: 'id = ?',
        whereArgs: [1],
        limit: 1,
      );

      if (result.isNotEmpty) {
        print('تم العثور على سجل أوقات صلاة: ${result.first}');
        return CurrentAdhan.fromMap(result.first);
      } else {
        print('لم يتم العثور على سجل أوقات صلاة، جاري إنشاء سجل جديد...');
        // إذا لم يتم العثور على سجل، نقوم بإنشاء سجل جديد
        await fixEmptyCurrentAdhanTable();
        // إعادة المحاولة بعد إنشاء السجل
        final newResult = await db.query(
          _tableName,
          where: 'id = ?',
          whereArgs: [1],
          limit: 1,
        );
        if (newResult.isNotEmpty) {
          print('تم إنشاء سجل جديد بنجاح: ${newResult.first}');
          return CurrentAdhan.fromMap(newResult.first);
        }
        print('فشل في إنشاء سجل جديد لأوقات الصلاة');
        return null;
      }
    } catch (e) {
      print('خطأ في الحصول على أوقات الأذان الحالية: $e');
      return null;
    }
  }
}
