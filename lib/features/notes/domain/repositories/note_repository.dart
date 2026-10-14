import '../entities/note.dart';
import '../entities/note_draft.dart';

abstract class NoteRepository {
  Future<List<Note>> getNotes();
  Future<void> addNote(Note note);
  Future<void> updateNote(Note note);
  Future<void> deleteNote(String id);
  Future<void> deleteAll();

  Future<NoteDraft?> getDraft();
  Future<void> saveDraft(NoteDraft draft);
  Future<void> clearDraft();
}
