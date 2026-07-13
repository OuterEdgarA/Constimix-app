class StudentEnrollment {
  const StudentEnrollment({
    required this.registration,
    required this.semester,
    required this.group,
    required this.medicalProvider,
    required this.nss,
    required this.hasCellphoneAccess,
    required this.hasTabletAccess,
    required this.hasComputerAccess,
    required this.hasInternetAccess,
    required this.hasNoEquipmentAccess,
    required this.studentFatherSurname,
    required this.studentMotherSurname,
    required this.studentName,
    required this.studentCurp,
    required this.genre,
    required this.bloodType,
    required this.placeOfBirth,
    required this.studentEmail,
    required this.schoolEmail,
    required this.studentLada,
    required this.studentCellphone,
    required this.studentDomicile,
    required this.tutorRelation,
    required this.tutorFatherSurname,
    required this.tutorMotherSurname,
    required this.tutorName,
    required this.tutorCurp,
    required this.tutorOccupation,
    required this.tutorLada,
    required this.tutorCellphone,
    required this.tutorEmail,
    required this.tutorDomicile,
    required this.lastAcademicLevel,
    required this.civilStatus,
    required this.canReadAndWrite,
    required this.createdAt,
    this.isActive = true,
  });

  final String registration;
  final int semester;
  final String group;
  final String medicalProvider;
  final String nss;
  final bool hasCellphoneAccess;
  final bool hasTabletAccess;
  final bool hasComputerAccess;
  final bool hasInternetAccess;
  final bool hasNoEquipmentAccess;
  final String studentFatherSurname;
  final String studentMotherSurname;
  final String studentName;
  final String studentCurp;
  final String genre;
  final String bloodType;
  final String placeOfBirth;
  final String studentEmail;
  final String schoolEmail;
  final String studentLada;
  final String studentCellphone;
  final String studentDomicile;
  final String tutorRelation;
  final String tutorFatherSurname;
  final String tutorMotherSurname;
  final String tutorName;
  final String tutorCurp;
  final String tutorOccupation;
  final String tutorLada;
  final String tutorCellphone;
  final String tutorEmail;
  final String tutorDomicile;
  final String lastAcademicLevel;
  final String civilStatus;
  final bool canReadAndWrite;
  final DateTime createdAt;
  final bool isActive;

  String get fullStudentName =>
      '$studentFatherSurname $studentMotherSurname $studentName'.trim();

  StudentEnrollment copyWith({
    int? semester,
    String? group,
    bool? isActive,
  }) {
    return StudentEnrollment(
      registration: registration,
      semester: semester ?? this.semester,
      group: group ?? this.group,
      medicalProvider: medicalProvider,
      nss: nss,
      hasCellphoneAccess: hasCellphoneAccess,
      hasTabletAccess: hasTabletAccess,
      hasComputerAccess: hasComputerAccess,
      hasInternetAccess: hasInternetAccess,
      hasNoEquipmentAccess: hasNoEquipmentAccess,
      studentFatherSurname: studentFatherSurname,
      studentMotherSurname: studentMotherSurname,
      studentName: studentName,
      studentCurp: studentCurp,
      genre: genre,
      bloodType: bloodType,
      placeOfBirth: placeOfBirth,
      studentEmail: studentEmail,
      schoolEmail: schoolEmail,
      studentLada: studentLada,
      studentCellphone: studentCellphone,
      studentDomicile: studentDomicile,
      tutorRelation: tutorRelation,
      tutorFatherSurname: tutorFatherSurname,
      tutorMotherSurname: tutorMotherSurname,
      tutorName: tutorName,
      tutorCurp: tutorCurp,
      tutorOccupation: tutorOccupation,
      tutorLada: tutorLada,
      tutorCellphone: tutorCellphone,
      tutorEmail: tutorEmail,
      tutorDomicile: tutorDomicile,
      lastAcademicLevel: lastAcademicLevel,
      civilStatus: civilStatus,
      canReadAndWrite: canReadAndWrite,
      createdAt: createdAt,
      isActive: isActive ?? this.isActive,
    );
  }

  bool matchesSearch(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return true;
    return studentFatherSurname.toLowerCase().contains(normalized) ||
        studentMotherSurname.toLowerCase().contains(normalized) ||
        studentName.toLowerCase().contains(normalized) ||
        studentCurp.toLowerCase().contains(normalized) ||
        registration.toLowerCase().contains(normalized);
  }
}
