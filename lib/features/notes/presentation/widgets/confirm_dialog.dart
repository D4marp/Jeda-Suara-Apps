import 'package:flutter/material.dart';

import '../../../../core/theme/palette.dart';

Future<bool> confirmDestructive(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Hapus',
}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Batal'),
        ),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: ctx.palette.danger),
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return ok == true;
}

Future<bool> confirmDeleteNote(BuildContext context) => confirmDestructive(
      context,
      title: 'Hapus catatan ini?',
      message: 'Tindakan ini tidak bisa dibatalkan.',
    );
