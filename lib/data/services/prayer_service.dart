import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/current_adhan.dart';
import '../models/current_location.dart';
import '../helpers/current_adhan_dao.dart';

class PrayerService {
  static const String _baseUrl = 'http://api.aladhan.com/v1';

  /// الحصول على أوقات الصلاة للموقع المحدد
  Future<CurrentAdhan> getPrayerTimes(CurrentLocation location) async {
    try {
      final response = await http.get(Uri.parse(
          '$_baseUrl/timings/${DateTime.now().millisecondsSinceEpoch ~/ 1000}?latitude=${location.latitude}&longitude=${location.longitude}&method=4'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final timings = data['data']['timings'];

        return CurrentAdhan(
          date: DateTime.now(),
          locationId: location.id,
          fajrTime: timings['Fajr'],
          sunriseTime: timings['Sunrise'],
          dhuhrTime: timings['Dhuhr'],
          asrTime: timings['Asr'],
          maghribTime: timings['Maghrib'],
          ishaTime: timings['Isha'],
        );
      } else {
        throw Exception(
            'فشل في الحصول على أوقات الصلاة: ${response.statusCode}');
      }
    } catch (e) {
      print('خطأ في الحصول على أوقات الصلاة: $e');
      // في حالة الفشل، نعيد أوقات افتراضية
      return CurrentAdhan(
        date: DateTime.now(),
        locationId: location.id,
        fajrTime: '00',
        sunriseTime: '00:00',
        dhuhrTime: '00:0',
        asrTime: '00:00',
        maghribTime: '00:00',
        ishaTime: '00:00',
      );
    }
  }

  /// تحديث أوقات الصلاة في قاعدة البيانات
  Future<void> updatePrayerTimes(CurrentLocation location) async {
    try {
      final prayerTimes = await getPrayerTimes(location);
      final adhanDao = CurrentAdhanDao();
      await adhanDao.ChangeCurrentAdhan(prayerTimes);
    } catch (e) {
      print('خطأ في تحديث أوقات الصلاة: $e');
    }
  }
}
