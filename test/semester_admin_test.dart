import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:constimix_app/app/constimix_app.dart';

void main() {
  testWidgets('level 1 admin can open semester administration', (tester) async {
    await tester.pumpWidget(const ConstiMixApp());

    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Admin').last);
    await tester.pumpAndSettle();

    final semesterAdmin = find.widgetWithText(ListTile, 'Semester admin');
    await tester.ensureVisible(semesterAdmin);
    await tester.tap(semesterAdmin);
    await tester.pumpAndSettle();

    expect(find.text('Subject creator'), findsOneWidget);
    expect(find.text('IDmateria'), findsOneWidget);
  });
}
