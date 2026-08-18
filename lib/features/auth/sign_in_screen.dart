import 'dart:math';

import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../core/models/app_user.dart';
import '../../core/services/auth_service.dart';
import '../enrollment/enrollment_wizard_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({
    super.key,
    required this.authService,
    required this.onSignedIn,
  });

  final AuthService authService;
  final ValueChanged<AppUser> onSignedIn;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _usernameController = TextEditingController(text: 'EVAZQUEZ');
  final _passwordController = TextEditingController(text: 'evazquezv');
  String? _error;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 24),
            Icon(Icons.school, color: scheme.primary, size: 56),
            const SizedBox(height: 16),
            Text(
              '#YoSoyConstiMix',
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Constitucion de 1917 Mixta',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _usernameController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: l10n.usernameOrCurp,
                prefixIcon: const Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              onSubmitted: (_) => _signIn(),
              decoration: InputDecoration(
                labelText: l10n.passwordOrRegistration,
                prefixIcon: const Icon(Icons.lock_outline),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: TextStyle(color: scheme.error)),
            ],
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _signIn,
              icon: const Icon(Icons.login),
              label: Text(l10n.signIn),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _openStudentSignUp,
              icon: const Icon(Icons.assignment_ind_outlined),
              label: Text(l10n.studentSignUp),
            ),
            const SizedBox(height: 24),
            Text(
              'Demo: EVAZQUEZ / evazquezv',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _openStudentSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const EnrollmentWizardScreen(standalone: true),
      ),
    );
  }

  void _signIn() {
    final user = widget.authService.signIn(
      _usernameController.text,
      _passwordController.text,
    );

    if (user == null) {
      final l10n = AppLocalizations.of(context)!;
      setState(() => _error = l10n.invalidCredentials);
      return;
    }

    widget.onSignedIn(user);
  }
}
