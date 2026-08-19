import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../core/data/mock_repository.dart';
import '../../core/models/academic_cycle.dart';
import '../../core/models/student_enrollment.dart';
import '../../shared/widgets/section_header.dart';
import 'enrollment_wizard_screen.dart';

enum _EnrollmentTableKind { current, past }

class EnrollmentTableScreen extends StatefulWidget {
  const EnrollmentTableScreen({
    super.key,
    this.canManageActivation = false,
  });

  final bool canManageActivation;

  @override
  State<EnrollmentTableScreen> createState() => _EnrollmentTableScreenState();
}

class _EnrollmentTableScreenState extends State<EnrollmentTableScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  _EnrollmentTableKind _selectedTable = _EnrollmentTableKind.current;
  final Set<int> _semesterFilters = {};
  final Set<String> _groupFilters = {};
  bool _showSuggestions = false;
  String? _pastCycleId;

  @override
  void initState() {
    super.initState();
    _pastCycleId = MockRepository.activeCycle?.id ??
        (MockRepository.cycles.isEmpty ? null : MockRepository.cycles.last.id);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final students = _filteredStudents;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionHeader(
          title: l10n.navEnroll,
          subtitle: l10n.enrollmentSubtitle,
        ),
        const SizedBox(height: 16),
        _label(context, l10n.selectEnrollmentTable),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<_EnrollmentTableKind>(
            showSelectedIcon: true,
            segments: [
              ButtonSegment(
                value: _EnrollmentTableKind.current,
                label: Text(l10n.currentEnrollment),
                icon: const Icon(Icons.check),
              ),
              ButtonSegment(
                value: _EnrollmentTableKind.past,
                label: Text(l10n.pastEnrollment),
                icon: const Icon(Icons.history),
              ),
            ],
            selected: {_selectedTable},
            onSelectionChanged: (selection) {
              setState(() {
                _selectedTable = selection.first;
                _showSuggestions = false;
              });
            },
          ),
        ),
        if (_selectedTable == _EnrollmentTableKind.past) ...[
          const SizedBox(height: 16),
          _label(context, l10n.enrollmentCycle),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            key: ValueKey('past-cycle-${_pastCycleId ?? 'none'}'),
            initialValue: _pastCycleId,
            isExpanded: true,
            menuMaxHeight: 320,
            decoration: InputDecoration(
              labelText: l10n.selectCycle,
              prefixIcon: const Icon(Icons.date_range_outlined),
            ),
            items: [
              for (final cycle in _cycleOptions)
                DropdownMenuItem(
                  value: cycle.id,
                  child: Text(cycle.name),
                ),
            ],
            onChanged: (value) => setState(() {
              _pastCycleId = value;
              _showSuggestions = false;
            }),
          ),
        ],
        const SizedBox(height: 16),
        _label(context, l10n.semesterFilter),
        const SizedBox(height: 8),
        _FilterChips<int>(
          values: const [1, 2, 3, 4, 5, 6],
          selectedValues: _semesterFilters,
          labelBuilder: (value) => '$value',
          onSelected: (value) => setState(() {
            if (!_semesterFilters.add(value)) _semesterFilters.remove(value);
          }),
        ),
        const SizedBox(height: 16),
        _label(context, l10n.groupFilter),
        const SizedBox(height: 8),
        _FilterChips<String>(
          values: const ['A', 'B', 'C', 'D'],
          selectedValues: _groupFilters,
          labelBuilder: (value) => value,
          onSelected: (value) => setState(() {
            if (!_groupFilters.add(value)) _groupFilters.remove(value);
          }),
        ),
        const SizedBox(height: 16),
        _label(context, l10n.customSearch),
        const SizedBox(height: 8),
        _SearchBox(
          controller: _searchController,
          focusNode: _searchFocusNode,
          showSuggestions: _showSuggestions,
          suggestions: _suggestions,
          onChanged: (_) => setState(() => _showSuggestions = true),
          onCloseSuggestions: () => setState(() => _showSuggestions = false),
          onClear: () => setState(() {
            _searchController.clear();
            _showSuggestions = false;
          }),
          onSuggestionSelected: (student) {
            setState(() {
              _searchController.text = student.fullStudentName;
              _searchController.selection = TextSelection.collapsed(
                offset: _searchController.text.length,
              );
              _showSuggestions = false;
            });
            _openStudent(student);
          },
        ),
        const SizedBox(height: 20),
        Text(l10n.students,
         style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        if (students.isEmpty)
          const _EmptyStudents()
        else
          for (final student in students) ...[
            _StudentEnrollmentCard(
              student: student,
              onOpen: () => _openStudent(student),
            ),
            const SizedBox(height: 10),
          ],
      ],
    );
  }

  Widget _label(BuildContext context, String text) {
    return Text(text, style: Theme.of(context).textTheme.labelLarge);
  }

  List<AcademicCycle> get _cycleOptions {
    final cycles = MockRepository.cycles.toList()
      ..sort((a, b) => b.startDate.compareTo(a.startDate));
    return cycles;
  }

  List<StudentEnrollment> get _sourceStudents {
    if (_selectedTable == _EnrollmentTableKind.current) {
      return MockRepository.currentEnrollments;
    }
    final cycleId = _pastCycleId;
    if (cycleId == null) return const [];
    if (cycleId == MockRepository.activeCycle?.id) {
      return MockRepository.pastEnrollments;
    }
    return MockRepository.enrollmentsForCycle(cycleId);
  }

  List<StudentEnrollment> get _filteredStudents {
    final query = _searchController.text;
    return _sourceStudents.where((student) {
      final semesterMatches = _semesterFilters.isEmpty ||
          _semesterFilters.contains(student.semester);
      final groupMatches =
          _groupFilters.isEmpty || _groupFilters.contains(student.group);
      return semesterMatches && groupMatches && student.matchesSearch(query);
    }).toList(growable: false);
  }

  List<StudentEnrollment> get _suggestions {
    final query = _searchController.text.trim();
    if (!_showSuggestions || query.isEmpty) return const [];
    return _sourceStudents
        .where((student) => student.matchesSearch(query))
        .take(3)
        .toList(growable: false);
  }

  Future<void> _openStudent(StudentEnrollment student) async {
    final l10n = AppLocalizations.of(context)!;
    final historicalCycle = _selectedTable == _EnrollmentTableKind.past &&
        _pastCycleId != MockRepository.activeCycle?.id;
    if (historicalCycle) {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(student.fullStudentName),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.registrationValue(student.registration),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.curpValue(student.studentCurp),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.semesterGroupValue(
                  student.semester,
                  student.group,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.emailValue(student.studentEmail),
              ),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.close),
            ),
          ],
        ),
      );
      return;
    }
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => EnrollmentWizardScreen(
          standalone: true,
          initialEnrollment: student,
          canManageActivation: widget.canManageActivation,
          onSaved: () => setState(() {}),
        ),
      ),
    );
    if (mounted) setState(() {});
  }
}

class _FilterChips<T> extends StatelessWidget {
  const _FilterChips({
    required this.values,
    required this.selectedValues,
    required this.labelBuilder,
    required this.onSelected,
  });

  final List<T> values;
  final Set<T> selectedValues;
  final String Function(T value) labelBuilder;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final value in values)
          ChoiceChip(
            label: Text(labelBuilder(value)),
            selected: selectedValues.contains(value),
            onSelected: (_) => onSelected(value),
          ),
      ],
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox({
    required this.controller,
    required this.focusNode,
    required this.showSuggestions,
    required this.suggestions,
    required this.onChanged,
    required this.onCloseSuggestions,
    required this.onClear,
    required this.onSuggestionSelected,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool showSuggestions;
  final List<StudentEnrollment> suggestions;
  final ValueChanged<String> onChanged;
  final VoidCallback onCloseSuggestions;
  final VoidCallback onClear;
  final ValueChanged<StudentEnrollment> onSuggestionSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: IconButton(
              tooltip: l10n.closeSuggestions,
              onPressed: onCloseSuggestions,
              icon: const Icon(Icons.arrow_back),
            ),
            suffixIcon: IconButton(
              tooltip: l10n.clearSearch,
              onPressed: onClear,
              icon: const Icon(Icons.close),
            ),
            hintText: l10n.searchStudents,
          ),
        ),
        if (showSuggestions && controller.text.trim().isNotEmpty) ...[
          const SizedBox(height: 4),
          Material(
            elevation: 3,
            borderRadius: BorderRadius.circular(8),
            color: colorScheme.surfaceContainerHighest,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 210),
              child: suggestions.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(l10n.noMatches),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      itemCount: suggestions.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final student = suggestions[index];
                        return ListTile(
                          leading: const Icon(Icons.person_outline),
                          title: Text(student.fullStudentName),
                          subtitle: Text(student.registration),
                          onTap: () => onSuggestionSelected(student),
                        );
                      },
                    ),
            ),
          ),
        ],
      ],
    );
  }
}

class _StudentEnrollmentCard extends StatelessWidget {
  const _StudentEnrollmentCard({required this.student, required this.onOpen});

  final StudentEnrollment student;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.fullStudentName.toUpperCase(),
                      style: textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(student.registration),
                    const SizedBox(height: 4),
                    Text(student.studentCurp),
                    const SizedBox(height: 4),
                    Text('${student.semester} ${student.group}'),
                  ],
                ),
              ),
              IconButton(
                tooltip: l10n.openStudentData,
                onPressed: onOpen,
                icon: const Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyStudents extends StatelessWidget {
  const _EmptyStudents();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        children: [
          Icon(Icons.school_outlined,
              size: 40, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.noStudentsToShow,
              style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
