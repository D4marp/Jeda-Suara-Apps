import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/palette.dart';
import '../../domain/entities/mood.dart';
import '../providers/notes_notifier.dart';

class StatsTab extends ConsumerWidget {
  const StatsTab({super.key});

  static const _hariInisial = ['S', 'S', 'R', 'K', 'J', 'S', 'M'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.palette;
    final s = ref.watch(noteStatsProvider);
    final now = DateTime.now();
    final maxDay = math.max(1, s.last7Days.reduce(math.max));
    final moodTotal = s.moods.values.fold(0, (a, b) => a + b);

    Color moodColor(Mood m) => switch (m) {
          Mood.happy => p.happy,
          Mood.sad => p.sad,
          Mood.neutral => p.line,
        };

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      children: [
        Text('RINGKASAN', style: AppText.overline(p.muted)),
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: 'Statistik'),
              TextSpan(text: '.', style: TextStyle(color: p.accent)),
            ],
          ),
          style: AppText.display(p.ink, size: 40),
        ),
        const SizedBox(height: 24),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 6,
                child: _StatCard(
                  label: 'Beruntun',
                  value: '${s.streak}',
                  unit: 'hari',
                  background: p.accent,
                  foreground: p.onAccent,
                  big: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 5,
                child: _StatCard(
                  label: 'Total',
                  value: '${s.total}',
                  unit: 'catatan',
                  background: p.surface,
                  foreground: p.ink,
                  big: true,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Minggu ini',
                  value: '${s.thisWeek}',
                  unit: 'catatan',
                  background: p.surface,
                  foreground: p.ink,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  label: 'Kata ditulis',
                  value: '${s.totalWords}',
                  unit: 'kata',
                  background: p.ink,
                  foreground: p.paper,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Text('7 HARI TERAKHIR', style: AppText.overline(p.muted)),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < 7; i++)
                Expanded(
                  child: Builder(builder: (context) {
                    final date = DateTime(now.year, now.month, now.day - (6 - i));
                    final n = s.last7Days[i];
                    final isToday = i == 6;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '$n',
                          style: TextStyle(color: p.muted, fontSize: 12),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: math.max(4.0, 90.0 * n / maxDay),
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            color: isToday
                                ? p.accent
                                : p.ink.withValues(alpha: n == 0 ? 0.12 : 0.85),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _hariInisial[date.weekday - 1],
                          style: TextStyle(
                            color: isToday ? p.accent : p.muted,
                            fontSize: 12,
                            fontWeight:
                                isToday ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Text('MOOD', style: AppText.overline(p.muted)),
        const SizedBox(height: 16),
        if (moodTotal == 0)
          Text(
            'Belum ada data. Tulis catatan untuk melihat mood-mu.',
            style: TextStyle(color: p.muted),
          )
        else ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 16,
              child: Row(
                children: [
                  for (final m in Mood.values)
                    if (s.moods[m]! > 0)
                      Expanded(
                        flex: s.moods[m]!,
                        child: Container(color: moodColor(m)),
                      ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          for (final m in Mood.values)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: moodColor(m),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    m == Mood.neutral ? m.label : '${m.emoji} ${m.label}',
                    style: const TextStyle(fontSize: 15),
                  ),
                  const Spacer(),
                  Text(
                    '${s.moods[m]}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.background,
    required this.foreground,
    this.big = false,
  });

  final String label;
  final String value;
  final String unit;
  final Color background;
  final Color foreground;
  final bool big;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label.toUpperCase(),
            style: AppText.overline(foreground.withValues(alpha: 0.75))
                .copyWith(fontSize: 11),
          ),
          SizedBox(height: big ? 28 : 16),
          Text(value, style: AppText.display(foreground, size: big ? 52 : 34)),
          const SizedBox(height: 2),
          Text(
            unit,
            style: TextStyle(
              color: foreground.withValues(alpha: 0.75),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
