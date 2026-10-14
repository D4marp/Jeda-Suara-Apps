import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/app_info.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/palette.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../../../notes/presentation/providers/notes_notifier.dart';
import '../../../notes/presentation/widgets/confirm_dialog.dart';
import '../../domain/entities/app_theme_mode.dart';
import '../providers/theme_mode_notifier.dart';
import 'change_pin_dialog.dart';

class SettingsTab extends ConsumerWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.palette;
    final mode = ref.watch(themeModeProvider);

    Future<void> changePin() async {
      final ok = await showDialog<bool>(
        context: context,
        builder: (_) => const ChangePinDialog(),
      );
      if (ok == true && context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('PIN diganti.')));
      }
    }

    Future<void> clearAll() async {
      final ok = await confirmDestructive(
        context,
        title: 'Hapus semua catatan?',
        message: 'Semua catatan akan dihapus dari perangkat ini. '
            'Tindakan ini tidak bisa dibatalkan.',
        confirmLabel: 'Hapus semua',
      );
      if (!ok) return;
      await ref.read(notesNotifierProvider.notifier).clearAll();
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Semua catatan dihapus.')));
      }
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      children: [
        Text('PREFERENSI', style: AppText.overline(p.muted)),
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: 'Pengaturan'),
              TextSpan(text: '.', style: TextStyle(color: p.accent)),
            ],
          ),
          style: AppText.display(p.ink, size: 40),
        ),
        const SizedBox(height: 32),
        _Section('Tampilan', p),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<AppThemeMode>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(value: AppThemeMode.system, label: Text('Sistem')),
              ButtonSegment(value: AppThemeMode.light, label: Text('Terang')),
              ButtonSegment(value: AppThemeMode.dark, label: Text('Gelap')),
            ],
            selected: {mode},
            onSelectionChanged: (s) =>
                ref.read(themeModeProvider.notifier).set(s.first),
          ),
        ),
        const SizedBox(height: 32),
        _Section('Keamanan', p),
        _Row(
          icon: Icons.pin_outlined,
          title: 'Ganti PIN',
          subtitle: 'Ubah PIN 4 digit untuk masuk',
          onTap: changePin,
        ),
        const SizedBox(height: 24),
        _Section('Data', p),
        _Row(
          icon: Icons.delete_sweep_outlined,
          title: 'Hapus semua catatan',
          subtitle: 'Mengosongkan jurnal di perangkat ini',
          danger: true,
          onTap: clearAll,
        ),
        const SizedBox(height: 24),
        _Section('Akun', p),
        _Row(
          icon: Icons.logout_rounded,
          title: 'Kunci & Keluar Sesi',
          subtitle: 'Hapus token akses dan kembali ke layar masuk',
          onTap: () => ref.read(authNotifierProvider.notifier).logout(),
        ),
        const SizedBox(height: 32),
        Text(
          'Catatan tersimpan di perangkat ini sebagai teks biasa dan belum '
          'dienkripsi. Login hanya menjaga akses ke aplikasi.',
          style: TextStyle(color: p.muted, fontSize: 12, height: 1.5),
        ),
        const SizedBox(height: 8),
        Text('$appName v$appVersion', style: TextStyle(color: p.muted, fontSize: 12)),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.text, this.p);

  final String text;
  final Palette p;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(text.toUpperCase(), style: AppText.overline(p.muted)),
      );
}

class _Row extends StatelessWidget {
  const _Row({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final color = danger ? p.danger : p.ink;
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 64),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: p.line)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(color: p.muted, fontSize: 13)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: p.muted),
          ],
        ),
      ),
    );
  }
}
