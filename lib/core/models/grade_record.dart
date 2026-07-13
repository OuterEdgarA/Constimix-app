class GradeRecord {
  const GradeRecord({
    required this.subject,
    required this.semester,
    required this.group,
    required this.activitiesCompleted,
    required this.totalActivities,
    required this.examScore,
  });

  final String subject;
  final int semester;
  final String group;
  final int activitiesCompleted;
  final int totalActivities;
  final double examScore;

  double get activityScore {
    if (totalActivities == 0) return 0;
    return (activitiesCompleted / totalActivities) * 7;
  }

  double get examWeightedScore => examScore * 0.3;

  double get finalGrade => activityScore + examWeightedScore;
}
