enum UserRole {
  level1Admin,
  level2SemesterAdmin,
  level3Teacher,
  level4Student,
}

extension UserRoleDetails on UserRole {
  int get clearanceLevel => switch (this) {
        UserRole.level1Admin => 1,
        UserRole.level2SemesterAdmin => 2,
        UserRole.level3Teacher => 3,
        UserRole.level4Student => 4,
      };

  String get label => switch (this) {
        UserRole.level1Admin => 'System admin',
        UserRole.level2SemesterAdmin => 'Semester admin',
        UserRole.level3Teacher => 'Teacher',
        UserRole.level4Student => 'Student',
      };

  bool get canPublishWithoutApproval => this == UserRole.level1Admin;

  bool get canReviewPosts => this == UserRole.level1Admin;

  bool get canAccessAllSchedules =>
      this == UserRole.level1Admin ||
      this == UserRole.level2SemesterAdmin ||
      this == UserRole.level3Teacher;

  bool get canGrade =>
      this == UserRole.level1Admin || this == UserRole.level3Teacher;

  bool get canManageEnrollment =>
      this == UserRole.level1Admin || this == UserRole.level2SemesterAdmin;
}
