class StudentGradeEntry {
  const StudentGradeEntry({
    required this.cycleId,
    required this.assignmentId,
    required this.registration,
    required this.evaluationType,
    required this.evaluationDate,
    required this.absences,
    required this.activitiesSubmitted,
    required this.testGrade,
    required this.finalGrade,
  });

  final String cycleId;
  final String assignmentId;
  final String registration;
  final String evaluationType;
  final DateTime evaluationDate;
  final int absences;
  final double activitiesSubmitted;
  final double testGrade;
  final double finalGrade;

  String get key => '$cycleId|$assignmentId|$evaluationType|$registration';
}
