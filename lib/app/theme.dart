import 'package:flutter/material.dart';

ThemeData buildConstiMixTheme(Brightness brightness) {
  const seed = Color(0xFF0B6B4F);
  final scheme = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: brightness,
  ).copyWith(
    primary: brightness == Brightness.light
        ? const Color(0xFF0B6B4F)
        : const Color(0xFF68D7B1),
    secondary: brightness == Brightness.light
        ? const Color(0xFFB6242D)
        : const Color(0xFFFFB3B8),
    tertiary: brightness == Brightness.light
        ? const Color(0xFF1B4F8F)
        : const Color(0xFF9FCBFF),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    visualDensity: VisualDensity.standard,
    appBarTheme: AppBarTheme(
      centerTitle: false,
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: scheme.outlineVariant),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );
}

