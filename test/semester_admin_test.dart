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

  test('schedule conflicts are isolated by cycle half and group deactivation',
      () {
    MockRepository.setActiveCycle('cycle-26-26');
    const algebra = SchoolSubject(
      idMateria: '9020',
      isExtracurricular: false,
      area: 0,
      semester: 5,
      group: 'A',
      keyCode: 'ALGEBRA-CONFLICT',
      name: 'ALGEBRA CONFLICT TEST',
      evaluationType: 'Number Evaluation',
    );
    const geometry = SchoolSubject(
      idMateria: '9021',
      isExtracurricular: false,
      area: 0,
      semester: 5,
      group: 'A',
      keyCode: 'GEOMETRY-CONFLICT',
      name: 'GEOMETRY CONFLICT TEST',
      evaluationType: 'Number Evaluation',
    );
    MockRepository.saveSubject(algebra);
    MockRepository.saveSubject(geometry);
    MockRepository.replaceSubjectAssignments(
      subject: algebra,
      semester: 5,
      periodHalf: 'First half',
      assignments: const [
        CycleSubjectAssignment(
          id: 'conflict-h1',
          subjectId: '9020',
          cycleId: 'cycle-26-26',
          subjectName: 'ALGEBRA CONFLICT TEST',
          teacherName: 'HERNANDEZ JOSE',
          teacherUserId: 'u-teacher-1',
          semester: 5,
          group: 'D',
          evaluationMode: 'Number Evaluation',
          periodHalf: 'First half',
          day: 'Saturday',
          timeRange: '08:00 - 09:30',
        ),
      ],
    );

    expect(
      MockRepository.assignmentTimeIsAvailable(
        semester: 5,
        group: 'D',
        periodHalf: 'First half',
        day: 'Saturday',
        timeRange: '08:00 - 09:30',
        exceptSubjectId: geometry.idMateria,
      ),
      isFalse,
    );
    expect(
      MockRepository.assignmentTimeIsAvailable(
        semester: 5,
        group: 'D',
        periodHalf: 'Second half',
        day: 'Saturday',
        timeRange: '08:00 - 09:30',
        exceptSubjectId: geometry.idMateria,
      ),
      isTrue,
    );

    MockRepository.replaceSubjectAssignments(
      subject: geometry,
      semester: 5,
      periodHalf: 'Second half',
      assignments: const [
        CycleSubjectAssignment(
          id: 'conflict-h2',
          subjectId: '9021',
          cycleId: 'cycle-26-26',
          subjectName: 'GEOMETRY CONFLICT TEST',
          teacherName: 'VAZQUEZ EVA',
          teacherUserId: 'u-admin-1',
          semester: 5,
          group: 'D',
          evaluationMode: 'Number Evaluation',
          periodHalf: 'Second half',
          day: 'Saturday',
          timeRange: '08:00 - 09:30',
        ),
      ],
    );

    expect(MockRepository.assignmentsForSubject(algebra), hasLength(1));
    expect(MockRepository.assignmentsForSubject(geometry), hasLength(1));
    expect(MockRepository.setGroupActive(5, 'D', false), isTrue);
    expect(MockRepository.assignmentsForSubject(algebra), isEmpty);
    expect(MockRepository.assignmentsForSubject(geometry), isEmpty);
    expect(MockRepository.setGroupActive(5, 'D', true), isTrue);
  });

  testWidgets('assignment UI disables a conflicting hour in the same half',
      (tester) async {
    MockRepository.setActiveCycle('cycle-26-26');
    const occupiedSubject = SchoolSubject(
      idMateria: '9023',
      isExtracurricular: false,
      area: 0,
      semester: 4,
      group: 'A',
      keyCode: 'OCCUPIED-HOUR',
      name: 'OCCUPIED HOUR TEST',
      evaluationType: 'Number Evaluation',
    );
    const targetSubject = SchoolSubject(
      idMateria: '9024',
      isExtracurricular: false,
      area: 0,
      semester: 4,
      group: 'A',
      keyCode: 'TARGET-HOUR',
      name: 'TARGET HOUR TEST',
      evaluationType: 'Number Evaluation',
    );
    MockRepository.saveSubject(occupiedSubject);
    MockRepository.saveSubject(targetSubject);
    MockRepository.replaceSubjectAssignments(
      subject: occupiedSubject,
      semester: 4,
      periodHalf: 'First half',
      assignments: const [
        CycleSubjectAssignment(
          id: 'occupied-hour-h1',
          subjectId: '9023',
          cycleId: 'cycle-26-26',
          subjectName: 'OCCUPIED HOUR TEST',
          teacherName: 'HERNANDEZ JOSE',
          teacherUserId: 'u-teacher-1',
          semester: 4,
          group: 'A',
          evaluationMode: 'Number Evaluation',
          periodHalf: 'First half',
          day: 'Saturday',
          timeRange: '08:00 - 09:30',
        ),
      ],
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: SubjectAssignmentScreen(subject: targetSubject),
      ),
    );
    tester
        .widget<FilledButton>(
          find.widgetWithText(FilledButton, 'Next').first,
        )
        .onPressed!
        .call();
    await tester.pump();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Slot A - Group A'),
      MockRepository.users.first.displayName,
    );
    tester
        .widget<FilledButton>(find.widgetWithText(FilledButton, 'Assign').first)
        .onPressed!
        .call();
    await tester.pump();

    final hourField = find.byKey(
      const ValueKey(
        'time-A-4-First half-Saturday-09:30 - 11:00',
      ),
    );
    final hourDropdown = tester.widget<DropdownButton<String>>(
      find.descendant(
        of: hourField,
        matching: find.byType(DropdownButton<String>),
      ),
    );
    final occupiedHour = hourDropdown.items!.firstWhere(
      (item) => item.value == '08:00 - 09:30',
    );
    expect(occupiedHour.enabled, isFalse);
    expect(hourDropdown.value, '09:30 - 11:00');
  });
  testWidgets('editing from the list opens the subject creator',
      (tester) async {
    MockRepository.setActiveCycle('cycle-26-26');
    const subject = SchoolSubject(
      idMateria: '9022',
      isExtracurricular: false,
      area: 0,
      semester: 2,
      group: 'A',
      keyCode: 'AUTO-OPEN',
      name: 'AUTO OPEN SUBJECT CREATOR',
      evaluationType: 'Letter Evaluation',
    );
    MockRepository.saveSubject(subject);

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SemesterAdminScreen())),
    );
    await tester.tap(find.text('Subject list'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Search subjects'),
      'AUTO OPEN SUBJECT CREATOR',
    );
    await tester.pump();
    await tester.tap(find.widgetWithText(OutlinedButton, 'Edit'));
    await tester.pumpAndSettle();

    expect(find.text('Editing 9022'), findsOneWidget);
    expect(find.text('IDmateria'), findsOneWidget);
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

    expect(find.text('Cycle name'), findsOneWidget);
    expect(find.text('Cycle date range'), findsOneWidget);
    expect(find.text('Select date range *'), findsOneWidget);
    expect(find.text('First half ending date'), findsOneWidget);
    expect(find.text('Second half beginning date'), findsOneWidget);
    final disabledDate = tester.widget<OutlinedButton>(
      find.widgetWithText(OutlinedButton, 'Select date *').first,
    );
    expect(disabledDate.onPressed, isNull);

    tester.widget<Stepper>(find.byType(Stepper)).onStepTapped!.call(1);
    await tester.pump();
    expect(find.text('First half'), findsOneWidget);
    expect(find.text('Second half'), findsOneWidget);
    expect(find.text('Platform *'), findsNWidgets(2));
    expect(find.text('Presential *'), findsNWidgets(2));

    tester.widget<Stepper>(find.byType(Stepper)).onStepTapped!.call(2);
    await tester.pump();
    expect(find.text('Recess time: 11:20'), findsOneWidget);
    expect(find.text('R1 (optional)'), findsOneWidget);
    expect(find.text('RE (optional)'), findsOneWidget);
    final create = find.widgetWithText(FilledButton, 'Create cycle').first;
    expect(tester.widget<FilledButton>(create).onPressed, isNull);
  });
}
