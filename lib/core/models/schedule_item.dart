class ScheduleItem {
  const ScheduleItem({
    required this.subject,
    required this.teacher,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.semester,
    required this.group,
  });

  final String subject;
  final String teacher;
  final String day;
  final String startTime;
  final String endTime;
  final int semester;
  final String group;
}
