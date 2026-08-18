import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:constimix_app/app/constimix_app.dart';
import 'package:constimix_app/core/data/mock_repository.dart';
import 'package:constimix_app/core/models/cycle_subject_assignment.dart';
import 'package:constimix_app/core/models/school_subject.dart';
import 'package:constimix_app/features/admin/semester_admin_screen.dart';
import 'package:constimix_app/features/admin/subject_assignment_screen.dart';

void main() {
  testWidgets('semester administration cards default to closed',
      (tester) async {
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
    expect(find.text('IDmateria'), findsNothing);
    final sections =
        tester.widgetList<ExpansionTile>(find.byType(ExpansionTile));
    expect(sections, isNotEmpty);
    expect(sections.every((section) => !section.initiallyExpanded), isTrue);
  });

  testWidgets(
      'subject creator stores semester and hides it for extracurriculars',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SemesterAdminScreen())),
    );

    await tester.tap(find.text('Subject creator'));
    await tester.pumpAndSettle();

    expect(find.text('Evaluation type'), findsOneWidget);
    expect(find.byKey(const ValueKey('subject-semester-1')), findsOneWidget);
    expect(find.widgetWithText(DropdownButtonFormField<String>, 'Group'),
        findsNothing);
    expect(find.widgetWithText(DropdownButtonFormField<int>, 'Area'),
        findsNothing);

    final extracurricular =
        find.widgetWithText(CheckboxListTile, 'Extracurricular');
    tester.widget<CheckboxListTile>(extracurricular).onChanged!.call(true);
    await tester.pump();

    expect(find.text('Evaluation type'), findsNothing);
    expect(find.byKey(const ValueKey('subject-semester-1')), findsNothing);
    final claveForm = find.widgetWithText(TextFormField, 'Clave');
    final clave = tester.widget<TextField>(
      find.descendant(of: claveForm, matching: find.byType(TextField)),
    );
    expect(clave.readOnly, isTrue);
    expect(clave.controller?.text, startsWith('X-'));
  });

  testWidgets(
      'assignment defaults to subject then existing assignment semester',
      (tester) async {
    MockRepository.setActiveCycle('cycle-26-26');
    const subject = SchoolSubject(
      idMateria: '9010',
      isExtracurricular: false,
      area: 0,
      semester: 3,
      group: 'A',
      keyCode: 'ASSIGN-UI',
      name: 'ASSIGNMENT UI TEST',
      evaluationType: 'Number Evaluation',
    );
    MockRepository.saveSubject(subject);

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: FilledButton(
              onPressed: () => Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (_) =>
                      const SubjectAssignmentScreen(subject: subject),
                ),
              ),
              child: const Text('Open assignment'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open assignment'));
    await tester.pumpAndSettle();

    tester
        .widget<FilledButton>(
          find.widgetWithText(FilledButton, 'Next').first,
        )
        .onPressed!
        .call();
    await tester.pump();

    expect(find.byKey(const ValueKey('assignment-semester-3')), findsOneWidget);
    final semester = find.byKey(const ValueKey('assignment-semester-3'));
    tester.widget<DropdownButtonFormField<int>>(semester).onChanged!.call(5);
    await tester.pump();
    expect(find.text('Slot A - Group A / Area 1'), findsOneWidget);
    expect(find.text('Slot D - Group D / Area 4'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Slot A - Group A / Area 1'),
      MockRepository.users.first.displayName,
    );
    tester
        .widget<FilledButton>(find.widgetWithText(FilledButton, 'Assign').first)
        .onPressed!
        .call();
    await tester.pump();
    expect(find.text('Saturday'), findsOneWidget);
    expect(find.text('08:00 - 09:30'), findsOneWidget);

    tester
        .widget<FilledButton>(find.widgetWithText(FilledButton, 'Save').first)
        .onPressed!
        .call();
    await tester.pumpAndSettle();

    final saved = MockRepository.assignmentsForSubjectSemester(subject, 5);
    expect(saved, hasLength(1));
    expect(saved.single.group, 'A');

    await tester.tap(find.text('Open assignment'));
    await tester.pumpAndSettle();
    tester
        .widget<FilledButton>(
          find.widgetWithText(FilledButton, 'Next').first,
        )
        .onPressed!
        .call();
    await tester.pump();
    expect(find.byKey(const ValueKey('assignment-semester-5')), findsOneWidget);
  });

  test('assigning a subject activates its empty group', () {
    MockRepository.setActiveCycle('cycle-26-26');
    expect(MockRepository.setGroupActive(2, 'D', false), isTrue);
    expect(MockRepository.groupIsActive(2, 'D'), isFalse);
    const subject = SchoolSubject(
      idMateria: '9011',
      isExtracurricular: false,
      area: 0,
      semester: 2,
      group: 'A',
      keyCode: 'ACTIVATE-GROUP',
      name: 'ACTIVATE GROUP TEST',
      evaluationType: 'Number Evaluation',
    );
    MockRepository.saveSubject(subject);
    MockRepository.replaceSubjectAssignments(
      subject: subject,
      semester: 2,
      assignments: const [
        CycleSubjectAssignment(
          id: 'activate-group-d',
          subjectId: '9011',
          cycleId: 'cycle-26-26',
          subjectName: 'ACTIVATE GROUP TEST',
          teacherName: 'HERNANDEZ JOSE',
          teacherUserId: 'u-teacher-1',
          semester: 2,
          group: 'D',
          evaluationMode: 'Number Evaluation',
        ),
      ],
    );

    expect(MockRepository.groupIsActive(2, 'D'), isTrue);
    expect(MockRepository.availableGroupsForSemester(2), contains('D'));
  });

  testWidgets('cycle editor exposes required and optional scheduling fields',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: CycleEditorScreen()),
    );

    expect(find.text('Cycle date range *'), findsOneWidget);
    expect(find.text('First half ending date *'), findsOneWidget);
    expect(find.text('Second half beginning date *'), findsOneWidget);

    tester.widget<Stepper>(find.byType(Stepper)).onStepTapped!.call(1);
    await tester.pump();
    expect(find.text('First half platform tests *'), findsOneWidget);
    expect(find.text('Second half presential tests *'), findsOneWidget);

    tester.widget<Stepper>(find.byType(Stepper)).onStepTapped!.call(2);
    await tester.pump();
    expect(find.text('Recess time: 11:20'), findsOneWidget);
    expect(find.text('R1 date range (optional)'), findsOneWidget);
    expect(find.text('RE date range (optional)'), findsOneWidget);
    final create = find.widgetWithText(FilledButton, 'Create cycle').first;
    expect(tester.widget<FilledButton>(create).onPressed, isNull);
  });
}
