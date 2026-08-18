import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:constimix_app/core/data/mock_repository.dart';
import 'package:constimix_app/features/enrollment/enrollment_table_screen.dart';
import 'package:constimix_app/features/enrollment/enrollment_wizard_screen.dart';

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
  testWidgets('past enrollment table can select a historical cycle',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(900, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    MockRepository.setActiveCycle('cycle-26-26');
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: EnrollmentTableScreen())),
    );

    await tester.tap(find.text('Past Enrollment'));
    await tester.pump();
    expect(find.text('Enrollment cycle'), findsOneWidget);
    expect(
        find.byKey(const ValueKey('past-cycle-cycle-26-26')), findsOneWidget);

    tester
        .widget<DropdownButtonFormField<String>>(
          find.byKey(const ValueKey('past-cycle-cycle-26-26')),
        )
        .onChanged!
        .call('cycle-23-24');
    await tester.pump();

    expect(
        find.byKey(const ValueKey('past-cycle-cycle-23-24')), findsOneWidget);
    expect(find.text('260000000001'), findsOneWidget);
    expect(find.text('1 A'), findsOneWidget);
  });
  testWidgets('final step requires acknowledgement of L4 credentials',
      (tester) async {
    final enrollment = MockRepository.studentEnrollments.first;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EnrollmentWizardScreen(initialEnrollment: enrollment),
        ),
      ),
    );

    tester.widget<Stepper>(find.byType(Stepper)).onStepTapped!.call(5);
    await tester.pump();

    expect(find.text('L4 account credentials'), findsOneWidget);
    expect(find.text(enrollment.studentCurp), findsWidgets);
    expect(find.text(enrollment.registration), findsWidgets);
    expect(find.byTooltip('Copy CURP'), findsOneWidget);
    expect(find.byTooltip('Copy Registration'), findsOneWidget);

    final save = find.widgetWithText(FilledButton, 'Save').first;
    expect(tester.widget<FilledButton>(save).onPressed, isNull);

    final acknowledgement = find.widgetWithText(
      CheckboxListTile,
      'I acknowledge these L4 account credentials',
    );
    tester.widget<CheckboxListTile>(acknowledgement).onChanged!.call(true);
    await tester.pump();

    expect(tester.widget<FilledButton>(save).onPressed, isNotNull);
  });
  testWidgets('advanced semester area updates its disabled group in real time',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: EnrollmentWizardScreen())),
    );

    final semester = find.byKey(const ValueKey('semester-1'));
    tester.widget<DropdownButtonFormField<int>>(semester).onChanged!.call(5);
    await tester.pump();

    final initialGroup = find.byKey(
      const ValueKey('group-5-A-ABCD-none'),
    );
    expect(
      tester.widget<DropdownButtonFormField<String>>(initialGroup).onChanged,
      isNull,
    );
    final area = find.byKey(const ValueKey('area-5-none'));
    tester
        .widget<DropdownButtonFormField<String>>(area)
        .onChanged!
        .call('Economics');
    await tester.pump();

    final mappedGroup = find.byKey(
      const ValueKey('group-5-C-ABCD-Economics'),
    );
    expect(mappedGroup, findsOneWidget);
    expect(
      tester.widget<DropdownButtonFormField<String>>(mappedGroup).onChanged,
      isNull,
    );
  });
}
