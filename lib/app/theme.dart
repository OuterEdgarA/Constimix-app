import 'package:flutter/material.dart';

ThemeData buildConstiMixTheme(Brightness brightness) {
  const schoolBlue = Color(0xFF458CAD);
  const schoolGreen = Color(0xFF99BD41);
  final isLight = brightness == Brightness.light;
  final scheme = ColorScheme.fromSeed(
    seedColor: schoolBlue,
    brightness: brightness,
  ).copyWith(
    primary: isLight ? schoolBlue : const Color(0xFF8BC9E5),
    onPrimary: isLight ? Colors.white : const Color(0xFF063246),
    secondary: isLight ? schoolGreen : const Color(0xFFC1E66D),
    onSecondary: isLight ? const Color(0xFF1D3300) : const Color(0xFF263700),
    surface: isLight ? Colors.white : const Color(0xFF111416),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: isLight ? Colors.white : const Color(0xFF111416),
    visualDensity: VisualDensity.standard,
    appBarTheme: AppBarTheme(
      centerTitle: false,
      backgroundColor: isLight ? schoolBlue : const Color(0xFF173846),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: isLight ? schoolGreen : const Color(0xFF33431D),
      indicatorColor: isLight
          ? Colors.white.withValues(alpha: 0.72)
          : scheme.primaryContainer,
      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(
          color: isLight ? const Color(0xFF172100) : scheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      iconTheme: WidgetStatePropertyAll(
        IconThemeData(
          color: isLight ? const Color(0xFF172100) : scheme.onSurface,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      margin: EdgeInsets.zero,
      color: isLight ? Colors.white : scheme.surfaceContainerLow,
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
