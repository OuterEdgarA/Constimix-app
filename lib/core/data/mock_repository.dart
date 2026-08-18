import '../models/academic_cycle.dart';
import '../models/app_user.dart';
import '../models/community_post.dart';
import '../models/cycle_subject_assignment.dart';
import '../models/enrollment_draft.dart';
import '../models/registry_tab_record.dart';
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
      firstHalfEndDate: DateTime(2023, 12, 15),
      secondHalfStartDate: DateTime(2024, 1, 8),
      firstHalfPlatformTests: AcademicDateRange(
        start: DateTime(2023, 11, 1),
        end: DateTime(2023, 11, 7),
      ),
      firstHalfPresentialTests: AcademicDateRange(
        start: DateTime(2023, 11, 20),
        end: DateTime(2023, 11, 25),
      ),
      secondHalfPlatformTests: AcademicDateRange(
        start: DateTime(2024, 5, 1),
        end: DateTime(2024, 5, 7),
      ),
      secondHalfPresentialTests: AcademicDateRange(
        start: DateTime(2024, 5, 20),
        end: DateTime(2024, 5, 25),
      ),
    ),
    AcademicCycle(
      id: 'cycle-26-26',
      name: 'Periodo 26-26',
      startDate: DateTime(2026, 1, 1),
      endDate: DateTime(2026, 12, 31),
      firstHalfEndDate: DateTime(2026, 6, 30),
      secondHalfStartDate: DateTime(2026, 7, 1),
      firstHalfPlatformTests: AcademicDateRange(
        start: DateTime(2026, 3, 1),
        end: DateTime(2026, 3, 7),
      ),
      firstHalfPresentialTests: AcademicDateRange(
        start: DateTime(2026, 4, 1),
        end: DateTime(2026, 4, 7),
      ),
      secondHalfPlatformTests: AcademicDateRange(
        start: DateTime(2026, 9, 1),
        end: DateTime(2026, 9, 7),
      ),
      secondHalfPresentialTests: AcademicDateRange(
        start: DateTime(2026, 10, 1),
        end: DateTime(2026, 10, 7),
      ),
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
      subjectId: 'seed-physics',
      cycleId: 'cycle-26-26',
      subjectName: 'PHYSICS',
      teacherName: 'HERNANDEZ JOSE',
      teacherUserId: 'u-teacher-1',
      semester: 3,
      group: 'B',
      evaluationMode: 'Number Evaluation',
      periodHalf: 'Second half',
      day: 'Tuesday',
      timeRange: '09:30 - 11:00',
    ),
    const CycleSubjectAssignment(
      id: 'assignment-math-26',
      subjectId: 'seed-math',
      cycleId: 'cycle-26-26',
      subjectName: 'MATHEMATICS',
      teacherName: 'VAZQUEZ EVA',
      teacherUserId: 'u-admin-1',
      semester: 3,
      group: 'B',
      evaluationMode: 'Letter Evaluation',
      periodHalf: 'Second half',
      day: 'Thursday',
      timeRange: '11:20 - 12:50',
    ),
    const CycleSubjectAssignment(
      id: 'assignment-spanish-23',
      subjectId: 'seed-spanish',
      cycleId: 'cycle-23-24',
      subjectName: 'SPANISH',
      teacherName: 'BERNAL ROXANA',
      teacherUserId: 'u-semester-1',
      semester: 1,
      group: 'A',
      evaluationMode: 'Letter Evaluation',
      day: 'Monday',
      timeRange: '08:00 - 09:30',
    ),
  ];
  static final List<StudentGradeEntry> _studentGrades = [];
  static final List<StudentGradeEntry> _pendingGradeUploads = [];
  static final List<StudentEnrollment> _pendingEnrollmentUploads = [];
  static final Map<String, Set<String>> _transferredSubjectIds = {};
  static final Set<String> _gradedAssignments = {};
  static final Map<String, double> _assignmentActivitiesCounts = {};
  static final List<RegistryTabRecord> _registryTabs = [];
  static final List<RegistryTabRecord> _pendingRegistryUploads = [];
  static final List<CommunityPost> _communityPosts = [
    CommunityPost(
      id: 'post-1',
      title: 'Welcome to #YoSoyConstiMix',
      body:
          'School announcements, events, links, and approved updates appear here first.',
      author: _users[0],
      createdAt: DateTime(2026, 7, 14),
      status: PostStatus.published,
      cycleId: 'cycle-26-26',
    ),
  ];
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

  static List<StudentEnrollment> enrollmentsForCycle(String cycleId) {
    return List.unmodifiable(
      _cycleEnrollments[cycleId] ?? const <StudentEnrollment>[],
    );
  }

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

  static AppUser? updateLimitedProfile({
    required String userId,
    required String password,
    required int profileAvatarIndex,
  }) {
    final index = _users.indexWhere((user) => user.id == userId);
    if (index == -1) return null;
    final updated = _users[index].copyWith(
      password: password,
      profileAvatarIndex: profileAvatarIndex,
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
    if (isOnline) {
      _pendingEnrollmentUploads.removeWhere(
        (item) => item.registration == enrollment.registration,
      );
    } else {
      final pendingIndex = _pendingEnrollmentUploads.indexWhere(
        (item) => item.registration == enrollment.registration,
      );
      if (pendingIndex == -1) {
        _pendingEnrollmentUploads.add(enrollment);
      } else {
        _pendingEnrollmentUploads[pendingIndex] = enrollment;
      }
    }
    _upsertStudentUser(enrollment);
    return enrollment;
  }

  static int get pendingEnrollmentUploadCount =>
      _pendingEnrollmentUploads.length;

  static void uploadPendingEnrollments() {
    if (!isOnline) return;
    _pendingEnrollmentUploads.clear();
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
    if (!isActive) {
      final cycleId = _activeCycleId;
      _subjectAssignments.removeWhere(
        (assignment) =>
            assignment.cycleId == cycleId &&
            assignment.semester == semester &&
            assignment.group == group,
      );
    }
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
    final previous = index == -1 ? null : _cycles[index];
    final periodBoundsChanged = previous != null &&
        (!_sameDay(previous.startDate, cycle.startDate) ||
            !_sameDay(previous.endDate, cycle.endDate));
    if (periodBoundsChanged) {
      _registryTabs.removeWhere((item) => item.cycleId == cycle.id);
      _pendingRegistryUploads.removeWhere((item) => item.cycleId == cycle.id);
    }
    if (index == -1) {
      _cycles.add(cycle);
    } else {
      _cycles[index] = cycle;
    }
    for (var postIndex = 0;
        postIndex < _communityPosts.length;
        postIndex += 1) {
      final post = _communityPosts[postIndex];
      if (post.cycleId == null && !post.createdAt.isAfter(cycle.endDate)) {
        _communityPosts[postIndex] = post.copyWith(cycleId: cycle.id);
      }
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

  static List<CommunityPost> posts(AppUser currentUser) {
    purgeCommunityPosts(DateTime.now());
    return _communityPosts
        .where((post) => post.status == PostStatus.published)
        .toList(growable: false)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  static List<CommunityPost> pendingCommunityPosts() {
    purgeCommunityPosts(DateTime.now());
    return _communityPosts
        .where((post) => post.status == PostStatus.pendingReview)
        .toList(growable: false)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  static CommunityPost submitCommunityPost({
    required AppUser author,
    required String title,
    required String body,
    String linkUrl = '',
    String attachmentPath = '',
    String attachmentName = '',
    DateTime? createdAt,
  }) {
    final timestamp = createdAt ?? DateTime.now();
    String? cycleId;
    final active = activeCycle;
    if (active != null &&
        !timestamp.isBefore(active.startDate) &&
        !timestamp.isAfter(active.endDate)) {
      cycleId = active.id;
    } else {
      final upcoming = _cycles
          .where((cycle) => !cycle.endDate.isBefore(timestamp))
          .toList()
        ..sort((a, b) => a.endDate.compareTo(b.endDate));
      if (upcoming.isNotEmpty) cycleId = upcoming.first.id;
    }
    final post = CommunityPost(
      id: 'post-${DateTime.now().microsecondsSinceEpoch}',
      title: title.trim(),
      body: body.trim(),
      author: author,
      createdAt: timestamp,
      status: author.role.canPublishWithoutApproval
          ? PostStatus.published
          : PostStatus.pendingReview,
      linkUrl: linkUrl.trim(),
      attachmentPath: attachmentPath.trim(),
      attachmentName: attachmentName.trim(),
      cycleId: cycleId,
    );
    _communityPosts.add(post);
    return post;
  }

  static CommunityPost? updateCommunityPost({
    required String postId,
    required AppUser editor,
    required String title,
    required String body,
    String linkUrl = '',
    String attachmentPath = '',
    String attachmentName = '',
  }) {
    final index = _communityPosts.indexWhere((post) => post.id == postId);
    if (index == -1) return null;
    final current = _communityPosts[index];
    final isL1 = editor.role == UserRole.level1Admin;
    final isApprovedAuthor = current.status == PostStatus.published &&
        current.author.id == editor.id &&
        const {
          UserRole.level2SemesterAdmin,
          UserRole.level3Teacher,
          UserRole.level4Student,
        }.contains(editor.role);
    if (!isL1 && !isApprovedAuthor) return null;

    final updated = current.copyWith(
      title: title.trim(),
      body: body.trim(),
      status: isL1 ? current.status : PostStatus.pendingReview,
      linkUrl: linkUrl.trim(),
      attachmentPath: attachmentPath.trim(),
      attachmentName: attachmentName.trim(),
    );
    _communityPosts[index] = updated;
    return updated;
  }

  static void approveCommunityPost(String postId) {
    _setCommunityPostStatus(postId, PostStatus.published);
  }

  static void rejectCommunityPost(String postId) {
    _setCommunityPostStatus(postId, PostStatus.rejected);
  }

  static void _setCommunityPostStatus(String postId, PostStatus status) {
    final index = _communityPosts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      _communityPosts[index] = _communityPosts[index].copyWith(status: status);
    }
  }

  static void purgeCommunityPosts(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    _communityPosts.removeWhere((post) {
      final cycleId = post.cycleId;
      if (cycleId == null) return false;
      AcademicCycle? cycle;
      for (final item in _cycles) {
        if (item.id == cycleId) {
          cycle = item;
          break;
        }
      }
      if (cycle == null) return false;
      final end = DateTime(
        cycle.endDate.year,
        cycle.endDate.month,
        cycle.endDate.day,
      );
      return today.isAfter(end);
    });
  }

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
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

  static List<CycleSubjectAssignment> assignmentsForSubject(
    SchoolSubject subject,
  ) {
    final cycleId = _activeCycleId;
    if (cycleId == null) return const [];
    return _subjectAssignments
        .where(
          (assignment) =>
              assignment.cycleId == cycleId &&
              assignment.subjectId == subject.idMateria,
        )
        .toList(growable: false);
  }

  static bool isSubjectAssigned(SchoolSubject subject) {
    return assignmentsForSubject(subject).isNotEmpty;
  }

  static CycleSubjectAssignment saveSubjectAssignment(
    CycleSubjectAssignment assignment,
  ) {
    final index = _subjectAssignments.indexWhere(
      (item) => item.id == assignment.id,
    );
    if (index == -1) {
      _subjectAssignments.add(assignment);
    } else {
      _subjectAssignments[index] = assignment;
    }
    return assignment;
  }

  static List<CycleSubjectAssignment> assignmentsForSubjectSemester(
    SchoolSubject subject,
    int semester,
  ) {
    return assignmentsForSubject(subject)
        .where((assignment) => assignment.semester == semester)
        .toList(growable: false);
  }

  static List<CycleSubjectAssignment> assignmentsForSubjectSemesterHalf(
    SchoolSubject subject,
    int semester,
    String periodHalf,
  ) {
    return assignmentsForSubjectSemester(subject, semester)
        .where((assignment) => assignment.periodHalf == periodHalf)
        .toList(growable: false);
  }

  static bool assignmentTimeIsAvailable({
    required int semester,
    required String group,
    required String periodHalf,
    required String day,
    required String timeRange,
    String? exceptSubjectId,
  }) {
    final cycleId = _activeCycleId;
    if (cycleId == null) return false;
    return !_subjectAssignments.any(
      (assignment) =>
          assignment.cycleId == cycleId &&
          assignment.semester == semester &&
          assignment.group == group &&
          assignment.periodHalf == periodHalf &&
          assignment.day == day &&
          assignment.timeRange == timeRange &&
          assignment.subjectId != exceptSubjectId,
    );
  }

  static void replaceSubjectAssignments({
    required SchoolSubject subject,
    required int semester,
    String? periodHalf,
    required Iterable<CycleSubjectAssignment> assignments,
  }) {
    final cycleId = _activeCycleId;
    if (cycleId == null) return;
    final replacements = assignments.toList(growable: false);
    final targetHalf = periodHalf ??
        (replacements.isEmpty ? null : replacements.first.periodHalf);
    _subjectAssignments.removeWhere(
      (assignment) =>
          assignment.cycleId == cycleId &&
          assignment.subjectId == subject.idMateria &&
          assignment.semester == semester &&
          (targetHalf == null || assignment.periodHalf == targetHalf),
    );
    _subjectAssignments.addAll(replacements);
    for (final assignment in replacements) {
      _groupActivationOverrides[
          _groupKey(assignment.semester, assignment.group)] = true;
    }
  }

  static List<CycleSubjectAssignment> get activeSubjectAssignments {
    final cycleId = _activeCycleId;
    if (cycleId == null) return const [];
    return _subjectAssignments
        .where((assignment) => assignment.cycleId == cycleId)
        .toList(growable: false);
  }

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
      if (currentUser.role == UserRole.level4Student) {
        return assignment.semester == currentUser.semester &&
            assignment.group == currentUser.group;
      }
      return true;
    }).toList(growable: false);
  }

  static List<CycleSubjectAssignment> transferableSubjectsForStudent(
    StudentEnrollment student,
  ) {
    final bySubject = <String, CycleSubjectAssignment>{};
    for (final assignment in activeSubjectAssignments) {
      if (assignment.semester == student.semester) {
        bySubject.putIfAbsent(assignment.subjectId, () => assignment);
      }
    }
    final result = bySubject.values.toList()
      ..sort((a, b) => a.subjectName.compareTo(b.subjectName));
    return result;
  }

  static Set<String> transferredSubjectIdsFor(String registration) =>
      Set.unmodifiable(
        _transferredSubjectIds[registration] ?? const <String>{},
      );

  static void setTransferredPassedSubjects(
    StudentEnrollment student,
    Set<String> subjectIds,
  ) {
    final previous =
        _transferredSubjectIds[student.registration] ?? const <String>{};
    final removed = previous.difference(subjectIds);
    if (removed.isNotEmpty) {
      bool shouldRemove(StudentGradeEntry grade) {
        if (grade.registration != student.registration ||
            grade.evaluationType != 'Final evaluation') {
          return false;
        }
        return _subjectAssignments.any(
          (assignment) =>
              assignment.id == grade.assignmentId &&
              removed.contains(assignment.subjectId),
        );
      }

      _studentGrades.removeWhere(shouldRemove);
      _pendingGradeUploads.removeWhere(shouldRemove);
    }

    _transferredSubjectIds[student.registration] = Set.of(subjectIds);
    final now = DateTime.now();
    for (final assignment in activeSubjectAssignments) {
      if (!subjectIds.contains(assignment.subjectId) ||
          assignment.semester != student.semester ||
          assignment.group != student.group) {
        continue;
      }
      saveStudentGrades([
        StudentGradeEntry(
          cycleId: assignment.cycleId,
          assignmentId: assignment.id,
          registration: student.registration,
          evaluationType: 'Final evaluation',
          evaluationDate: now,
          absences: 0,
          activitiesSubmitted: 0,
          testGrade: 10,
          finalGrade: 10,
        ),
      ]);
      markAssignmentGraded(assignment);
    }
  }

  static List<StudentGradeEntry> gradesForStudentAssignment({
    required CycleSubjectAssignment assignment,
    required String registration,
  }) {
    final byEvaluation = <String, StudentGradeEntry>{};
    for (final grade in [
      ..._pendingGradeUploads.reversed,
      ..._studentGrades.reversed,
    ]) {
      if (grade.cycleId == assignment.cycleId &&
          grade.assignmentId == assignment.id &&
          grade.registration == registration) {
        byEvaluation.putIfAbsent(grade.evaluationType, () => grade);
      }
    }
    return byEvaluation.values.toList(growable: false);
  }

  static bool studentHasGrade({
    required CycleSubjectAssignment assignment,
    required String registration,
  }) =>
      gradesForStudentAssignment(
        assignment: assignment,
        registration: registration,
      ).isNotEmpty;

  static String? pendingSubjectStage({
    required CycleSubjectAssignment assignment,
    required String registration,
  }) {
    final grades = {
      for (final grade in gradesForStudentAssignment(
        assignment: assignment,
        registration: registration,
      ))
        grade.evaluationType: grade.finalGrade,
    };
    final finalGrade = grades['Final evaluation'];
    if (finalGrade == null || finalGrade > 5) return null;
    for (final stage in const ['R1', 'R2', 'R3', 'RE']) {
      final grade = grades[stage];
      if (grade == null) return stage;
      if (grade > 5) return null;
    }
    return 'RE failed';
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

  static bool isAssignmentGraded(CycleSubjectAssignment assignment) {
    return _gradedAssignments.contains(
      '${assignment.cycleId}|${assignment.id}',
    );
  }

  static void markAssignmentGraded(CycleSubjectAssignment assignment) {
    _gradedAssignments.add('${assignment.cycleId}|${assignment.id}');
  }

  static double? activitiesCountForAssignment(
    CycleSubjectAssignment assignment,
  ) {
    return _assignmentActivitiesCounts[
        '${assignment.cycleId}|${assignment.id}'];
  }

  static void saveActivitiesCountForAssignment(
    CycleSubjectAssignment assignment,
    double activitiesCount,
  ) {
    _assignmentActivitiesCounts['${assignment.cycleId}|${assignment.id}'] =
        activitiesCount;
  }

  static String registryIdForAssignment(
    CycleSubjectAssignment assignment,
  ) {
    return '${assignment.cycleId}|${assignment.subjectId}|'
        '${assignment.teacherUserId}|${assignment.semester}|'
        '${assignment.group}|${assignment.periodHalf}';
  }

  static List<DateTime> registryDatesForAssignment(
    CycleSubjectAssignment assignment,
  ) {
    AcademicCycle? cycle;
    for (final item in _cycles) {
      if (item.id == assignment.cycleId) {
        cycle = item;
        break;
      }
    }
    if (cycle == null) return const [];
    final start = assignment.periodHalf == 'Second half'
        ? cycle.secondHalfStartDate
        : cycle.startDate;
    final end = assignment.periodHalf == 'Second half'
        ? cycle.endDate
        : cycle.firstHalfEndDate;
    final scheduledDays = _subjectAssignments
        .where(
          (item) =>
              item.cycleId == assignment.cycleId &&
              item.subjectId == assignment.subjectId &&
              item.teacherUserId == assignment.teacherUserId &&
              item.semester == assignment.semester &&
              item.group == assignment.group &&
              item.periodHalf == assignment.periodHalf,
        )
        .map((item) => item.day)
        .toSet();
    if (scheduledDays.isEmpty) scheduledDays.add(assignment.day);
    const weekdayNumbers = {
      'Monday': DateTime.monday,
      'Tuesday': DateTime.tuesday,
      'Wednesday': DateTime.wednesday,
      'Thursday': DateTime.thursday,
      'Friday': DateTime.friday,
      'Saturday': DateTime.saturday,
      'Sunday': DateTime.sunday,
    };
    final dates = <DateTime>{};
    final firstDate = DateTime(start.year, start.month, start.day);
    final lastDate = DateTime(end.year, end.month, end.day);
    for (final day in scheduledDays) {
      final weekday = weekdayNumbers[day];
      if (weekday == null) continue;
      final offset = (weekday - firstDate.weekday + 7) % 7;
      var date = firstDate.add(Duration(days: offset));
      while (!date.isAfter(lastDate)) {
        dates.add(date);
        date = date.add(const Duration(days: 7));
      }
    }
    final sorted = dates.toList()..sort();
    return sorted;
  }

  static bool registryCanEdit({
    required CycleSubjectAssignment assignment,
    required AppUser currentUser,
    required DateTime tabDate,
    required DateTime now,
  }) {
    if (currentUser.role == UserRole.level1Admin) return true;
    if (currentUser.role != UserRole.level3Teacher ||
        currentUser.id != assignment.teacherUserId) {
      return false;
    }
    final date = DateTime(tabDate.year, tabDate.month, tabDate.day);
    final today = DateTime(now.year, now.month, now.day);
    return !today.isBefore(date) &&
        !today.isAfter(date.add(const Duration(days: 3)));
  }

  static RegistryTabRecord? registryTab({
    required String assignmentId,
    required DateTime date,
  }) {
    final key = _registryKey(assignmentId, date);
    for (final record in _pendingRegistryUploads.reversed) {
      if (record.key == key) return record;
    }
    for (final record in _registryTabs.reversed) {
      if (record.key == key) return record;
    }
    return null;
  }

  static bool saveRegistryTab(RegistryTabRecord record) {
    if (isOnline) {
      _pendingRegistryUploads.removeWhere((item) => item.key == record.key);
      _upsertRegistry(_registryTabs, record);
      return true;
    }
    _upsertRegistry(_pendingRegistryUploads, record);
    return false;
  }

  static int get pendingRegistryUploadCount => _pendingRegistryUploads.length;

  static void uploadPendingRegistries() {
    if (!isOnline) return;
    for (final record
        in List<RegistryTabRecord>.from(_pendingRegistryUploads)) {
      _upsertRegistry(_registryTabs, record);
    }
    _pendingRegistryUploads.clear();
  }

  static void _upsertRegistry(
    List<RegistryTabRecord> destination,
    RegistryTabRecord record,
  ) {
    final index = destination.indexWhere((item) => item.key == record.key);
    if (index == -1) {
      destination.add(record);
    } else {
      destination[index] = record;
    }
  }

  static String _registryKey(String assignmentId, DateTime date) {
    return '$assignmentId|${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
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
