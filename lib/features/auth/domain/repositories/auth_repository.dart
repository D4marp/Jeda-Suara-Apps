import '../entities/login_result.dart';
import '../entities/session.dart';

abstract class AuthRepository {
  Future<LoginResult> login(String username, String pin);
  Future<Session?> getSession();
  Future<void> logout();

  /// `false` bila [currentPin] salah.
  Future<bool> changePin(String currentPin, String newPin);
}
