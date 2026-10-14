import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/app_info.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/providers/auth_notifier.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/splash/presentation/splash_screen.dart';
import 'features/settings/domain/entities/app_theme_mode.dart';
import 'features/settings/presentation/providers/theme_mode_notifier.dart';

class JedaSuaraApp extends ConsumerWidget {
  const JedaSuaraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: switch (mode) {
        AppThemeMode.system => ThemeMode.system,
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.dark => ThemeMode.dark,
      },
      home: const SplashGate(),
    );
  }
}

/// Menampilkan splash minimal [minDuration], lalu masuk ke [AuthGate].
class SplashGate extends StatefulWidget {
  const SplashGate({super.key});

  static const minDuration = Duration(milliseconds: 1600);

  @override
  State<SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<SplashGate> {
  bool _done = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(SplashGate.minDuration, () {
      if (mounted) setState(() => _done = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: _done
          ? const AuthGate(key: ValueKey('gate'))
          : const SplashScreen(key: ValueKey('splash')),
    );
  }
}

/// Route guard: tanpa token, layar utama tidak pernah dibangun.
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authNotifierProvider);
    return auth.when(
      loading: () => const Scaffold(body: SizedBox.shrink()),
      error: (_, _) => const LoginScreen(),
      data: (session) =>
          session == null ? const LoginScreen() : const HomeScreen(),
    );
  }
}
