import '../entities/mood.dart';
import '../entities/note.dart';
import '../repositories/note_repository.dart';
import '../services/mood_scanner.dart';

class UpdateNote {
  UpdateNote(
    this._repository,
    this._scanner, {
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final NoteRepository _repository;
  final MoodScanner _scanner;
  final DateTime Function() _now;

  Future<Note> call(
    Note original, {
    required String title,
    required String content,
    Mood? mood,
  }) async {
    final cleanContent = content.trim();
    final bare = MoodScanner.stripMood(title.trim());
    final cleanTitle = mood == null
        ? _scanner.apply(bare, cleanContent)
        : MoodScanner.withMood(bare, mood);
    final updated = original.copyWith(
      title: cleanTitle,
      content: cleanContent,
      updatedAt: _now(),
    );
    await _repository.updateNote(updated);
    return updated;
  }
}
