// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Constitución de 1917 Mixta';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get gradesTitle => 'Grades';

  @override
  String get usernameOrCurp => 'Username or CURP';

  @override
  String get passwordOrRegistration => 'Password or registration';

  @override
  String get signIn => 'Sign in';

  @override
  String get studentSignUp => 'Student sign up';

  @override
  String get invalidCredentials => 'Invalid credentials.';

  @override
  String get navHome => 'Home';

  @override
  String get navBoard => 'Board';

  @override
  String get navEnroll => 'Enroll';

  @override
  String get navSchedule => 'Schedule';

  @override
  String get navGrades => 'Grades';

  @override
  String get navProfile => 'Profile';

  @override
  String get navAdmin => 'Admin';

  @override
  String get useLightMode => 'Use light mode';

  @override
  String get useDarkMode => 'Use dark mode';

  @override
  String welcomeUser(String userName) {
    return 'Welcome, $userName';
  }

  @override
  String get homeDashboardSubtitle =>
      'Mobile-first dashboard with role-aware features.';

  @override
  String get pendingOfflineSyncItems => 'Pending offline sync items';

  @override
  String accessLevel(int level) {
    return 'Level $level';
  }

  @override
  String get dynamicContent => 'Dynamic content';

  @override
  String get dynamicContentSubtitle =>
      'Visible modules are filtered by clearance level.';

  @override
  String get featureCommunityBoard => 'Community board';

  @override
  String get featureEnrollment => 'Enrollment';

  @override
  String get featureGradingTool => 'Grading tool';

  @override
  String get roleSystemAdmin => 'System admin';

  @override
  String get roleSemesterAdmin => 'Semester admin';

  @override
  String get roleTeacher => 'Teacher';

  @override
  String get roleStudent => 'Student';

  @override
  String clearanceLevel(int level) {
    return 'Clearance level $level';
  }

  @override
  String get communityBoardTitle => 'Community board';

  @override
  String get communityPublishedUpdates => 'Published community updates';

  @override
  String get communityPostsReviewed =>
      'Your posts are reviewed before publication';

  @override
  String get communityPost => 'Post';

  @override
  String pendingReviewCount(int count) {
    return 'Pending review ($count)';
  }

  @override
  String get noPublishedPosts => 'No published posts.';

  @override
  String get postEditor => 'Post editor';

  @override
  String get editPost => 'Edit post';

  @override
  String get addFile => 'Add file';

  @override
  String get filePathOrImageUrl => 'File path or image URL';

  @override
  String get add => 'Add';

  @override
  String get videoAttachmentsUnsupported =>
      'Video attachments are not supported.';

  @override
  String get header => 'Header';

  @override
  String get body => 'Body';

  @override
  String get link => 'Link';

  @override
  String get attachFile => 'Attach file';

  @override
  String get requiredField => 'Required';

  @override
  String get linkOptional => 'Link (optional)';

  @override
  String get removeAttachment => 'Remove attachment';

  @override
  String get publishPost => 'Publish post';

  @override
  String get submitForApproval => 'Submit for approval';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get submitChangesForApproval => 'Submit changes for approval';

  @override
  String get pendingCommunityPosts => 'Pending community posts';

  @override
  String get noPostsAwaitingReview => 'No posts awaiting review.';

  @override
  String get reject => 'Reject';

  @override
  String get approve => 'Approve';

  @override
  String get downloadFile => 'Download file';

  @override
  String get closeImage => 'Close image';

  @override
  String get imageUnavailable => 'Image unavailable';

  @override
  String get linkCopied => 'Link copied.';

  @override
  String get downloadLinkCopied => 'Download link copied.';

  @override
  String get attachedFileUnavailable =>
      'The attached file is no longer available.';

  @override
  String savedTo(String path) {
    return 'Saved to $path';
  }

  @override
  String get enrollmentSubtitle =>
      'Review current and past level 4 student enrollments.';

  @override
  String get selectEnrollmentTable => 'Select your table';

  @override
  String get currentEnrollment => 'Current Enrollment';

  @override
  String get pastEnrollment => 'Past Enrollment';

  @override
  String get enrollmentCycle => 'Enrollment cycle';

  @override
  String get selectCycle => 'Select cycle';

  @override
  String get semesterFilter => 'Apply a semester filter';

  @override
  String get groupFilter => 'Apply a group filter';

  @override
  String get customSearch => 'Custom search';

  @override
  String get students => 'Students';

  @override
  String get closeSuggestions => 'Close suggestions';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get searchStudents => 'Search students';

  @override
  String get noMatches => 'No matches';

  @override
  String get openStudentData => 'Open student data';

  @override
  String get noStudentsToShow => 'No students to show';

  @override
  String get close => 'Close';

  @override
  String registrationValue(String registration) {
    return 'Registration: $registration';
  }

  @override
  String curpValue(String curp) {
    return 'CURP: $curp';
  }

  @override
  String semesterGroupValue(int semester, String group) {
    return 'Semester $semester | Group $group';
  }

  @override
  String emailValue(String email) {
    return 'Email: $email';
  }

  @override
  String get studentEnrollment => 'Student enrollment';

  @override
  String get editStudentEnrollment => 'Edit student enrollment';

  @override
  String get reviewSevenStepsBeforeSaving =>
      'Review all seven steps before saving.';

  @override
  String get completeSixStepsToCreateLevel4 =>
      'Complete the six steps to create a level 4 account.';

  @override
  String get schoolData => 'School data';

  @override
  String get studentData => 'Student data';

  @override
  String get studentContact => 'Student contact';

  @override
  String get tutorData => 'Tutor data';

  @override
  String get tutorContact => 'Tutor contact';

  @override
  String get additionalInfo => 'Additional info';

  @override
  String get transferredSubjects => 'Transferred subjects';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get disableUser => 'Disable user';

  @override
  String get enableUser => 'Enable user';

  @override
  String get studentAccountEnabled => 'Student account enabled.';

  @override
  String get studentAccountDisabled => 'Student account disabled.';

  @override
  String get completeRequiredFieldsBeforeSaving =>
      'Complete every required field before saving.';

  @override
  String studentSavedWithRegistration(String registration) {
    return 'Student saved with registration $registration.';
  }

  @override
  String get registration => 'Registration';

  @override
  String get semester => 'Semester';

  @override
  String get group => 'Group';

  @override
  String get groupAssignedFromArea =>
      'Group is assigned from the selected area.';

  @override
  String get area => 'Area';

  @override
  String get chooseAreaToAssignGroup => 'Choose an area to assign the group.';

  @override
  String get areaPhysics => 'Physics';

  @override
  String get areaBiological => 'Biological';

  @override
  String get areaEconomics => 'Economics';

  @override
  String get areaHumanities => 'Humanities';

  @override
  String get medicalProvider => 'Medical provider';

  @override
  String get medicalProviderPrivate => 'Private';

  @override
  String get medicalProviderMarineMilitary => 'Marine/Military';

  @override
  String get selectEquipmentAccess => 'Select the ones you have access to';

  @override
  String get equipmentCellphone => 'Cellphone';

  @override
  String get equipmentTablet => 'Tablet';

  @override
  String get equipmentComputer => 'Laptop/PC';

  @override
  String get equipmentInternet => 'Internet';

  @override
  String get equipmentNone => 'None';

  @override
  String get studentFatherSurname => 'Student father surname';

  @override
  String get studentMotherSurname => 'Student mother surname';

  @override
  String get studentName => 'Student name';

  @override
  String get studentCurp => 'Student CURP';

  @override
  String get sex => 'Sex';

  @override
  String get sexMale => 'Male';

  @override
  String get sexFemale => 'Female';

  @override
  String get bloodType => 'Blood type';

  @override
  String get placeOfBirth => 'Place of birth';

  @override
  String get curpMustBe18Characters => 'CURP must be 18 characters';

  @override
  String get openMapSelector => 'Open map selector';
}
