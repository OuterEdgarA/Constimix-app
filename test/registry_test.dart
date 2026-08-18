import 'package:constimix_app/core/data/mock_repository.dart';
import 'package:constimix_app/core/models/academic_cycle.dart';
import 'package:constimix_app/core/models/cycle_subject_assignment.dart';
import 'package:constimix_app/core/models/registry_tab_record.dart';
import 'package:constimix_app/features/academics/registry_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('registry dates stay inside the half and support multiple weekdays', () {
    final cycle = AcademicCycle(
      id: 'cycle-registry-dates',
      name: 'Periodo registry dates',
      startDate: DateTime(2026, 6, 13),
      endDate: DateTime(2026, 12, 20),
      firstHalfEndDate: DateTime(2026, 7, 18),
      secondHalfStartDate: DateTime(2026, 7, 19),
      firstHalfPlatformTests: AcademicDateRange(
        start: DateTime(2026, 6, 20),
        end: DateTime(2026, 6, 21),
      ),
      firstHalfPresentialTests: AcademicDateRange(
        start: DateTime(2026, 6, 27),
        end: DateTime(2026, 6, 28),
      ),
      secondHalfPlatformTests: AcademicDateRange(
        start: DateTime(2026, 9, 1),
        end: DateTime(2026, 9, 2),
      ),
      secondHalfPresentialTests: AcademicDateRange(
        start: DateTime(2026, 10, 1),
        end: DateTime(2026, 10, 2),
      ),
    );
    MockRepository.saveCycle(cycle);
    const monday = CycleSubjectAssignment(
      id: 'registry-monday',
      subjectId: 'registry-multi-day',
      cycleId: 'cycle-registry-dates',
      subjectName: 'REGISTRY DATE TEST',
      teacherName: 'HERNANDEZ JOSE',
      teacherUserId: 'u-teacher-1',
      semester: 1,
      group: 'A',
      evaluationMode: 'Number Evaluation',
      periodHalf: 'First half',
      day: 'Monday',
    );
    const saturday = CycleSubjectAssignment(
      id: 'registry-saturday',
      subjectId: 'registry-multi-day',
      cycleId: 'cycle-registry-dates',
      subjectName: 'REGISTRY DATE TEST',
      teacherName: 'HERNANDEZ JOSE',
      teacherUserId: 'u-teacher-1',
      semester: 1,
      group: 'A',
      evaluationMode: 'Number Evaluation',
      periodHalf: 'First half',
      day: 'Saturday',
    );
    MockRepository.saveSubjectAssignment(monday);
    MockRepository.saveSubjectAssignment(saturday);
    expect(
      MockRepository.registryIdForAssignment(monday),
      MockRepository.registryIdForAssignment(saturday),
    );

    final dates = MockRepository.registryDatesForAssignment(monday);
    expect(dates, hasLength(11));
    expect(dates.first, DateTime(2026, 6, 13));
    expect(dates, contains(DateTime(2026, 6, 15)));
    expect(dates, contains(DateTime(2026, 7, 13)));
    expect(dates.last, DateTime(2026, 7, 18));
    expect(
        dates.every((date) => !date.isAfter(cycle.firstHalfEndDate)), isTrue);
  });

  test('registry data clears only when the cycle period bounds change', () {
    AcademicCycle cycle({
      DateTime? start,
      DateTime? end,
      DateTime? firstHalfEnd,
    }) {
      return AcademicCycle(
        id: 'cycle-registry-invalidation',
        name: 'Periodo 26-26',
        startDate: start ?? DateTime(2026, 1, 1),
        endDate: end ?? DateTime(2026, 12, 31),
        firstHalfEndDate: firstHalfEnd ?? DateTime(2026, 6, 30),
        secondHalfStartDate: DateTime(2026, 7, 1),
        firstHalfPlatformTests: AcademicDateRange(
          start: DateTime(2026, 3, 1),
          end: DateTime(2026, 3, 1),
        ),
        firstHalfPresentialTests: AcademicDateRange(
          start: DateTime(2026, 4, 1),
          end: DateTime(2026, 4, 1),
        ),
        secondHalfPlatformTests: AcademicDateRange(
          start: DateTime(2026, 9, 1),
          end: DateTime(2026, 9, 1),
        ),
        secondHalfPresentialTests: AcademicDateRange(
          start: DateTime(2026, 10, 1),
          end: DateTime(2026, 10, 1),
        ),
      );
    }

    MockRepository.isOnline = true;
    MockRepository.saveCycle(cycle());
    final record = RegistryTabRecord(
      assignmentId: 'registry-invalidation-assignment',
      cycleId: 'cycle-registry-invalidation',
      date: DateTime(2026, 2, 7),
      teacherName: 'Teacher',
      semester: 1,
      group: 'A',
      students: const [],
    );
    MockRepository.saveRegistryTab(record);

    MockRepository.saveCycle(cycle(firstHalfEnd: DateTime(2026, 7, 4)));
    expect(
      MockRepository.registryTab(
        assignmentId: record.assignmentId,
        date: record.date,
      ),
      isNotNull,
    );

    MockRepository.saveCycle(cycle(start: DateTime(2026, 1, 2)));
    expect(
      MockRepository.registryTab(
        assignmentId: record.assignmentId,
        date: record.date,
      ),
      isNull,
    );
  });
  test('registry edit permissions use the three-day correction window', () {
    MockRepository.setActiveCycle('cycle-26-26');
    final assignment = MockRepository.activeSubjectAssignments.firstWhere(
      (item) => item.teacherUserId == 'u-teacher-1',
    );
    final teacher = MockRepository.users.firstWhere(
      (user) => user.id == 'u-teacher-1',
    );

    expect(
      MockRepository.registryCanEdit(
        assignment: assignment,
        currentUser: teacher,
        tabDate: DateTime(2026, 7, 7),
        now: DateTime(2026, 7, 7),
      ),
      isTrue,
    );
    expect(
      MockRepository.registryCanEdit(
        assignment: assignment,
        currentUser: teacher,
        tabDate: DateTime(2026, 7, 7),
        now: DateTime(2026, 7, 11),
      ),
      isFalse,
    );
    expect(
      MockRepository.registryCanEdit(
        assignment: assignment,
        currentUser: MockRepository.users.first,
        tabDate: DateTime(2026, 12, 29),
        now: DateTime(2026, 7, 7),
      ),
      isTrue,
    );
    expect(
      MockRepository.registryCanEdit(
        assignment: assignment,
        currentUser: MockRepository.users[1],
        tabDate: DateTime(2026, 7, 7),
        now: DateTime(2026, 7, 7),
      ),
      isFalse,
    );
  });

  test('offline registry records queue and upload without losing behavior', () {
    MockRepository.setActiveCycle('cycle-26-26');
    final assignment = MockRepository.activeSubjectAssignments.first;
    final before = MockRepository.pendingRegistryUploadCount;
    final record = RegistryTabRecord(
      assignmentId: MockRepository.registryIdForAssignment(assignment),
      cycleId: assignment.cycleId,
      date: DateTime(2026, 7, 7),
      teacherName: assignment.teacherName,
      semester: assignment.semester,
      group: assignment.group,
      students: const [
        RegistryStudentRecord(
          registration: '260000000001',
          studentName: 'Perez Lopez Juan',
          behaviorChecks: {'Talking'},
          note: 'Offline note',
        ),
      ],
    );

    MockRepository.isOnline = false;
    expect(MockRepository.saveRegistryTab(record), isFalse);
    expect(MockRepository.pendingRegistryUploadCount, before + 1);
    expect(
      MockRepository.registryTab(
        assignmentId: MockRepository.registryIdForAssignment(assignment),
        date: record.date,
      )?.students.single.note,
      'Offline note',
    );
    MockRepository.isOnline = true;
    MockRepository.uploadPendingRegistries();
    expect(MockRepository.pendingRegistryUploadCount, 0);
  });

  test('behavior status maps one or two checks to irregular and three to bad',
      () {
    const irregular = RegistryStudentRecord(
      registration: '1',
      studentName: 'Student',
      behaviorChecks: {'Talking', 'Not working'},
    );
    const bad = RegistryStudentRecord(
      registration: '1',
      studentName: 'Student',
      behaviorChecks: {'Talking', 'Not working', 'Aggressive'},
    );
    expect(irregular.behaviorStatus, 'Irregular');
    expect(bad.behaviorStatus, 'Bad');
  });

  testWidgets('assigned teacher edits and saves an unlocked registry tab',
      (tester) async {
    MockRepository.setActiveCycle('cycle-26-26');
    MockRepository.isOnline = true;
    final assignment = MockRepository.activeSubjectAssignments.firstWhere(
      (item) => item.teacherUserId == 'u-teacher-1',
    );
    final teacher = MockRepository.users.firstWhere(
      (user) => user.id == 'u-teacher-1',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: RegistryScreen(
          assignment: assignment,
          currentUser: teacher,
          initialDateOverride: DateTime(2026, 7, 7),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('07/07/2026'), findsWidgets);
    expect(find.text('29/12/2026'), findsOneWidget);
    expect(find.text('Open for editing'), findsOneWidget);
    expect(find.text('260000000001'), findsOneWidget);

    await tester.tap(find.byTooltip('Behavior details').first);
    await tester.pumpAndSettle();
    tester
        .widget<CheckboxListTile>(
          find.widgetWithText(CheckboxListTile, 'Talking'),
        )
        .onChanged!
        .call(true);
    tester
        .widget<CheckboxListTile>(
          find.widgetWithText(CheckboxListTile, 'Not working'),
        )
        .onChanged!
        .call(true);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Behavior notes'),
      'Needs reminders to focus.',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Apply'));
    await tester.pumpAndSettle();

    expect(find.text('Irregular'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Save registry tab'));
    await tester.pump();

    final saved = MockRepository.registryTab(
      assignmentId: MockRepository.registryIdForAssignment(assignment),
      date: DateTime(2026, 7, 7),
    );
    expect(saved, isNotNull);
    expect(saved!.students.single.behaviorChecks, hasLength(2));
    expect(saved.students.single.note, 'Needs reminders to focus.');
  });
}
