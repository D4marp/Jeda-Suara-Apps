import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/login_result.dart';
import '../../domain/entities/session.dart';

class AuthNotifier extends AsyncNotifier<Session?> {
  @override
  Future<Session?> build() => ref.read(getSessionUseCaseProvider)();

  /// Hanya hasil sukses yang mengubah state.
  Future<LoginResult> login(String username, String pin) async {
    final result = await ref.read(loginUseCaseProvider)(username, pin);
    if (result is LoginSuccess) state = AsyncData(result.session);
    return result;
  }

  Future<void> logout() async {
    await ref.read(logoutUseCaseProvider)();
    state = const AsyncData(null);
  }

  Future<bool> changePin(String currentPin, String newPin) =>
      ref.read(changePinUseCaseProvider)(currentPin, newPin);
}

final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, Session?>(AuthNotifier.new);
