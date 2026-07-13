import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Constitución de 1917 Mixta app movil',
      debugShowCheckedModeBanner: false,
      theme: buildConstiMixTheme(Brightness.light),
      darkTheme: buildConstiMixTheme(Brightness.dark),
      home: _currentUser == null
          ? SignInScreen(
              authService: _authService,
              onSignedIn: (user) => setState(() => _currentUser = user),
            )
          : DashboardShell(
              currentUser: _currentUser!,
              onSignedOut: () => setState(() => _currentUser = null),
            ),
    );
  }
}
