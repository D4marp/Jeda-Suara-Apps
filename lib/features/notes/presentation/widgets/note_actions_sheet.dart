import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/palette.dart';
import '../../domain/entities/note.dart';
import '../providers/notes_notifier.dart';
import '../screens/note_editor_screen.dart';
import 'confirm_dialog.dart';

/// Menu tekan-lama pada baris catatan.
Future<void> showNoteActions(
  BuildContext context,
  WidgetRef ref,
  Note note,
) async {
  final action = await showModalBottomSheet<String>(
    context: context,
    builder: (ctx) {
      final p = ctx.palette;
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(note.isPinned
                    ? Icons.push_pin_outlined
                    : Icons.push_pin_rounded),
                title: Text(note.isPinned ? 'Lepas sematan' : 'Sematkan'),
                onTap: () => Navigator.of(ctx).pop('pin'),
              ),
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Edit'),
                onTap: () => Navigator.of(ctx).pop('edit'),
              ),
              ListTile(
                leading: Icon(Icons.delete_outline_rounded, color: p.danger),
                title: Text('Hapus', style: TextStyle(color: p.danger)),
                onTap: () => Navigator.of(ctx).pop('delete'),
              ),
            ],
          ),
        ),
      );
    },
  );
  if (action == null || !context.mounted) return;

  final notifier = ref.read(notesNotifierProvider.notifier);
  switch (action) {
    case 'pin':
      await notifier.togglePin(note);
    case 'edit':
      await Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => NoteEditorScreen(note: note)),
      );
    case 'delete':
      if (await confirmDeleteNote(context)) await notifier.remove(note.id);
  }
}
