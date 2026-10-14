import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/note_draft.dart';
import '../models/note_model.dart';

class NoteLocalDataSource {
  const NoteLocalDataSource(this._prefs);

  static const notesKey = 'notes_json';
  static const draftKey = 'note_draft_json';

  final SharedPreferences _prefs;

  /// Melempar [StorageFailure] bila JSON rusak; tidak pernah crash.
  List<NoteModel> readAll() {
    final raw = _prefs.getString(notesKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => NoteModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      throw const StorageFailure('Data catatan rusak dan tidak bisa dibaca.');
    }
  }

  Future<void> writeAll(List<NoteModel> notes) async {
    final ok = await _prefs.setString(
      notesKey,
      jsonEncode(notes.map((n) => n.toJson()).toList()),
    );
    if (!ok) throw const StorageFailure('Catatan gagal disimpan.');
  }

  NoteDraft? readDraft() {
    final raw = _prefs.getString(draftKey);
    if (raw == null) return null;
    try {
      final m = jsonDecode(raw) as Map<String, dynamic>;
      return NoteDraft(
        title: m['title'] as String? ?? '',
        content: m['content'] as String? ?? '',
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> writeDraft(NoteDraft d) => _prefs.setString(
        draftKey,
        jsonEncode({'title': d.title, 'content': d.content}),
      );

  Future<void> clearDraft() => _prefs.remove(draftKey);
}
