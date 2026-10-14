import '../entities/note_draft.dart';
import '../repositories/note_repository.dart';

class GetDraft {
  const GetDraft(this._repository);

  final NoteRepository _repository;

  Future<NoteDraft?> call() => _repository.getDraft();
}

class SaveDraft {
  const SaveDraft(this._repository);

  final NoteRepository _repository;

  /// Draft kosong menghapus draft yang tersimpan.
  Future<void> call(NoteDraft draft) =>
      draft.isEmpty ? _repository.clearDraft() : _repository.saveDraft(draft);
}

class ClearDraft {
  const ClearDraft(this._repository);

  final NoteRepository _repository;

  Future<void> call() => _repository.clearDraft();
}
