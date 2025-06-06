import 'package:intl/intl.dart';
import 'adhan_time.dart';
import '../../core/functions/utils.dart';

/// نموذج يمثل الأذان الحالي (الأذان النشط حالياً)
class CurrentAdhan {
  final int? id;
  final int? locationId;
  final DateTime date;
  final String fajrTime; // وقت أذان الفجر
  final String sunriseTime; // وقت الشروق
  final String dhuhrTime; // وقت أذان الظهر
  final String asrTime; // وقت أذان العصر
  final String maghribTime; // وقت أذان المغرب
  final String ishaTime; // وقت أذان العشاء

  CurrentAdhan({
    this.id,
    this.locationId,
    required this.date,
    this.fajrTime = '00:00',
    this.sunriseTime = '00:00',
    this.dhuhrTime = '00:00',
    this.asrTime = '00:00',
    this.maghribTime = '00:00',
    this.ishaTime = '00:00',
  }) {
    _validateTimes();
  }

  /// التحقق من صحة جميع الأوقات
  void _validateTimes() {
    final times = {
      'الفجر': fajrTime,
      'الشروق': sunriseTime,
      'الظهر': dhuhrTime,
      'العصر': asrTime,
      'المغرب': maghribTime,
      'العشاء': ishaTime,
    };

    for (var entry in times.entries) {
      if (!isValidTimeFormat(entry.value)) {
        throw FormatException(
            'صيغة وقت ${entry.key} غير صالحة: ${entry.value}');
      }
    }
  }

  /// التحقق من صحة صيغة الوقت
  static bool isValidTimeFormat(String time) {
    if (time.isEmpty) return false;

    final parts = time.split(':');
    if (parts.length != 2) return false;

    try {
      final hours = int.parse(parts[0]);
      final minutes = int.parse(parts[1]);

      return hours >= 0 && hours < 24 && minutes >= 0 && minutes < 60;
    } catch (e) {
      return false;
    }
  }

  factory CurrentAdhan.fromAdhanTimes(AdhanTimes adhanTimes) {
    return CurrentAdhan(
      id: 1,
      locationId: adhanTimes.locationId,
      date: adhanTimes.date,
      fajrTime: adhanTimes.fajrTime,
      sunriseTime: adhanTimes.sunriseTime,
      dhuhrTime: adhanTimes.dhuhrTime,
      asrTime: adhanTimes.asrTime,
      maghribTime: adhanTimes.maghribTime,
      ishaTime: adhanTimes.ishaTime,
    );
  }

  /// إنشاء نموذج من خريطة بيانات
  factory CurrentAdhan.fromMap(Map<String, dynamic> map) {
    try {
      // معالجة التاريخ: يمكن أن يكون إما String أو DateTime
      DateTime dateTime;
      if (map['date'] is String) {
        dateTime = DateTime.parse(map['date']);
      } else if (map['date'] is DateTime) {
        dateTime = map['date'];
      } else {
        throw FormatException('صيغة التاريخ غير صالحة: ${map['date']}');
      }

      return CurrentAdhan(
        id: map['id'] ?? 1,
        locationId: map['location_id'] ?? 1,
        date: dateTime,
        fajrTime: map['fajr_time'] ?? '00:00',
        sunriseTime: map['sunrise_time'] ?? '00:00',
        dhuhrTime: map['dhuhr_time'] ?? '00:00',
        asrTime: map['asr_time'] ?? '00:00',
        maghribTime: map['maghrib_time'] ?? '00:00',
        ishaTime: map['isha_time'] ?? '00:00',
      );
    } catch (e) {
      print('خطأ في تحويل البيانات إلى نموذج CurrentAdhan: $e');
      rethrow;
    }
  }

  /// تحويل النموذج إلى خريطة بيانات لحفظها في قاعدة البيانات
  Map<String, dynamic> toMap() {
    try {
      return {
        'id': id ?? 1,
        'location_id': locationId ?? 1,
        'date': DateFormat('yyyy-MM-dd').format(date),
        'fajr_time': fajrTime,
        'sunrise_time': sunriseTime,
        'dhuhr_time': dhuhrTime,
        'asr_time': asrTime,
        'maghrib_time': maghribTime,
        'isha_time': ishaTime,
      };
    } catch (e) {
      print('خطأ في تحويل نموذج CurrentAdhan إلى خريطة: $e');
      rethrow;
    }
  }

  /// إنشاء نسخة معدلة من هذا النموذج
  CurrentAdhan copyWith({
    int? id,
    DateTime? date,
    int? locationId,
    String? fajrTime,
    String? sunriseTime,
    String? dhuhrTime,
    String? asrTime,
    String? maghribTime,
    String? ishaTime,
  }) {
    return CurrentAdhan(
      id: id ?? this.id,
      locationId: locationId ?? this.locationId,
      date: date ?? this.date,
      fajrTime: fajrTime ?? this.fajrTime,
      sunriseTime: sunriseTime ?? this.sunriseTime,
      dhuhrTime: dhuhrTime ?? this.dhuhrTime,
      asrTime: asrTime ?? this.asrTime,
      maghribTime: maghribTime ?? this.maghribTime,
      ishaTime: ishaTime ?? this.ishaTime,
    );
  }

  @override
  String toString() {
    return 'CurrentAdhan(id: $id, '
        'fajrTime: $fajrTime, sunriseTime: $sunriseTime, '
        'dhuhrTime: $dhuhrTime, asrTime: $asrTime, '
        'maghribTime: $maghribTime, ishaTime: $ishaTime, '
        'locationId: $locationId, date: ${DateFormat('yyyy-MM-dd').format(date)})';
  }
}
