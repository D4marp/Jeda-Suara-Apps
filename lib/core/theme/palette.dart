import 'package:flutter/material.dart';

/// Token warna solid (tanpa gradient). Satu aksen: jingga-merah.
@immutable
class Palette extends ThemeExtension<Palette> {
  const Palette({
    required this.paper,
    required this.surface,
    required this.ink,
    required this.muted,
    required this.line,
    required this.accent,
    required this.onAccent,
    required this.danger,
    required this.happy,
    required this.sad,
  });

  final Color paper;
  final Color surface;
  final Color ink;
  final Color muted;
  final Color line;
  final Color accent;
  final Color onAccent;
  final Color danger;
  final Color happy;
  final Color sad;

  static const light = Palette(
    paper: Color(0xFFF6F3EC),
    surface: Color(0xFFEBE7DC),
    ink: Color(0xFF17150F),
    muted: Color(0xFF6B655A),
    line: Color(0xFFD8D2C4),
    accent: Color(0xFFCF3F0E),
    onAccent: Color(0xFFFFFFFF),
    danger: Color(0xFFB3261E),
    happy: Color(0xFFE8B516),
    sad: Color(0xFF4A78C2),
  );

  static const dark = Palette(
    paper: Color(0xFF121110),
    surface: Color(0xFF1E1C19),
    ink: Color(0xFFF3EFE6),
    muted: Color(0xFFA39D8F),
    line: Color(0xFF2E2B26),
    accent: Color(0xFFFF6B3D),
    onAccent: Color(0xFF17150F),
    danger: Color(0xFFFF8A80),
    happy: Color(0xFFF2C94C),
    sad: Color(0xFF7AA2E3),
  );

  @override
  Palette copyWith({
    Color? paper,
    Color? surface,
    Color? ink,
    Color? muted,
    Color? line,
    Color? accent,
    Color? onAccent,
    Color? danger,
    Color? happy,
    Color? sad,
  }) =>
      Palette(
        paper: paper ?? this.paper,
        surface: surface ?? this.surface,
        ink: ink ?? this.ink,
        muted: muted ?? this.muted,
        line: line ?? this.line,
        accent: accent ?? this.accent,
        onAccent: onAccent ?? this.onAccent,
        danger: danger ?? this.danger,
        happy: happy ?? this.happy,
        sad: sad ?? this.sad,
      );

  @override
  Palette lerp(ThemeExtension<Palette>? other, double t) {
    if (other is! Palette) return this;
    return Palette(
      paper: Color.lerp(paper, other.paper, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      line: Color.lerp(line, other.line, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      happy: Color.lerp(happy, other.happy, t)!,
      sad: Color.lerp(sad, other.sad, t)!,
    );
  }
}

extension PaletteContext on BuildContext {
  Palette get palette => Theme.of(this).extension<Palette>()!;
}
