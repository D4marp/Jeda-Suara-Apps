import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/change_pin.dart';
import '../../features/auth/domain/usecases/get_session.dart';
import '../../features/auth/domain/usecases/login.dart';
import '../../features/auth/domain/usecases/logout.dart';
import '../../features/notes/data/datasources/note_local_datasource.dart';
import '../../features/notes/data/repositories/note_repository_impl.dart';
import '../../features/notes/domain/repositories/note_repository.dart';
import '../../features/notes/domain/services/mood_scanner.dart';
import '../../features/notes/domain/usecases/add_note.dart';
import '../../features/notes/domain/usecases/delete_all_notes.dart';
import '../../features/notes/domain/usecases/delete_note.dart';
import '../../features/notes/domain/usecases/draft_usecases.dart';
import '../../features/notes/domain/usecases/get_notes.dart';
import '../../features/notes/domain/usecases/toggle_pin_note.dart';
import '../../features/notes/domain/usecases/update_note.dart';
import '../../features/settings/data/datasources/settings_local_datasource.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../storage/prefs_provider.dart';

/// Composition root: satu-satunya tempat `data` dirangkai ke `domain`.
/// Layer presentation hanya memakai provider bertipe domain dari sini.

// ---- auth
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    AuthLocalDataSource(ref.watch(sharedPreferencesProvider)),
  ),
);
final loginUseCaseProvider =
    Provider((ref) => Login(ref.watch(authRepositoryProvider)));
final logoutUseCaseProvider =
    Provider((ref) => Logout(ref.watch(authRepositoryProvider)));
final getSessionUseCaseProvider =
    Provider((ref) => GetSession(ref.watch(authRepositoryProvider)));
final changePinUseCaseProvider =
    Provider((ref) => ChangePin(ref.watch(authRepositoryProvider)));

// ---- notes
final noteRepositoryProvider = Provider<NoteRepository>(
  (ref) => NoteRepositoryImpl(
    NoteLocalDataSource(ref.watch(sharedPreferencesProvider)),
  ),
);
final moodScannerProvider = Provider((ref) => const MoodScanner());

final getNotesUseCaseProvider =
    Provider((ref) => GetNotes(ref.watch(noteRepositoryProvider)));
final addNoteUseCaseProvider = Provider(
  (ref) => AddNote(
    ref.watch(noteRepositoryProvider),
    ref.watch(moodScannerProvider),
  ),
);
final updateNoteUseCaseProvider = Provider(
  (ref) => UpdateNote(
    ref.watch(noteRepositoryProvider),
    ref.watch(moodScannerProvider),
  ),
);
final togglePinUseCaseProvider =
    Provider((ref) => TogglePinNote(ref.watch(noteRepositoryProvider)));
final deleteNoteUseCaseProvider =
    Provider((ref) => DeleteNote(ref.watch(noteRepositoryProvider)));
final deleteAllNotesUseCaseProvider =
    Provider((ref) => DeleteAllNotes(ref.watch(noteRepositoryProvider)));
final getDraftUseCaseProvider =
    Provider((ref) => GetDraft(ref.watch(noteRepositoryProvider)));
final saveDraftUseCaseProvider =
    Provider((ref) => SaveDraft(ref.watch(noteRepositoryProvider)));
final clearDraftUseCaseProvider =
    Provider((ref) => ClearDraft(ref.watch(noteRepositoryProvider)));

// ---- settings
final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepositoryImpl(
    SettingsLocalDataSource(ref.watch(sharedPreferencesProvider)),
  ),
);
