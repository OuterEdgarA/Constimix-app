import '../models/academic_cycle.dart';
import '../models/app_user.dart';
import '../models/community_post.dart';
import '../models/cycle_subject_assignment.dart';
import '../models/enrollment_draft.dart';
import '../models/schedule_item.dart';
import '../models/school_subject.dart';
import '../models/student_enrollment.dart';
import '../models/student_grade_entry.dart';
import '../models/user_role.dart';

class MockRepository {
  static final List<AppUser> _users = [
    const AppUser(
      id: 'u-admin-1',
      displayName: 'Vazquez  Eva',
      username: 'EVAZQUEZ',
      role: UserRole.level1Admin,
      fatherSurname: 'Vazquez',
      motherSurname: '',
      name: 'Eva',
      curp: 'VAZE010101MDFZVA01',
      password: 'evazquezv',
      profileDescription: 'First system administrator.',
    ),
    const AppUser(
      id: 'u-semester-1',
      displayName: 'Bernal  Roxana',
      username: 'RBernal',
      role: UserRole.level2SemesterAdmin,
      fatherSurname: 'Bernal',
      motherSurname: '',
      name: 'Roxana',
      curp: 'BERO010101MDFRXX02',
      password: 'rbernal010101',
    ),
    const AppUser(
      id: 'u-teacher-1',
      displayName: 'Hernandez  Jose',
      username: 'JHernandez',
      role: UserRole.level3Teacher,
      fatherSurname: 'Hernandez',
      motherSurname: '',
      name: 'Jose',
      curp: 'HEJJ010101HDFRRS03',
      password: 'jhernandez010101',
    ),
    const AppUser(
      id: 'u-student-1',
      displayName: 'Perez Lopez Juan',
      username: 'PEJL080101HDFRPN04',
      role: UserRole.level4Student,
      fatherSurname: 'Perez',
      motherSurname: 'Lopez',
      name: 'Juan',
      curp: 'PEJL080101HDFRPN04',
      registration: '260000000001',
      semester: 3,
      group: 'B',
    ),
  ];

  static final List<StudentEnrollment> _studentEnrollments = [
    StudentEnrollment(
      registration: '260000000001',
      semester: 3,
      group: 'B',
      medicalProvider: 'IMSS',
      nss: 'NSS260000000001',
      hasCellphoneAccess: true,
      hasTabletAccess: false,
      hasComputerAccess: true,
      hasInternetAccess: true,
      hasNoEquipmentAccess: false,
      studentFatherSurname: 'Perez',
      studentMotherSurname: 'Lopez',
      studentName: 'Juan',
      studentCurp: 'PEJL080101HDFRPN04',
      genre: 'Male',
      bloodType: 'O+',
      placeOfBirth: 'Xalapa, Veracruz',
      studentEmail: 'juan.perez@example.com',
      schoolEmail: '',
      studentLada: '+52',
      studentCellphone: '2281000000',
      studentDomicile: AddressSeed.schoolAddress,
      tutorRelation: 'Mother',
      tutorFatherSurname: 'Lopez',
      tutorMotherSurname: 'Garcia',
      tutorName: 'Ana',
      tutorCurp: 'LOGA800101MVZPRN01',
      tutorOccupation: 'Tutor',
      tutorLada: '+52',
      tutorCellphone: '2281000001',
      tutorEmail: 'ana@example.com',
      tutorDomicile: AddressSeed.schoolAddress,
      lastAcademicLevel: 'Bachillerato',
      civilStatus: 'Married',
      canReadAndWrite: true,
      createdAt: DateTime(2026, 7, 7),
    ),
  ];

  static final List<SchoolSubject> _subjects = [];
  static final List<AcademicCycle> _cycles = [
    AcademicCycle(
      id: 'cycle-23-24',
      name: 'Periodo 23-24',
      startDate: DateTime(2023, 8, 1),
      endDate: DateTime(2024, 7, 15),
    ),
    AcademicCycle(
      id: 'cycle-26-26',
      name: 'Periodo 26-26',
      startDate: DateTime(2026, 1, 1),
      endDate: DateTime(2026, 12, 31),
    ),
  ];
  static final Map<String, List<StudentEnrollment>> _cycleEnrollments = {
    'cycle-26-26': _studentEnrollments,
    'cycle-23-24': [
      _studentEnrollments.first.copyWith(semester: 1, group: 'A'),
    ],
  };
  static final Map<String, Set<String>> _cycleSubjectIds = {};
  static final List<CycleSubjectAssignment> _subjectAssignments = [
    const CycleSubjectAssignment(
      id: 'assignment-physics-26',
      cycleId: 'cycle-26-26',
      subjectName: 'PHYSICS',
      teacherName: 'HERNANDEZ JOSE',
      teacherUserId: 'u-teacher-1',
      semester: 3,
      group: 'B',
      evaluationMode: 'Number Evaluation',
    ),
    const CycleSubjectAssignment(
      id: 'assignment-math-26',
      cycleId: 'cycle-26-26',
      subjectName: 'MATHEMATICS',
      teacherName: 'VAZQUEZ EVA',
      teacherUserId: 'u-admin-1',
      semester: 3,
      group: 'B',
      evaluationMode: 'Letter Evaluation',
    ),
    const CycleSubjectAssignment(
      id: 'assignment-spanish-23',
      cycleId: 'cycle-23-24',
      subjectName: 'SPANISH',
      teacherName: 'BERNAL ROXANA',
      teacherUserId: 'u-semester-1',
      semester: 1,
      group: 'A',
      evaluationMode: 'Letter Evaluation',
    ),
  ];
  static final List<StudentGradeEntry> _studentGrades = [];
  static final List<StudentGradeEntry> _pendingGradeUploads = [];
  static final Map<String, int> _groupSizeLimits = {};
  static final Map<String, bool> _groupActivationOverrides = {};
  static String? _activeCycleId = 'cycle-26-26';
  static bool _gradingPeriodActive = false;
  static bool isOnline = true;

  static List<StudentEnrollment> get _activeEnrollmentStore {
    final cycleId = _activeCycleId;
    if (cycleId == null) return _studentEnrollments;
    return _cycleEnrollments.putIfAbsent(cycleId, () => []);
  }

  static List<AppUser> get users => List.unmodifiable(_users);

  static List<StudentEnrollment> get studentEnrollments =>
      List.unmodifiable(_activeEnrollmentStore);

  static List<StudentEnrollment> get currentEnrollments =>
      _activeEnrollmentStore
          .where((enrollment) => enrollment.isActive)
          .toList(growable: false);

  static List<StudentEnrollment> get pastEnrollments => _activeEnrollmentStore
      .where((enrollment) => !enrollment.isActive)
      .toList(growable: false);

  static bool usernameExists(String username, {String? exceptUserId}) {
    final normalized = username.trim().toUpperCase();
    return _users.any(
      (user) =>
          user.id != exceptUserId && user.username.toUpperCase() == normalized,
    );
  }

  static AppUser createStaffAccount({
    required UserRole role,
    required String fatherSurname,
    required String motherSurname,
    required String name,
    required String username,
    required String curp,
    required String password,
  }) {
    final user = AppUser(
      id: 'u-staff-${_users.length + 1}',
      displayName: _fullName(fatherSurname, motherSurname, name),
      username: username,
      role: role,
      fatherSurname: fatherSurname,
      motherSurname: motherSurname,
      name: name,
      curp: curp,
      password: password,
    );
    _users.add(user);
    return user;
  }

  static AppUser? updateStaffAccount({
    required String userId,
    required String fatherSurname,
    required String motherSurname,
    required String name,
    required String curp,
    required String username,
    required String password,
  }) {
    final index = _users.indexWhere((user) => user.id == userId);
    if (index == -1) return null;
    final updated = _users[index].copyWith(
      displayName: _fullName(fatherSurname, motherSurname, name),
      fatherSurname: fatherSurname,
      motherSurname: motherSurname,
      name: name,
      curp: curp,
      username: username,
      password: password,
    );
    _users[index] = updated;
    return updated;
  }

  static AppUser? updateUserProfile({
    required String userId,
    required String fatherSurname,
    required String motherSurname,
    required String name,
    required String curp,
    required String password,
    required int profileAvatarIndex,
    required String profileDescription,
  }) {
    final index = _users.indexWhere((user) => user.id == userId);
    if (index == -1) return null;
    final updated = _users[index].copyWith(
      displayName: _fullName(fatherSurname, motherSurname, name),
      fatherSurname: fatherSurname,
      motherSurname: motherSurname,
      name: name,
      curp: curp,
      password: password,
      profileAvatarIndex: profileAvatarIndex,
      profileDescription: profileDescription,
    );
    _users[index] = updated;
    return updated;
  }

  static AppUser? setUserActive(String userId, bool isActive) {
    final index = _users.indexWhere((user) => user.id == userId);
    if (index == -1) return null;
    final user = _users[index];
    final updated = user.copyWith(isActive: isActive);
    _users[index] = updated;
    if (user.role == UserRole.level4Student && user.registration != null) {
      setStudentEnrollmentActive(user.registration!, isActive);
      return _users.firstWhere((item) => item.id == userId);
    }
    return updated;
  }

  static StudentEnrollment? findEnrollmentForUser(AppUser user) {
    if (user.role != UserRole.level4Student) return null;
    for (final enrollment in _activeEnrollmentStore) {
      final sameRegistration = user.registration != null &&
          enrollment.registration == user.registration;
      final sameCurp = user.curp != null && enrollment.studentCurp == user.curp;
      if (sameRegistration || sameCurp) return enrollment;
    }
    return null;
  }

  static StudentEnrollment? setStudentEnrollmentActive(
    String registration,
    bool isActive,
  ) {
    final index = _activeEnrollmentStore.indexWhere(
      (enrollment) => enrollment.registration == registration,
    );
    if (index == -1) return null;
    final updated = _activeEnrollmentStore[index].copyWith(isActive: isActive);
    _activeEnrollmentStore[index] = updated;
    _upsertStudentUser(updated);
    return updated;
  }

  static String previewNextRegistration() {
    return nextRegistrationForYear(
      DateTime.now().year,
      _activeEnrollmentStore.map((item) => item.registration),
    );
  }

  static String nextRegistrationForYear(
    int year,
    Iterable<String> registrations,
  ) {
    final prefix = year.remainder(100).toString().padLeft(2, '0');
    var highestCounter = 0;
    for (final registration in registrations) {
      if (registration.length != 12 || !registration.startsWith(prefix)) {
        continue;
      }
      final counter = int.tryParse(registration.substring(2));
      if (counter != null && counter > highestCounter) {
        highestCounter = counter;
      }
    }
    return '$prefix${(highestCounter + 1).toString().padLeft(10, '0')}';
  }

  static List<String> availableGroupsForSemester(int semester) {
    return const ['A', 'B', 'C', 'D']
        .where((group) => groupIsActive(semester, group))
        .toList(growable: false);
  }

  static StudentEnrollment saveStudentEnrollment(StudentEnrollment enrollment) {
    final index = _activeEnrollmentStore.indexWhere(
      (item) => item.registration == enrollment.registration,
    );
    if (index == -1) {
      _activeEnrollmentStore.add(enrollment);
    } else {
      _activeEnrollmentStore[index] = enrollment;
    }
    _upsertStudentUser(enrollment);
    return enrollment;
  }

  static void _upsertStudentUser(StudentEnrollment enrollment) {
    final index = _users.indexWhere(
      (user) =>
          user.role == UserRole.level4Student &&
          user.registration == enrollment.registration,
    );
    final existing = index == -1 ? null : _users[index];
    final user = AppUser(
      id: existing?.id ?? 'u-student-${_users.length + 1}',
      displayName: enrollment.fullStudentName,
      username: enrollment.studentCurp,
      role: UserRole.level4Student,
      fatherSurname: enrollment.studentFatherSurname,
      motherSurname: enrollment.studentMotherSurname,
      name: enrollment.studentName,
      curp: enrollment.studentCurp,
      registration: enrollment.registration,
      semester: enrollment.semester,
      group: enrollment.group,
      password: existing?.password,
      profileDescription: existing?.profileDescription,
      profileAvatarIndex: existing?.profileAvatarIndex ?? 0,
      isActive: enrollment.isActive,
    );
    if (index == -1) {
      _users.add(user);
    } else {
      _users[index] = user;
    }
  }

  static String _fullName(
      String fatherSurname, String motherSurname, String name) {
    return [fatherSurname, motherSurname, name]
        .where((part) => part.trim().isNotEmpty)
        .join(' ');
  }

  static List<SchoolSubject> get subjects {
    final cycleId = _activeCycleId;
    if (cycleId == null) return List.unmodifiable(_subjects);
    final ids = _cycleSubjectIds[cycleId] ?? const <String>{};
    return _subjects
        .where((subject) => ids.contains(subject.idMateria))
        .toList(growable: false);
  }

  static String previewNextSubjectId(bool extracurricular) {
    final prefix = extracurricular ? 'X-' : '';
    var highest = 0;
    for (final subject in _subjects) {
      if (subject.isExtracurricular != extracurricular) continue;
      final rawId = extracurricular
          ? subject.idMateria.replaceFirst('X-', '')
          : subject.idMateria;
      final value = int.tryParse(rawId) ?? 0;
      if (value > highest) highest = value;
    }
    return '$prefix${highest + 1}';
  }

  static bool subjectKeyExists(String keyCode, {String? exceptId}) {
    final normalized = keyCode.trim().toUpperCase();
    return _subjects.any(
      (subject) =>
          subject.idMateria != exceptId &&
          subject.keyCode.toUpperCase() == normalized,
    );
  }

  static bool subjectNameExists(String name, {String? exceptId}) {
    final normalized = name.trim().toUpperCase();
    return subjects.any(
      (subject) =>
          subject.idMateria != exceptId &&
          subject.name.toUpperCase() == normalized,
    );
  }

  static SchoolSubject saveSubject(SchoolSubject subject) {
    final index = _subjects.indexWhere(
      (item) => item.idMateria == subject.idMateria,
    );
    if (index == -1) {
      _subjects.add(subject);
    } else {
      _subjects[index] = subject;
    }
    final cycleId = _activeCycleId;
    if (cycleId != null) {
      _cycleSubjectIds
          .putIfAbsent(cycleId, () => <String>{})
          .add(subject.idMateria);
    }
    return subject;
  }

  static String _groupKey(int semester, String group) {
    return '${_activeCycleId ?? 'no-cycle'}:$semester-$group';
  }

  static int groupSizeLimit(int semester, String group) {
    return _groupSizeLimits[_groupKey(semester, group)] ?? 25;
  }

  static int groupStudentCount(int semester, String group) {
    return _activeEnrollmentStore
        .where(
          (student) =>
              student.isActive &&
              student.semester == semester &&
              student.group == group,
        )
        .length;
  }

  static bool groupIsActive(int semester, String group) {
    if (groupStudentCount(semester, group) > 0) return true;
    final override = _groupActivationOverrides[_groupKey(semester, group)];
    if (override != null) return override;
    if (semester >= 5 || group == 'A' || group == 'B') return true;
    if (group == 'C') {
      return groupStudentCount(semester, 'A') >=
              groupSizeLimit(semester, 'A') &&
          groupStudentCount(semester, 'B') >= groupSizeLimit(semester, 'B');
    }
    return groupStudentCount(semester, 'C') >= groupSizeLimit(semester, 'C');
  }

  static bool setGroupActive(int semester, String group, bool isActive) {
    if (groupStudentCount(semester, group) > 0) return false;
    if (!isActive) {
      final activeGroups = const ['A', 'B', 'C', 'D']
          .where((item) => groupIsActive(semester, item))
          .length;
      if (activeGroups <= 1) return false;
    }
    _groupActivationOverrides[_groupKey(semester, group)] = isActive;
    return true;
  }

  static void saveGroupSizeLimit(int semester, String group, int limit) {
    _groupSizeLimits[_groupKey(semester, group)] = limit.clamp(1, 45).toInt();
  }

  static StudentEnrollment? assignStudentToGroup(
    String registration,
    int semester,
    String group,
  ) {
    final index = _activeEnrollmentStore.indexWhere(
      (student) => student.registration == registration,
    );
    if (index == -1) return null;
    final updated = _activeEnrollmentStore[index].copyWith(
      semester: semester,
      group: group,
    );
    _activeEnrollmentStore[index] = updated;
    _groupActivationOverrides[_groupKey(semester, group)] = true;
    _upsertStudentUser(updated);
    return updated;
  }

  static List<AcademicCycle> get cycles => List.unmodifiable(_cycles);

  static AcademicCycle? get activeCycle {
    final id = _activeCycleId;
    if (id == null) return null;
    for (final cycle in _cycles) {
      if (cycle.id == id) return cycle;
    }
    return null;
  }

  static bool get gradingPeriodActive =>
      activeCycle != null && _gradingPeriodActive;

  static AcademicCycle saveCycle(AcademicCycle cycle) {
    final index = _cycles.indexWhere((item) => item.id == cycle.id);
    if (index == -1) {
      _cycles.add(cycle);
    } else {
      _cycles[index] = cycle;
    }
    return cycle;
  }

  static void setActiveCycle(String cycleId) {
    if (_cycles.any((cycle) => cycle.id == cycleId)) {
      _activeCycleId = cycleId;
      _cycleEnrollments.putIfAbsent(cycleId, () => []);
      _cycleSubjectIds.putIfAbsent(cycleId, () => <String>{});
      _gradingPeriodActive = false;
      for (final enrollment in _activeEnrollmentStore) {
        _upsertStudentUser(enrollment);
      }
    }
  }

  static void setGradingPeriodActive(bool isActive) {
    _gradingPeriodActive = activeCycle == null ? false : isActive;
  }

  static List<CommunityPost> posts(AppUser currentUser) => [
        CommunityPost(
          id: 'post-1',
          title: 'Welcome to ConstiMix',
          body:
              'School announcements, events, links, and approved updates appear here first.',
          author: users.first,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          status: PostStatus.published,
        ),
        CommunityPost(
          id: 'post-2',
          title: 'Enrollment window',
          body:
              'Students can prepare contact information, tutor details, and social security data before re-enrollment opens.',
          author: users[1],
          createdAt: DateTime.now().subtract(const Duration(hours: 4)),
          status: currentUser.role.canReviewPosts
              ? PostStatus.pendingReview
              : PostStatus.published,
        ),
      ];

  static final Map<String, List<ScheduleItem>> _schedulesByCycle = {
    'cycle-26-26': const [
      ScheduleItem(
        subject: 'Physics',
        teacher: 'Hernandez Jose',
        day: 'Tuesday',
        startTime: '09:30',
        endTime: '11:00',
        semester: 3,
        group: 'B',
      ),
      ScheduleItem(
        subject: 'Mathematics',
        teacher: 'Vazquez Eva',
        day: 'Thursday',
        startTime: '11:20',
        endTime: '12:50',
        semester: 3,
        group: 'B',
      ),
    ],
    'cycle-23-24': const [
      ScheduleItem(
        subject: 'Spanish',
        teacher: 'Bernal Roxana',
        day: 'Monday',
        startTime: '08:00',
        endTime: '09:30',
        semester: 1,
        group: 'A',
      ),
    ],
  };

  static List<ScheduleItem> get schedules => List.unmodifiable(
        _schedulesByCycle[_activeCycleId] ?? const <ScheduleItem>[],
      );

  static List<CycleSubjectAssignment> subjectAssignmentsFor(
    AppUser currentUser,
  ) {
    final cycleId = _activeCycleId;
    if (cycleId == null) return const [];
    return _subjectAssignments.where((assignment) {
      if (assignment.cycleId != cycleId) return false;
      if (currentUser.role == UserRole.level3Teacher) {
        return assignment.teacherUserId == currentUser.id;
      }
      return true;
    }).toList(growable: false);
  }

  static List<StudentEnrollment> studentsForAssignment(
    CycleSubjectAssignment assignment,
  ) {
    return currentEnrollments
        .where(
          (student) =>
              student.semester == assignment.semester &&
              student.group == assignment.group,
        )
        .toList(growable: false);
  }

  static StudentGradeEntry? gradeForStudent({
    required CycleSubjectAssignment assignment,
    required String registration,
    required String evaluationType,
  }) {
    for (final grade in _studentGrades.reversed) {
      if (grade.cycleId == assignment.cycleId &&
          grade.assignmentId == assignment.id &&
          grade.registration == registration &&
          grade.evaluationType == evaluationType) {
        return grade;
      }
    }
    return null;
  }

  static bool saveStudentGrades(Iterable<StudentGradeEntry> entries) {
    final destination = isOnline ? _studentGrades : _pendingGradeUploads;
    for (final entry in entries) {
      final index = destination.indexWhere((item) => item.key == entry.key);
      if (index == -1) {
        destination.add(entry);
      } else {
        destination[index] = entry;
      }
    }
    return isOnline;
  }

  static int get pendingGradeUploadCount => _pendingGradeUploads.length;

  static void uploadPendingGrades() {
    if (!isOnline) return;
    saveStudentGrades(List<StudentGradeEntry>.from(_pendingGradeUploads));
    _pendingGradeUploads.clear();
  }

  static const enrollmentDraft = EnrollmentDraft(
    registration: '260000000002',
    semester: 1,
    group: 'A',
    studentName: 'Maria Lopez Garcia',
    curp: 'LOGM080101MDFPRA09',
    cellphone: '555-010-1010',
    tutorName: 'Ana Garcia',
    tutorRelation: 'Mother',
    hasInternet: true,
  );
}

class AddressSeed {
  static const schoolAddress =
      'Av. 20 de noviembre #360 Colonia Modelo C.P. 91040 Xalapa, Veracruz';
}
