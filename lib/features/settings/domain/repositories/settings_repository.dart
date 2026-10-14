import '../entities/app_theme_mode.dart';

abstract class SettingsRepository {
  AppThemeMode getThemeMode();
  Future<void> setThemeMode(AppThemeMode mode);
}
