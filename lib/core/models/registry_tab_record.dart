class RegistryStudentRecord {
  const RegistryStudentRecord({
    required this.registration,
    required this.studentName,
    this.behaviorChecks = const {},
    this.note = '',
  });

  final String registration;
  final String studentName;
  final Set<String> behaviorChecks;
  final String note;

  int get behaviorCount => behaviorChecks.length;

  String get behaviorStatus {
    if (behaviorCount == 0) return 'Regular';
    if (behaviorCount <= 2) return 'Irregular';
    return 'Bad';
  }
}

class RegistryTabRecord {
  const RegistryTabRecord({
    required this.assignmentId,
    required this.cycleId,
    required this.date,
    required this.teacherName,
    required this.semester,
    required this.group,
    required this.students,
  });

  final String assignmentId;
  final String cycleId;
  final DateTime date;
  final String teacherName;
  final int semester;
  final String group;
  final List<RegistryStudentRecord> students;

  String get key => '$assignmentId|${_dateKey(date)}';

  static String _dateKey(DateTime value) {
    return '${value.year.toString().padLeft(4, '0')}-'
        '${value.month.toString().padLeft(2, '0')}-'
        '${value.day.toString().padLeft(2, '0')}';
  }
}
