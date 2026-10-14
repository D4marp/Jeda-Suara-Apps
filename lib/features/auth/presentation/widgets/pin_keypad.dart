import 'package:flutter/material.dart';

import '../../../../core/theme/palette.dart';

class PinKeypad extends StatelessWidget {
  const PinKeypad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
    this.enabled = true,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    Widget row(List<Widget> children) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: children,
          ),
        );

    Widget digit(String d) => _Key(
          key: Key('key_$d'),
          semanticLabel: d,
          onTap: enabled ? () => onDigit(d) : null,
          child: Text(d, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
        );

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Column(
        children: [
          row([digit('1'), digit('2'), digit('3')]),
          row([digit('4'), digit('5'), digit('6')]),
          row([digit('7'), digit('8'), digit('9')]),
          row([
            const SizedBox(width: 60, height: 60),
            digit('0'),
            _Key(
              key: const Key('key_backspace'),
              semanticLabel: 'Hapus digit',
              onTap: enabled ? onBackspace : null,
              child: const Icon(Icons.backspace_outlined, size: 24),
            ),
          ]),
        ],
      ),
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({
    super.key,
    required this.child,
    required this.onTap,
    required this.semanticLabel,
  });

  final Widget child;
  final VoidCallback? onTap;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      button: true,
      label: semanticLabel,
      excludeSemantics: true,
      child: Material(
        color: p.surface,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 60,
            height: 60,
            child: Center(
              child: DefaultTextStyle.merge(
                style: TextStyle(
                  color: onTap == null ? p.muted : p.ink,
                ),
                child: IconTheme(
                  data: IconThemeData(color: onTap == null ? p.muted : p.ink),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
