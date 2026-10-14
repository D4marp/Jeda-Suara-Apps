import '../../../../core/error/failures.dart';
import '../../domain/entities/note.dart';
import '../../domain/entities/note_draft.dart';
import '../../domain/repositories/note_repository.dart';
import '../datasources/note_local_datasource.dart';
import '../models/note_model.dart';

class NoteRepositoryImpl implements NoteRepository {
  const NoteRepositoryImpl(this._local);

  final NoteLocalDataSource _local;

  @override
  Future<List<Note>> getNotes() async => _local.readAll();

  @override
  Future<void> addNote(Note note) async {
    // Data rusak ditimpa agar pengguna tetap bisa menulis.
    List<NoteModel> current;
    try {
      current = _local.readAll();
    } on StorageFailure {
      current = [];
    }
    await _local.writeAll([...current, NoteModel.fromEntity(note)]);
  }

  @override
  Future<void> updateNote(Note note) async {
    final current = _local.readAll();
    await _local.writeAll([
      for (final n in current) n.id == note.id ? NoteModel.fromEntity(note) : n,
    ]);
  }

  @override
  Future<void> deleteNote(String id) async {
    final current = _local.readAll();
    await _local.writeAll(current.where((n) => n.id != id).toList());
  }

  @override
  Future<void> deleteAll() => _local.writeAll([]);

  @override
  Future<NoteDraft?> getDraft() async => _local.readDraft();

  @override
  Future<void> saveDraft(NoteDraft draft) => _local.writeDraft(draft);

  @override
  Future<void> clearDraft() => _local.clearDraft();
}
