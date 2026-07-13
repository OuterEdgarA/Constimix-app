import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/data/mock_repository.dart';
import '../../core/models/app_user.dart';
import '../../core/models/cycle_subject_assignment.dart';
import '../../core/models/student_enrollment.dart';
import '../../core/models/student_grade_entry.dart';
import '../../core/models/user_role.dart';
import '../../shared/widgets/section_header.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen({super.key, required this.currentUser});

  final AppUser currentUser;

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  final _searchController = TextEditingController();
  final Set<int> _semesterFilters = {};
  final Set<String> _groupFilters = {};
  bool _showSuggestions = false;

  List<CycleSubjectAssignment> get _assignments {
    return MockRepository.subjectAssignmentsFor(widget.currentUser);
  }

  List<CycleSubjectAssignment> get _filteredAssignments {
    final query = _searchController.text;
    return _assignments.where((assignment) {
      final semesterMatches = _semesterFilters.isEmpty ||
          _semesterFilters.contains(assignment.semester);
      final groupMatches =
          _groupFilters.isEmpty || _groupFilters.contains(assignment.group);
      return semesterMatches && groupMatches && assignment.matchesSearch(query);
    }).toList(growable: false);
  }

  List<CycleSubjectAssignment> get _suggestions {
    final query = _searchController.text.trim();
    if (!_showSuggestions || query.isEmpty) return const [];
    return _assignments
        .where((assignment) => assignment.matchesSearch(query))
        .take(3)
        .toList(growable: false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cycleName =
        MockRepository.activeCycle?.name.toUpperCase() ?? 'NO CYCLE SELECTED';
    final canGrade = widget.currentUser.role.canGrade;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionHeader(
          title: canGrade ? 'Grades' : 'Grade registry',
          subtitle: 'Cycle subject assignments',
          trailing: IconButton(
            tooltip: 'Download grade PDF table',
            onPressed: _showPdfNotice,
            icon: const Icon(Icons.picture_as_pdf_outlined),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          key: ValueKey(cycleName),
          initialValue: cycleName,
          readOnly: true,
          decoration: const InputDecoration(labelText: 'Current active cycle'),
        ),
        const SizedBox(height: 16),
        Text('Semester', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        _MultiFilterChips<int>(
          values: const [1, 2, 3, 4, 5, 6],
          selectedValues: _semesterFilters,
          label: (value) => '$value',
          onToggle: (value) => setState(() {
            if (!_semesterFilters.add(value)) _semesterFilters.remove(value);
          }),
        ),
        const SizedBox(height: 14),
        Text('Group', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        _MultiFilterChips<String>(
          values: const ['A', 'B', 'C', 'D'],
          selectedValues: _groupFilters,
          label: (value) => value,
          onToggle: (value) => setState(() {
            if (!_groupFilters.add(value)) _groupFilters.remove(value);
          }),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _searchController,
          onChanged: (_) => setState(() => _showSuggestions = true),
          decoration: InputDecoration(
            labelText: 'Search subjects',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              tooltip: 'Clear search',
              onPressed: () => setState(() {
                _searchController.clear();
                _showSuggestions = false;
              }),
              icon: const Icon(Icons.close),
            ),
          ),
        ),
        if (_showSuggestions && _searchController.text.trim().isNotEmpty) ...[
          const SizedBox(height: 4),
          Material(
            elevation: 3,
            borderRadius: BorderRadius.circular(8),
            child: _suggestions.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No matches'),
                  )
                : Column(
                    children: [
                      for (final assignment in _suggestions)
                        ListTile(
                          leading: const Icon(Icons.menu_book_outlined),
                          title: Text(assignment.subjectName),
                          subtitle: Text(
                            '${assignment.teacherName} | '
                            '${assignment.semester}${assignment.group}',
                          ),
                          onTap: () => _openGradingTool(assignment),
                        ),
                    ],
                  ),
          ),
        ],
        const SizedBox(height: 20),
        Text('Subjects', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 10),
        if (MockRepository.activeCycle == null)
          const _EmptyState(message: 'No active cycle')
        else if (_filteredAssignments.isEmpty)
          const _EmptyState(message: 'No assigned subjects')
        else
          for (final assignment in _filteredAssignments) ...[
            _SubjectAssignmentCard(
              assignment: assignment,
              canGrade: canGrade,
              onGrade: () => _openGradingTool(assignment),
              onRegistry: _showPdfNotice,
            ),
            const SizedBox(height: 8),
          ],
      ],
    );
  }

  Future<void> _openGradingTool(CycleSubjectAssignment assignment) async {
    setState(() {
      _searchController.text = assignment.subjectName;
      _showSuggestions = false;
    });
    if (!widget.currentUser.role.canGrade) {
      _showPdfNotice();
      return;
    }
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => GradingToolScreen(assignment: assignment),
      ),
    );
    if (mounted) setState(() {});
  }

  void _showPdfNotice() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Grade PDF table export is display only.')),
    );
  }
}

class _MultiFilterChips<T> extends StatelessWidget {
  const _MultiFilterChips({
    required this.values,
    required this.selectedValues,
    required this.label,
    required this.onToggle,
  });

  final List<T> values;
  final Set<T> selectedValues;
  final String Function(T) label;
  final ValueChanged<T> onToggle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final value in values)
          FilterChip(
            label: Text(label(value)),
            selected: selectedValues.contains(value),
            onSelected: (_) => onToggle(value),
          ),
      ],
    );
  }
}

class _SubjectAssignmentCard extends StatelessWidget {
  const _SubjectAssignmentCard({
    required this.assignment,
    required this.canGrade,
    required this.onGrade,
    required this.onRegistry,
  });

  final CycleSubjectAssignment assignment;
  final bool canGrade;
  final VoidCallback onGrade;
  final VoidCallback onRegistry;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              assignment.subjectName,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(assignment.teacherName),
            Text('Semester ${assignment.semester} | Group ${assignment.group}'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: canGrade ? onGrade : null,
                    icon: const Icon(Icons.edit_note_outlined),
                    label: const Text('Grade'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onRegistry,
                    icon: const Icon(Icons.table_chart_outlined),
                    label: const Text('Registry'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum _StudentGradeFilter { graded, ungraded, all }

class GradingToolScreen extends StatefulWidget {
  const GradingToolScreen({super.key, required this.assignment});

  final CycleSubjectAssignment assignment;

  @override
  State<GradingToolScreen> createState() => _GradingToolScreenState();
}

class _GradingToolScreenState extends State<GradingToolScreen> {
  static const _evaluationTypes = [
    'Final evaluation',
    'R1',
    'R2',
    'R3',
    'RE',
    'TS',
  ];

  int _step = 0;
  String _evaluationType = _evaluationTypes.first;
  DateTime _evaluationDate = DateTime.now();
  final _activitiesCountController = TextEditingController(text: '0');
  final _activitiesPercentageController = TextEditingController(text: '7');
  final _testPercentageController = TextEditingController(text: '3');
  bool _customizePercentages = false;
  _StudentGradeFilter _studentFilter = _StudentGradeFilter.all;
  final Map<String, _GradeInputControllers> _studentInputs = {};

  double get _activitiesCount =>
      double.tryParse(_activitiesCountController.text) ?? -1;
  double get _activitiesPercentage {
    if (_activitiesCount == 0) return 0;
    if (!_customizePercentages) return 7;
    return double.tryParse(_activitiesPercentageController.text) ?? -1;
  }

  double get _testPercentage {
    if (_activitiesCount == 0) return 10;
    if (!_customizePercentages) return 3;
    return double.tryParse(_testPercentageController.text) ?? -1;
  }

  bool get _percentagesValid {
    if (_activitiesCount < 0) return false;
    if (!_customizePercentages || _activitiesCount == 0) return true;
    return (_activitiesPercentage + _testPercentage - 10).abs() < 0.0001;
  }

  List<StudentEnrollment> get _students {
    return MockRepository.studentsForAssignment(widget.assignment);
  }

  List<StudentEnrollment> get _visibleStudents {
    return _students.where((student) {
      final graded = MockRepository.gradeForStudent(
            assignment: widget.assignment,
            registration: student.registration,
            evaluationType: _evaluationType,
          ) !=
          null;
      return switch (_studentFilter) {
        _StudentGradeFilter.graded => graded,
        _StudentGradeFilter.ungraded => !graded,
        _StudentGradeFilter.all => true,
      };
    }).toList(growable: false);
  }

  @override
  void initState() {
    super.initState();
    _activitiesCountController.addListener(_activitiesCountChanged);
    _activitiesPercentageController.addListener(_refresh);
    _testPercentageController.addListener(_refresh);
    _loadStudentInputs();
  }

  @override
  void dispose() {
    _activitiesCountController
      ..removeListener(_activitiesCountChanged)
      ..dispose();
    _activitiesPercentageController
      ..removeListener(_refresh)
      ..dispose();
    _testPercentageController
      ..removeListener(_refresh)
      ..dispose();
    for (final inputs in _studentInputs.values) {
      inputs.dispose();
    }
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  void _activitiesCountChanged() {
    if (_customizePercentages && _activitiesCount == 0) {
      if (_activitiesPercentageController.text != '0') {
        _activitiesPercentageController.text = '0';
      }
      if (_testPercentageController.text != '10') {
        _testPercentageController.text = '10';
      }
    }
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Grading tool'),
        actions: [
          IconButton(
            tooltip: 'Download grade PDF table',
            onPressed: _showPdfNotice,
            icon: const Icon(Icons.picture_as_pdf_outlined),
          ),
        ],
      ),
      body: Stepper(
        currentStep: _step,
        onStepTapped: (step) {
          if (step <= _step) setState(() => _step = step);
        },
        controlsBuilder: (_, __) => const SizedBox.shrink(),
        steps: [
          Step(
            title: const Text('Subject data'),
            isActive: _step >= 0,
            state: _step > 0 ? StepState.complete : StepState.indexed,
            content: _subjectDataStep(),
          ),
          Step(
            title: const Text('Evaluation data'),
            isActive: _step >= 1,
            state: _step > 1 ? StepState.complete : StepState.indexed,
            content: _evaluationDataStep(),
          ),
          Step(
            title: const Text('Grading'),
            isActive: _step >= 2,
            content: _gradingStep(),
          ),
        ],
      ),
    );
  }

  Widget _subjectDataStep() {
    final cycle =
        MockRepository.activeCycle?.name.toUpperCase() ?? 'NO CYCLE SELECTED';
    return Column(
      children: [
        _ReadOnlyValue(
            label: 'Semester', value: '${widget.assignment.semester}'),
        const SizedBox(height: 10),
        _ReadOnlyValue(label: 'Group', value: widget.assignment.group),
        const SizedBox(height: 10),
        _ReadOnlyValue(label: 'Current active cycle', value: cycle),
        const SizedBox(height: 10),
        _ReadOnlyValue(
          label: 'Assigned teacher',
          value: widget.assignment.teacherName,
        ),
        const SizedBox(height: 10),
        _ReadOnlyValue(
          label: 'Subject name',
          value: widget.assignment.subjectName,
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
            onPressed: () => setState(() => _step = 1),
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Next'),
          ),
        ),
      ],
    );
  }

  Widget _evaluationDataStep() {
    final sum = _activitiesPercentage + _testPercentage;
    return Column(
      children: [
        OutlinedButton.icon(
          onPressed: _pickEvaluationDate,
          icon: const Icon(Icons.calendar_month_outlined),
          label: Text(_formatDate(_evaluationDate)),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: _evaluationType,
          decoration: const InputDecoration(labelText: 'Evaluation type'),
          items: [
            for (final type in _evaluationTypes)
              DropdownMenuItem(value: type, child: Text(type)),
          ],
          onChanged: (value) {
            if (value == null) return;
            setState(() {
              _evaluationType = value;
              _reloadSavedGrades();
            });
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _activitiesCountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: const [_DecimalInputFormatter()],
          decoration: InputDecoration(
            labelText: 'Activities count',
            errorText:
                _activitiesCount < 0 ? 'Enter zero or a positive value.' : null,
          ),
        ),
        const SizedBox(height: 8),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          value: _customizePercentages,
          title: const Text('Customize grade percentage'),
          onChanged: (value) => setState(() {
            _customizePercentages = value ?? false;
            if (_activitiesCount == 0) {
              _activitiesPercentageController.text = '0';
              _testPercentageController.text = '10';
            }
          }),
        ),
        if (_customizePercentages) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _activitiesPercentageController,
                  enabled: _activitiesCount != 0,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: const [_DecimalInputFormatter()],
                  decoration: InputDecoration(
                    labelText: 'Activities percentage',
                    errorText: !_percentagesValid
                        ? 'Percentages must add to 10.'
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _testPercentageController,
                  enabled: _activitiesCount != 0,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: const [_DecimalInputFormatter()],
                  decoration: InputDecoration(
                    labelText: 'Test percentage',
                    errorText: !_percentagesValid
                        ? 'Current total: ${sum.toStringAsFixed(1)}'
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            TextButton.icon(
              onPressed: () => setState(() => _step = 0),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back'),
            ),
            const Spacer(),
            FilledButton.icon(
              onPressed: _percentagesValid ? _showTable : null,
              icon: const Icon(Icons.table_rows_outlined),
              label: const Text('Show table'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _gradingStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton<_StudentGradeFilter>(
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(
              value: _StudentGradeFilter.graded,
              label: Text('Graded'),
            ),
            ButtonSegment(
              value: _StudentGradeFilter.ungraded,
              label: Text('Not graded'),
            ),
            ButtonSegment(
              value: _StudentGradeFilter.all,
              label: Text('All'),
            ),
          ],
          selected: {_studentFilter},
          onSelectionChanged: (selection) {
            setState(() => _studentFilter = selection.first);
          },
        ),
        const SizedBox(height: 12),
        if (_visibleStudents.isEmpty)
          const _EmptyState(message: 'No students in this view')
        else
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 520),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _visibleStudents.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final student = _visibleStudents[index];
                return _StudentGradeCard(
                  student: student,
                  inputs: _inputsFor(student),
                  activitiesCount: _activitiesCount,
                  activitiesPercentage: _activitiesPercentage,
                  testPercentage: _testPercentage,
                  usesLetterGrades: widget.assignment.usesLetterGrades,
                  onChanged: _refresh,
                );
              },
            ),
          ),
        const SizedBox(height: 16),
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.green.shade700,
            foregroundColor: Colors.white,
          ),
          onPressed: _saveGrades,
          icon: const Icon(Icons.save_outlined),
          label: const Text('Save grades'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _showPdfNotice,
          icon: const Icon(Icons.picture_as_pdf_outlined),
          label: const Text('Download grade PDF table'),
        ),
      ],
    );
  }

  Future<void> _pickEvaluationDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _evaluationDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selected != null) setState(() => _evaluationDate = selected);
  }

  void _showTable() {
    if (!_percentagesValid) return;
    _loadStudentInputs();
    setState(() => _step = 2);
  }

  _GradeInputControllers _inputsFor(StudentEnrollment student) {
    return _studentInputs.putIfAbsent(
      student.registration,
      () => _GradeInputControllers(),
    );
  }

  void _loadStudentInputs() {
    for (final student in _students) {
      final inputs = _inputsFor(student);
      final saved = MockRepository.gradeForStudent(
        assignment: widget.assignment,
        registration: student.registration,
        evaluationType: _evaluationType,
      );
      if (saved != null) inputs.load(saved);
    }
  }

  void _reloadSavedGrades() {
    for (final inputs in _studentInputs.values) {
      inputs.clear();
    }
    _loadStudentInputs();
  }

  bool _isInputValid(StudentEnrollment student) {
    final inputs = _inputsFor(student);
    final absences = int.tryParse(inputs.absences.text);
    final submitted = double.tryParse(inputs.activities.text);
    final test = double.tryParse(inputs.test.text);
    if (absences == null || absences < 0 || submitted == null || test == null) {
      return false;
    }
    return submitted >= 0 &&
        submitted <= math.max(0, _activitiesCount) &&
        test >= 0 &&
        test <= 10;
  }

  Future<void> _saveGrades() async {
    final ungraded =
        _students.where((student) => !_isInputValid(student)).length;
    if (ungraded > 0) {
      final continueSaving = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Ungraded students'),
          content: Text(
            '$ungraded students do not have complete valid grades.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Keep grading'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Continue saving'),
            ),
          ],
        ),
      );
      if (continueSaving != true) return;
    }

    final entries = <StudentGradeEntry>[];
    for (final student in _students.where(_isInputValid)) {
      final inputs = _inputsFor(student);
      final submitted = double.parse(inputs.activities.text);
      final test = double.parse(inputs.test.text);
      final activityGrade = _activitiesCount == 0
          ? 0
          : (submitted * _activitiesPercentage) / _activitiesCount;
      final testGrade = (test * _testPercentage) / 10;
      entries.add(
        StudentGradeEntry(
          cycleId: widget.assignment.cycleId,
          assignmentId: widget.assignment.id,
          registration: student.registration,
          evaluationType: _evaluationType,
          evaluationDate: _evaluationDate,
          absences: int.parse(inputs.absences.text),
          activitiesSubmitted: submitted,
          testGrade: test,
          finalGrade: activityGrade + testGrade,
        ),
      );
    }

    final uploaded = MockRepository.saveStudentGrades(entries);
    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          uploaded
              ? 'Grades saved.'
              : 'Offline draft saved and queued for upload.',
        ),
      ),
    );
  }

  void _showPdfNotice() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Grade PDF table export is display only.')),
    );
  }
}

class _StudentGradeCard extends StatelessWidget {
  const _StudentGradeCard({
    required this.student,
    required this.inputs,
    required this.activitiesCount,
    required this.activitiesPercentage,
    required this.testPercentage,
    required this.usesLetterGrades,
    required this.onChanged,
  });

  final StudentEnrollment student;
  final _GradeInputControllers inputs;
  final double activitiesCount;
  final double activitiesPercentage;
  final double testPercentage;
  final bool usesLetterGrades;
  final VoidCallback onChanged;

  double get _submitted => double.tryParse(inputs.activities.text) ?? 0;
  double get _test => double.tryParse(inputs.test.text) ?? 0;
  double get _activityGrade => activitiesCount <= 0
      ? 0
      : (_submitted * activitiesPercentage) / activitiesCount;
  double get _testGrade => (_test * testPercentage) / 10;
  double get _finalGrade =>
      (_activityGrade + _testGrade).clamp(0, 10).toDouble();

  @override
  Widget build(BuildContext context) {
    final submitted = double.tryParse(inputs.activities.text);
    final test = double.tryParse(inputs.test.text);
    final activityInvalid =
        submitted != null && (submitted < 0 || submitted > activitiesCount);
    final testInvalid = test != null && (test < 0 || test > 10);
    final displayedGrade = _displayGrade(_finalGrade, usesLetterGrades);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${student.studentName} ${student.studentFatherSurname} '
              '${student.studentMotherSurname}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: inputs.absences,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (_) => onChanged(),
              decoration: const InputDecoration(labelText: 'Absences'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: inputs.activities,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: const [_DecimalInputFormatter()],
              onChanged: (_) => onChanged(),
              decoration: InputDecoration(
                labelText: 'Submitted activities',
                errorText: activityInvalid
                    ? 'Maximum ${math.max(0, activitiesCount)}'
                    : null,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: inputs.test,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: const [_DecimalInputFormatter()],
              onChanged: (_) => onChanged(),
              decoration: InputDecoration(
                labelText: 'Test grade',
                errorText: testInvalid ? 'Use a value from 0 to 10.' : null,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              key: ValueKey('${student.registration}-$displayedGrade'),
              initialValue: displayedGrade,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Final grade'),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _showDetails(context),
                icon: const Icon(Icons.calculate_outlined),
                label: const Text('Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDetails(BuildContext context) {
    final total = math.max(0, activitiesCount);
    final mapped = _displayGrade(_finalGrade, usesLetterGrades);
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Grade details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                total == 0
                    ? 'Activities: no activities configured = 0.00'
                    : 'Activities: ${_trimDouble(_submitted)} x '
                        '${_trimDouble(activitiesPercentage)} / '
                        '${_trimDouble(total.toDouble())} = '
                        '${_activityGrade.toStringAsFixed(2)}',
              ),
              const SizedBox(height: 8),
              Text(
                'Test: ${_trimDouble(_test)} x '
                '${_trimDouble(testPercentage)} / 10 = '
                '${_testGrade.toStringAsFixed(2)}',
              ),
              const Divider(height: 24),
              Text(
                'Final: ${_activityGrade.toStringAsFixed(2)} + '
                '${_testGrade.toStringAsFixed(2)} = '
                '${_finalGrade.toStringAsFixed(2)} ($mapped)',
              ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _GradeInputControllers {
  final absences = TextEditingController(text: '0');
  final activities = TextEditingController();
  final test = TextEditingController();

  void load(StudentGradeEntry grade) {
    absences.text = '${grade.absences}';
    activities.text = _trimDouble(grade.activitiesSubmitted);
    test.text = _trimDouble(grade.testGrade);
  }

  void clear() {
    absences.text = '0';
    activities.clear();
    test.clear();
  }

  void dispose() {
    absences.dispose();
    activities.dispose();
    test.dispose();
  }
}

class _ReadOnlyValue extends StatelessWidget {
  const _ReadOnlyValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value.toUpperCase(),
      readOnly: true,
      decoration: InputDecoration(labelText: label),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Center(child: Text(message)),
    );
  }
}

class _DecimalInputFormatter extends TextInputFormatter {
  const _DecimalInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (RegExp(r'^\d*([.]\d*)?$').hasMatch(newValue.text)) return newValue;
    return oldValue;
  }
}

String _displayGrade(double grade, bool usesLetterGrades) {
  if (grade <= 0) return 'NP';
  if (!usesLetterGrades) return grade.toStringAsFixed(1);
  final mapped = grade.round().clamp(1, 10);
  return switch (mapped) {
    10 => 'A',
    9 => 'B',
    8 => 'C',
    7 => 'D',
    6 => 'E',
    5 => 'F',
    _ => '$mapped',
  };
}

String _formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/${date.year}';
}

String _trimDouble(double value) {
  return value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toString();
}
