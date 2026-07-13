import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:constimix_app/app/constimix_app.dart';

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
}
