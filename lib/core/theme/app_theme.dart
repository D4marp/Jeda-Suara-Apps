import 'package:flutter/material.dart';

import 'palette.dart';

class AppText {
  /// Judul bergaya editorial (serif sistem; tanpa font tambahan).
  static TextStyle display(Color color, {double size = 32}) => TextStyle(
        fontFamily: 'Georgia',
        fontFamilyFallback: const ['serif'],
        fontSize: size,
        fontWeight: FontWeight.w700,
        height: 1.1,
        letterSpacing: -0.5,
        color: color,
      );

  /// Label kecil huruf kapital.
  static TextStyle overline(Color color) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: color,
      );
}

class AppTheme {
  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness b) {
    final p = b == Brightness.light ? Palette.light : Palette.dark;
    final scheme = ColorScheme(
      brightness: b,
      primary: p.accent,
      onPrimary: p.onAccent,
      secondary: p.accent,
      onSecondary: p.onAccent,
      error: p.danger,
      onError: Colors.white,
      surface: p.paper,
      onSurface: p.ink,
      outline: p.line,
      surfaceContainerHighest: p.surface,
    );

    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c, width: w),
        );

    final base = ThemeData(brightness: b, useMaterial3: true);

    return ThemeData(
      useMaterial3: true,
      brightness: b,
      colorScheme: scheme,
      extensions: [p],
      scaffoldBackgroundColor: p.paper,
      textTheme: base.textTheme.apply(bodyColor: p.ink, displayColor: p.ink),
      dividerColor: p.line,
      appBarTheme: AppBarTheme(
        backgroundColor: p.paper,
        foregroundColor: p.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: p.ink,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: border(Colors.transparent),
        enabledBorder: border(Colors.transparent),
        focusedBorder: border(p.ink, 1.5),
        errorBorder: border(p.danger),
        focusedErrorBorder: border(p.danger, 1.5),
        hintStyle: TextStyle(color: p.muted),
        labelStyle: TextStyle(color: p.muted),
        errorStyle: TextStyle(color: p.danger),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: p.ink,
          foregroundColor: p.paper,
          disabledBackgroundColor: p.line,
          minimumSize: const Size.fromHeight(56),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: p.ink,
          minimumSize: const Size(48, 48),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: p.ink,
          minimumSize: const Size(48, 48),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: p.muted,
          selectedBackgroundColor: p.ink,
          selectedForegroundColor: p.paper,
          side: BorderSide(color: p.line),
          minimumSize: const Size(48, 48),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: p.paper,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.paper,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: p.ink,
        contentTextStyle: TextStyle(color: p.paper),
        shape: const StadiumBorder(),
      ),
    );
  }
}
