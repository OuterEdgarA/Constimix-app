import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:constimix_app/core/data/mock_repository.dart';
import 'package:constimix_app/features/enrollment/enrollment_table_screen.dart';

void main() {
  test('registration counter uses year plus ten-digit sequence', () {
    expect(
      MockRepository.nextRegistrationForYear(2026, const []),
      '260000000001',
    );
    expect(
      MockRepository.nextRegistrationForYear(
        2026,
        const ['260000000001', '260000000009'],
      ),
      '260000000010',
    );
    expect(
      MockRepository.nextRegistrationForYear(
        2026,
        const ['250000009999', '260000000199'],
      ),
      '260000000200',
    );
    expect(
      MockRepository.nextRegistrationForYear(
        2026,
        const ['260000000999'],
      ),
      '260000001000',
    );
  });

  testWidgets('semester and group filters support multiple selections',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: EnrollmentTableScreen())),
    );

    await tester.tap(find.widgetWithText(ChoiceChip, '1'));
    await tester.tap(find.widgetWithText(ChoiceChip, '3'));
    await tester.tap(find.widgetWithText(ChoiceChip, 'A'));
    await tester.tap(find.widgetWithText(ChoiceChip, 'B'));
    await tester.pump();

    expect(
      tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, '1')).selected,
      isTrue,
    );
    expect(
      tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, '3')).selected,
      isTrue,
    );
    expect(
      tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'A')).selected,
      isTrue,
    );
    expect(
      tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'B')).selected,
      isTrue,
    );

    await tester.tap(find.widgetWithText(ChoiceChip, '1'));
    await tester.pump();

    expect(
      tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, '1')).selected,
      isFalse,
    );
    expect(
      tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, '3')).selected,
      isTrue,
    );
  });
}
