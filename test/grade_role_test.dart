import 'package:constimix_app/core/data/mock_repository.dart';
import 'package:constimix_app/core/models/student_grade_entry.dart';
import 'package:constimix_app/core/models/user_role.dart';
import 'package:constimix_app/features/academics/grades_screen.dart';
import 'package:constimix_app/features/enrollment/enrollment_wizard_screen.dart';
import 'package:constimix_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('transferred subjects create editable final grades of ten', () {
    MockRepository.setActiveCycle('cycle-26-26');
    MockRepository.isOnline = true;
    final student = MockRepository.currentEnrollments.first;
    final assignment =
        MockRepository.transferableSubjectsForStudent(student).first;

    MockRepository.setTransferredPassedSubjects(
      student,
      {assignment.subjectId},
    );

    final matchingAssignment =
        MockRepository.activeSubjectAssignments.firstWhere(
      (item) =>
          item.subjectId == assignment.subjectId &&
          item.semester == student.semester &&
          item.group == student.group,
    );
    final grade = MockRepository.gradeForStudent(
      assignment: matchingAssignment,
      registration: student.registration,
      evaluationType: 'Final evaluation',
    );
    expect(grade?.finalGrade, 10);
    expect(
      MockRepository.transferredSubjectIdsFor(student.registration),
      contains(assignment.subjectId),
    );
  });

  test('grade report generator creates a PDF document', () async {
    MockRepository.setActiveCycle('cycle-26-26');
    final user = MockRepository.users.firstWhere(
      (item) => item.role == UserRole.level3Teacher,
    );
    final assignment = MockRepository.subjectAssignmentsFor(user).first;

    final bytes = await buildGradePdfReport(
      assignments: [assignment],
      currentUser: user,
      l10n: lookupAppLocalizations(const Locale('en')),
    );

    expect(String.fromCharCodes(bytes.take(4)), '%PDF');
    expect(bytes.length, greaterThan(500));
  });

  testWidgets('managed L4 editor exposes transferred subjects as step seven',
      (tester) async {
    MockRepository.setActiveCycle('cycle-26-26');
    final student = MockRepository.currentEnrollments.first;
    await tester.pumpWidget(
      MaterialApp(
        home: EnrollmentWizardScreen(
          standalone: true,
          initialEnrollment: student,
          canManageActivation: true,
        ),
      ),
    );

    final stepper = tester.widget<Stepper>(find.byType(Stepper));
    expect(stepper.steps, hasLength(7));
    stepper.onStepTapped!.call(6);
    await tester.pump();

    expect(find.text('Subjects passed at another institution'), findsOneWidget);
    expect(find.text('PHYSICS'), findsOneWidget);
    expect(find.byType(CheckboxListTile), findsWidgets);
  });

  test('failed subjects advance through special test stages', () {
    MockRepository.setActiveCycle('cycle-26-26');
    MockRepository.isOnline = true;
    final student = MockRepository.currentEnrollments.first;
    final assignment = MockRepository.activeSubjectAssignments.firstWhere(
      (item) =>
          item.semester == student.semester && item.group == student.group,
    );

    void save(String type, double grade) {
      MockRepository.saveStudentGrades([
        StudentGradeEntry(
          cycleId: assignment.cycleId,
          assignmentId: assignment.id,
          registration: student.registration,
          evaluationType: type,
          evaluationDate: DateTime(2026, 7, 16),
          absences: 0,
          activitiesSubmitted: 0,
          testGrade: grade,
          finalGrade: grade,
        ),
      ]);
    }

    save('Final evaluation', 5);
    expect(
      MockRepository.pendingSubjectStage(
        assignment: assignment,
        registration: student.registration,
      ),
      'R1',
    );
    save('R1', 5);
    expect(
      MockRepository.pendingSubjectStage(
        assignment: assignment,
        registration: student.registration,
      ),
      'R2',
    );
    save('R2', 6);
    expect(
      MockRepository.pendingSubjectStage(
        assignment: assignment,
        registration: student.registration,
      ),
      isNull,
    );
  });

  testWidgets('L4 grades are isolated and include a pending view',
      (tester) async {
    MockRepository.setActiveCycle('cycle-26-26');
    MockRepository.isOnline = true;
    final enrollment = MockRepository.currentEnrollments.first;
    final student = MockRepository.users.firstWhere(
      (user) => user.role == UserRole.level4Student,
    );
    final assignment = MockRepository.activeSubjectAssignments.firstWhere(
      (item) =>
          item.semester == enrollment.semester &&
          item.group == enrollment.group &&
          item.subjectName == 'MATHEMATICS',
    );
    MockRepository.saveStudentGrades([
      StudentGradeEntry(
        cycleId: assignment.cycleId,
        assignmentId: assignment.id,
        registration: enrollment.registration,
        evaluationType: 'Final evaluation',
        evaluationDate: DateTime(2026, 7, 16),
        absences: 0,
        activitiesSubmitted: 0,
        testGrade: 5,
        finalGrade: 5,
      ),
    ]);

    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: GradesScreen(currentUser: student))),
    );

    expect(find.text('Search subjects'), findsNothing);
    expect(find.byType(FilterChip), findsNothing);
    expect(find.widgetWithText(FilledButton, 'Grade'), findsNothing);
    expect(find.widgetWithText(FilledButton, 'View'), findsWidgets);
    expect(find.text(assignment.subjectName), findsOneWidget);

    await tester.tap(find.text('Pending'));
    await tester.pump();
    expect(find.text('Pending R1'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'View').first);
    await tester.pumpAndSettle();
    expect(find.text('Subject PDF'), findsOneWidget);
    expect(find.text(enrollment.fullStudentName), findsOneWidget);
  });

  testWidgets('L3 grades show assigned subjects without global filters',
      (tester) async {
    MockRepository.setActiveCycle('cycle-26-26');
    MockRepository.setGradingPeriodActive(false);
    addTearDown(() => MockRepository.setGradingPeriodActive(false));
    final teacher = MockRepository.users.firstWhere(
      (user) => user.role == UserRole.level3Teacher,
    );
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: GradesScreen(currentUser: teacher))),
    );

    expect(find.text('Search subjects'), findsNothing);
    expect(find.byType(FilterChip), findsNothing);
    expect(find.widgetWithText(FilledButton, 'Grade'), findsWidgets);
    expect(find.widgetWithText(FilledButton, 'View'), findsNothing);
    final disabledGrade = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Grade').first,
    );
    expect(disabledGrade.onPressed, isNull);
    expect(find.text('PHYSICS'), findsOneWidget);
    expect(find.text('MATHEMATICS'), findsNothing);

    MockRepository.setGradingPeriodActive(true);
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: GradesScreen(currentUser: teacher))),
    );
    final enabledGrade = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Grade').first,
    );
    expect(enabledGrade.onPressed, isNotNull);
    await tester.tap(find.widgetWithText(FilledButton, 'Grade').first);
    await tester.pumpAndSettle();
    expect(find.text('Grading tool'), findsOneWidget);
    expect(find.byTooltip('Download grade PDF table'), findsNothing);
  });

  testWidgets('graded subjects restore activity count and custom fields edit',
      (tester) async {
    MockRepository.setActiveCycle('cycle-26-26');
    final assignment = MockRepository.activeSubjectAssignments.first;
    MockRepository.saveActivitiesCountForAssignment(assignment, 6);
    MockRepository.markAssignmentGraded(assignment);

    await tester.pumpWidget(
      MaterialApp(home: GradingToolScreen(assignment: assignment)),
    );
    expect(
      tester
          .widget<TextFormField>(
            find.widgetWithText(TextFormField, 'Activities count'),
          )
          .controller
          ?.text,
      '6',
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Next'));
    await tester.pump();
    await tester.ensureVisible(find.text('Customize grade percentage'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Customize grade percentage'));
    await tester.pump();
    expect(
      tester
          .widget<TextFormField>(
            find.widgetWithText(TextFormField, 'Activities percentage'),
          )
          .enabled,
      isNot(false),
    );
    expect(
      tester
          .widget<TextFormField>(
            find.widgetWithText(TextFormField, 'Test percentage'),
          )
          .enabled,
      isNot(false),
    );
  });
}
