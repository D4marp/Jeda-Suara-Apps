import 'package:flutter/material.dart';

import '../../../../core/theme/palette.dart';
import '../../domain/entities/mood.dart';

class MoodFilterBar extends StatelessWidget {
  const MoodFilterBar({
    super.key,
    required this.selected,
    required this.onSelect,
    this.allLabel = 'Semua',
  });

  final String allLabel;
  final Mood? selected;
  final ValueChanged<Mood?> onSelect;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          _Tab(label: allLabel, active: selected == null, onTap: () => onSelect(null)),
          for (final m in Mood.values)
            _Tab(
              label: m == Mood.neutral ? 'Netral' : '${m.emoji} ${m.label}',
              active: selected == m,
              onTap: () => onSelect(m),
            ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: active ? p.ink : p.muted,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              height: 2,
              width: 18,
              color: active ? p.accent : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
