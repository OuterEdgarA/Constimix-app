import 'package:constimix_app/app/constimix_app.dart';
import 'package:constimix_app/app/theme.dart';
import 'package:constimix_app/core/data/mock_repository.dart';
import 'package:constimix_app/core/models/school_subject.dart';
import 'package:constimix_app/core/models/user_role.dart';
import 'package:constimix_app/core/services/auth_service.dart';
import 'package:constimix_app/features/admin/semester_admin_screen.dart';
import 'package:constimix_app/features/dashboard/dashboard_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('light theme uses the school header and footer colors', () {
    final theme = buildConstiMixTheme(Brightness.light);
    expect(theme.scaffoldBackgroundColor, Colors.white);
    expect(theme.appBarTheme.backgroundColor, const Color(0xFF458CAD));
    expect(
      theme.navigationBarTheme.backgroundColor,
      const Color(0xFF99BD41),
    );
  });

  testWidgets('theme switch defaults to light and toggles dark mode',
      (tester) async {
    await tester.pumpWidget(const ConstiMixApp());
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    final toggle = tester.widget<Switch>(find.byType(Switch));
    expect(toggle.value, isFalse);
    toggle.onChanged!.call(true);
    await tester.pump();

    expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
    expect(find.byTooltip('Sign out'), findsNothing);
  });

  testWidgets('L4 hides enrollment and exposes the limited profile',
      (tester) async {
    final student = MockRepository.users.firstWhere(
      (user) => user.role == UserRole.level4Student,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: DashboardShell(currentUser: student, onSignedOut: () {}),
      ),
    );

    expect(find.text('Enroll'), findsNothing);
    expect(find.text('Profile'), findsOneWidget);
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Full name'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Father surname'), findsNothing);
    expect(find.text('CURP'), findsNothing);
  });

  testWidgets('L3 dashboard includes the same limited profile tab',
      (tester) async {
    final teacher = MockRepository.users.firstWhere(
      (user) => user.role == UserRole.level3Teacher,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: DashboardShell(currentUser: teacher, onSignedOut: () {}),
      ),
    );

    expect(find.text('Profile'), findsOneWidget);
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Username'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Save profile'), findsOneWidget);
  });

  testWidgets('L2 semester admin keeps only read-only catalogs and groups',
      (tester) async {
    MockRepository.setActiveCycle('cycle-26-26');
    MockRepository.saveSubject(
      const SchoolSubject(
        idMateria: 'l2-read-only',
        isExtracurricular: false,
        area: 0,
        semester: 3,
        group: 'A',
        keyCode: 'L2-READ',
        name: 'L2 READ ONLY SUBJECT',
        evaluationType: 'Number Evaluation',
      ),
    );
    final l2 = MockRepository.users.firstWhere(
      (user) => user.role == UserRole.level2SemesterAdmin,
    );
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: SemesterAdminScreen(currentUser: l2))),
    );

    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Subject creator'), findsNothing);
    expect(find.text('Cycle manager'), findsNothing);
    expect(find.text('Subject list'), findsOneWidget);
    expect(find.text('Extracurricular list'), findsOneWidget);
    expect(find.text('Group admin'), findsOneWidget);

    await tester.tap(find.text('Subject list'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(OutlinedButton, 'Edit'), findsNothing);
    expect(find.widgetWithText(FilledButton, 'Assign'), findsNothing);
  });

  testWidgets('L4 can sign out from the profile tab', (tester) async {
    final student = MockRepository.users.firstWhere(
      (user) => user.role == UserRole.level4Student,
    );
    var signedOut = false;
    await tester.pumpWidget(
      MaterialApp(
        home: DashboardShell(
          currentUser: student,
          onSignedOut: () => signedOut = true,
        ),
      ),
    );

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(ListTile, 'Sign out'), findsOneWidget);

    await tester.ensureVisible(find.widgetWithText(ListTile, 'Sign out'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Sign out'));
    expect(signedOut, isTrue);
  });

  testWidgets('L2 admin uses the light page background and ends with sign out',
      (tester) async {
    final l2 = MockRepository.users.firstWhere(
      (user) => user.role == UserRole.level2SemesterAdmin,
    );
    var signedOut = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildConstiMixTheme(Brightness.light),
        home: SemesterAdminScreen(
          currentUser: l2,
          onSignedOut: () => signedOut = true,
        ),
      ),
    );

    final pageBackground = tester.widget<ColoredBox>(
        find.byKey(const ValueKey('semester-admin-background')));
    expect(pageBackground.color, Colors.white);
    expect(find.widgetWithText(ListTile, 'Sign out'), findsOneWidget);

    await tester.tap(find.widgetWithText(ListTile, 'Sign out'));
    expect(signedOut, isTrue);
  });

  test('limited student password is accepted by authentication', () {
    final student = MockRepository.users.firstWhere(
      (user) => user.role == UserRole.level4Student,
    );
    MockRepository.updateLimitedProfile(
      userId: student.id,
      password: 'new-student-password',
      profileAvatarIndex: 2,
    );

    expect(
      AuthService.seeded()
          .signIn(
            student.curp!,
            'new-student-password',
          )
          ?.id,
      student.id,
    );
  });
}
