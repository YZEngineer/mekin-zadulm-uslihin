import '../models/current_location.dart';
import '../database/database_helper.dart';
import '../database/database.dart';

/// فئة للتعامل مع بيانات الموقع الحالي في قاعدة البيانات
class CurrentLocationDao {
  final _databaseHelper = DatabaseHelper.instance;
  final String _tableName = AppDatabase.tableLessons;

  /// الحصول على معرف الموقع الحالي المختار
  Future<int> getCurrentLocationId() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('current_location');

    if (maps.isEmpty) {
      throw Exception('لم يتم العثور على موقع حالي');
    }

    return maps.first['location_id'] as int;
  }

  /// الحصول على معلومات الموقع الحالي المختار
  Future<CurrentLocation> getCurrentLocation() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('current_location');

    if (maps.isEmpty) {
      // الموقع الافتراضي
      return CurrentLocation(
        id: 1,
        latitude: 00.0082,
        longitude: 00.9784,
        city: 'ss',
        country: 's',
      );
    }

    return CurrentLocation.fromMap(maps.first);
  }

  /// تحديث معلومات الموقع الحالي
  Future<void> updateCurrentLocation(CurrentLocation location) async {
    final db = await _databaseHelper.database;
    await db.update(
      'current_location',
      location.toMap(),
      where: 'id = ?',
      whereArgs: [location.id],
    );
  }

  /// إدراج موقع جديد وتعيينه كموقع حالي
  Future<int> insertCurrentLocation(CurrentLocation location) async {
    final db = await _databaseHelper.database;

    // إدراج الموقع الجديد في جدول المواقع
    final locationData = {
      'city': location.city,
      'country': location.country,
      'latitude': location.latitude,
      'longitude': location.longitude,
    };

    final newLocationId = await db.insert('locations', locationData);

    // التحقق من وجود سجل في جدول الموقع الحالي
    final currentLocationResult = await db.query('current_location');

    if (currentLocationResult.isEmpty) {
      // إدراج سجل جديد
      await db.insert('current_location', {'location_id': newLocationId});
    } else {
      // تحديث السجل الموجود
      await db.update('current_location', {'location_id': newLocationId},
          where: '1 = 1');
    }

    return newLocationId;
  }

  /// احصل على جميع المواقع المخزنة
  Future<List<CurrentLocation>> getAllLocations() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> result = await db.query('locations');

    return result
        .map((map) => CurrentLocation.fromMap({
              'location_id': map['location_id'],
              'city': map['city'],
              'country': map['country'],
              'latitude': map['latitude'],
              'longitude': map['longitude'],
              'timezone': map['timezone'],
              'madhab': map['madhab'],
              'method_id': map['method_id'],
            }))
        .toList();
  }
}
