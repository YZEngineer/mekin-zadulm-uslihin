class Settings {
  final bool notificationsEnabled;
  final String location;

  Settings({required this.notificationsEnabled, required this.location});

  Map<String, dynamic> toMap() {
    return {
      'notificationsEnabled': notificationsEnabled ? 1 : 0,
      'location': location,
    };
  }

  factory Settings.fromMap(Map<String, dynamic> map) {
    return Settings(
      notificationsEnabled: map['notificationsEnabled'] == 1,
      location: map['location'] ?? '',
    );
  }

  Settings copyWith({bool? notificationsEnabled, String? location}) {
    return Settings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      location: location ?? this.location,
    );
  }
}
