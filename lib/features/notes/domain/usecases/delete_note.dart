import '../repositories/note_repository.dart';

class DeleteNote {
  const DeleteNote(this._repository);

  final NoteRepository _repository;

  Future<void> call(String id) => _repository.deleteNote(id);
}
