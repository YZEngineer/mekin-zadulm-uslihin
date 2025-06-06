import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings_model.dart';

class SettingsService {
  static const String _notificationsKey = 'notifications_enabled';
  static const String _locationKey = 'location';

  Future<Settings> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return Settings(
      notificationsEnabled: prefs.getBool(_notificationsKey) ?? true,
      location: prefs.getString(_locationKey) ?? '',
    );
  }

  Future<void> saveSettings(Settings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, settings.notificationsEnabled);
    await prefs.setString(_locationKey, settings.location);
  }
}
