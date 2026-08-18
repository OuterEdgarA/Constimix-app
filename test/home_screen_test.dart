import 'package:constimix_app/core/data/mock_repository.dart';
import 'package:constimix_app/features/dashboard/dashboard_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'home shows surname-first welcome, active cycle, and sync details',
      (tester) async {
    MockRepository.setActiveCycle('cycle-26-26');
    await tester.pumpWidget(
      MaterialApp(
        home: DashboardShell(
          currentUser: MockRepository.users.first,
          onSignedOut: () {},
        ),
      ),
    );

    expect(find.text('Welcome, Vazquez Eva'), findsOneWidget);
    expect(find.text('Periodo 26-26'), findsOneWidget);
    expect(find.text('Active cycle'), findsOneWidget);
    expect(find.text('Pending offline sync items'), findsOneWidget);

    await tester.tap(find.text('Pending offline sync items'));
    await tester.pumpAndSettle();
    expect(find.text('Pending offline sync'), findsOneWidget);
  });
}
