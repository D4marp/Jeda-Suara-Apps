import '../repositories/note_repository.dart';

class DeleteAllNotes {
  const DeleteAllNotes(this._repository);

  final NoteRepository _repository;

  Future<void> call() => _repository.deleteAll();
}
