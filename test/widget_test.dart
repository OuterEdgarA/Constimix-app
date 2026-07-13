import 'package:flutter_test/flutter_test.dart';

import 'package:constimix_app/app/constimix_app.dart';

void main() {
  testWidgets('ConstiMix sign-in screen loads', (WidgetTester tester) async {
    await tester.pumpWidget(const ConstiMixApp());

    expect(find.text('ConstiMix'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
  });

  testWidgets('student sign up opens enrollment flow', (WidgetTester tester) async {
    await tester.pumpWidget(const ConstiMixApp());

    await tester.tap(find.text('Student sign up'));
    await tester.pumpAndSettle();

    expect(find.text('Student enrollment'), findsOneWidget);
    expect(find.text('School data'), findsWidgets);
  });
}
