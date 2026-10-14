import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/mood.dart';
import '../../domain/entities/note.dart';
import '../../domain/services/note_stats.dart';

class NotesState {
  const NotesState({this.notes = const [], this.error});

  final List<Note> notes;
  final String? error;
}

class NotesNotifier extends AsyncNotifier<NotesState> {
  @override
  Future<NotesState> build() => _load();

  Future<NotesState> _load() async {
    try {
      return NotesState(notes: await ref.read(getNotesUseCaseProvider)());
    } on StorageFailure catch (e) {
      return NotesState(error: e.message);
    }
  }

  Future<void> add(String title, String content, {Mood? mood}) async {
    await ref
        .read(addNoteUseCaseProvider)(title: title, content: content, mood: mood);
    state = AsyncData(await _load());
  }

  Future<void> edit(
    Note note,
    String title,
    String content, {
    Mood? mood,
  }) async {
    await ref.read(updateNoteUseCaseProvider)(
      note,
      title: title,
      content: content,
      mood: mood,
    );
    state = AsyncData(await _load());
  }

  Future<void> togglePin(Note note) async {
    await ref.read(togglePinUseCaseProvider)(note);
    state = AsyncData(await _load());
  }

  Future<void> remove(String id) async {
    await ref.read(deleteNoteUseCaseProvider)(id);
    state = AsyncData(await _load());
  }

  Future<void> clearAll() async {
    await ref.read(deleteAllNotesUseCaseProvider)();
    state = AsyncData(await _load());
  }
}

final notesNotifierProvider =
    AsyncNotifierProvider<NotesNotifier, NotesState>(NotesNotifier.new);

final searchQueryProvider = StateProvider.autoDispose<String>((ref) => '');
final moodFilterProvider = StateProvider.autoDispose<Mood?>((ref) => null);

List<Note> _all(Ref ref) =>
    ref.watch(notesNotifierProvider).valueOrNull?.notes ?? const [];

/// Catatan setelah pencarian + filter mood diterapkan.
final visibleNotesProvider = Provider.autoDispose<List<Note>>((ref) {
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final mood = ref.watch(moodFilterProvider);
  return _all(ref).where((n) {
    if (mood != null && n.mood != mood) return false;
    if (query.isEmpty) return true;
    return n.title.toLowerCase().contains(query) ||
        n.content.toLowerCase().contains(query);
  }).toList();
});

final noteStatsProvider = Provider.autoDispose<NoteStats>(
  (ref) => NoteStats.from(_all(ref), DateTime.now()),
);
