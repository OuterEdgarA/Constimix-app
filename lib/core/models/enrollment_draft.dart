class EnrollmentDraft {
  const EnrollmentDraft({
    required this.registration,
    required this.semester,
    required this.group,
    required this.studentName,
    required this.curp,
    required this.cellphone,
    required this.tutorName,
    required this.tutorRelation,
    required this.hasInternet,
  });

  final String registration;
  final int semester;
  final String group;
  final String studentName;
  final String curp;
  final String cellphone;
  final String tutorName;
  final String tutorRelation;
  final bool hasInternet;
}
