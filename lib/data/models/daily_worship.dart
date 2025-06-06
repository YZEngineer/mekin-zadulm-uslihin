/// نموذج يمثل العبادات اليومية للمستخدم
class DailyWorship {
  final int id;
  final bool fajrPrayer;
  final bool dhuhrPrayer;
  final bool asrPrayer;
  final bool maghribPrayer;
  final bool ishaPrayer;
  final bool witr;
  final bool qiyam;
  final bool quran_reading;
  final bool thikr;

  DailyWorship({
    required this.id,
    required this.fajrPrayer,
    required this.dhuhrPrayer,
    required this.asrPrayer,
    required this.maghribPrayer,
    required this.ishaPrayer,
    required this.witr,
    required this.qiyam,
    required this.quran_reading,
    required this.thikr,
  });

  /// إنشاء نموذج من خريطة بيانات قاعدة البيانات
  factory DailyWorship.fromMap(Map<String, dynamic> map) {
    return DailyWorship(
      id: map['id'] as int,
      fajrPrayer: map['fajr_prayer'] == 1,
      dhuhrPrayer: map['dhuhr_prayer'] == 1,
      asrPrayer: map['asr_prayer'] == 1,
      maghribPrayer: map['maghrib_prayer'] == 1,
      ishaPrayer: map['isha_prayer'] == 1,
      witr: map['witr'] == 1,
      qiyam: map['qiyam'] == 1,
      quran_reading: map['quran_reading'] == 1,
      thikr: map['thikr'] == 1,
    );
  }

  /// تحويل النموذج إلى خريطة بيانات لحفظها في قاعدة البيانات
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fajr_prayer': fajrPrayer ? 1 : 0,
      'dhuhr_prayer': dhuhrPrayer ? 1 : 0,
      'asr_prayer': asrPrayer ? 1 : 0,
      'maghrib_prayer': maghribPrayer ? 1 : 0,
      'isha_prayer': ishaPrayer ? 1 : 0,
      'witr': witr ? 1 : 0,
      'qiyam': qiyam ? 1 : 0,
      'quran_reading': quran_reading ? 1 : 0,
      'thikr': thikr ? 1 : 0,
    };
  }

  /// إنشاء نسخة معدلة من هذا النموذج
  DailyWorship copyWith({
    int? id,
    bool? fajrPrayer,
    bool? dhuhrPrayer,
    bool? asrPrayer,
    bool? maghribPrayer,
    bool? ishaPrayer,
    bool? witr,
    bool? qiyam,
    bool? quran_reading,
    bool? thikr,
  }) {
    return DailyWorship(
      id: id ?? this.id,
      fajrPrayer: fajrPrayer ?? this.fajrPrayer,
      dhuhrPrayer: dhuhrPrayer ?? this.dhuhrPrayer,
      asrPrayer: asrPrayer ?? this.asrPrayer,
      maghribPrayer: maghribPrayer ?? this.maghribPrayer,
      ishaPrayer: ishaPrayer ?? this.ishaPrayer,
      witr: witr ?? this.witr,
      qiyam: qiyam ?? this.qiyam,
      quran_reading: quran_reading ?? this.quran_reading,
      thikr: thikr ?? this.thikr,
    );
  }

  @override
  String toString() {
    return 'DailyWorship(id: $id, fajrPrayer: $fajrPrayer, dhuhrPrayer: $dhuhrPrayer, '
        'asrPrayer: $asrPrayer, maghribPrayer: $maghribPrayer, ishaPrayer: $ishaPrayer, '
        'witr: $witr, qiyam: $qiyam, quran_reading: $quran_reading, thikr: $thikr)';
  }
}
