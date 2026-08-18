import 'package:constimix_app/core/data/mock_repository.dart';
import 'package:constimix_app/features/academics/schedule_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpSchedule(
    WidgetTester tester, {
    required int userIndex,
    required DateTime clock,
  }) async {
    await tester.binding.setSurfaceSize(const Size(900, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ScheduleScreen(
            currentUser: MockRepository.users[userIndex],
            initialClockOverride: clock,
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('staff timeline shows cycle, CST clock, activities, and filters',
      (tester) async {
    await pumpSchedule(
      tester,
      userIndex: 0,
      clock: DateTime(2026, 7, 14, 9, 45),
    );

    expect(find.text('Periodo 26-26'), findsOneWidget);
    expect(find.text('14/07/2026'), findsOneWidget);
    expect(find.text('09:45:00'), findsOneWidget);
    expect(find.byType(FilterChip), findsNWidgets(7));
    expect(find.text('Semester 3 - 1 activity'), findsOneWidget);
    expect(find.text('11:00 - 11:20  Recess'), findsOneWidget);

    final semesterOneChip = tester.widget<FilterChip>(
      find.widgetWithText(FilterChip, '1'),
    );
    expect(semesterOneChip.selected, isTrue);
    await tester.tap(find.widgetWithText(FilterChip, '1'));
    await tester.pump();

    expect(
      tester.widget<FilterChip>(find.widgetWithText(FilterChip, '1')).selected,
      isFalse,
    );
    expect(
      tester.widget<FilterChip>(find.widgetWithText(FilterChip, '2')).selected,
      isTrue,
    );
    expect(
      tester
          .widget<FilterChip>(
            find.widgetWithText(FilterChip, 'All'),
          )
          .selected,
      isFalse,
    );

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('teacher timeline can see assignments from other teachers',
      (tester) async {
    await pumpSchedule(
      tester,
      userIndex: 2,
      clock: DateTime(2026, 7, 16, 12),
    );

    expect(find.byType(FilterChip), findsNWidgets(7));
    expect(find.text('Semester 3 - 1 activity'), findsOneWidget);
    final mathTooltip = find.byWidgetPredicate(
      (widget) =>
          widget is Tooltip &&
          (widget.message?.contains('MATHEMATICS - Eva Vazquez') ?? false),
    );
    expect(mathTooltip, findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });
  testWidgets(
      'student timeline hides filters and limits activities to its group',
      (tester) async {
    await pumpSchedule(
      tester,
      userIndex: 3,
      clock: DateTime(2026, 7, 14, 9, 45),
    );

    expect(find.byType(FilterChip), findsNothing);
    expect(find.text('Semester 3 schedule'), findsOneWidget);
    expect(find.text('Semester 3 - 1 activity'), findsOneWidget);
    expect(find.textContaining('Semester 1'), findsNothing);

    final physicsTooltip = find.byWidgetPredicate(
      (widget) =>
          widget is Tooltip &&
          (widget.message?.contains('PHYSICS - Jose Hernandez') ?? false),
    );
    expect(physicsTooltip, findsOneWidget);
    await tester.tap(physicsTooltip);
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.textContaining('Group B: PHYSICS - Jose Hernandez'),
        findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('timeline loads only the schedule half containing the date',
      (tester) async {
    await pumpSchedule(
      tester,
      userIndex: 0,
      clock: DateTime(2026, 6, 16, 9, 45),
    );

    expect(find.text('No activities for today.'), findsOneWidget);
    expect(find.textContaining('PHYSICS'), findsNothing);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('calendar marks period, test, school, and overlap dates',
      (tester) async {
    await pumpSchedule(
      tester,
      userIndex: 0,
      clock: DateTime(2026, 7, 14, 9, 45),
    );

    await tester.tap(find.text('Calendar'));
    await tester.pump();

    expect(find.text('Current period'), findsOneWidget);
    expect(find.text('Tests'), findsOneWidget);
    expect(find.text('School day'), findsOneWidget);
    expect(find.text('Overlap'), findsOneWidget);

    Tooltip dayTooltip(String key) => tester.widget<Tooltip>(
          find.ancestor(
            of: find.byKey(ValueKey(key)),
            matching: find.byType(Tooltip),
          ),
        );

    expect(
      dayTooltip('calendar-day-2026-07-14').message,
      contains('Current period, School day'),
    );

    Color dayColor(String key) {
      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byKey(ValueKey(key)),
              matching: find.byType(Container),
            )
            .first,
      );
      return (container.decoration! as BoxDecoration).color!;
    }

    expect(dayColor('calendar-day-2026-07-14'), const Color(0xFF276F27));
    expect(dayColor('calendar-day-2026-07-19'), const Color(0xFF3B7597));

    await tester.tap(find.byTooltip('Next month'));
    await tester.pump();
    await tester.tap(find.byTooltip('Next month'));
    await tester.pump();

    final septemberFirst = dayTooltip('calendar-day-2026-09-01').message!;
    expect(septemberFirst, contains('Current period'));
    expect(septemberFirst, contains('Test application'));
    expect(septemberFirst, contains('School day'));
    expect(dayColor('calendar-day-2026-09-01'), const Color(0xFFBD4444));
    expect(dayColor('calendar-day-2026-09-02'), const Color(0xFFFF8F00));

    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('empty day message and calendar mode use the selected date',
      (tester) async {
    await pumpSchedule(
      tester,
      userIndex: 0,
      clock: DateTime(2026, 7, 19, 10),
    );

    expect(find.text('No activities for today.'), findsOneWidget);

    await tester.tap(find.text('Calendar'));
    await tester.pump();

    expect(
      find.byKey(const ValueKey('calendar-day-2026-07-19')),
      findsOneWidget,
    );
    expect(find.text('No activities for this date.'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });
}
