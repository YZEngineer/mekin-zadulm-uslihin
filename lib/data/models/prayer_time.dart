class PrayerTime {
  final String name;
  final DateTime time;

  PrayerTime({required this.name, required this.time});

  Map<String, dynamic> toMap() {
    return {'name': name, 'time': time.toIso8601String()};
  }

  factory PrayerTime.fromMap(Map<String, dynamic> map) {
    return PrayerTime(
      name: map['name'] as String,
      time: DateTime.parse(map['time'] as String),
    );
  }
}
