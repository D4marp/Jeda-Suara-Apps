import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/palette.dart';
import '../../../../core/utils/date_format.dart';
import '../../domain/entities/note.dart';
import '../providers/notes_notifier.dart';
import '../widgets/mood_filter_bar.dart';
import '../widgets/note_actions_sheet.dart';
import '../widgets/note_tile.dart';
import 'note_detail_screen.dart';

class NotesTab extends ConsumerStatefulWidget {
  const NotesTab({super.key, required this.onWrite});

  final VoidCallback onWrite;

  @override
  ConsumerState<NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends ConsumerState<NotesTab> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  /// Datar: String = judul grup, Note = baris.
  List<Object> _items(List<Note> notes, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final items = <Object>[];
    String? current;
    for (final n in notes) {
      final d = DateTime(n.createdAt.year, n.createdAt.month, n.createdAt.day);
      final label = n.isPinned
          ? 'Disematkan'
          : d == today
              ? 'Hari ini'
              : d == yesterday
                  ? 'Kemarin'
                  : '${bulanPanjang(d.month)} ${d.year}';
      if (label != current) {
        items.add(label);
        current = label;
      }
      items.add(n);
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final async = ref.watch(notesNotifierProvider);
    final visible = ref.watch(visibleNotesProvider);
    final moodFilter = ref.watch(moodFilterProvider);
    final total = async.valueOrNull?.notes.length ?? 0;
    final now = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${namaHari(now.weekday)}, ${now.day} ${bulanPanjang(now.month)}'
                    .toUpperCase(),
                style: AppText.overline(p.muted),
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: 'Catatanku'),
                    TextSpan(text: '.', style: TextStyle(color: p.accent)),
                  ],
                ),
                style: AppText.display(p.ink, size: 40),
              ),
            ],
          ),
        ),
        if (total > 0) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
            child: TextField(
              controller: _search,
              onChanged: (v) => ref.read(searchQueryProvider.notifier).state = v,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Cari catatan',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _search.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Hapus pencarian',
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          _search.clear();
                          ref.read(searchQueryProvider.notifier).state = '';
                          setState(() {});
                        },
                      ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide(color: p.ink, width: 1.5),
                ),
              ),
            ),
          ),
          MoodFilterBar(
            selected: moodFilter,
            onSelect: (m) => ref.read(moodFilterProvider.notifier).state = m,
          ),
        ],
        Expanded(
          child: async.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => const _Message('Catatan gagal dimuat.'),
            data: (state) {
              if (state.error != null) {
                return _Message(state.error!, isError: true);
              }
              if (state.notes.isEmpty) {
                return _EmptyState(onWrite: widget.onWrite);
              }
              if (visible.isEmpty) {
                return const _Message('Tidak ada catatan yang cocok.');
              }
              final items = _items(visible, now);
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 24),
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final item = items[i];
                  if (item is String) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 4),
                      child: Text(
                        item.toUpperCase(),
                        style: AppText.overline(p.muted),
                      ),
                    );
                  }
                  final note = item as Note;
                  return NoteTile(
                    key: ValueKey(note.id),
                    note: note,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => NoteDetailScreen(noteId: note.id),
                      ),
                    ),
                    onLongPress: () => showNoteActions(context, ref, note),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onWrite});

  final VoidCallback onWrite;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Belum ada catatan.',
              textAlign: TextAlign.center,
              style: AppText.display(p.ink, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              'Jeda pertamamu menunggu.',
              style: TextStyle(color: p.muted),
            ),
            const SizedBox(height: 24),
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size(200, 52)),
              onPressed: onWrite,
              child: const Text('Mulai Jeda Baru'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message(this.text, {this.isError = false});

  final String text;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: isError ? p.danger : p.muted),
        ),
      ),
    );
  }
}
