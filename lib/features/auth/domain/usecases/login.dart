import '../entities/login_result.dart';
import '../repositories/auth_repository.dart';

class Login {
  const Login(this._repository);

  final AuthRepository _repository;

  Future<LoginResult> call(String username, String pin) =>
      _repository.login(username.trim(), pin);
}
