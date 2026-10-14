import '../entities/session.dart';
import '../repositories/auth_repository.dart';

class GetSession {
  const GetSession(this._repository);

  final AuthRepository _repository;

  Future<Session?> call() => _repository.getSession();
}
