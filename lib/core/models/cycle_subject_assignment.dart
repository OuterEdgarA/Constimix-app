class CycleSubjectAssignment {
  const CycleSubjectAssignment({
    required this.id,
    required this.subjectId,
    required this.cycleId,
    required this.subjectName,
    required this.teacherName,
    required this.teacherUserId,
    required this.semester,
    required this.group,
    required this.evaluationMode,
    this.periodHalf = 'First half',
    this.day = 'Saturday',
    this.timeRange = '08:00 - 09:30',
  });

  final String id;
  final String subjectId;
  final String cycleId;
  final String subjectName;
  final String teacherName;
  final String teacherUserId;
  final int semester;
  final String group;
  final String evaluationMode;
  final String periodHalf;
  final String day;
  final String timeRange;

  bool get usesLetterGrades => evaluationMode == 'Letter Evaluation';

  bool matchesSearch(String query) {
    final normalized = query.trim().toLowerCase();
    return normalized.isEmpty ||
        subjectName.toLowerCase().contains(normalized) ||
        teacherName.toLowerCase().contains(normalized);
  }
}
