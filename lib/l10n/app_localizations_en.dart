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
}
