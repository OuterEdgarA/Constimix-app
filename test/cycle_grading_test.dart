import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:constimix_app/core/data/mock_repository.dart';
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
}
