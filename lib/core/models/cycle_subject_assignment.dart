class CycleSubjectAssignment {
  const CycleSubjectAssignment({
    required this.id,
    required this.cycleId,
    required this.subjectName,
    required this.teacherName,
    required this.teacherUserId,
    required this.semester,
    required this.group,
    required this.evaluationMode,
  });

  final String id;
  final String cycleId;
  final String subjectName;
  final String teacherName;
  final String teacherUserId;
  final int semester;
  final String group;
  final String evaluationMode;

  bool get usesLetterGrades => evaluationMode == 'Letter Evaluation';

  bool matchesSearch(String query) {
    final normalized = query.trim().toLowerCase();
    return normalized.isEmpty ||
        subjectName.toLowerCase().contains(normalized) ||
        teacherName.toLowerCase().contains(normalized);
  }
}
