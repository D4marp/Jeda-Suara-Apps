import 'package:flutter/material.dart';

import '../../../core/theme/palette.dart';

class AppDock extends StatelessWidget {
  const AppDock({
    super.key,
    required this.index,
    required this.onSelect,
    required this.onAdd,
  });

  final int index;
  final ValueChanged<int> onSelect;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 64,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: p.ink,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _Item(
                      icon: Icons.auto_stories_rounded,
                      label: 'Catatan',
                      selected: index == 0,
                      onTap: () => onSelect(0),
                    ),
                    _Item(
                      icon: Icons.insights_rounded,
                      label: 'Statistik',
                      selected: index == 1,
                      onTap: () => onSelect(1),
                    ),
                    _Item(
                      icon: Icons.tune_rounded,
                      label: 'Pengaturan',
                      selected: index == 2,
                      onTap: () => onSelect(2),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Tooltip(
              message: 'Mulai Jeda Baru',
              child: Material(
                color: p.accent,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onAdd,
                  child: SizedBox(
                    width: 64,
                    height: 64,
                    child: Icon(Icons.add_rounded, color: p.onAccent, size: 30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Tooltip(
      message: label,
      child: Semantics(
        selected: selected,
        button: true,
        label: label,
        excludeSemantics: true,
        child: InkResponse(
          onTap: onTap,
          radius: 28,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 56,
            height: 48,
            decoration: BoxDecoration(
              color: selected
                  ? p.paper.withValues(alpha: 0.16)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              icon,
              size: 24,
              color: p.paper.withValues(alpha: selected ? 1 : 0.6),
            ),
          ),
        ),
      ),
    );
  }
}
