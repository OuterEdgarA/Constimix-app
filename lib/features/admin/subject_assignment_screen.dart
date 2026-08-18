import 'package:flutter/material.dart';

import '../../core/data/mock_repository.dart';
import '../../core/models/app_user.dart';
import '../../core/models/cycle_subject_assignment.dart';
import '../../core/models/school_subject.dart';
import '../../core/models/user_role.dart';
import '../../shared/widgets/section_header.dart';

class SubjectAssignmentScreen extends StatefulWidget {
  const SubjectAssignmentScreen({
    super.key,
    required this.subject,
  });

  final SchoolSubject subject;

  @override
  State<SubjectAssignmentScreen> createState() =>
      _SubjectAssignmentScreenState();
}

class _SubjectAssignmentScreenState extends State<SubjectAssignmentScreen> {
  static const _groups = ['A', 'B', 'C', 'D'];
  static const _periodHalves = ['First half', 'Second half'];
  static const _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  static const _timeRanges = [
    '08:00 - 09:30',
    '09:30 - 11:00',
    '11:20 - 12:50',
    '12:50 - 14:20',
    '14:20 - 15:50',
  ];

  int _currentStep = 0;
  int _semester = 1;
  String _periodHalf = _periodHalves.first;
  Map<String, _AssignmentSlotDraft> _slots = {};

  List<AppUser> get _teacherCandidates => MockRepository.users
      .where(
        (user) =>
            user.isActive &&
            (user.role == UserRole.level1Admin ||
                user.role == UserRole.level3Teacher),
      )
      .toList(growable: false);

  Iterable<_AssignmentSlotDraft> get _assignedSlots =>
      _slots.values.where((slot) => slot.teacherUserId != null);

  @override
  void initState() {
    super.initState();
    final existing = MockRepository.assignmentsForSubject(widget.subject);
    final initialSemester = existing.isNotEmpty
        ? existing.first.semester
        : widget.subject.semester.clamp(1, 6);
    _loadSemester(initialSemester);
  }

  @override
  void dispose() {
    _disposeSlots();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assign subject')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SectionHeader(
              title: widget.subject.name,
              subtitle: 'Assign teachers, groups, and class times.',
            ),
            const SizedBox(height: 16),
            Stepper(
              currentStep: _currentStep,
              controlsBuilder: _buildControls,
              steps: [
                Step(
                  title: const Text('Subject information'),
                  isActive: _currentStep >= 0,
                  content: _subjectInformationStep(),
                ),
                Step(
                  title: const Text('Teacher, semester and group'),
                  isActive: _currentStep >= 1,
                  content: _teacherAssignmentStep(),
                ),
                Step(
                  title: const Text('Day and hour'),
                  isActive: _currentStep >= 2,
                  content: _scheduleStep(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls(BuildContext context, ControlsDetails details) {
    final isLast = _currentStep == 2;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          FilledButton.icon(
            onPressed: isLast ? _saveAssignments : _continue,
            icon: Icon(
              isLast
                  ? Icons.save_outlined
                  : _currentStep == 1
                      ? Icons.person_add_alt_outlined
                      : Icons.arrow_forward,
            ),
            label: Text(
              isLast
                  ? 'Save'
                  : _currentStep == 1
                      ? 'Assign'
                      : 'Next',
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: _currentStep == 0
                ? null
                : () => setState(() => _currentStep -= 1),
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }

  Widget _subjectInformationStep() {
    return Column(
      children: [
        _ReadOnlyField(label: 'IDmateria', value: widget.subject.idMateria),
        const SizedBox(height: 12),
        _ReadOnlyField(label: 'Subject name', value: widget.subject.name),
        const SizedBox(height: 12),
        _ReadOnlyField(label: 'Clave', value: widget.subject.keyCode),
        const SizedBox(height: 12),
        _ReadOnlyField(
          label: 'Evaluation type',
          value: widget.subject.evaluationType,
        ),
      ],
    );
  }

  Widget _teacherAssignmentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<int>(
          key: ValueKey('assignment-semester-$_semester'),
          initialValue: _semester,
          decoration: const InputDecoration(labelText: 'Semester'),
          items: [
            for (var semester = 1; semester <= 6; semester++)
              DropdownMenuItem(value: semester, child: Text('$semester')),
          ],
          onChanged: (value) {
            if (value == null || value == _semester) return;
            setState(() => _loadSemester(value));
          },
        ),
        const SizedBox(height: 16),
        for (final group in _groups) ...[
          _TeacherSlotField(
            key: ValueKey('teacher-slot-$group-$_semester'),
            group: group,
            semester: _semester,
            slot: _slots[group]!,
            candidates: _teacherCandidates,
          ),
          if (group != _groups.last) const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _scheduleStep() {
    final assigned = _assignedSlots.toList(growable: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<String>(
          initialValue: _periodHalf,
          decoration: const InputDecoration(labelText: 'Period half'),
          items: [
            for (final value in _periodHalves)
              DropdownMenuItem(value: value, child: Text(value)),
          ],
          onChanged: (value) {
            if (value != null) setState(() => _periodHalf = value);
          },
        ),
        const SizedBox(height: 16),
        for (final slot in assigned) ...[
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _slotTitle(slot.group, _semester),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(slot.teacherName),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: slot.day,
                    decoration: const InputDecoration(labelText: 'Day'),
                    items: [
                      for (final day in _days)
                        DropdownMenuItem(value: day, child: Text(day)),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => slot.day = value);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: slot.timeRange,
                    decoration: const InputDecoration(labelText: 'Hour range'),
                    items: [
                      for (final range in _timeRanges)
                        DropdownMenuItem(value: range, child: Text(range)),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => slot.timeRange = value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  void _continue() {
    if (_currentStep == 0) {
      setState(() => _currentStep = 1);
      return;
    }
    if (_validateTeacherSlots()) setState(() => _currentStep = 2);
  }

  bool _validateTeacherSlots() {
    for (final slot in _slots.values) {
      final input = slot.controller.text.trim();
      if (input.isEmpty) {
        slot.clearTeacher();
        continue;
      }
      if (slot.teacherUserId != null && input == slot.teacherName) continue;
      AppUser? match;
      for (final candidate in _teacherCandidates) {
        if (candidate.displayName.toLowerCase() == input.toLowerCase() ||
            candidate.username.toLowerCase() == input.toLowerCase()) {
          match = candidate;
          break;
        }
      }
      if (match == null) {
        _showMessage('Choose a suggested account for Slot ${slot.group}.');
        return false;
      }
      slot.selectTeacher(match);
    }
    if (_assignedSlots.isEmpty) {
      _showMessage('Assign at least one teacher slot.');
      return false;
    }
    return true;
  }

  void _saveAssignments() {
    if (!_validateTeacherSlots()) return;
    final cycle = MockRepository.activeCycle;
    if (cycle == null) {
      _showMessage('Select an active cycle before assigning a subject.');
      return;
    }
    final assignments = _assignedSlots.map(
      (slot) => CycleSubjectAssignment(
        id: '${cycle.id}-${widget.subject.idMateria}-$_semester-${slot.group}',
        subjectId: widget.subject.idMateria,
        cycleId: cycle.id,
        subjectName: widget.subject.name,
        teacherName: slot.teacherName,
        teacherUserId: slot.teacherUserId!,
        semester: _semester,
        group: slot.group,
        evaluationMode: widget.subject.evaluationType,
        periodHalf: _periodHalf,
        day: slot.day,
        timeRange: slot.timeRange,
      ),
    );
    MockRepository.replaceSubjectAssignments(
      subject: widget.subject,
      semester: _semester,
      assignments: assignments,
    );
    Navigator.of(context).pop(true);
  }

  void _loadSemester(int semester) {
    _disposeSlots();
    _semester = semester;
    final existing = {
      for (final assignment in MockRepository.assignmentsForSubjectSemester(
        widget.subject,
        semester,
      ))
        assignment.group: assignment,
    };
    if (existing.isNotEmpty) {
      _periodHalf = existing.values.first.periodHalf;
    } else {
      _periodHalf = _periodHalves.first;
    }
    _slots = {
      for (final group in _groups)
        group: _AssignmentSlotDraft(
          group: group,
          assignment: existing[group],
        ),
    };
  }

  void _disposeSlots() {
    for (final slot in _slots.values) {
      slot.dispose();
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static String _slotTitle(String group, int semester) {
    if (semester < 5) return 'Slot $group - Group $group';
    final area = _groups.indexOf(group) + 1;
    return 'Slot $group - Group $group / Area $area';
  }
}

class _TeacherSlotField extends StatelessWidget {
  const _TeacherSlotField({
    super.key,
    required this.group,
    required this.semester,
    required this.slot,
    required this.candidates,
  });

  final String group;
  final int semester;
  final _AssignmentSlotDraft slot;
  final List<AppUser> candidates;

  @override
  Widget build(BuildContext context) {
    return Autocomplete<AppUser>(
      textEditingController: slot.controller,
      focusNode: slot.focusNode,
      displayStringForOption: (user) => user.displayName,
      optionsBuilder: (value) {
        final query = value.text.trim().toLowerCase();
        return candidates.where(
          (user) =>
              query.isEmpty ||
              user.displayName.toLowerCase().contains(query) ||
              user.username.toLowerCase().contains(query),
        );
      },
      onSelected: slot.selectTeacher,
      fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          onChanged: slot.updateInput,
          decoration: InputDecoration(
            labelText:
                _SubjectAssignmentScreenState._slotTitle(group, semester),
            prefixIcon: const Icon(Icons.person_search_outlined),
            suffixIcon: controller.text.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Clear slot',
                    onPressed: slot.clear,
                    icon: const Icon(Icons.close),
                  ),
          ),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        final entries = options.toList(growable: false);
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220, maxWidth: 420),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final user = entries[index];
                  return ListTile(
                    leading: const Icon(Icons.account_circle_outlined),
                    title: Text(user.displayName),
                    subtitle: Text('${user.role.label} | ${user.username}'),
                    onTap: () => onSelected(user),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AssignmentSlotDraft {
  _AssignmentSlotDraft({
    required this.group,
    CycleSubjectAssignment? assignment,
  })  : teacherUserId = assignment?.teacherUserId,
        teacherName = assignment?.teacherName ?? '',
        day = assignment?.day ?? 'Saturday',
        timeRange = assignment?.timeRange ?? '08:00 - 09:30',
        controller = TextEditingController(text: assignment?.teacherName ?? ''),
        focusNode = FocusNode();

  final String group;
  final TextEditingController controller;
  final FocusNode focusNode;
  String? teacherUserId;
  String teacherName;
  String day;
  String timeRange;

  void selectTeacher(AppUser user) {
    teacherUserId = user.id;
    teacherName = user.displayName;
    controller.text = user.displayName;
    controller.selection =
        TextSelection.collapsed(offset: controller.text.length);
  }

  void updateInput(String value) {
    if (value.trim() == teacherName) return;
    teacherUserId = null;
    teacherName = value.trim();
  }

  void clearTeacher() {
    teacherUserId = null;
    teacherName = '';
  }

  void clear() {
    controller.clear();
    clearTeacher();
    focusNode.requestFocus();
  }

  void dispose() {
    controller.dispose();
    focusNode.dispose();
  }
}

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      decoration: InputDecoration(labelText: label),
    );
  }
}
