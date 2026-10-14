import 'package:flutter_dpl_prd_app/core/error/failures.dart';
import 'package:flutter_dpl_prd_app/features/notes/data/datasources/note_local_datasource.dart';
import 'package:flutter_dpl_prd_app/features/notes/data/models/note_model.dart';
import 'package:flutter_dpl_prd_app/features/notes/data/repositories/note_repository_impl.dart';
import 'package:flutter_dpl_prd_app/features/notes/domain/entities/mood.dart';
import 'package:flutter_dpl_prd_app/features/notes/domain/entities/note.dart';
import 'package:flutter_dpl_prd_app/features/notes/domain/entities/note_draft.dart';
import 'package:flutter_dpl_prd_app/features/notes/domain/services/mood_scanner.dart';
import 'package:flutter_dpl_prd_app/features/notes/domain/usecases/add_note.dart';
import 'package:flutter_dpl_prd_app/features/notes/domain/usecases/draft_usecases.dart';
import 'package:flutter_dpl_prd_app/features/notes/domain/usecases/get_notes.dart';
import 'package:flutter_dpl_prd_app/features/notes/domain/usecases/toggle_pin_note.dart';
import 'package:flutter_dpl_prd_app/features/notes/domain/usecases/update_note.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<NoteLocalDataSource> make([Map<String, Object> initial = const {}]) async {
    SharedPreferences.setMockInitialValues(initial);
    return NoteLocalDataSource(await SharedPreferences.getInstance());
  }

  test('baca kosong -> list kosong', () async {
    final ds = await make();
    expect(ds.readAll(), isEmpty);
  });

  test('tulis lalu baca kembali', () async {
    final ds = await make();
    await ds.writeAll([
      NoteModel(
        id: '1',
        title: 'Judul',
        content: 'Isi',
        createdAt: DateTime(2026, 10, 13, 17, 33),
        isPinned: true,
        updatedAt: DateTime(2026, 10, 14),
      ),
    ]);
    final read = ds.readAll().single;
    expect(read.title, 'Judul');
    expect(read.createdAt, DateTime(2026, 10, 13, 17, 33));
    expect(read.isPinned, isTrue);
    expect(read.updatedAt, DateTime(2026, 10, 14));
  });

  test('JSON lama tanpa isPinned/updatedAt tetap terbaca', () async {
    final ds = await make({
      NoteLocalDataSource.notesKey:
          '[{"id":"1","title":"A","content":"B","createdAt":"2026-10-13T10:00:00.000"}]',
    });
    final n = ds.readAll().single;
    expect(n.isPinned, isFalse);
    expect(n.updatedAt, isNull);
  });

  test('JSON rusak -> StorageFailure, bukan crash', () async {
    final ds = await make({NoteLocalDataSource.notesKey: '{rusak'});
    expect(ds.readAll, throwsA(isA<StorageFailure>()));
  });

  test('AddNote menyimpan emoji di data, GetNotes mengurutkan terbaru dulu',
      () async {
    final ds = await make();
    final repo = NoteRepositoryImpl(ds);
    var t = DateTime(2026, 10, 12, 21, 5);
    final add = AddNote(repo, const MoodScanner(), now: () => t);

    await add(title: 'Kabar', content: 'Aku sedih');
    t = DateTime(2026, 10, 13, 17, 33);
    await add(title: 'Hari ini', content: 'Aku senang');

    final notes = await GetNotes(repo)();
    expect(notes.map((Note n) => n.title), ['😄 Hari ini', '😢 Kabar']);

    await repo.deleteNote(notes.first.id);
    expect((await GetNotes(repo)()).single.title, '😢 Kabar');
  });

  test('addNote menimpa data rusak agar pengguna tetap bisa menulis', () async {
    final ds = await make({NoteLocalDataSource.notesKey: 'bukan json'});
    final repo = NoteRepositoryImpl(ds);
    await AddNote(repo, const MoodScanner())(title: 'A', content: 'B');
    expect(ds.readAll(), hasLength(1));
  });

  test('UpdateNote menghitung ulang mood dan menandai diedit', () async {
    final ds = await make();
    final repo = NoteRepositoryImpl(ds);
    final scanner = const MoodScanner();
    final created = await AddNote(repo, scanner,
        now: () => DateTime(2026, 10, 13))(title: 'Hari', content: 'Aku senang');
    expect(created.mood, Mood.happy);

    final edited = await UpdateNote(repo, scanner,
        now: () => DateTime(2026, 10, 14))(
      created,
      title: created.title,
      content: 'Sekarang sedih',
    );
    expect(edited.title, '😢 Hari');
    expect(edited.updatedAt, DateTime(2026, 10, 14));
    expect(edited.createdAt, created.createdAt);
    expect((await GetNotes(repo)()).single.title, '😢 Hari');
  });

  test('catatan yang disematkan diurutkan paling atas', () async {
    final ds = await make();
    final repo = NoteRepositoryImpl(ds);
    var t = DateTime(2026, 10, 12);
    final add = AddNote(repo, const MoodScanner(), now: () => t);
    final lama = await add(title: 'Lama', content: 'x');
    t = DateTime(2026, 10, 13);
    await add(title: 'Baru', content: 'x');

    await TogglePinNote(repo)(lama);
    final notes = await GetNotes(repo)();
    expect(notes.map((n) => n.title), ['Lama', 'Baru']);
    expect(notes.first.isPinned, isTrue);
  });

  test('deleteAll mengosongkan catatan', () async {
    final ds = await make();
    final repo = NoteRepositoryImpl(ds);
    await AddNote(repo, const MoodScanner())(title: 'A', content: 'B');
    await repo.deleteAll();
    expect(await repo.getNotes(), isEmpty);
  });

  test('draft: simpan, baca, kosong menghapus', () async {
    final ds = await make();
    final repo = NoteRepositoryImpl(ds);
    await SaveDraft(repo)(const NoteDraft(title: 'J', content: 'I'));
    final d = await GetDraft(repo)();
    expect(d?.title, 'J');
    expect(d?.content, 'I');

    await SaveDraft(repo)(const NoteDraft(title: ' ', content: ''));
    expect(await GetDraft(repo)(), isNull);

    await SaveDraft(repo)(const NoteDraft(title: 'J', content: ''));
    await ClearDraft(repo)();
    expect(await GetDraft(repo)(), isNull);
  });
}
