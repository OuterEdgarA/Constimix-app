import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:constimix_app/core/data/mock_repository.dart';
import 'package:constimix_app/core/models/cycle_subject_assignment.dart';
import 'package:constimix_app/core/models/school_subject.dart';
import 'package:constimix_app/core/models/student_grade_entry.dart';
import 'package:constimix_app/features/academics/grades_screen.dart';
import 'package:constimix_app/features/admin/semester_admin_screen.dart';

void main() {
  test('switching cycles changes the academic profile', () {
    MockRepository.setActiveCycle('cycle-26-26');
    expect(MockRepository.currentEnrollments.single.semester, 3);
    expect(MockRepository.schedules.first.subject, 'Physics');

    MockRepository.setActiveCycle('cycle-23-24');
    expect(MockRepository.currentEnrollments.single.semester, 1);
    expect(MockRepository.schedules.single.subject, 'Spanish');

    MockRepository.setActiveCycle('cycle-26-26');
  });

  test('empty group activation controls enrollment dropdown visibility', () {
    MockRepository.setActiveCycle('cycle-26-26');
    expect(MockRepository.availableGroupsForSemester(2), contains('A'));

    expect(MockRepository.setGroupActive(2, 'A', false), isTrue);
    expect(MockRepository.availableGroupsForSemester(2), isNot(contains('A')));

    expect(MockRepository.setGroupActive(2, 'A', true), isTrue);
  });

  test('offline grades are queued for upload', () {
    MockRepository.isOnline = false;
    final before = MockRepository.pendingGradeUploadCount;
    final uploaded = MockRepository.saveStudentGrades([
      StudentGradeEntry(
        cycleId: 'cycle-26-26',
        assignmentId: 'assignment-physics-26',
        registration: '260000000001',
        evaluationType: 'R1',
        evaluationDate: DateTime(2026, 7, 12),
        absences: 0,
        activitiesSubmitted: 5,
        testGrade: 8.5,
        finalGrade: 6.05,
      ),
    ]);

    expect(uploaded, isFalse);
    expect(MockRepository.pendingGradeUploadCount, before + 1);
    MockRepository.isOnline = true;
    MockRepository.uploadPendingGrades();
    expect(MockRepository.pendingGradeUploadCount, 0);
  });

  testWidgets('grades table opens the three-step grading tool', (tester) async {
    MockRepository.setActiveCycle('cycle-26-26');
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GradesScreen(currentUser: MockRepository.users.first),
        ),
      ),
    );

    expect(find.text('PERIODO 26-26'), findsOneWidget);
    expect(find.text('PHYSICS'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Grade').first);
    await tester.pumpAndSettle();

    expect(find.text('Grading tool'), findsOneWidget);
    expect(find.text('Subject data'), findsOneWidget);
    expect(find.text('Evaluation data'), findsOneWidget);
  });

  testWidgets('teacher gets isolated reports and registry access',
      (tester) async {
    MockRepository.setActiveCycle('cycle-26-26');
    MockRepository.setGradingPeriodActive(false);
    final teacher = MockRepository.users.firstWhere(
      (user) => user.id == 'u-teacher-1',
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: GradesScreen(currentUser: teacher)),
      ),
    );

    expect(find.text('Search subjects'), findsNothing);
    expect(find.byType(FilterChip), findsNothing);
    final grade = find.widgetWithText(FilledButton, 'Grade').first;
    expect(find.widgetWithText(FilledButton, 'View'), findsNothing);
    final registry = find.widgetWithText(OutlinedButton, 'Registry').first;
    expect(tester.widget<FilledButton>(grade).onPressed, isNull);
    expect(tester.widget<OutlinedButton>(registry).onPressed, isNotNull);

    tester.widget<OutlinedButton>(registry).onPressed!.call();
    await tester.pumpAndSettle();
    expect(find.text('PHYSICS registry'), findsOneWidget);
    expect(find.text('07/07/2026'), findsWidgets);
  });
  testWidgets('saving the grading tool marks the subject as graded',
      (tester) async {
    MockRepository.setActiveCycle('cycle-26-26');
    final assignment = MockRepository.activeSubjectAssignments.firstWhere(
      (item) => item.subjectName == 'PHYSICS',
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GradesScreen(currentUser: MockRepository.users.first),
        ),
      ),
    );

    expect(find.text('Not graded'), findsWidgets);
    await tester.tap(find.widgetWithText(FilledButton, 'Grade').first);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Next'));
    await tester.pump();
    tester
        .widget<FilledButton>(
          find.widgetWithText(FilledButton, 'Show table'),
        )
        .onPressed!
        .call();
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Submitted activities'),
      '0',
    );
    await tester.enterText(find.widgetWithText(TextField, 'Test grade'), '9');
    tester
        .widget<FilledButton>(
          find.widgetWithText(FilledButton, 'Save grades'),
        )
        .onPressed!
        .call();
    await tester.pump();

    expect(MockRepository.isAssignmentGraded(assignment), isTrue);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Graded'), findsWidgets);
  });
  testWidgets('activation button is hidden for a populated group',
      (tester) async {
    MockRepository.setActiveCycle('cycle-26-26');
    await tester.pumpWidget(
      const MaterialApp(home: GroupManagerScreen(semester: 3, group: 'B')),
    );

    expect(find.text('Deactivate group'), findsNothing);
    expect(find.text('Activate group'), findsNothing);
  });

  testWidgets('grading card defaults absences and maps letter grades',
      (tester) async {
    MockRepository.setActiveCycle('cycle-26-26');
    final assignment =
        MockRepository.subjectAssignmentsFor(MockRepository.users.first)
            .firstWhere((item) => item.usesLetterGrades);

    await tester.pumpWidget(
      MaterialApp(home: GradingToolScreen(assignment: assignment)),
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Next'));
    await tester.pump();
    final showTable = find.widgetWithText(FilledButton, 'Show table');
    tester.widget<FilledButton>(showTable).onPressed!.call();
    await tester.pumpAndSettle();

    final absences = tester.widget<TextField>(
      find.widgetWithText(TextField, 'Absences'),
    );
    expect(absences.controller?.text, '0');
    expect(find.text('NP'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, 'Test grade'), '9');
    await tester.pump();
    expect(find.text('B'), findsWidgets);

    final details = find.widgetWithText(TextButton, 'Details').first;
    tester.widget<TextButton>(details).onPressed!.call();
    await tester.pumpAndSettle();
    expect(find.text('Grade details'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'OK'), findsOneWidget);
  });

  test('one subject supports multiple teachers across groups', () {
    MockRepository.setActiveCycle('cycle-26-26');
    const subject = SchoolSubject(
      idMateria: '9001',
      isExtracurricular: false,
      area: 0,
      semester: 1,
      group: 'A',
      keyCode: 'ESP-TEST',
      name: 'SPANISH TEST',
      evaluationType: 'Number Evaluation',
    );
    MockRepository.saveSubject(subject);
    expect(MockRepository.isSubjectAssigned(subject), isFalse);

    for (final assignment in const [
      CycleSubjectAssignment(
        id: 'spanish-test-a',
        subjectId: '9001',
        cycleId: 'cycle-26-26',
        subjectName: 'SPANISH TEST',
        teacherName: 'CARLOS GONZALES',
        teacherUserId: 'teacher-carlos',
        semester: 1,
        group: 'A',
        evaluationMode: 'Number Evaluation',
      ),
      CycleSubjectAssignment(
        id: 'spanish-test-b',
        subjectId: '9001',
        cycleId: 'cycle-26-26',
        subjectName: 'SPANISH TEST',
        teacherName: 'CARLOS GONZALES',
        teacherUserId: 'teacher-carlos',
        semester: 1,
        group: 'B',
        evaluationMode: 'Number Evaluation',
      ),
      CycleSubjectAssignment(
        id: 'spanish-test-c',
        subjectId: '9001',
        cycleId: 'cycle-26-26',
        subjectName: 'SPANISH TEST',
        teacherName: 'SANDRA GUZMAN',
        teacherUserId: 'teacher-sandra',
        semester: 1,
        group: 'C',
        evaluationMode: 'Number Evaluation',
      ),
      CycleSubjectAssignment(
        id: 'spanish-test-d',
        subjectId: '9001',
        cycleId: 'cycle-26-26',
        subjectName: 'SPANISH TEST',
        teacherName: 'SANDRA GUZMAN',
        teacherUserId: 'teacher-sandra',
        semester: 1,
        group: 'D',
        evaluationMode: 'Number Evaluation',
      ),
    ]) {
      MockRepository.saveSubjectAssignment(assignment);
    }

    final assignments = MockRepository.assignmentsForSubject(subject);
    expect(assignments, hasLength(4));
    expect(
      MockRepository.subjectAssignmentsFor(MockRepository.users.first).where(
        (assignment) => assignment.subjectId == subject.idMateria,
      ),
      hasLength(4),
    );
    expect(MockRepository.isSubjectAssigned(subject), isTrue);
    expect(
      assignments.where((item) => item.teacherName == 'CARLOS GONZALES'),
      hasLength(2),
    );
  });
}
