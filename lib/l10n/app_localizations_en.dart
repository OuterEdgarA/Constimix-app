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

  @override
  String get email => 'Email';

  @override
  String get schoolEmail => 'School email';

  @override
  String get cellphoneNumber => 'Cellphone number';

  @override
  String get privateDomicile => 'Private domicile';

  @override
  String get enterValidEmail => 'Enter a valid email';

  @override
  String get relationToStudent => 'Relation to student';

  @override
  String get relationMother => 'Mother';

  @override
  String get relationFather => 'Father';

  @override
  String get relationCousin => 'Cousin';

  @override
  String get relationAuntUncle => 'Aunt/Uncle';

  @override
  String get relationCloseFriend => 'Close friend';

  @override
  String get relationMyself => 'Myself';

  @override
  String get tutorFatherSurname => 'Tutor father surname';

  @override
  String get tutorMotherSurname => 'Tutor mother surname';

  @override
  String get tutorName => 'Tutor name';

  @override
  String get tutorCurp => 'Tutor CURP';

  @override
  String get occupation => 'Occupation';

  @override
  String get tutorCellphoneNumber => 'Tutor cellphone number';

  @override
  String get tutorEmail => 'Tutor email';

  @override
  String get sameDomicileAsStudent => 'Same domicile as student';

  @override
  String get tutorPrivateDomicile => 'Tutor private domicile';

  @override
  String get lastAcademicLevel => 'Last academic level';

  @override
  String get academicPrimary => 'Primary';

  @override
  String get academicSecondary => 'Secondary';

  @override
  String get academicHighSchool => 'High school';

  @override
  String get academicBachelor => 'Bachelor\'s degree';

  @override
  String get academicMaster => 'Master\'s degree';

  @override
  String get academicDoctorate => 'Doctorate';

  @override
  String get civilStatus => 'Civil status';

  @override
  String get civilSingle => 'Single';

  @override
  String get civilMarried => 'Married';

  @override
  String get civilWidowed => 'Widowed';

  @override
  String get civilFreeUnion => 'Free union';

  @override
  String get ableToReadAndWrite => 'Able to read and write';

  @override
  String get l4AccountCredentials => 'L4 account credentials';

  @override
  String get acknowledgeL4Credentials =>
      'I acknowledge these L4 account credentials';

  @override
  String get l4CredentialsExplanation =>
      'CURP is the username; registration is the password.';

  @override
  String copyField(String field) {
    return 'Copy $field';
  }

  @override
  String fieldCopied(String field) {
    return '$field copied.';
  }

  @override
  String get openStreetMapSelector => 'OpenStreetMap selector';

  @override
  String get searchLocation => 'Search location';

  @override
  String get search => 'Search';

  @override
  String get centerOnXalapa => 'Center on Xalapa';

  @override
  String get useThisLocation => 'Use this location';

  @override
  String get noMatchingLocationFound => 'No matching location was found.';

  @override
  String get locationServiceUnavailable =>
      'The location service is unavailable.';

  @override
  String get addressCouldNotBeResolved => 'The address could not be resolved.';

  @override
  String get locationSearchFailed =>
      'The location search could not be completed.';

  @override
  String selectedPointCoordinates(String latitude, String longitude) {
    return 'Selected point $latitude, $longitude';
  }

  @override
  String get subjectsPassedAtAnotherInstitution =>
      'Subjects passed at another institution';

  @override
  String get transferredSubjectsGradeExplanation =>
      'Selected subjects receive a final grade of 10 and remain editable in the grading tool.';

  @override
  String get noSubjectsAvailableForSemester =>
      'No subjects are available for this semester.';

  @override
  String semesterValue(int semester) {
    return 'Semester $semester';
  }

  @override
  String studentSemesterSchedule(int semester) {
    return 'Semester $semester schedule';
  }

  @override
  String get academicActivitiesBySemester => 'Academic activities by semester';

  @override
  String get overrideDateAndTime => 'Override date and time';

  @override
  String get useCurrentCst => 'Use current CST';

  @override
  String get currentActiveCycle => 'Current active cycle';

  @override
  String get noActiveCycle => 'No active cycle';

  @override
  String get currentDateCst => 'Current date (CST)';

  @override
  String get currentHourCst => 'Current hour (CST)';

  @override
  String get timeline => 'Timeline';

  @override
  String get calendar => 'Calendar';

  @override
  String get all => 'All';

  @override
  String get noActivitiesToday => 'No activities for today.';

  @override
  String get recess => 'Recess';

  @override
  String get noActiveGroups => 'No active groups';

  @override
  String groupNoClassAssigned(String group) {
    return 'Group $group: No class assigned';
  }

  @override
  String groupSubjectTeacher(String group, String subject, String teacher) {
    return 'Group $group: $subject - $teacher';
  }

  @override
  String semesterActivity(int semester) {
    return 'Semester $semester - 1 activity';
  }

  @override
  String semesterActivities(int semester, int count) {
    return 'Semester $semester - $count activities';
  }

  @override
  String get overrideScheduleClock => 'Override schedule clock';

  @override
  String get date => 'Date';

  @override
  String get hour => 'Hour';

  @override
  String get apply => 'Apply';

  @override
  String get noActivitiesForDate => 'No activities for this date.';

  @override
  String get currentPeriod => 'Current period';

  @override
  String get testApplication => 'Test application';

  @override
  String get schoolDay => 'School day';

  @override
  String get noAcademicActivities => 'No academic activities';

  @override
  String get tests => 'Tests';

  @override
  String get overlap => 'Overlap';

  @override
  String scheduleSemesterGroup(int semester, String group) {
    return 'Semester $semester$group';
  }
}
