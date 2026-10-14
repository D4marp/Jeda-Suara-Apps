import 'package:shared_preferences/shared_preferences.dart';

class SettingsLocalDataSource {
  const SettingsLocalDataSource(this._prefs);

  static const themeKey = 'theme_mode';

  final SharedPreferences _prefs;

  String? readThemeMode() => _prefs.getString(themeKey);
  Future<void> saveThemeMode(String name) => _prefs.setString(themeKey, name);
}
