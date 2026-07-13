import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/data/mock_repository.dart';
import '../../core/models/academic_cycle.dart';
import '../../core/models/school_subject.dart';
import '../../core/models/student_enrollment.dart';
import '../../shared/widgets/section_header.dart';
import '../enrollment/enrollment_wizard_screen.dart';

class SemesterAdminScreen extends StatefulWidget {
  const SemesterAdminScreen({super.key});

  @override
  State<SemesterAdminScreen> createState() => _SemesterAdminScreenState();
}

class _SemesterAdminScreenState extends State<SemesterAdminScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              tooltip: 'Back to system admin',
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back),
            ),
            const SizedBox(width: 4),
            const Expanded(
              child: SectionHeader(
                title: 'Semester admin',
                subtitle: 'Manage subjects, groups, and academic cycles.',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _SubjectCreatorCard(onChanged: () => setState(() {})),
        const SizedBox(height: 12),
        _GroupAdminCard(onChanged: () => setState(() {})),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(Icons.date_range_outlined),
            title: const Text('Cycle manager'),
            subtitle: Text(
              MockRepository.activeCycle?.name ?? 'No cycle selected',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              await Navigator.of(context).push<void>(
                MaterialPageRoute(builder: (_) => const CycleManagerScreen()),
              );
              if (mounted) setState(() {});
            },
          ),
        ),
      ],
    );
  }
}

class _SubjectCreatorCard extends StatefulWidget {
  const _SubjectCreatorCard({required this.onChanged});

  final VoidCallback onChanged;

  @override
  State<_SubjectCreatorCard> createState() => _SubjectCreatorCardState();
}

class _SubjectCreatorCardState extends State<_SubjectCreatorCard> {
  final _formKey = GlobalKey<FormState>();
  final _keyController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  SchoolSubject? _editingSubject;
  bool _isExtracurricular = false;
  int _area = 0;
  int _semester = 1;
  String _evaluationType = 'Number Evaluation';
  DateTimeRange? _dateRange;

  String get _idMateria =>
      _editingSubject?.idMateria ??
      MockRepository.previewNextSubjectId(_isExtracurricular);
  bool get _keyInUse =>
      _keyController.text.trim().isNotEmpty &&
      MockRepository.subjectKeyExists(
        _keyController.text,
        exceptId: _editingSubject?.idMateria,
      );
  bool get _nameInUse =>
      _nameController.text.trim().isNotEmpty &&
      MockRepository.subjectNameExists(
        _nameController.text,
        exceptId: _editingSubject?.idMateria,
      );

  @override
  void initState() {
    super.initState();
    _keyController.addListener(_refresh);
    _nameController.addListener(_refresh);
  }

  @override
  void dispose() {
    _keyController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: true,
        leading: const Icon(Icons.menu_book_outlined),
        title: const Text('Subject creator'),
        subtitle: Text(
          _editingSubject == null
              ? 'Create a study-plan or extracurricular subject.'
              : 'Editing ${_editingSubject!.idMateria}',
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  key: ValueKey(_idMateria),
                  initialValue: _idMateria,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: 'IDmateria'),
                ),
                CheckboxListTile(
                  value: _isExtracurricular,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Extracurricular'),
                  subtitle: const Text('Special course or event'),
                  onChanged: _editingSubject == null
                      ? (value) => setState(() {
                            _isExtracurricular = value ?? false;
                            _area = _isExtracurricular ? 6 : 0;
                            _semester = _isExtracurricular ? 0 : 1;
                            _dateRange = null;
                          })
                      : null,
                ),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        initialValue: _area,
                        decoration: const InputDecoration(labelText: 'Area'),
                        items: [
                          for (var value = 0; value <= 6; value++)
                            DropdownMenuItem(
                                value: value, child: Text('$value')),
                        ],
                        onChanged: _isExtracurricular
                            ? null
                            : (value) => setState(() => _area = value ?? 0),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        initialValue: _semester,
                        decoration:
                            const InputDecoration(labelText: 'Semester'),
                        items: [
                          if (_isExtracurricular)
                            const DropdownMenuItem(value: 0, child: Text('0'))
                          else
                            for (var value = 1; value <= 6; value++)
                              DropdownMenuItem(
                                value: value,
                                child: Text('$value'),
                              ),
                        ],
                        onChanged: _isExtracurricular
                            ? null
                            : (value) => setState(() => _semester = value ?? 1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _keyController,
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: const [_UpperCaseTextFormatter()],
                  decoration: InputDecoration(
                    labelText: 'Clave',
                    errorText: _keyInUse ? 'This key is already in use.' : null,
                  ),
                  validator: _required,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: const [_UpperCaseTextFormatter()],
                  decoration: InputDecoration(
                    labelText: 'Subject name',
                    helperText: _nameInUse
                        ? 'Duplicate name. Saving is still allowed.'
                        : null,
                    enabledBorder: _nameInUse
                        ? OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.amber.shade700,
                              width: 2,
                            ),
                          )
                        : null,
                    focusedBorder: _nameInUse
                        ? OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.amber.shade700,
                              width: 2,
                            ),
                          )
                        : null,
                  ),
                  validator: _required,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _evaluationType,
                  decoration:
                      const InputDecoration(labelText: 'Evaluation type'),
                  items: const [
                    DropdownMenuItem(
                      value: 'Number Evaluation',
                      child: Text('Number Evaluation'),
                    ),
                    DropdownMenuItem(
                      value: 'Letter Evaluation',
                      child: Text('Letter Evaluation'),
                    ),
                  ],
                  onChanged: (value) => setState(
                    () => _evaluationType = value ?? 'Number Evaluation',
                  ),
                ),
                if (_isExtracurricular) ...[
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _pickDateRange,
                    icon: const Icon(Icons.calendar_month_outlined),
                    label: Text(
                      _dateRange == null
                          ? 'Select date range'
                          : _formatRange(_dateRange!),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descriptionController,
                    minLines: 2,
                    maxLines: 4,
                    decoration: const InputDecoration(labelText: 'Description'),
                    validator: _required,
                  ),
                ],
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _keyInUse ? null : _saveSubject,
                  icon: Icon(
                    _editingSubject == null
                        ? Icons.add_outlined
                        : Icons.save_outlined,
                  ),
                  label: Text(
                    _editingSubject == null
                        ? 'Create subject'
                        : 'Overwrite data',
                  ),
                ),
                if (_editingSubject != null)
                  TextButton(
                    onPressed: _clearForm,
                    child: const Text('Cancel editing'),
                  ),
              ],
            ),
          ),
          if (MockRepository.subjects.isNotEmpty) ...[
            const Divider(height: 32),
            for (final subject in MockRepository.subjects)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('${subject.idMateria} - ${subject.name}'),
                subtitle: Text(
                  '${subject.keyCode} | Area ${subject.area} | Semester ${subject.semester}',
                ),
                trailing: IconButton(
                  tooltip: 'Edit subject',
                  onPressed: () => _editSubject(subject),
                  icon: const Icon(Icons.edit_outlined),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 10),
      initialDateRange: _dateRange,
    );
    if (range != null) setState(() => _dateRange = range);
  }

  void _saveSubject() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_isExtracurricular && _dateRange == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select the extracurricular date range.')),
      );
      return;
    }
    final subject = SchoolSubject(
      idMateria: _idMateria,
      isExtracurricular: _isExtracurricular,
      area: _isExtracurricular ? 6 : _area,
      semester: _isExtracurricular ? 0 : _semester,
      keyCode: _keyController.text.trim().toUpperCase(),
      name: _nameController.text.trim().toUpperCase(),
      evaluationType: _evaluationType,
      startDate: _dateRange?.start,
      endDate: _dateRange?.end,
      description: _descriptionController.text.trim(),
    );
    MockRepository.saveSubject(subject);
    widget.onChanged();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Subject ${subject.idMateria} saved.')),
    );
    _clearForm();
  }

  void _editSubject(SchoolSubject subject) {
    setState(() {
      _editingSubject = subject;
      _isExtracurricular = subject.isExtracurricular;
      _area = subject.area;
      _semester = subject.semester;
      _evaluationType = subject.evaluationType;
      _keyController.text = subject.keyCode;
      _nameController.text = subject.name;
      _descriptionController.text = subject.description;
      _dateRange = subject.startDate == null || subject.endDate == null
          ? null
          : DateTimeRange(start: subject.startDate!, end: subject.endDate!);
    });
  }

  void _clearForm() {
    setState(() {
      _editingSubject = null;
      _isExtracurricular = false;
      _area = 0;
      _semester = 1;
      _evaluationType = 'Number Evaluation';
      _dateRange = null;
      _keyController.clear();
      _nameController.clear();
      _descriptionController.clear();
    });
  }
}

class _GroupAdminCard extends StatelessWidget {
  const _GroupAdminCard({required this.onChanged});

  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: true,
        leading: const Icon(Icons.groups_outlined),
        title: const Text('Group admin'),
        subtitle: const Text('Review capacity and assigned students.'),
        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
        children: [
          SizedBox(
            height: 520,
            child: ListView(
              children: [
                for (var semester = 1; semester <= 6; semester++) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 14, 4, 8),
                    child: Text(
                      'Semester $semester',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  for (final group in const ['A', 'B', 'C', 'D'])
                    _GroupCard(
                      semester: semester,
                      group: group,
                      onChanged: onChanged,
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({
    required this.semester,
    required this.group,
    required this.onChanged,
  });

  final int semester;
  final String group;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final active = MockRepository.groupIsActive(semester, group);
    final count = MockRepository.groupStudentCount(semester, group);
    final limit = MockRepository.groupSizeLimit(semester, group);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(child: Text('$semester$group')),
        title: Text('Semester $semester - Group $group'),
        subtitle: Text(active ? '$count of $limit students' : 'Inactive'),
        trailing: IconButton(
          tooltip: 'Manage group',
          icon: const Icon(Icons.manage_accounts_outlined),
          onPressed: () async {
            await Navigator.of(context).push<void>(
              MaterialPageRoute(
                builder: (_) => GroupManagerScreen(
                  semester: semester,
                  group: group,
                ),
              ),
            );
            onChanged();
          },
        ),
      ),
    );
  }
}

class GroupManagerScreen extends StatefulWidget {
  const GroupManagerScreen({
    super.key,
    required this.semester,
    required this.group,
  });

  final int semester;
  final String group;

  @override
  State<GroupManagerScreen> createState() => _GroupManagerScreenState();
}

class _GroupManagerScreenState extends State<GroupManagerScreen> {
  late final TextEditingController _sizeController;
  final Map<String, StudentEnrollment> _pendingAssignments = {};

  List<StudentEnrollment> get _assignedStudents {
    final students = <String, StudentEnrollment>{
      for (final student in MockRepository.currentEnrollments)
        if (student.semester == widget.semester &&
            student.group == widget.group)
          student.registration: student,
    };
    students.addAll(_pendingAssignments);
    final values = students.values.toList()
      ..sort((a, b) => a.fullStudentName.compareTo(b.fullStudentName));
    return values;
  }

  @override
  void initState() {
    super.initState();
    _sizeController = TextEditingController(
      text: '${MockRepository.groupSizeLimit(widget.semester, widget.group)}',
    );
  }

  @override
  void dispose() {
    _sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final active =
        MockRepository.groupIsActive(widget.semester, widget.group) ||
            _pendingAssignments.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text('Group ${widget.semester}${widget.group}'),
        actions: [
          IconButton(
            tooltip: 'Assign student',
            onPressed: _showStudentSearch,
            icon: const Icon(Icons.person_add_alt_1_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionHeader(
            title: 'Group manager',
            subtitle: active
                ? '${_assignedStudents.length} students assigned'
                : 'Inactive until a student is assigned',
            trailing: Chip(label: Text(active ? 'Active' : 'Inactive')),
          ),
          const SizedBox(height: 16),
          if (_assignedStudents.isEmpty) ...[
            OutlinedButton.icon(
              onPressed: _toggleGroupActivation,
              icon: Icon(
                active ? Icons.toggle_off_outlined : Icons.toggle_on_outlined,
              ),
              label: Text(active ? 'Deactivate group' : 'Activate group'),
            ),
            const SizedBox(height: 12),
          ],
          TextFormField(
            controller: _sizeController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'Size limit',
              helperText: 'Default 25, maximum 45',
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Assigned students',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          if (_assignedStudents.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 28),
              child: Center(child: Text('No students assigned')),
            )
          else
            for (final student in _assignedStudents) ...[
              _AssignedStudentCard(
                student: student,
                onEdit: () => _editStudent(student),
              ),
              const SizedBox(height: 8),
            ],
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _toggleGroupActivation() {
    final active = MockRepository.groupIsActive(
      widget.semester,
      widget.group,
    );
    final changed = MockRepository.setGroupActive(
      widget.semester,
      widget.group,
      !active,
    );
    if (!changed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('At least one group must remain active.'),
        ),
      );
      return;
    }
    setState(() {});
  }

  Future<void> _showStudentSearch() async {
    final searchController = TextEditingController();
    final selected = await showDialog<StudentEnrollment>(
      context: context,
      builder: (dialogContext) => _StudentSearchDialog(
        controller: searchController,
      ),
    );
    searchController.dispose();
    if (selected == null || !mounted) return;
    if (selected.semester != widget.semester) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Change semester?'),
          content: Text(
            '${selected.fullStudentName} is in semester '
            '${selected.semester}. Assigning this student will also change '
            'their semester to ${widget.semester}.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Continue'),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }
    setState(() {
      _pendingAssignments[selected.registration] = selected.copyWith(
        semester: widget.semester,
        group: widget.group,
      );
    });
  }

  Future<void> _editStudent(StudentEnrollment student) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => EnrollmentWizardScreen(
          standalone: true,
          initialEnrollment: student,
          canManageActivation: true,
          onSaved: () => setState(() {}),
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  void _save() {
    final size = int.tryParse(_sizeController.text);
    if (size == null || size < 1 || size > 45) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Size limit must be from 1 to 45.')),
      );
      return;
    }
    MockRepository.saveGroupSizeLimit(widget.semester, widget.group, size);
    for (final student in _pendingAssignments.values) {
      MockRepository.assignStudentToGroup(
        student.registration,
        widget.semester,
        widget.group,
      );
    }
    setState(_pendingAssignments.clear);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Group changes saved.')),
    );
  }
}

class _StudentSearchDialog extends StatefulWidget {
  const _StudentSearchDialog({required this.controller});

  final TextEditingController controller;

  @override
  State<_StudentSearchDialog> createState() => _StudentSearchDialogState();
}

class _StudentSearchDialogState extends State<_StudentSearchDialog> {
  @override
  Widget build(BuildContext context) {
    final students = MockRepository.currentEnrollments
        .where((student) => student.matchesSearch(widget.controller.text))
        .take(8)
        .toList();
    return AlertDialog(
      title: const Text('Assign student'),
      content: SizedBox(
        width: 440,
        height: 380,
        child: Column(
          children: [
            TextField(
              controller: widget.controller,
              autofocus: true,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText: 'Search active level 4 accounts',
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  return ListTile(
                    title: Text(student.fullStudentName),
                    subtitle: Text(
                      '${student.registration} | '
                      '${student.semester}${student.group}',
                    ),
                    onTap: () => Navigator.of(context).pop(student),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

class _AssignedStudentCard extends StatelessWidget {
  const _AssignedStudentCard({required this.student, required this.onEdit});

  final StudentEnrollment student;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        title: Text(student.fullStudentName.toUpperCase()),
        subtitle: Text(
          '${student.registration}\n${student.studentCurp}\n'
          '${student.semester} ${student.group}',
        ),
        isThreeLine: true,
        trailing: IconButton(
          tooltip: 'Edit student',
          onPressed: onEdit,
          icon: const Icon(Icons.edit_outlined),
        ),
      ),
    );
  }
}

class CycleManagerScreen extends StatefulWidget {
  const CycleManagerScreen({super.key});

  @override
  State<CycleManagerScreen> createState() => _CycleManagerScreenState();
}

class _CycleManagerScreenState extends State<CycleManagerScreen> {
  @override
  Widget build(BuildContext context) {
    final activeCycle = MockRepository.activeCycle;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Cycle manager'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            key: ValueKey(activeCycle?.id ?? 'no-cycle'),
            initialValue: activeCycle?.name ?? 'No cycle selected',
            readOnly: true,
            decoration:
                const InputDecoration(labelText: 'Current active cycle'),
          ),
          if (activeCycle != null) ...[
            const SizedBox(height: 12),
            SwitchListTile(
              value: MockRepository.gradingPeriodActive,
              contentPadding: EdgeInsets.zero,
              title: const Text('Activate grading period'),
              subtitle: const Text(
                'Controls grading-tool access for level 3 accounts.',
              ),
              onChanged: (value) {
                MockRepository.setGradingPeriodActive(value);
                setState(() {});
              },
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Existing cycles',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              FilledButton.icon(
                onPressed: () => _openEditor(),
                icon: const Icon(Icons.add),
                label: const Text('Create cycle'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (MockRepository.cycles.isEmpty)
            const Center(
                child: Padding(
              padding: EdgeInsets.all(28),
              child: Text('No cycles created'),
            ))
          else
            SizedBox(
              height: 420,
              child: ListView.separated(
                itemCount: MockRepository.cycles.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final cycle = MockRepository.cycles[index];
                  final isActive = activeCycle?.id == cycle.id;
                  return Card(
                    child: ListTile(
                      title: Text(cycle.name),
                      subtitle: Text(
                        '${_formatDate(cycle.startDate)} - '
                        '${_formatDate(cycle.endDate)}',
                      ),
                      trailing: Wrap(
                        spacing: 4,
                        children: [
                          if (!isActive)
                            TextButton(
                              onPressed: () {
                                MockRepository.setActiveCycle(cycle.id);
                                setState(() {});
                              },
                              child: const Text('Set active'),
                            )
                          else
                            const Chip(label: Text('Active')),
                          IconButton(
                            tooltip: 'Edit cycle',
                            onPressed: () => _openEditor(cycle),
                            icon: const Icon(Icons.edit_outlined),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _openEditor([AcademicCycle? cycle]) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(builder: (_) => CycleEditorScreen(cycle: cycle)),
    );
    if (mounted) setState(() {});
  }
}

class CycleEditorScreen extends StatefulWidget {
  const CycleEditorScreen({super.key, this.cycle});

  final AcademicCycle? cycle;

  @override
  State<CycleEditorScreen> createState() => _CycleEditorScreenState();
}

class _CycleEditorScreenState extends State<CycleEditorScreen> {
  DateTimeRange? _dateRange;

  String get _cycleName {
    final range = _dateRange;
    if (range == null) return '';
    final start = range.start.year.remainder(100).toString().padLeft(2, '0');
    final end = range.end.year.remainder(100).toString().padLeft(2, '0');
    return 'Periodo $start-$end';
  }

  @override
  void initState() {
    super.initState();
    final cycle = widget.cycle;
    if (cycle != null) {
      _dateRange = DateTimeRange(
        start: cycle.startDate,
        end: cycle.endDate,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(widget.cycle == null ? 'Create cycle' : 'Edit cycle'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          OutlinedButton.icon(
            onPressed: _pickRange,
            icon: const Icon(Icons.calendar_month_outlined),
            label: Text(
              _dateRange == null
                  ? 'Select cycle date range'
                  : _formatRange(_dateRange!),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            key: ValueKey(_cycleName),
            initialValue:
                _cycleName.isEmpty ? 'Select a date range' : _cycleName,
            readOnly: true,
            decoration: const InputDecoration(labelText: 'Cycle name'),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _dateRange == null ? null : _save,
            icon: Icon(
              widget.cycle == null ? Icons.add_outlined : Icons.save_outlined,
            ),
            label: Text(
              widget.cycle == null ? 'Create cycle' : 'Save data',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final selected = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 15),
      initialDateRange: _dateRange,
    );
    if (selected != null) setState(() => _dateRange = selected);
  }

  void _save() {
    final range = _dateRange!;
    MockRepository.saveCycle(
      AcademicCycle(
        id: widget.cycle?.id ??
            'cycle-${DateTime.now().microsecondsSinceEpoch}',
        name: _cycleName,
        startDate: range.start,
        endDate: range.end,
      ),
    );
    Navigator.of(context).pop();
  }
}

class _UpperCaseTextFormatter extends TextInputFormatter {
  const _UpperCaseTextFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}

String? _required(String? value) {
  return value == null || value.trim().isEmpty ? 'Required' : null;
}

String _formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/${date.year}';
}

String _formatRange(DateTimeRange range) {
  return '${_formatDate(range.start)} - ${_formatDate(range.end)}';
}
