import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../l10n/app_localizations.dart';
import '../core/models/app_user.dart';
import '../core/services/auth_service.dart';
import '../features/auth/sign_in_screen.dart';
import '../features/dashboard/dashboard_shell.dart';
import 'theme.dart';

class ConstiMixApp extends StatefulWidget {
  const ConstiMixApp({super.key});

  @override
  State<ConstiMixApp> createState() => _ConstiMixAppState();
}

class _ConstiMixAppState extends State<ConstiMixApp> {
  final AuthService _authService = AuthService.seeded();
  AppUser? _currentUser;
  ThemeMode _themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      locale: const Locale('es', 'MX'),

      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],

      supportedLocales: AppLocalizations.supportedLocales,

      onGenerateTitle: (context) =>
        AppLocalizations.of(context)!.appTitle,

      theme: buildConstiMixTheme(Brightness.light),
      darkTheme: buildConstiMixTheme(Brightness.dark),
      themeMode: _themeMode,
      home: _currentUser == null
          ? SignInScreen(
              authService: _authService,
              onSignedIn: (user) => setState(() => _currentUser = user),
            )
          : DashboardShell(
              currentUser: _currentUser!,
              onSignedOut: () => setState(() => _currentUser = null),
              isDarkMode: _themeMode == ThemeMode.dark,
              onThemeChanged: (isDark) => setState(
                () => _themeMode = isDark ? ThemeMode.dark : ThemeMode.light,
              ),
            ),
    );
  }
}
