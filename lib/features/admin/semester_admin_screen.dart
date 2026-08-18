import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/data/mock_repository.dart';
import '../../core/models/academic_cycle.dart';
import '../../core/models/app_user.dart';
import '../../core/models/user_role.dart';
import '../../core/models/school_subject.dart';
import '../../core/models/student_enrollment.dart';
import '../../shared/widgets/section_header.dart';
import '../enrollment/enrollment_wizard_screen.dart';
import '../profile/limited_profile_screen.dart';
import 'subject_assignment_screen.dart';

class SemesterAdminScreen extends StatefulWidget {
  const SemesterAdminScreen({
    super.key,
    this.currentUser,
    this.onSignedOut,
  });

  final AppUser? currentUser;
  final VoidCallback? onSignedOut;

  @override
  State<SemesterAdminScreen> createState() => _SemesterAdminScreenState();
}

class _SemesterAdminScreenState extends State<SemesterAdminScreen> {
  final _scrollController = ScrollController();
  final _subjectCreatorKey = GlobalKey<_SubjectCreatorCardState>();

  bool get _limitedAccess =>
      widget.currentUser?.role == UserRole.level2SemesterAdmin;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      key: const ValueKey('semester-admin-background'),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_limitedAccess) ...[
                IconButton(
                  tooltip: 'Back to system admin',
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back),
                ),
                const SizedBox(width: 4),
              ],
              const Expanded(
                child: SectionHeader(
                  title: 'Semester admin',
                  subtitle: 'Manage subjects, groups, and academic cycles.',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_limitedAccess) ...[
            LimitedProfileScreen(
              user: widget.currentUser!,
              embedded: true,
            ),
            const SizedBox(height: 12),
          ],
          if (!_limitedAccess) ...[
            _SubjectCreatorCard(
              key: _subjectCreatorKey,
              onChanged: () => setState(() {}),
            ),
            const SizedBox(height: 12),
          ],
          _SubjectListCard(
            onEdit: _editSubject,
            onAssigned: () => setState(() {}),
            readOnly: _limitedAccess,
          ),
          const SizedBox(height: 12),
          _ExtracurricularListCard(
            onEdit: _editSubject,
            readOnly: _limitedAccess,
          ),
          const SizedBox(height: 12),
          _GroupAdminCard(onChanged: () => setState(() {})),
          const SizedBox(height: 12),
          if (!_limitedAccess)
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
                    MaterialPageRoute(
                        builder: (_) => const CycleManagerScreen()),
                  );
                  if (mounted) setState(() {});
                },
              ),
            ),
          if (widget.onSignedOut != null) ...[
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: const Text('Sign out'),
                subtitle: const Text('Return to the sign-in screen.'),
                onTap: widget.onSignedOut,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _editSubject(SchoolSubject subject) {
    if (_limitedAccess) return;
    _subjectCreatorKey.currentState?.loadSubject(subject);
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}

class _SubjectCreatorCard extends StatefulWidget {
  const _SubjectCreatorCard({
    super.key,
    required this.onChanged,
  });

  final VoidCallback onChanged;

  @override
  State<_SubjectCreatorCard> createState() => _SubjectCreatorCardState();
}

class _SubjectCreatorCardState extends State<_SubjectCreatorCard> {
  static const _allGroups = 'All groups';

  final _formKey = GlobalKey<FormState>();
  final _keyController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _expansionController = ExpansibleController();

  SchoolSubject? _editingSubject;
  bool _isExtracurricular = false;
  int _semester = 1;
  String _evaluationType = 'Number Evaluation';
  DateTimeRange? _dateRange;

  String get _idMateria =>
      _editingSubject?.idMateria ??
      MockRepository.previewNextSubjectId(_isExtracurricular);

  bool get _keyInUse =>
      !_isExtracurricular &&
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
        controller: _expansionController,
        initiallyExpanded: false,
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
                      ? (value) {
                          setState(() {
                            _isExtracurricular = value ?? false;
                            _dateRange = null;
                            _keyController.text =
                                _isExtracurricular ? _idMateria : '';
                          });
                        }
                      : null,
                ),
                if (!_isExtracurricular) ...[
                  DropdownButtonFormField<int>(
                    key: ValueKey('subject-semester-$_semester'),
                    initialValue: _semester,
                    decoration: const InputDecoration(labelText: 'Semester'),
                    items: [
                      for (var semester = 1; semester <= 6; semester++)
                        DropdownMenuItem(
                          value: semester,
                          child: Text('$semester'),
                        ),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => _semester = value);
                    },
                  ),
                  const SizedBox(height: 12),
                ],
                TextFormField(
                  controller: _keyController,
                  readOnly: _isExtracurricular,
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
                if (!_isExtracurricular) ...[
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    key: ValueKey(_evaluationType),
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
                ],
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

  String _formatRange(DateTimeRange range) {
    String date(DateTime value) => '${value.day.toString().padLeft(2, '0')}/'
        '${value.month.toString().padLeft(2, '0')}/${value.year}';
    return '${date(range.start)} - ${date(range.end)}';
  }

  String? _required(Object? value) {
    if (value == null || value.toString().trim().isEmpty) return 'Required';
    return null;
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
      area: 0,
      semester: _isExtracurricular ? 0 : _semester,
      group: _isExtracurricular ? _allGroups : 'A',
      keyCode: _isExtracurricular
          ? _idMateria
          : _keyController.text.trim().toUpperCase(),
      name: _nameController.text.trim().toUpperCase(),
      evaluationType: _isExtracurricular ? 'Not applicable' : _evaluationType,
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

  void loadSubject(SchoolSubject subject) {
    setState(() {
      _editingSubject = subject;
      _isExtracurricular = subject.isExtracurricular;
      _semester = subject.isExtracurricular ? 1 : subject.semester;
      _evaluationType = subject.isExtracurricular
          ? 'Number Evaluation'
          : subject.evaluationType;
      _keyController.text =
          subject.isExtracurricular ? subject.idMateria : subject.keyCode;
      _nameController.text = subject.name;
      _descriptionController.text = subject.description;
      _dateRange = subject.startDate == null || subject.endDate == null
          ? null
          : DateTimeRange(start: subject.startDate!, end: subject.endDate!);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_expansionController.isExpanded) {
        _expansionController.expand();
      }
    });
  }

  void _clearForm() {
    setState(() {
      _editingSubject = null;
      _isExtracurricular = false;
      _semester = 1;
      _evaluationType = 'Number Evaluation';
      _dateRange = null;
      _keyController.clear();
      _nameController.clear();
      _descriptionController.clear();
    });
  }
}

enum _SubjectListFilter { notAssigned, assigned, all }

class _SubjectListCard extends StatefulWidget {
  const _SubjectListCard({
    required this.onEdit,
    required this.onAssigned,
    this.readOnly = false,
  });

  final ValueChanged<SchoolSubject> onEdit;
  final VoidCallback onAssigned;
  final bool readOnly;

  @override
  State<_SubjectListCard> createState() => _SubjectListCardState();
}

class _SubjectListCardState extends State<_SubjectListCard> {
  final _searchController = TextEditingController();
  _SubjectListFilter _filter = _SubjectListFilter.all;
  bool _showSuggestions = false;

  List<SchoolSubject> get _regularSubjects => MockRepository.subjects
      .where((subject) => !subject.isExtracurricular)
      .toList(growable: false);

  List<SchoolSubject> get _filteredSubjects {
    return _regularSubjects.where((subject) {
      final assigned = MockRepository.isSubjectAssigned(subject);
      final statusMatches = switch (_filter) {
        _SubjectListFilter.notAssigned => !assigned,
        _SubjectListFilter.assigned => assigned,
        _SubjectListFilter.all => true,
      };
      return statusMatches && subject.matchesSearch(_searchController.text);
    }).toList(growable: false);
  }

  List<SchoolSubject> get _suggestions {
    final query = _searchController.text.trim();
    if (!_showSuggestions || query.isEmpty) return const [];
    return _regularSubjects
        .where((subject) => subject.matchesSearch(query))
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
    return Card(
      child: ExpansionTile(
        initiallyExpanded: false,
        leading: const Icon(Icons.library_books_outlined),
        title: const Text('Subject list'),
        subtitle: Text('${_regularSubjects.length} subjects'),
        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
        children: [
          SegmentedButton<_SubjectListFilter>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(
                value: _SubjectListFilter.notAssigned,
                label: Text('Not assigned'),
              ),
              ButtonSegment(
                value: _SubjectListFilter.assigned,
                label: Text('Assigned'),
              ),
              ButtonSegment(
                value: _SubjectListFilter.all,
                label: Text('All subjects'),
              ),
            ],
            selected: {_filter},
            onSelectionChanged: (selection) {
              setState(() => _filter = selection.first);
            },
          ),
          const SizedBox(height: 12),
          _SubjectSearchField(
            controller: _searchController,
            onChanged: () => setState(() => _showSuggestions = true),
            onClear: () => setState(() => _showSuggestions = false),
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
                        for (final subject in _suggestions)
                          ListTile(
                            leading: const Icon(Icons.menu_book_outlined),
                            title: Text(subject.name),
                            subtitle: Text(
                              '${subject.idMateria} | ${subject.keyCode}',
                            ),
                            onTap: widget.readOnly
                                ? null
                                : () {
                                    setState(() => _showSuggestions = false);
                                    widget.onEdit(subject);
                                  },
                          ),
                      ],
                    ),
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            height: 500,
            child: _filteredSubjects.isEmpty
                ? const Center(child: Text('No subjects to show'))
                : ListView.separated(
                    itemCount: _filteredSubjects.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final subject = _filteredSubjects[index];
                      return _SubjectListItem(
                        subject: subject,
                        assigned: MockRepository.isSubjectAssigned(subject),
                        onEdit: widget.readOnly
                            ? null
                            : () => widget.onEdit(subject),
                        onAssign: widget.readOnly
                            ? null
                            : () => _openAssignment(subject),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _openAssignment(SchoolSubject subject) async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => SubjectAssignmentScreen(subject: subject),
      ),
    );
    if (!mounted) return;
    setState(() {});
    widget.onAssigned();
  }
}

class _ExtracurricularListCard extends StatefulWidget {
  const _ExtracurricularListCard({
    required this.onEdit,
    this.readOnly = false,
  });

  final ValueChanged<SchoolSubject> onEdit;
  final bool readOnly;

  @override
  State<_ExtracurricularListCard> createState() =>
      _ExtracurricularListCardState();
}

class _ExtracurricularListCardState extends State<_ExtracurricularListCard> {
  final _searchController = TextEditingController();

  List<SchoolSubject> get _subjects => MockRepository.subjects
      .where(
        (subject) =>
            subject.isExtracurricular &&
            subject.matchesSearch(_searchController.text),
      )
      .toList(growable: false);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: false,
        leading: const Icon(Icons.event_note_outlined),
        title: const Text('Extracurricular list'),
        subtitle: const Text('Courses and special events'),
        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
        children: [
          _SubjectSearchField(
            controller: _searchController,
            label: 'Search extracurriculars',
            onChanged: () => setState(() {}),
            onClear: () => setState(() {}),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 360,
            child: _subjects.isEmpty
                ? const Center(child: Text('No extracurricular subjects'))
                : ListView.separated(
                    itemCount: _subjects.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final subject = _subjects[index];
                      return _ExtracurricularListItem(
                        subject: subject,
                        onEdit: widget.readOnly
                            ? null
                            : () => widget.onEdit(subject),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _SubjectSearchField extends StatelessWidget {
  const _SubjectSearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
    this.label = 'Search subjects',
  });

  final TextEditingController controller;
  final VoidCallback onChanged;
  final VoidCallback onClear;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: (_) => onChanged(),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          tooltip: 'Clear search',
          onPressed: () {
            controller.clear();
            onClear();
          },
          icon: const Icon(Icons.close),
        ),
      ),
    );
  }
}

class _SubjectListItem extends StatelessWidget {
  const _SubjectListItem({
    required this.subject,
    required this.assigned,
    this.onEdit,
    this.onAssign,
  });

  final SchoolSubject subject;
  final bool assigned;
  final VoidCallback? onEdit;
  final VoidCallback? onAssign;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${subject.idMateria} - ${subject.name}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              _AssignmentStatus(assigned: assigned),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${subject.keyCode} | Semester ${subject.semester} | '
            '${subject.evaluationType}',
          ),
          if (onEdit != null || onAssign != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: onAssign,
                    icon: const Icon(Icons.person_add_alt_outlined),
                    label: const Text('Assign'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ExtracurricularListItem extends StatelessWidget {
  const _ExtracurricularListItem({
    required this.subject,
    this.onEdit,
  });

  final SchoolSubject subject;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final start = subject.startDate;
    final end = subject.endDate;
    final date = start == null || end == null
        ? 'No date selected'
        : '${_date(start)} - ${_date(end)}';
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${subject.idMateria} - ${subject.name}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                const Text('All semesters'),
                Text(date),
              ],
            ),
          ),
          if (onEdit != null)
            IconButton(
              tooltip: 'Edit extracurricular subject',
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined),
            ),
        ],
      ),
    );
  }

  static String _date(DateTime value) =>
      '${value.day.toString().padLeft(2, '0')}/'
      '${value.month.toString().padLeft(2, '0')}/${value.year}';
}

class _AssignmentStatus extends StatelessWidget {
  const _AssignmentStatus({required this.assigned});

  final bool assigned;

  @override
  Widget build(BuildContext context) {
    final background =
        assigned ? const Color(0xFFDDF3E4) : const Color(0xFFFFF1C7);
    final foreground =
        assigned ? const Color(0xFF245C36) : const Color(0xFF725A00);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        assigned ? 'Assigned' : 'Not assigned',
        style: TextStyle(color: foreground),
      ),
    );
  }
}

class _GroupAdminCard extends StatelessWidget {
  const _GroupAdminCard({required this.onChanged});

  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: false,
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
  static const _specialTests = ['R1', 'R2', 'R3', 'R4', 'TS', 'RE'];

  int _currentStep = 0;
  DateTimeRange? _dateRange;
  DateTime? _firstHalfEndDate;
  DateTime? _secondHalfStartDate;
  DateTime? _firstHalfPlatformTest;
  DateTime? _firstHalfPresentialTest;
  DateTime? _secondHalfPlatformTest;
  DateTime? _secondHalfPresentialTest;
  TimeOfDay _recessTime = const TimeOfDay(hour: 11, minute: 20);
  final Map<String, DateTime?> _specialTestDates = {
    for (final test in _specialTests) test: null,
  };

  String get _cycleName {
    final range = _dateRange;
    if (range == null) return '';
    final start = range.start.year.remainder(100).toString().padLeft(2, '0');
    final end = range.end.year.remainder(100).toString().padLeft(2, '0');
    return 'Periodo $start-$end';
  }

  bool get _cycleDatesComplete =>
      _dateRange != null &&
      _firstHalfEndDate != null &&
      _secondHalfStartDate != null &&
      !_firstHalfEndDate!.isAfter(_secondHalfStartDate!);

  bool get _regularTestsComplete =>
      _firstHalfPlatformTest != null &&
      _firstHalfPresentialTest != null &&
      _secondHalfPlatformTest != null &&
      _secondHalfPresentialTest != null;

  bool get _requiredFieldsComplete =>
      _cycleDatesComplete && _regularTestsComplete;

  @override
  void initState() {
    super.initState();
    final cycle = widget.cycle;
    if (cycle == null) return;
    _dateRange = DateTimeRange(start: cycle.startDate, end: cycle.endDate);
    _firstHalfEndDate = cycle.firstHalfEndDate;
    _secondHalfStartDate = cycle.secondHalfStartDate;
    _firstHalfPlatformTest = cycle.firstHalfPlatformTests.start;
    _firstHalfPresentialTest = cycle.firstHalfPresentialTests.start;
    _secondHalfPlatformTest = cycle.secondHalfPlatformTests.start;
    _secondHalfPresentialTest = cycle.secondHalfPresentialTests.start;
    _recessTime = _parseTime(cycle.recessTime);
    for (final entry in cycle.specialTestRanges.entries) {
      if (_specialTestDates.containsKey(entry.key)) {
        _specialTestDates[entry.key] = entry.value.start;
      }
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
          TextFormField(
            key: ValueKey(_cycleName),
            initialValue:
                _cycleName.isEmpty ? 'Select a date range' : _cycleName,
            readOnly: true,
            decoration: const InputDecoration(labelText: 'Cycle name'),
          ),
          const SizedBox(height: 12),
          Stepper(
            currentStep: _currentStep,
            onStepTapped: (step) => setState(() => _currentStep = step),
            controlsBuilder: _buildControls,
            steps: [
              Step(
                title: const Text('Cycle and halves'),
                isActive: _currentStep >= 0,
                content: _cycleDatesStep(),
              ),
              Step(
                title: const Text('Regular tests'),
                isActive: _currentStep >= 1,
                content: _regularTestsStep(),
              ),
              Step(
                title: const Text('Recess and special tests'),
                isActive: _currentStep >= 2,
                content: _specialTestsStep(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControls(BuildContext context, ControlsDetails details) {
    final isLast = _currentStep == 2;
    final canContinue = switch (_currentStep) {
      0 => _cycleDatesComplete,
      1 => _regularTestsComplete,
      _ => _requiredFieldsComplete,
    };
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          FilledButton.icon(
            onPressed: canContinue
                ? isLast
                    ? _save
                    : () => setState(() => _currentStep += 1)
                : null,
            icon: Icon(
              isLast
                  ? widget.cycle == null
                      ? Icons.add_outlined
                      : Icons.save_outlined
                  : Icons.arrow_forward,
            ),
            label: Text(
              isLast
                  ? widget.cycle == null
                      ? 'Create cycle'
                      : 'Save data'
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

  Widget _cycleDatesStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionLabel('Cycle date range'),
        _rangeButton(value: _dateRange),
        const SizedBox(height: 16),
        _sectionLabel('First half ending date'),
        _dateButton(
          value: _firstHalfEndDate,
          placeholder: 'Select date *',
          onChanged: (value) => _firstHalfEndDate = value,
        ),
        const SizedBox(height: 16),
        _sectionLabel('Second half beginning date'),
        _dateButton(
          value: _secondHalfStartDate,
          placeholder: 'Select date *',
          onChanged: (value) => _secondHalfStartDate = value,
        ),
        if (_firstHalfEndDate != null &&
            _secondHalfStartDate != null &&
            _firstHalfEndDate!.isAfter(_secondHalfStartDate!)) ...[
          const SizedBox(height: 8),
          Text(
            'The first half must end before the second half begins.',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
      ],
    );
  }

  Widget _regularTestsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionLabel('First half'),
        _dateButton(
          value: _firstHalfPlatformTest,
          placeholder: 'Platform *',
          selectedPrefix: 'Platform',
          onChanged: (value) => _firstHalfPlatformTest = value,
        ),
        const SizedBox(height: 12),
        _dateButton(
          value: _firstHalfPresentialTest,
          placeholder: 'Presential *',
          selectedPrefix: 'Presential',
          onChanged: (value) => _firstHalfPresentialTest = value,
        ),
        const SizedBox(height: 16),
        _sectionLabel('Second half'),
        _dateButton(
          value: _secondHalfPlatformTest,
          placeholder: 'Platform *',
          selectedPrefix: 'Platform',
          onChanged: (value) => _secondHalfPlatformTest = value,
        ),
        const SizedBox(height: 12),
        _dateButton(
          value: _secondHalfPresentialTest,
          placeholder: 'Presential *',
          selectedPrefix: 'Presential',
          onChanged: (value) => _secondHalfPresentialTest = value,
        ),
      ],
    );
  }

  Widget _specialTestsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: _pickRecessTime,
          icon: const Icon(Icons.schedule_outlined),
          label: Text('Recess time: ${_formatTime(_recessTime)}'),
        ),
        const SizedBox(height: 16),
        _sectionLabel('Special tests'),
        for (final test in _specialTests) ...[
          _dateButton(
            value: _specialTestDates[test],
            placeholder: '$test (optional)',
            selectedPrefix: test,
            onChanged: (value) => _specialTestDates[test] = value,
          ),
          if (test != _specialTests.last) const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleSmall),
          const Divider(),
        ],
      ),
    );
  }

  Widget _dateButton({
    required DateTime? value,
    required String placeholder,
    required ValueChanged<DateTime> onChanged,
    String? selectedPrefix,
  }) {
    final enabled = _dateRange != null;
    final valueLabel = value == null
        ? placeholder
        : selectedPrefix == null
            ? _formatDate(value)
            : '$selectedPrefix: ${_formatDate(value)}';
    return OutlinedButton.icon(
      onPressed: enabled
          ? () async {
              final selected = await _selectDate(value);
              if (selected != null) setState(() => onChanged(selected));
            }
          : null,
      icon: const Icon(Icons.event_outlined),
      label: Text(valueLabel),
    );
  }

  Widget _rangeButton({required DateTimeRange? value}) {
    return OutlinedButton.icon(
      onPressed: () async {
        final selected = await _selectCycleRange(value);
        if (selected == null) return;
        setState(() {
          _dateRange = selected;
          _clearDatesOutsideCycle();
        });
      },
      icon: const Icon(Icons.date_range_outlined),
      label: Text(
        value == null ? 'Select date range *' : _formatRange(value),
      ),
    );
  }

  Future<DateTime?> _selectDate(DateTime? current) {
    final range = _dateRange;
    if (range == null) return Future.value(null);
    var initial = current ?? range.start;
    if (initial.isBefore(range.start)) initial = range.start;
    if (initial.isAfter(range.end)) initial = range.end;
    return showDatePicker(
      context: context,
      firstDate: range.start,
      lastDate: range.end,
      initialDate: initial,
    );
  }

  Future<DateTimeRange?> _selectCycleRange(DateTimeRange? current) {
    final now = DateTime.now();
    return showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 15),
      initialDateRange: current,
    );
  }

  void _clearDatesOutsideCycle() {
    final range = _dateRange;
    if (range == null) return;
    bool outside(DateTime? value) =>
        value != null &&
        (value.isBefore(range.start) || value.isAfter(range.end));

    if (outside(_firstHalfEndDate)) _firstHalfEndDate = null;
    if (outside(_secondHalfStartDate)) _secondHalfStartDate = null;
    if (outside(_firstHalfPlatformTest)) _firstHalfPlatformTest = null;
    if (outside(_firstHalfPresentialTest)) _firstHalfPresentialTest = null;
    if (outside(_secondHalfPlatformTest)) _secondHalfPlatformTest = null;
    if (outside(_secondHalfPresentialTest)) _secondHalfPresentialTest = null;
    for (final test in _specialTests) {
      if (outside(_specialTestDates[test])) _specialTestDates[test] = null;
    }
  }

  Future<void> _pickRecessTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: _recessTime,
    );
    if (selected != null) setState(() => _recessTime = selected);
  }

  void _save() {
    if (!_requiredFieldsComplete) return;
    final range = _dateRange!;
    MockRepository.saveCycle(
      AcademicCycle(
        id: widget.cycle?.id ??
            'cycle-${DateTime.now().microsecondsSinceEpoch}',
        name: _cycleName,
        startDate: range.start,
        endDate: range.end,
        firstHalfEndDate: _firstHalfEndDate!,
        secondHalfStartDate: _secondHalfStartDate!,
        firstHalfPlatformTests: _singleDayRange(_firstHalfPlatformTest!),
        firstHalfPresentialTests: _singleDayRange(_firstHalfPresentialTest!),
        secondHalfPlatformTests: _singleDayRange(_secondHalfPlatformTest!),
        secondHalfPresentialTests: _singleDayRange(_secondHalfPresentialTest!),
        recessTime: _formatTime(_recessTime),
        specialTestRanges: {
          for (final entry in _specialTestDates.entries)
            if (entry.value != null) entry.key: _singleDayRange(entry.value!),
        },
      ),
    );
    Navigator.of(context).pop();
  }

  static AcademicDateRange _singleDayRange(DateTime date) {
    return AcademicDateRange(start: date, end: date);
  }

  static TimeOfDay _parseTime(String value) {
    final parts = value.split(':');
    if (parts.length != 2) return const TimeOfDay(hour: 11, minute: 20);
    return TimeOfDay(
      hour: int.tryParse(parts.first) ?? 11,
      minute: int.tryParse(parts.last) ?? 20,
    );
  }

  static String _formatTime(TimeOfDay value) {
    return '${value.hour.toString().padLeft(2, '0')}:'
        '${value.minute.toString().padLeft(2, '0')}';
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

String _formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/${date.year}';
}

String _formatRange(DateTimeRange range) {
  return '${_formatDate(range.start)} - ${_formatDate(range.end)}';
}
