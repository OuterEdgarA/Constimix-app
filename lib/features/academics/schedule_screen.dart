import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../core/data/mock_repository.dart';
import '../../core/models/academic_cycle.dart';
import '../../core/models/app_user.dart';
import '../../core/models/cycle_subject_assignment.dart';
import '../../core/models/user_role.dart';
import '../../shared/widgets/section_header.dart';

enum _ScheduleView { timeline, calendar }

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({
    super.key,
    required this.currentUser,
    this.initialClockOverride,
  });

  final AppUser currentUser;
  final DateTime? initialClockOverride;

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  static const _schoolDayStart = 8 * 60;
  static const _schoolDayEnd = 16 * 60;
  static const _semesterColors = {
    1: Color(0xFFA51211),
    2: Color(0xFF3153A6),
    3: Color(0xFF991FB5),
    4: Color(0xFF178E0A),
    5: Color(0xFFEF5B13),
    6: Color(0xFF667094),
  };
  static const _recessColor = Color(0xFFFCC92C);
  static const _classRanges = [
    '08:00 - 09:30',
    '09:30 - 11:00',
    '11:20 - 12:50',
    '12:50 - 14:20',
    '14:20 - 15:50',
  ];
  static const _weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  final _timelineController = ScrollController();
  final Set<int> _semesterFilters = {1, 2, 3, 4, 5, 6};
  final Map<String, GlobalKey> _periodKeys = {
    for (final range in _classRanges) range: GlobalKey(),
    'Recess': GlobalKey(),
  };

  _ScheduleView _view = _ScheduleView.timeline;
  DateTime? _overrideClock;
  late DateTime _calendarDate;
  late DateTime _calendarMonth;
  Timer? _clockTimer;
  Timer? _refocusTimer;

  bool get _isStudent => widget.currentUser.role == UserRole.level4Student;

  DateTime get _clock => _overrideClock ?? _centralStandardTimeNow();

  Set<int> get _visibleSemesters {
    if (_isStudent) return {widget.currentUser.semester ?? 1};
    return _semesterFilters;
  }

  @override
  void initState() {
    super.initState();
    _overrideClock = widget.initialClockOverride;
    _calendarDate = _clock;
    _calendarMonth = DateTime(_clock.year, _clock.month);
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {});
      if (_overrideClock == null &&
          _refocusTimer == null &&
          DateTime.now().second % 30 == 0) {
        _scheduleCurrentTimeFocus();
      }
    });
    _scheduleCurrentTimeFocus();
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    _refocusTimer?.cancel();
    _timelineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clock = _clock;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionHeader(
            title: 'Schedule',
            subtitle: _isStudent
                ? 'Semester ${widget.currentUser.semester ?? 1} schedule'
                : 'Academic activities by semester',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Override date and time',
                  onPressed: _showClockOverride,
                  icon: const Icon(Icons.edit_calendar_outlined),
                ),
                if (_overrideClock != null)
                  IconButton(
                    tooltip: 'Use current CST',
                    onPressed: _resetClockOverride,
                    icon: const Icon(Icons.restore_outlined),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _ReadOnlyField(
            label: 'Current active cycle',
            value: MockRepository.activeCycle?.name ?? 'No active cycle',
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _ReadOnlyField(
                  label: 'Current date (CST)',
                  value: _formatDate(clock),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ReadOnlyField(
                  label: 'Current hour (CST)',
                  value: _formatTime(clock),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SegmentedButton<_ScheduleView>(
            segments: const [
              ButtonSegment(
                value: _ScheduleView.timeline,
                icon: Icon(Icons.view_timeline_outlined),
                label: Text('Timeline'),
              ),
              ButtonSegment(
                value: _ScheduleView.calendar,
                icon: Icon(Icons.calendar_month_outlined),
                label: Text('Calendar'),
              ),
            ],
            selected: {_view},
            onSelectionChanged: (selection) {
              setState(() => _view = selection.first);
              if (_view == _ScheduleView.timeline) {
                _scheduleCurrentTimeFocus();
              }
            },
          ),
          if (_view == _ScheduleView.timeline && !_isStudent) ...[
            const SizedBox(height: 10),
            _semesterFilterGroup(),
          ],
          const SizedBox(height: 10),
          Expanded(
            child: _view == _ScheduleView.timeline
                ? _timelineView(clock)
                : _calendarView(),
          ),
        ],
      ),
    );
  }

  Widget _semesterFilterGroup() {
    final allSelected = _semesterFilters.length == 6;
    return Wrap(
      spacing: 7,
      runSpacing: 7,
      children: [
        FilterChip(
          label: const Text('All'),
          selected: allSelected,
          onSelected: (_) => setState(() {
            if (allSelected) {
              _semesterFilters.clear();
            } else {
              _semesterFilters
                ..clear()
                ..addAll(const [1, 2, 3, 4, 5, 6]);
            }
          }),
        ),
        for (var semester = 1; semester <= 6; semester++)
          FilterChip(
            label: Text('$semester'),
            selected: _semesterFilters.contains(semester),
            onSelected: (_) => setState(() {
              if (!_semesterFilters.add(semester)) {
                _semesterFilters.remove(semester);
              }
            }),
          ),
      ],
    );
  }

  Widget _timelineView(DateTime date) {
    final assignments = _assignmentsForDate(date);
    if (assignments.isEmpty) {
      return const Center(child: Text('No activities for today.'));
    }
    final semesters = _visibleSemesters.toList()..sort();
    return NotificationListener<UserScrollNotification>(
      onNotification: (notification) {
        if (notification.direction != ScrollDirection.idle) {
          _pauseAutoFocus();
        }
        return false;
      },
      child: ListView(
        controller: _timelineController,
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          for (var index = 0; index < _classRanges.length; index++) ...[
            _TimelinePeriod(
              key: _periodKeys[_classRanges[index]],
              timeRange: _classRanges[index],
              semesters: semesters,
              assignments: assignments,
              colorForSemester: _colorForSemester,
              tooltipForSemester: (semester) => _semesterTooltip(
                semester: semester,
                timeRange: _classRanges[index],
                assignments: assignments,
              ),
            ),
            if (index == 1)
              _RecessPeriod(
                key: _periodKeys['Recess'],
                color: _recessColor,
              ),
          ],
        ],
      ),
    );
  }

  Widget _calendarView() {
    final assignments = _assignmentsForDate(_calendarDate);
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        _ScheduleCalendar(
          month: _calendarMonth,
          selectedDate: _calendarDate,
          currentDate: _clock,
          markersForDate: _calendarMarkersForDate,
          onMonthChanged: (value) => setState(() => _calendarMonth = value),
          onDateSelected: (value) => setState(() => _calendarDate = value),
        ),
        const SizedBox(height: 10),
        const _CalendarLegend(),
        const Divider(height: 28),
        Text(
          _formatDate(_calendarDate),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        if (assignments.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 28),
            child: Center(child: Text('No activities for this date.')),
          )
        else ...[
          for (final assignment in assignments) ...[
            _CalendarActivity(
              assignment: assignment,
              color: _colorForSemester(assignment.semester),
              teacher: _teacherShortName(assignment),
            ),
            const SizedBox(height: 8),
          ],
          const _CalendarRecess(color: _recessColor),
        ],
      ],
    );
  }

  List<CycleSubjectAssignment> _assignmentsForDate(DateTime date) {
    final periodHalf = _periodHalfForDate(date);
    if (periodHalf == null) return const [];
    final day = _weekdays[date.weekday - 1];
    final assignments =
        MockRepository.activeSubjectAssignments.where((assignment) {
      if (assignment.periodHalf != periodHalf) return false;
      if (assignment.day != day) return false;
      if (!_visibleSemesters.contains(assignment.semester)) return false;
      if (_isStudent) {
        return assignment.semester == widget.currentUser.semester &&
            assignment.group == widget.currentUser.group;
      }
      return true;
    }).toList(growable: false);
    assignments.sort((a, b) {
      final time =
          _startMinutes(a.timeRange).compareTo(_startMinutes(b.timeRange));
      if (time != 0) return time;
      final semester = a.semester.compareTo(b.semester);
      if (semester != 0) return semester;
      return a.group.compareTo(b.group);
    });
    return assignments;
  }

  String? _periodHalfForDate(DateTime date) {
    final cycle = MockRepository.activeCycle;
    if (cycle == null) return null;
    final value = DateUtils.dateOnly(date);
    if (!_isBefore(value, cycle.startDate) &&
        !_isAfter(value, cycle.firstHalfEndDate)) {
      return 'First half';
    }
    if (!_isBefore(value, cycle.secondHalfStartDate) &&
        !_isAfter(value, cycle.endDate)) {
      return 'Second half';
    }
    return null;
  }

  _CalendarDayMarkers _calendarMarkersForDate(DateTime date) {
    final cycle = MockRepository.activeCycle;
    if (cycle == null) return const _CalendarDayMarkers();
    final normalized = DateTime(date.year, date.month, date.day);
    final cycleStart = DateTime(
      cycle.startDate.year,
      cycle.startDate.month,
      cycle.startDate.day,
    );
    final cycleEnd = DateTime(
      cycle.endDate.year,
      cycle.endDate.month,
      cycle.endDate.day,
    );
    final periodRelevant =
        !normalized.isBefore(cycleStart) && !normalized.isAfter(cycleEnd);
    final testDay = _cycleTestRanges(cycle).any(
      (range) => _isWithin(date, range.start, range.end),
    );
    final schoolDay = _assignmentsForDate(date).isNotEmpty;
    return _CalendarDayMarkers(
      periodRelevant: periodRelevant,
      testDay: testDay,
      schoolDay: schoolDay,
    );
  }

  Iterable<AcademicDateRange> _cycleTestRanges(AcademicCycle cycle) sync* {
    yield cycle.firstHalfPlatformTests;
    yield cycle.firstHalfPresentialTests;
    yield cycle.secondHalfPlatformTests;
    yield cycle.secondHalfPresentialTests;
    yield* cycle.specialTestRanges.values;
  }

  static bool _isWithin(DateTime value, DateTime start, DateTime end) {
    final date = DateUtils.dateOnly(value);
    return !_isBefore(date, start) && !_isAfter(date, end);
  }

  static bool _isBefore(DateTime value, DateTime other) {
    return DateUtils.dateOnly(value).isBefore(DateUtils.dateOnly(other));
  }

  static bool _isAfter(DateTime value, DateTime other) {
    return DateUtils.dateOnly(value).isAfter(DateUtils.dateOnly(other));
  }

  String _semesterTooltip({
    required int semester,
    required String timeRange,
    required List<CycleSubjectAssignment> assignments,
  }) {
    final activeGroups = MockRepository.availableGroupsForSemester(semester);
    if (activeGroups.isEmpty) return 'No active groups';
    return activeGroups.map((group) {
      final matches = assignments.where(
        (assignment) =>
            assignment.semester == semester &&
            assignment.group == group &&
            assignment.timeRange == timeRange,
      );
      if (matches.isEmpty) return 'Group $group: No class assigned';
      return matches.map((assignment) {
        return 'Group $group: ${assignment.subjectName} - '
            '${_teacherShortName(assignment)}';
      }).join('\n');
    }).join('\n');
  }

  String _teacherShortName(CycleSubjectAssignment assignment) {
    AppUser? teacher;
    for (final user in MockRepository.users) {
      if (user.id == assignment.teacherUserId) {
        teacher = user;
        break;
      }
    }
    if (teacher == null) return assignment.teacherName;
    return [teacher.name, teacher.fatherSurname]
        .where((part) => part.trim().isNotEmpty)
        .join(' ');
  }

  void _pauseAutoFocus() {
    _refocusTimer?.cancel();
    _refocusTimer = Timer(const Duration(seconds: 5), () {
      _refocusTimer = null;
      _scrollToCurrentTime();
    });
  }

  void _scheduleCurrentTimeFocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrentTime());
  }

  void _scrollToCurrentTime() {
    if (!mounted || _view != _ScheduleView.timeline) return;
    final minutes = _clock.hour * 60 + _clock.minute;
    if (minutes < _schoolDayStart || minutes >= _schoolDayEnd) return;
    final period = _periodForMinutes(minutes);
    final target = _periodKeys[period]?.currentContext;
    if (target == null) return;
    Scrollable.ensureVisible(
      target,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOut,
      alignment: 0.22,
    );
  }

  String _periodForMinutes(int minutes) {
    if (minutes < 9 * 60 + 30) return _classRanges[0];
    if (minutes < 11 * 60) return _classRanges[1];
    if (minutes < 11 * 60 + 20) return 'Recess';
    if (minutes < 12 * 60 + 50) return _classRanges[2];
    if (minutes < 14 * 60 + 20) return _classRanges[3];
    return _classRanges[4];
  }

  Future<void> _showClockOverride() async {
    var selectedDate = _clock;
    var selectedTime = TimeOfDay.fromDateTime(_clock);
    final result = await showDialog<DateTime>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Override schedule clock'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.event_outlined),
                title: const Text('Date'),
                subtitle: Text(_formatDate(selectedDate)),
                onTap: () async {
                  final selected = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(selectedDate.year - 5),
                    lastDate: DateTime(selectedDate.year + 5, 12, 31),
                  );
                  if (selected != null) {
                    setDialogState(() => selectedDate = selected);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.schedule_outlined),
                title: const Text('Hour'),
                subtitle: Text(_formatTimeOfDay(selectedTime)),
                onTap: () async {
                  final selected = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (selected != null) {
                    setDialogState(() => selectedTime = selected);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(
                DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                ),
              ),
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
    if (result == null || !mounted) return;
    setState(() {
      _overrideClock = result;
      _calendarDate = result;
      _calendarMonth = DateTime(result.year, result.month);
    });
    _scheduleCurrentTimeFocus();
  }

  void _resetClockOverride() {
    setState(() {
      _overrideClock = null;
      _calendarDate = _centralStandardTimeNow();
      _calendarMonth = DateTime(_calendarDate.year, _calendarDate.month);
    });
    _scheduleCurrentTimeFocus();
  }

  static DateTime _centralStandardTimeNow() {
    return DateTime.now().toUtc().subtract(const Duration(hours: 6));
  }

  static int _startMinutes(String timeRange) {
    final start = timeRange.split('-').first.trim().split(':');
    if (start.length != 2) return 0;
    return (int.tryParse(start.first) ?? 0) * 60 +
        (int.tryParse(start.last) ?? 0);
  }

  static String _formatDate(DateTime value) {
    return '${value.day.toString().padLeft(2, '0')}/'
        '${value.month.toString().padLeft(2, '0')}/${value.year}';
  }

  static String _formatTime(DateTime value) {
    return '${value.hour.toString().padLeft(2, '0')}:'
        '${value.minute.toString().padLeft(2, '0')}:'
        '${value.second.toString().padLeft(2, '0')}';
  }

  static String _formatTimeOfDay(TimeOfDay value) {
    return '${value.hour.toString().padLeft(2, '0')}:'
        '${value.minute.toString().padLeft(2, '0')}';
  }

  static Color _colorForSemester(int semester) {
    return _semesterColors[semester] ?? Colors.grey;
  }
}

class _TimelinePeriod extends StatelessWidget {
  const _TimelinePeriod({
    super.key,
    required this.timeRange,
    required this.semesters,
    required this.assignments,
    required this.colorForSemester,
    required this.tooltipForSemester,
  });

  final String timeRange;
  final List<int> semesters;
  final List<CycleSubjectAssignment> assignments;
  final Color Function(int) colorForSemester;
  final String Function(int) tooltipForSemester;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(timeRange, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 5),
          for (final semester in semesters) ...[
            Tooltip(
              message: tooltipForSemester(semester),
              triggerMode: TooltipTriggerMode.tap,
              waitDuration: Duration.zero,
              showDuration: const Duration(minutes: 1),
              preferBelow: false,
              child: _SemesterLane(
                semester: semester,
                color: colorForSemester(semester),
                activityCount: assignments
                    .where(
                      (assignment) =>
                          assignment.semester == semester &&
                          assignment.timeRange == timeRange,
                    )
                    .length,
              ),
            ),
            if (semester != semesters.last) const SizedBox(height: 4),
          ],
        ],
      ),
    );
  }
}

class _SemesterLane extends StatelessWidget {
  const _SemesterLane({
    required this.semester,
    required this.color,
    required this.activityCount,
  });

  final int semester;
  final Color color;
  final int activityCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: activityCount == 0 ? color.withValues(alpha: 0.3) : color,
        borderRadius: BorderRadius.circular(5),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        activityCount == 0
            ? 'Semester $semester'
            : 'Semester $semester - $activityCount ${activityCount == 1 ? 'activity' : 'activities'}',
        style: TextStyle(
          color: activityCount == 0 ? Colors.black87 : Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _RecessPeriod extends StatelessWidget {
  const _RecessPeriod({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      alignment: Alignment.centerLeft,
      child: const Text(
        '11:00 - 11:20  Recess',
        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
      ),
    );
  }
}

class _CalendarDayMarkers {
  const _CalendarDayMarkers({
    this.periodRelevant = false,
    this.testDay = false,
    this.schoolDay = false,
  });

  final bool periodRelevant;
  final bool testDay;
  final bool schoolDay;

  String get description {
    final values = <String>[
      if (periodRelevant) 'Current period',
      if (testDay) 'Test application',
      if (schoolDay) 'School day',
    ];
    return values.isEmpty ? 'No academic activities' : values.join(', ');
  }
}

class _ScheduleCalendar extends StatelessWidget {
  const _ScheduleCalendar({
    required this.month,
    required this.selectedDate,
    required this.currentDate,
    required this.markersForDate,
    required this.onMonthChanged,
    required this.onDateSelected,
  });

  static const _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  static const _weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  static const _outline = Color(0xFF173B68);
  static const _period = Color(0xFF3B7597);
  static const _test = Color(0xFFFF8F00);
  static const _school = Color(0xFF276F27);
  static const _overlap = Color(0xFFBD4444);

  final DateTime month;
  final DateTime selectedDate;
  final DateTime currentDate;
  final _CalendarDayMarkers Function(DateTime) markersForDate;
  final ValueChanged<DateTime> onMonthChanged;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    final first = DateTime(month.year, month.month);
    final offset = first.weekday % 7;
    final days = DateUtils.getDaysInMonth(month.year, month.month);
    final cellCount = ((offset + days + 6) ~/ 7) * 7;
    final gridStart = first.subtract(Duration(days: offset));
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 6, 8, 10),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: 'Previous month',
                  onPressed: () => onMonthChanged(
                    DateTime(month.year, month.month - 1),
                  ),
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: Text(
                    '${_monthNames[month.month - 1]} ${month.year}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: 'Next month',
                  onPressed: () => onMonthChanged(
                    DateTime(month.year, month.month + 1),
                  ),
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            Row(
              children: [
                for (final weekday in _weekdays)
                  Expanded(
                    child: Center(
                      child: Text(
                        weekday,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
                mainAxisSpacing: 3,
                crossAxisSpacing: 3,
              ),
              itemCount: cellCount,
              itemBuilder: (context, index) {
                final date = gridStart.add(Duration(days: index));
                return _dayCell(context, date);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _dayCell(BuildContext context, DateTime date) {
    final markers = markersForDate(date);
    final overlaps = markers.schoolDay && markers.testDay;
    final inMonth = date.month == month.month;
    final selected = DateUtils.isSameDay(date, selectedDate);
    final today = DateUtils.isSameDay(date, currentDate);
    final background = overlaps
        ? _overlap
        : markers.testDay
            ? _test
            : markers.schoolDay
                ? _school
                : markers.periodRelevant
                    ? _period
                    : Colors.transparent;
    final foreground = overlaps ||
            markers.testDay ||
            markers.schoolDay ||
            markers.periodRelevant
        ? Colors.white
        : inMonth
            ? Theme.of(context).colorScheme.onSurface
            : Theme.of(context).colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.45,
                );
    return Tooltip(
      message: markers.description,
      child: InkWell(
        key: ValueKey(
          'calendar-day-${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
        ),
        borderRadius: BorderRadius.circular(4),
        onTap: () => onDateSelected(date),
        child: Container(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: selected
                  ? Theme.of(context).colorScheme.primary
                  : today
                      ? _outline
                      : markers.periodRelevant
                          ? _outline
                          : Colors.transparent,
              width: selected ? 2 : 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            '${date.day}',
            style: TextStyle(
              color: foreground,
              fontWeight: selected || today ? FontWeight.w700 : null,
            ),
          ),
        ),
      ),
    );
  }
}

class _CalendarLegend extends StatelessWidget {
  const _CalendarLegend();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 12,
      runSpacing: 7,
      children: [
        _LegendItem(color: Color(0xFF3B7597), label: 'Current period'),
        _LegendItem(color: Color(0xFFFF8F00), label: 'Tests'),
        _LegendItem(color: Color(0xFF276F27), label: 'School day'),
        _LegendItem(color: Color(0xFFBD4444), label: 'Overlap'),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 5),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}

class _CalendarActivity extends StatelessWidget {
  const _CalendarActivity({
    required this.assignment,
    required this.color,
    required this.teacher,
  });

  final CycleSubjectAssignment assignment;
  final Color color;
  final String teacher;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: color, width: 6)),
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            assignment.subjectName,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 3),
          Text(
              '${assignment.timeRange} | Semester ${assignment.semester}${assignment.group}'),
          Text(teacher),
        ],
      ),
    );
  }
}

class _CalendarRecess extends StatelessWidget {
  const _CalendarRecess({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Text(
        '11:00 - 11:20  Recess',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: ValueKey('$label-$value'),
      initialValue: value,
      readOnly: true,
      decoration: InputDecoration(labelText: label),
    );
  }
}
