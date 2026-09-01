import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../l10n/app_localizations.dart';
import '../../core/data/mock_repository.dart';
import '../../core/models/app_user.dart';
import '../../core/models/cycle_subject_assignment.dart';
import '../../core/models/student_enrollment.dart';
import '../../core/models/student_grade_entry.dart';
import '../../core/models/user_role.dart';
import '../../shared/widgets/section_header.dart';
import 'registry_screen.dart';

StudentGradeEntry? _latestGradeForReport(
  CycleSubjectAssignment assignment,
  String registration,
) {
  final grades = MockRepository.gradesForStudentAssignment(
    assignment: assignment,
    registration: registration,
  );
  const priority = ['RE', 'R3', 'R2', 'R1', 'Final evaluation'];
  for (final evaluation in priority) {
    for (final grade in grades) {
      if (grade.evaluationType == evaluation) return grade;
    }
  }
  return null;
}

List<StudentEnrollment> _studentsForGradeReport(
  CycleSubjectAssignment assignment,
  AppUser currentUser,
) {
  if (currentUser.role == UserRole.level4Student) {
    return MockRepository.currentEnrollments
        .where((student) => student.registration == currentUser.registration)
        .toList(growable: false);
  }
  return MockRepository.studentsForAssignment(assignment);
}

String _gradeTextForReport(
  AppLocalizations l10n,
  CycleSubjectAssignment assignment,
  StudentEnrollment student,
) {
  final latest = _latestGradeForReport(
    assignment,
    student.registration,
  );
  
  return latest == null
      ? l10n.notGraded
      : _displayGrade(
        latest.finalGrade,
        assignment.usesLetterGrades,
      );
}

String _statusTextForReport(
  AppLocalizations l10n,
  CycleSubjectAssignment assignment,
  StudentEnrollment student,
) {
  if (_latestGradeForReport(
    assignment,
    student.registration,
    ) == 
    null) {
    return l10n.notGraded;
  }

  final pending = MockRepository.pendingSubjectStage(
    assignment: assignment,
    registration: student.registration,
  );

  return pending == null
  ? l10n.passed
  : l10n.pendingStage(pending);
}

pw.Widget _pdfCell(
  String text, {
  bool header = false,
  pw.Alignment alignment = pw.Alignment.centerLeft,
}) {
  return pw.Container(
    alignment: alignment,
    padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 7),
    color: header ? PdfColor.fromHex('458CAD') : null,
    child: pw.Text(
      text,
      style: pw.TextStyle(
        color: header ? PdfColors.white : PdfColors.black,
        fontWeight: header ? pw.FontWeight.bold : pw.FontWeight.normal,
        fontSize: 9,
      ),
    ),
  );
}

/// Builds the role-filtered grade report used by the Grades PDF actions.
Future<Uint8List> buildGradePdfReport({
  required List<CycleSubjectAssignment> assignments,
  required AppUser currentUser,
  required AppLocalizations l10n,
}) async {
  final document = pw.Document();
  final cycleName = 
    MockRepository.activeCycle?.name ?? l10n.noActiveCycle;
  document.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(32, 42, 32, 42),
      header: (_) => pw.Container(
        padding: const pw.EdgeInsets.only(bottom: 8),
        decoration: pw.BoxDecoration(
          border: pw.Border(
            bottom: pw.BorderSide(
              color: PdfColor.fromHex('458CAD'),
              width: 2,
            ),
          ),
        ),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              l10n.constimixGradeReport,
              style: pw.TextStyle(
                color: PdfColor.fromHex('458CAD'),
                fontWeight: pw.FontWeight.bold,
                fontSize: 15,
              ),
            ),
            pw.Text(cycleName, style: const pw.TextStyle(fontSize: 9)),
          ],
        ),
      ),
      footer: (context) => pw.Container(
        padding: const pw.EdgeInsets.only(top: 7),
        decoration: pw.BoxDecoration(
          border: pw.Border(
            top: pw.BorderSide(
              color: PdfColor.fromHex('99BD41'),
              width: 2,
            ),
          ),
        ),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(currentUser.displayName),
            pw.Text(
              l10n.pageOf(
                context.pageNumber,
                context.pagesCount,
              ),
            ),
          ],
        ),
      ),
      build: (_) => [
        if (assignments.isEmpty)
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 24),
            child: pw.Text(
              l10n.noGradedSubjectsAvailable,
            ),
          ),
        for (final assignment in assignments) ...[
          pw.SizedBox(height: 14),
          pw.Text(
            assignment.subjectName,
            style: const pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 3),
          pw.Text(
            '${l10n.semesterGroupValue(
              assignment.semester,
              assignment.group,
            )} | ${assignment.teacherName}',
            style: const pw.TextStyle(
              fontSize: 9,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
            columnWidths: const {
              0: pw.FlexColumnWidth(3.2),
              1: pw.FlexColumnWidth(1.8),
              2: pw.FlexColumnWidth(1),
              3: pw.FlexColumnWidth(1.4),
            },
            children: [
              pw.TableRow(
                children: [
                  _pdfCell(l10n.student, header: true),
                  _pdfCell(l10n.registration, header: true),
                  _pdfCell(l10n.grade, header: true),
                  _pdfCell(l10n.status, header: true),
                ],
              ),
              for (final student
                  in _studentsForGradeReport(assignment, currentUser))
                pw.TableRow(
                  children: [
                    _pdfCell(student.fullStudentName),
                    _pdfCell(student.registration),
                    _pdfCell(
                      _gradeTextForReport(
                        l10n,
                        assignment,
                        student,
                      ),
                      alignment: pw.Alignment.center,
                    ),
                    _pdfCell(
                      _statusTextForReport(
                        l10n,
                        assignment,
                        student,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ],
    ),
  );
  return document.save();
}

Future<String> saveGradePdfReport(
  Uint8List bytes, {
  required String baseName,
}) async {
  final candidates = <Directory>[];
  final home =
      Platform.environment['USERPROFILE'] ?? Platform.environment['HOME'];
  if (home != null) {
    candidates.add(Directory('$home${Platform.pathSeparator}Downloads'));
  }
  if (Platform.isAndroid) {
    candidates.add(Directory('/storage/emulated/0/Download'));
  }
  candidates.add(Directory.systemTemp);

  Directory destination = Directory.systemTemp;
  for (final candidate in candidates) {
    try {
      if (!await candidate.exists()) await candidate.create(recursive: true);
      destination = candidate;
      break;
    } on FileSystemException {
      continue;
    }
  }
  final safeName = baseName
      .replaceAll(RegExp(r'[^A-Za-z0-9_-]+'), '_')
      .replaceAll(RegExp(r'_+'), '_')
      .replaceAll(RegExp(r'^_|_$'), '');
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final file = File(
    '${destination.path}${Platform.pathSeparator}'
    '${
      safeName.isEmpty
      ? 'reporte_calificaciones'
      : safeName
    }_$timestamp.pdf',
  );
  await file.writeAsBytes(bytes, flush: true);
  return file.path;
}

class GradesScreen extends StatefulWidget {
  const GradesScreen({super.key, required this.currentUser});

  final AppUser currentUser;

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

enum _L4GradeView { subjects, pending }

class _GradesScreenState extends State<GradesScreen> {
  final _searchController = TextEditingController();
  final Set<int> _semesterFilters = {};
  final Set<String> _groupFilters = {};
  bool _showSuggestions = false;
  _L4GradeView _l4View = _L4GradeView.subjects;

  bool get _isStudent => widget.currentUser.role == UserRole.level4Student;
  bool get _isTeacher => widget.currentUser.role == UserRole.level3Teacher;
  bool get _isIsolated => _isStudent || _isTeacher;
  bool get _showsGradeAction =>
      widget.currentUser.role == UserRole.level1Admin || _isTeacher;
  bool get _gradeActionEnabled =>
      widget.currentUser.role == UserRole.level1Admin ||
      (_isTeacher && MockRepository.gradingPeriodActive);

  List<CycleSubjectAssignment> get _assignments =>
      MockRepository.subjectAssignmentsFor(widget.currentUser);

  List<CycleSubjectAssignment> get _visibleAssignments {
    if (_isStudent) {
      final registration = widget.currentUser.registration;
      if (registration == null) return const [];
      return _assignments.where((assignment) {
        if (!MockRepository.studentHasGrade(
          assignment: assignment,
          registration: registration,
        )) {
          return false;
        }
        final pending = MockRepository.pendingSubjectStage(
          assignment: assignment,
          registration: registration,
        );
        return _l4View == _L4GradeView.pending ? pending != null : true;
      }).toList(growable: false);
    }
    if (_isTeacher) return _assignments;

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
    if (_isIsolated || !_showSuggestions || query.isEmpty) return const [];
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
    final l10n = AppLocalizations.of(context)!;

    final cycleName =
        MockRepository.activeCycle?.name.toUpperCase() ??
        l10n.noActiveCycle.toUpperCase();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionHeader(
          title: l10n.gradesTitle,
          subtitle: _isStudent
              ? l10n.yourGradedSubjects
              : _isTeacher
                  ? l10n.yourAssignedSubjects
                  : l10n.cycleSubjectAssignments,
          trailing: IconButton(
            tooltip: l10n.downloadGradedSubjectPdfs,
            onPressed: _showPdfNotice,
            icon: const Icon(Icons.picture_as_pdf_outlined),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          key: ValueKey(cycleName),
          initialValue: cycleName,
          readOnly: true,
          decoration: InputDecoration(
            labelText: l10n.currentActiveCycle,
          ),
        ),
        if (_isStudent) ...[
          const SizedBox(height: 16),
          SegmentedButton<_L4GradeView>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(
                value: _L4GradeView.subjects,
                label: Text(l10n.graded),
                icon: const Icon(Icons.fact_check_outlined),
              ),
              ButtonSegment(
                value: _L4GradeView.pending,
                label: Text(l10n.pending),
                icon: const Icon(Icons.pending_actions_outlined),
              ),
            ],
            selected: {_l4View},
            onSelectionChanged: (selection) {
              setState(() => _l4View = selection.first);
            },
          ),
        ],
        if (!_isIsolated) ...[
          const SizedBox(height: 16),
          Text(
            l10n.semester,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 8),
          _MultiFilterChips<int>(
            values: const [1, 2, 3, 4, 5, 6],
            selectedValues: _semesterFilters,
            label: (value) => '$value',
            onToggle: (value) => setState(() {
              if (!_semesterFilters.add(value)) {
                _semesterFilters.remove(value);
              }
            }),
          ),
          const SizedBox(height: 14),
          Text(
            l10n.group,
            style: Theme.of(context).textTheme.labelLarge,
          ),
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
              labelText: l10n.searchSubjects,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                tooltip: l10n.clearSearch,
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
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(l10n.noMatches),
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
                            onTap: () => _openPrimaryAction(assignment),
                          ),
                      ],
                    ),
            ),
          ],
        ],
        const SizedBox(height: 20),
        Text(
          _isStudent && _l4View == _L4GradeView.pending
              ? l10n.pendingSubjects
              : l10n.subjects,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 10),
        if (MockRepository.activeCycle == null)
          _EmptyState(
            message: l10n.noActiveCycle,
          )
        else if (_visibleAssignments.isEmpty)
          _EmptyState(
            message: _isStudent && _l4View == _L4GradeView.pending
                ? l10n.noPendingSubjects
                : _isStudent
                    ? l10n.noGradedSubjects
                    : l10n.noAssignedSubjects,
          )
        else
          for (final assignment in _visibleAssignments) ...[
            _SubjectAssignmentCard(
              assignment: assignment,
              graded: _isStudent
                  ? true
                  : MockRepository.isAssignmentGraded(assignment),
              pendingStage: _isStudent
                  ? MockRepository.pendingSubjectStage(
                      assignment: assignment,
                      registration: widget.currentUser.registration!,
                    )
                  : null,
              primaryLabel: 
                _showsGradeAction ? l10n.gradeAction : l10n.viewAction,
              primaryIcon: _showsGradeAction
                  ? Icons.edit_note_outlined
                  : Icons.picture_as_pdf_outlined,
              onPrimary: !_showsGradeAction || _gradeActionEnabled
                  ? () => _openPrimaryAction(assignment)
                  : null,
              onRegistry: () => _openRegistry(assignment),
            ),
            const SizedBox(height: 8),
          ],
      ],
    );
  }

  Future<void> _openPrimaryAction(
    CycleSubjectAssignment assignment,
  ) async {
    setState(() {
      _searchController.text = assignment.subjectName;
      _showSuggestions = false;
    });
    if (!_showsGradeAction) {
      await Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) => _SubjectGradeReportScreen(
            assignment: assignment,
            currentUser: widget.currentUser,
          ),
        ),
      );
      return;
    }
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => GradingToolScreen(assignment: assignment),
      ),
    );
    if (mounted) setState(() {});
  }

  Future<void> _openRegistry(CycleSubjectAssignment assignment) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => RegistryScreen(
          assignment: assignment,
          currentUser: widget.currentUser,
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  Future<void> _showPdfNotice() async {
    final l10n = AppLocalizations.of(context)!;
    final reportable = _isStudent
        ? _assignments
            .where(
              (assignment) => MockRepository.studentHasGrade(
                assignment: assignment,
                registration: widget.currentUser.registration!,
              ),
            )
            .toList(growable: false)
        : _assignments
            .where(MockRepository.isAssignmentGraded)
            .toList(growable: false);
    if (reportable.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.noGradedSubjectsToDownload,
            ),
        )
      );
      return;
    }
    try {
      final bytes = await buildGradePdfReport(
        assignments: reportable,
        currentUser: widget.currentUser,
        l10n: l10n,
      );
      final path = await saveGradePdfReport(
        bytes,
        baseName: 'reporte_calificaciones',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.pdfSavedTo(path),
          ),
        )
      );
    } on FileSystemException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.couldNotSavePdf(error.message),
          ),
        )
      );
    }
  }
}

class _SubjectGradeReportScreen extends StatelessWidget {
  const _SubjectGradeReportScreen({
    required this.assignment,
    required this.currentUser,
  });

  final CycleSubjectAssignment assignment;
  final AppUser currentUser;

  Future<void> _download(
    BuildContext context,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    try {
      final bytes = await buildGradePdfReport(
        assignments: [assignment],
        currentUser: currentUser,
        l10n: l10n,
      );
      final path = await saveGradePdfReport(
        bytes,
        baseName: 
          '${assignment.subjectName}_reporte_calificaciones',
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.pdfSavedTo(path),
          ),
        ),
      );
    } on FileSystemException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.couldNotSavePdf(
              error.message,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final students =
      _studentsForGradeReport(assignment, currentUser);
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(l10n.subjectGradeReport),
        actions: [
          IconButton(
            tooltip: l10n.downloadPdf,
            onPressed: () => _download(context),
            icon: const Icon(Icons.download_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Icon(
            Icons.picture_as_pdf_outlined,
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Text(
            assignment.subjectName,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            l10n.semesterGroupValue(
              assignment.semester,
              assignment.group,
            ),
            textAlign: TextAlign.center,
          ),
          Text(assignment.teacherName, textAlign: TextAlign.center),
          const Divider(height: 28),
          if (students.isEmpty)
            _EmptyState(
              message: l10n.noStudentsInReport,
            )
          else
            for (final student in students) ...[
              _GradeReportRow(
                student: student,
                assignment: assignment,
              ),
              const SizedBox(height: 8),
            ],
        ],
      ),
    );
  }
}

class _GradeReportRow extends StatelessWidget {
  const _GradeReportRow({
    required this.student,
    required this.assignment,
  });

  final StudentEnrollment student;
  final CycleSubjectAssignment assignment;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final latest = _latestGradeForReport(assignment, student.registration);
    final pending = MockRepository.pendingSubjectStage(
      assignment: assignment,
      registration: student.registration,
    );
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      title: Text(student.fullStudentName),
      subtitle: Text(student.registration),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            latest == null
                ? l10n.notGraded
                : _displayGrade(
                    latest.finalGrade,
                    assignment.usesLetterGrades,
                  ),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (pending != null)
            Text(
              l10n.pendingStage(pending),
            ),
        ],
      ),
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
    required this.graded,
    required this.pendingStage,
    required this.primaryLabel,
    required this.primaryIcon,
    required this.onPrimary,
    required this.onRegistry,
  });

  final CycleSubjectAssignment assignment;
  final bool graded;
  final String? pendingStage;
  final String primaryLabel;
  final IconData primaryIcon;
  final VoidCallback? onPrimary;
  final VoidCallback onRegistry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    assignment.subjectName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                _GradingStatus(graded: graded, pendingStage: pendingStage),
              ],
            ),
            const SizedBox(height: 4),
            Text(assignment.teacherName),
            Text(
              l10n.semesterGroupValue(
                assignment.semester,
                assignment.group,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onPrimary,
                    icon: Icon(primaryIcon),
                    label: Text(primaryLabel),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onRegistry,
                    icon: const Icon(Icons.table_chart_outlined),
                    label: Text(l10n.registry),
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

class _GradingStatus extends StatelessWidget {
  const _GradingStatus({
    required this.graded,
    required this.pendingStage,
  });

  final bool graded;
  final String? pendingStage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isPending = pendingStage != null;
    final background = isPending
        ? const Color(0xFFFFE2A8)
        : graded
            ? const Color(0xFFDDF3E4)
            : const Color(0xFFFFF1C7);
    final foreground = isPending
        ? const Color(0xFF754B00)
        : graded
            ? const Color(0xFF245C36)
            : const Color(0xFF725A00);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        isPending
            ? l10n.pendingStage(pendingStage!)
            : graded
                ? l10n.graded
                : l10n.notGraded,
        style: TextStyle(
          color: foreground,
          fontWeight: FontWeight.w600,
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

  String _evaluationTypeLabel(
    AppLocalizations l10n,
    String type,
  ) {
    return switch (type) {
      'Final evaluation' => l10n.finalEvaluation,
      _ => type,
    };
  }

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
    final savedActivitiesCount =
        MockRepository.activitiesCountForAssignment(widget.assignment);
    if (MockRepository.isAssignmentGraded(widget.assignment) &&
        savedActivitiesCount != null) {
      _activitiesCountController.text =
          savedActivitiesCount == savedActivitiesCount.truncateToDouble()
              ? savedActivitiesCount.toInt().toString()
              : savedActivitiesCount.toString();
    }
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(l10n.gradingTool),
      ),
      body: Stepper(
        currentStep: _step,
        onStepTapped: (step) {
          if (step <= _step) setState(() => _step = step);
        },
        controlsBuilder: (_, __) => const SizedBox.shrink(),
        steps: [
          Step(
            title: Text(l10n.subjectData),
            isActive: _step >= 0,
            state: _step > 0 ? StepState.complete : StepState.indexed,
            content: _subjectDataStep(),
          ),
          Step(
            title: Text(l10n.evaluationData),
            isActive: _step >= 1,
            state: _step > 1 ? StepState.complete : StepState.indexed,
            content: _evaluationDataStep(),
          ),
          Step(
            title: Text(l10n.grading),
            isActive: _step >= 2,
            content: _gradingStep(),
          ),
        ],
      ),
    );
  }

  Widget _subjectDataStep() {
    final l10n = AppLocalizations.of(context)!;

    final cycle =
        MockRepository.activeCycle?.name.toUpperCase() ??
         l10n.noActiveCycle.toUpperCase();
    return Column(
      children: [
        _ReadOnlyValue(
            label: l10n.semester,
            value: '${widget.assignment.semester}'),
        const SizedBox(height: 10),
        _ReadOnlyValue(
          label: l10n.group,
          value: widget.assignment.group,
        ),
        const SizedBox(height: 10),
        _ReadOnlyValue(
          label: l10n.currentActiveCycle,
          value: cycle,
        ),
        const SizedBox(height: 10),
        _ReadOnlyValue(
          label: l10n.assignedTeacher,
          value: widget.assignment.teacherName,
        ),
        const SizedBox(height: 10),
        _ReadOnlyValue(
          label: l10n.subjectName,
          value: widget.assignment.subjectName,
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
            onPressed: () => setState(() => _step = 1),
            icon: const Icon(Icons.arrow_forward),
            label: Text(l10n.next),
          ),
        ),
      ],
    );
  }

  Widget _evaluationDataStep() {
    final l10n = AppLocalizations.of(context)!;
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
          decoration: InputDecoration(
            labelText: l10n.evaluationType,
          ),
          items: [
            for (final type in _evaluationTypes)
              DropdownMenuItem(
                value: type,
                child: Text(
                  _evaluationTypeLabel(l10n, type),
                ),
              ),
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
            labelText: l10n.activitiesCount,
            errorText:
                _activitiesCount < 0
                 ? l10n.enterZeroOrPositive
                 : null,
          ),
        ),
        const SizedBox(height: 8),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          value: _customizePercentages,
          title: Text(l10n.customizeGradePercentage),
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
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: const [_DecimalInputFormatter()],
                  decoration: InputDecoration(
                    labelText: l10n.activitiesPercentage,
                    errorText: !_percentagesValid
                        ? l10n.percentagesMustAddToTen
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _testPercentageController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: const [_DecimalInputFormatter()],
                  decoration: InputDecoration(
                    labelText: l10n.testPercentage,
                    errorText: !_percentagesValid
                        ? l10n.currentTotal(
                          sum.toStringAsFixed(1),
                        )
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
              label: Text(l10n.back),
            ),
            const Spacer(),
            FilledButton.icon(
              onPressed: _percentagesValid ? _showTable : null,
              icon: const Icon(Icons.table_rows_outlined),
              label: Text(l10n.showTable),
            ),
          ],
        ),
      ],
    );
  }

  Widget _gradingStep() {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton<_StudentGradeFilter>(
          showSelectedIcon: false,
          segments: [
            ButtonSegment(
              value: _StudentGradeFilter.graded,
              label: Text(l10n.graded),
            ),
            ButtonSegment(
              value: _StudentGradeFilter.ungraded,
              label: Text(l10n.notGraded),
            ),
            ButtonSegment(
              value: _StudentGradeFilter.all,
              label: Text(l10n.all),
            ),
          ],
          selected: {_studentFilter},
          onSelectionChanged: (selection) {
            setState(() => _studentFilter = selection.first);
          },
        ),
        const SizedBox(height: 12),
        if (_visibleStudents.isEmpty)
          _EmptyState(message: l10n.noStudentsInView)
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
          label: Text(l10n.saveGrades),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _showPdfNotice,
          icon: const Icon(Icons.picture_as_pdf_outlined),
          label: Text(l10n.downloadGradePdfTable),
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
    final l10n = AppLocalizations.of(context)!;

    final ungraded =
        _students.where((student) => !_isInputValid(student)).length;
    if (ungraded > 0) {
      final continueSaving = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(l10n.ungradedStudents),
          content: Text(
            ungraded == 1
              ? l10n.oneStudentIncompleteGrade
              : l10n.studentsIncompleteGrades(ungraded),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.keepGrading),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.continueSaving),
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
    MockRepository.saveActivitiesCountForAssignment(
      widget.assignment,
      _activitiesCount,
    );
    MockRepository.markAssignmentGraded(widget.assignment);
    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          uploaded
              ? l10n.gradesSaved
              : l10n.offlineGradesSaved
        ),
      ),
    );
  }

  void _showPdfNotice() {
    final l10n = AppLocalizations.of(context)!;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.gradePdfDisplayOnly,
        ),
      ),
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
    final l10n = AppLocalizations.of(context)!;
    
    final submitted =
     double.tryParse(inputs.activities.text);
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
              decoration: InputDecoration(
                labelText: l10n.absences,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: inputs.activities,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: const [_DecimalInputFormatter()],
              onChanged: (_) => onChanged(),
              decoration: InputDecoration(
                labelText: l10n.submittedActivities,
                errorText: activityInvalid
                    ? l10n.maximumValue(
                      _trimDouble(
                        math.max(0, activitiesCount).toDouble(),
                      ),
                    )
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
                labelText: l10n.testGrade,
                errorText: testInvalid ? l10n.useValueZeroToTen : null,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              key: ValueKey('${student.registration}-$displayedGrade'),
              initialValue: displayedGrade,
              readOnly: true,
              decoration: InputDecoration(
                labelText: l10n.finalGrade,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _showDetails(context),
                icon: const Icon(Icons.calculate_outlined),
                label: Text(l10n.details),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDetails(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    final total = math.max(0, activitiesCount);
    final mapped = _displayGrade(_finalGrade, usesLetterGrades);
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.gradeDetails),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                total == 0
                    ? l10n.activitiesNotConfiguredCalculation
                    : l10n.activitiesCalculation(
                      _trimDouble(_submitted),
                      _trimDouble(activitiesPercentage),
                      _trimDouble(total.toDouble()),
                      _activityGrade.toStringAsFixed(2),
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.testCalculation(
                  _trimDouble(_test),
                  _trimDouble(testPercentage),
                  _testGrade.toStringAsFixed(2),
                ),
              ),
              const Divider(height: 24),
              Text(
                l10n.finalGradeCalculation(
                  _activityGrade.toStringAsFixed(2),
                  _testGrade.toStringAsFixed(2),
                  _finalGrade.toStringAsFixed(2),
                  mapped,
                ),
              ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.ok),
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
