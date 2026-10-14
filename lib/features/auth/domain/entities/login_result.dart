import 'session.dart';

sealed class LoginResult {
  const LoginResult();
}

class LoginSuccess extends LoginResult {
  const LoginSuccess(this.session);

  final Session session;
}

/// Kredensial salah. [attemptsLeft] = sisa percobaan sebelum dikunci.
class LoginInvalid extends LoginResult {
  const LoginInvalid(this.attemptsLeft);

  final int attemptsLeft;
}

/// Terkunci sementara sampai [until].
class LoginLocked extends LoginResult {
  const LoginLocked(this.until);

  final DateTime until;
}
