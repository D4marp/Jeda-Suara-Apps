import '../entities/mood.dart';
import '../entities/note.dart';
import '../repositories/note_repository.dart';
import '../services/mood_scanner.dart';

class AddNote {
  AddNote(
    this._repository,
    this._scanner, {
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final NoteRepository _repository;
  final MoodScanner _scanner;
  final DateTime Function() _now;

  Future<Note> call({
    required String title,
    required String content,
    String categoryId = '',
    List<String> tags = const [],
    int colorIndex = 0,
    Mood? mood,
  }) async {
    final cleanTitle = title.trim();
    final cleanContent = content.trim();
    final now = _now();
    final note = Note(
      id: now.microsecondsSinceEpoch.toString(),
      title: mood == null
          ? _scanner.apply(cleanTitle, cleanContent)
          : MoodScanner.withMood(cleanTitle, mood),
      content: cleanContent,
      createdAt: now,
      updatedAt: now,
      categoryId: categoryId,
      tags: tags,
      colorIndex: colorIndex,
    );
    await _repository.addNote(note);
    return note;
  }
}