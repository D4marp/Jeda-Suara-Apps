import '../../domain/entities/login_result.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';

/// Autentikasi demo lokal (A2): username tetap, PIN awal `1234` dan bisa
/// diganti. Bukan batas keamanan sungguhan.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._local, {DateTime Function()? now})
      : _now = now ?? DateTime.now;

  static const username = 'admin';
  static const defaultPin = '1234';
  static const maxAttempts = 5;
  static const lockDuration = Duration(seconds: 30);

  final AuthLocalDataSource _local;
  final DateTime Function() _now;

  String get _pin => _local.readPin() ?? defaultPin;

  @override
  Future<LoginResult> login(String user, String pin) async {
    final now = _now();
    final lockedUntil = _local.readLockUntil();
    if (lockedUntil != null && lockedUntil.isAfter(now)) {
      return LoginLocked(lockedUntil);
    }

    if (user == username && pin == _pin) {
      await _local.saveFailedAttempts(0);
      final token = 'tok_${now.microsecondsSinceEpoch}';
      await _local.saveToken(token);
      return LoginSuccess(Session(token));
    }

    final failed = _local.readFailedAttempts() + 1;
    if (failed >= maxAttempts) {
      final until = now.add(lockDuration);
      await _local.saveLockUntil(until);
      await _local.saveFailedAttempts(0);
      return LoginLocked(until);
    }
    await _local.saveFailedAttempts(failed);
    return LoginInvalid(maxAttempts - failed);
  }

  @override
  Future<Session?> getSession() async {
    final token = _local.readToken();
    return (token == null || token.isEmpty) ? null : Session(token);
  }

  @override
  Future<void> logout() => _local.clearToken();

  @override
  Future<bool> changePin(String currentPin, String newPin) async {
    if (currentPin != _pin) return false;
    await _local.savePin(newPin);
    return true;
  }
}
