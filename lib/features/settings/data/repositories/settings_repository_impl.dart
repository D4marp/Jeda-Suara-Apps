import '../../domain/entities/app_theme_mode.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._local);

  final SettingsLocalDataSource _local;

  @override
  AppThemeMode getThemeMode() {
    final name = _local.readThemeMode();
    return AppThemeMode.values.firstWhere(
      (m) => m.name == name,
      orElse: () => AppThemeMode.system,
    );
  }

  @override
  Future<void> setThemeMode(AppThemeMode mode) =>
      _local.saveThemeMode(mode.name);
}
