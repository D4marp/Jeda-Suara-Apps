import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  const AuthLocalDataSource(this._prefs);

  static const tokenKey = 'auth_token';
  static const pinKey = 'auth_pin';
  static const failedKey = 'auth_failed_attempts';
  static const lockKey = 'auth_lock_until';

  final SharedPreferences _prefs;

  String? readToken() => _prefs.getString(tokenKey);
  Future<void> saveToken(String token) => _prefs.setString(tokenKey, token);
  Future<void> clearToken() => _prefs.remove(tokenKey);

  String? readPin() => _prefs.getString(pinKey);
  Future<void> savePin(String pin) => _prefs.setString(pinKey, pin);

  int readFailedAttempts() => _prefs.getInt(failedKey) ?? 0;
  Future<void> saveFailedAttempts(int n) => _prefs.setInt(failedKey, n);

  DateTime? readLockUntil() {
    final ms = _prefs.getInt(lockKey);
    return ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
  }

  Future<void> saveLockUntil(DateTime t) =>
      _prefs.setInt(lockKey, t.millisecondsSinceEpoch);
}
