import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/app_theme_mode.dart';

class ThemeModeNotifier extends Notifier<AppThemeMode> {
  @override
  AppThemeMode build() => ref.read(settingsRepositoryProvider).getThemeMode();

  Future<void> set(AppThemeMode mode) async {
    state = mode;
    await ref.read(settingsRepositoryProvider).setThemeMode(mode);
  }
}

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, AppThemeMode>(ThemeModeNotifier.new);
