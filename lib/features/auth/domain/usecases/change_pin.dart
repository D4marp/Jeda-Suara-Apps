import '../repositories/auth_repository.dart';

class ChangePin {
  const ChangePin(this._repository);

  final AuthRepository _repository;

  Future<bool> call(String currentPin, String newPin) =>
      _repository.changePin(currentPin, newPin);
}
