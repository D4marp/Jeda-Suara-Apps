import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/palette.dart';
import '../../../../core/utils/date_format.dart';
import '../../domain/entities/note.dart';

/// Baris gaya majalah: tanggal besar di kiri, tanpa kartu.
class NoteTile extends StatelessWidget {
  const NoteTile({
    super.key,
    required this.note,
    required this.onTap,
    this.onLongPress,
  });

  final Note note;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final d = note.createdAt;
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: p.line)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 52,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${d.day}', style: AppText.display(p.ink, size: 30)),
                  const SizedBox(height: 2),
                  Text(
                    bulanPendek(d.month).toUpperCase(),
                    style: AppText.overline(p.muted).copyWith(fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          note.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (note.isPinned) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.push_pin_rounded,
                          size: 16,
                          color: p.accent,
                          semanticLabel: 'Disematkan',
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    note.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: p.muted, fontSize: 14, height: 1.4),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${formatJam(d)} · ${note.wordCount} kata'
                    '${note.isEdited ? ' · diedit' : ''}',
                    style: TextStyle(color: p.muted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
