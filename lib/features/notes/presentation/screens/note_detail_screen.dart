import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/palette.dart';
import '../../../../core/utils/date_format.dart';
import '../../domain/entities/note.dart';
import '../providers/notes_notifier.dart';
import '../widgets/confirm_dialog.dart';
import 'note_editor_screen.dart';

class NoteDetailScreen extends ConsumerWidget {
  const NoteDetailScreen({super.key, required this.noteId});

  final String noteId;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    if (!await confirmDeleteNote(context)) return;
    await ref.read(notesNotifierProvider.notifier).remove(noteId);
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.palette;
    final notes = ref.watch(notesNotifierProvider).valueOrNull?.notes ?? const [];
    Note? note;
    for (final n in notes) {
      if (n.id == noteId) note = n;
    }
    if (note == null) return Scaffold(appBar: AppBar());
    final current = note;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: current.isPinned ? 'Lepas sematan' : 'Sematkan',
            icon: Icon(
              current.isPinned
                  ? Icons.push_pin_rounded
                  : Icons.push_pin_outlined,
              color: current.isPinned ? p.accent : null,
            ),
            onPressed: () =>
                ref.read(notesNotifierProvider.notifier).togglePin(current),
          ),
          IconButton(
            tooltip: 'Edit catatan',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => NoteEditorScreen(note: current),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Hapus catatan',
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: () => _delete(context, ref),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formatTanggal(current.createdAt).toUpperCase(),
                style: AppText.overline(p.muted),
              ),
              const SizedBox(height: 12),
              Text(current.title, style: AppText.display(p.ink, size: 34)),
              const SizedBox(height: 12),
              Text(
                '${current.wordCount} kata'
                '${current.isEdited ? ' · diedit ${formatTanggal(current.updatedAt!)}' : ''}',
                style: TextStyle(color: p.muted, fontSize: 13),
              ),
              const SizedBox(height: 20),
              Container(height: 1, color: p.line),
              const SizedBox(height: 20),
              Text(
                current.content,
                style: const TextStyle(fontSize: 17, height: 1.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
