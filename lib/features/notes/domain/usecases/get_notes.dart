import '../entities/note.dart';
import '../repositories/note_repository.dart';

class GetNotes {
  const GetNotes(this._repository);

  final NoteRepository _repository;

  /// Disematkan di atas, lalu terbaru di atas.
  Future<List<Note>> call() async {
    final notes = await _repository.getNotes();
    return [...notes]..sort((a, b) {
        if (a.isPinned != b.isPinned) return a.isPinned ? -1 : 1;
        return b.createdAt.compareTo(a.createdAt);
      });
  }
}
