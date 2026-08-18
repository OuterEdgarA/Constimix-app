import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:constimix_app/app/constimix_app.dart';
import 'package:constimix_app/core/data/mock_repository.dart';
import 'package:constimix_app/core/models/user_role.dart';
import 'package:constimix_app/features/admin/admin_hub_screen.dart';

void main() {
  testWidgets('admin can open account admin screen', (tester) async {
    await tester.pumpWidget(const ConstiMixApp());

    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Admin').last);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ListTile, 'Account admin'));
    await tester.pumpAndSettle();

    expect(find.text('Staff Account Sign Up'), findsOneWidget);
  });

  testWidgets('account sections retract and role filters are independent',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        home: AccountAdminScreen(currentUser: MockRepository.users.first),
      ),
    );

    final staffSection =
        find.widgetWithText(ExpansionTile, 'Staff Account Sign Up');
    expect(
        tester.widget<ExpansionTile>(staffSection).initiallyExpanded, isTrue);
    final accountsSection =
        find.widgetWithText(ExpansionTile, 'Accounts table');
    expect(
      tester.widget<ExpansionTile>(accountsSection).initiallyExpanded,
      isTrue,
    );
    expect(find.text('Student account'), findsOneWidget);

    final staffButtons = find.byType(SegmentedButton<UserRole>);
    expect(find.descendant(of: staffButtons, matching: find.text('L1')),
        findsOneWidget);
    expect(find.descendant(of: staffButtons, matching: find.text('L2')),
        findsOneWidget);
    expect(find.descendant(of: staffButtons, matching: find.text('L3')),
        findsOneWidget);

    await tester.tap(find.widgetWithText(FilterChip, 'L1'));
    await tester.tap(find.widgetWithText(FilterChip, 'L3'));
    await tester.pump();

    expect(
      tester.widget<FilterChip>(find.widgetWithText(FilterChip, 'L1')).selected,
      isTrue,
    );
    expect(
      tester.widget<FilterChip>(find.widgetWithText(FilterChip, 'L2')).selected,
      isFalse,
    );
    expect(
      tester.widget<FilterChip>(find.widgetWithText(FilterChip, 'L3')).selected,
      isTrue,
    );
    expect(
      tester.widget<FilterChip>(find.widgetWithText(FilterChip, 'L4')).selected,
      isFalse,
    );

    await tester.tap(
      find.descendant(of: staffSection, matching: find.byType(ListTile)).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Step 1 - Account data'), findsNothing);
    expect(find.text('Student account'), findsOneWidget);
  });
}
