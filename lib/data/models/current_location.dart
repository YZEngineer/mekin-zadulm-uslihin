/// نموذج يمثل الموقع الحالي المختار
class CurrentLocation {
  final int? id;
  final double latitude;
  final double longitude;
  final String city;
  final String country;

  CurrentLocation({
    this.id,
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.country,
  });

  /// إنشاء نموذج من خريطة بيانات
  factory CurrentLocation.fromMap(Map<String, dynamic> map) {
    return CurrentLocation(
      id: map['id'] as int,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      city: map['city'] as String,
      country: map['country'] as String,
    );
  }

  /// تحويل النموذج إلى خريطة بيانات لحفظها في قاعدة البيانات
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'city': city,
      'country': country,
    };
  }

  /// إنشاء نسخة معدلة من هذا النموذج
  CurrentLocation copyWith({
    int? id,
    double? latitude,
    double? longitude,
    String? city,
    String? country,
  }) {
    return CurrentLocation(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      city: city ?? this.city,
      country: country ?? this.country,
    );
  }

  @override
  String toString() {
    return 'CurrentLocation(id: $id, city: $city, country: $country, latitude: $latitude, longitude: $longitude)';
  }
}
