import 'package:flutter/material.dart';

import '../../core/data/mock_repository.dart';
import '../../core/models/app_user.dart';
import '../../core/models/cycle_subject_assignment.dart';
import '../../core/models/registry_tab_record.dart';
import '../../core/models/student_enrollment.dart';
import '../../core/models/user_role.dart';

class RegistryScreen extends StatefulWidget {
  const RegistryScreen({
    super.key,
    required this.assignment,
    required this.currentUser,
    this.initialDateOverride,
  });

  final CycleSubjectAssignment assignment;
  final AppUser currentUser;
  final DateTime? initialDateOverride;

  @override
  State<RegistryScreen> createState() => _RegistryScreenState();
}

class _RegistryScreenState extends State<RegistryScreen> {
  static const _behaviorOptions = [
    'Skipped class',
    'Talking',
    'Not working',
    'Aggressive',
  ];

  late final List<DateTime> _dates;
  final Map<String, Map<String, _BehaviorDraft>> _drafts = {};

  DateTime get _today => widget.initialDateOverride ?? DateTime.now();

  String get _registryId =>
      MockRepository.registryIdForAssignment(widget.assignment);

  List<StudentEnrollment> get _students =>
      MockRepository.studentsForAssignment(widget.assignment);

  @override
  void initState() {
    super.initState();
    _dates = MockRepository.registryDatesForAssignment(widget.assignment);
    for (final date in _dates) {
      _loadDraft(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_dates.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Registry')),
        body: const Center(
          child: Text('This assignment has no registry dates.'),
        ),
      );
    }
    return DefaultTabController(
      length: _dates.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.assignment.subjectName} registry'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              for (final date in _dates) Tab(text: _formatDate(date)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            for (final date in _dates) _registryTab(date),
          ],
        ),
      ),
    );
  }

  Widget _registryTab(DateTime date) {
    final canEdit = MockRepository.registryCanEdit(
      assignment: widget.assignment,
      currentUser: widget.currentUser,
      tabDate: date,
      now: _today,
    );
    final draft = _drafts[_dateKey(date)]!;
    return ListView(
      key: PageStorageKey(_dateKey(date)),
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                _formatDate(date),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            _RegistryAccessChip(
              label: _accessLabel(date, canEdit),
              editable: canEdit,
            ),
          ],
        ),
        const SizedBox(height: 14),
        _RegistryInfo(
          teacher: widget.assignment.teacherName,
          semester: widget.assignment.semester,
          group: widget.assignment.group,
          periodHalf: widget.assignment.periodHalf,
        ),
        const SizedBox(height: 18),
        Text('Students', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        if (_students.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 28),
            child: Center(child: Text('No students assigned to this group.')),
          )
        else
          for (final student in _students) ...[
            _RegistryStudentCard(
              student: student,
              behavior: draft[student.registration]!,
              onBehavior: () => _showBehaviorEditor(
                date: date,
                student: student,
                canEdit: canEdit,
              ),
            ),
            const SizedBox(height: 8),
          ],
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: canEdit ? () => _saveTab(date) : null,
          icon: const Icon(Icons.save_outlined),
          label: const Text('Save registry tab'),
        ),
        if (!canEdit) ...[
          const SizedBox(height: 8),
          Text(
            'This tab is available for viewing only.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }

  void _loadDraft(DateTime date) {
    final saved = MockRepository.registryTab(
      assignmentId: _registryId,
      date: date,
    );
    final savedStudents = {
      for (final student in saved?.students ?? const <RegistryStudentRecord>[])
        student.registration: student,
    };
    _drafts[_dateKey(date)] = {
      for (final student in _students)
        student.registration: _BehaviorDraft.fromRecord(
          savedStudents[student.registration],
        ),
    };
  }

  Future<void> _showBehaviorEditor({
    required DateTime date,
    required StudentEnrollment student,
    required bool canEdit,
  }) async {
    final behavior = _drafts[_dateKey(date)]![student.registration]!;
    final selected = Set<String>.from(behavior.checks);
    var note = behavior.note;
    final applied = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(student.fullStudentName),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final option in _behaviorOptions)
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: selected.contains(option),
                    onChanged: canEdit
                        ? (value) => setDialogState(() {
                              if (value ?? false) {
                                selected.add(option);
                              } else {
                                selected.remove(option);
                              }
                            })
                        : null,
                    title: Text(option),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: note,
                  readOnly: !canEdit,
                  onChanged: (value) => note = value,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Behavior notes',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            if (canEdit)
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Cancel'),
              ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(canEdit),
              child: Text(canEdit ? 'Apply' : 'Close'),
            ),
          ],
        ),
      ),
    );
    if (applied == true && mounted) {
      setState(() {
        behavior
          ..checks = selected
          ..note = note.trim();
      });
    }
  }

  void _saveTab(DateTime date) {
    final draft = _drafts[_dateKey(date)]!;
    final record = RegistryTabRecord(
      assignmentId: _registryId,
      cycleId: widget.assignment.cycleId,
      date: date,
      teacherName: widget.assignment.teacherName,
      semester: widget.assignment.semester,
      group: widget.assignment.group,
      students: [
        for (final student in _students)
          RegistryStudentRecord(
            registration: student.registration,
            studentName: student.fullStudentName,
            behaviorChecks: Set.unmodifiable(
              draft[student.registration]!.checks,
            ),
            note: draft[student.registration]!.note,
          ),
      ],
    );
    final uploaded = MockRepository.saveRegistryTab(record);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          uploaded
              ? 'Registry tab saved.'
              : 'Offline registry draft saved and queued for upload.',
        ),
      ),
    );
  }

  String _accessLabel(DateTime date, bool canEdit) {
    if (widget.currentUser.role == UserRole.level1Admin) {
      return 'L1 edit override';
    }
    if (canEdit) return 'Open for editing';
    final today = DateTime(_today.year, _today.month, _today.day);
    final tabDate = DateTime(date.year, date.month, date.day);
    if (today.isBefore(tabDate)) return 'Locked until ${_formatDate(date)}';
    if (widget.currentUser.role == UserRole.level3Teacher &&
        widget.currentUser.id == widget.assignment.teacherUserId) {
      return 'Correction window closed';
    }
    return 'View only';
  }

  static String _formatDate(DateTime value) {
    return '${value.day.toString().padLeft(2, '0')}/'
        '${value.month.toString().padLeft(2, '0')}/${value.year}';
  }

  static String _dateKey(DateTime value) {
    return '${value.year}-${value.month}-${value.day}';
  }
}

class _BehaviorDraft {
  _BehaviorDraft({Set<String>? checks, this.note = ''})
      : checks = checks ?? <String>{};

  factory _BehaviorDraft.fromRecord(RegistryStudentRecord? record) {
    return _BehaviorDraft(
      checks: Set<String>.from(record?.behaviorChecks ?? const {}),
      note: record?.note ?? '',
    );
  }

  Set<String> checks;
  String note;

  int get count => checks.length;
  String get status {
    if (count == 0) return 'Regular';
    if (count <= 2) return 'Irregular';
    return 'Bad';
  }
}

class _RegistryInfo extends StatelessWidget {
  const _RegistryInfo({
    required this.teacher,
    required this.semester,
    required this.group,
    required this.periodHalf,
  });

  final String teacher;
  final int semester;
  final String group;
  final String periodHalf;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        Chip(
          avatar: const Icon(Icons.person_outline, size: 18),
          label: Text(teacher),
        ),
        Chip(label: Text('Semester $semester')),
        Chip(label: Text('Group $group')),
        Chip(label: Text(periodHalf)),
      ],
    );
  }
}

class _RegistryAccessChip extends StatelessWidget {
  const _RegistryAccessChip({required this.label, required this.editable});

  final String label;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        editable ? Icons.lock_open_outlined : Icons.lock_outline,
        size: 17,
      ),
      label: Text(label),
      backgroundColor: editable
          ? const Color(0xFFDDF3E4)
          : Theme.of(context).colorScheme.surfaceContainerHighest,
    );
  }
}

class _RegistryStudentCard extends StatelessWidget {
  const _RegistryStudentCard({
    required this.student,
    required this.behavior,
    required this.onBehavior,
  });

  final StudentEnrollment student;
  final _BehaviorDraft behavior;
  final VoidCallback onBehavior;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (behavior.status) {
      'Irregular' => (const Color(0xFFFFF1C7), const Color(0xFF725A00)),
      'Bad' => (const Color(0xFFFAD8D5), const Color(0xFF8B1E18)),
      _ => (const Color(0xFFDDF3E4), const Color(0xFF245C36)),
    };
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.fullStudentName,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 3),
                  Text(student.registration),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: background,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      behavior.status,
                      style: TextStyle(color: foreground),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Behavior details',
              onPressed: onBehavior,
              icon: const Icon(Icons.rule_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
