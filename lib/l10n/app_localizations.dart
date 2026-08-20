import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('es', 'MX')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Constitución de 1917 Mixta'**
  String get appTitle;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @gradesTitle.
  ///
  /// In en, this message translates to:
  /// **'Grades'**
  String get gradesTitle;

  /// No description provided for @usernameOrCurp.
  ///
  /// In en, this message translates to:
  /// **'Username or CURP'**
  String get usernameOrCurp;

  /// No description provided for @passwordOrRegistration.
  ///
  /// In en, this message translates to:
  /// **'Password or registration'**
  String get passwordOrRegistration;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @studentSignUp.
  ///
  /// In en, this message translates to:
  /// **'Student sign up'**
  String get studentSignUp;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials.'**
  String get invalidCredentials;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navBoard.
  ///
  /// In en, this message translates to:
  /// **'Board'**
  String get navBoard;

  /// No description provided for @navEnroll.
  ///
  /// In en, this message translates to:
  /// **'Enroll'**
  String get navEnroll;

  /// No description provided for @navSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get navSchedule;

  /// No description provided for @navGrades.
  ///
  /// In en, this message translates to:
  /// **'Grades'**
  String get navGrades;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get navAdmin;

  /// No description provided for @useLightMode.
  ///
  /// In en, this message translates to:
  /// **'Use light mode'**
  String get useLightMode;

  /// No description provided for @useDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Use dark mode'**
  String get useDarkMode;

  /// Welcome message shown on the home screen
  ///
  /// In en, this message translates to:
  /// **'Welcome, {userName}'**
  String welcomeUser(String userName);

  /// No description provided for @homeDashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Mobile-first dashboard with role-aware features.'**
  String get homeDashboardSubtitle;

  /// No description provided for @pendingOfflineSyncItems.
  ///
  /// In en, this message translates to:
  /// **'Pending offline sync items'**
  String get pendingOfflineSyncItems;

  /// User access level
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String accessLevel(int level);

  /// No description provided for @dynamicContent.
  ///
  /// In en, this message translates to:
  /// **'Dynamic content'**
  String get dynamicContent;

  /// No description provided for @dynamicContentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Visible modules are filtered by clearance level.'**
  String get dynamicContentSubtitle;

  /// No description provided for @featureCommunityBoard.
  ///
  /// In en, this message translates to:
  /// **'Community board'**
  String get featureCommunityBoard;

  /// No description provided for @featureEnrollment.
  ///
  /// In en, this message translates to:
  /// **'Enrollment'**
  String get featureEnrollment;

  /// No description provided for @featureGradingTool.
  ///
  /// In en, this message translates to:
  /// **'Grading tool'**
  String get featureGradingTool;

  /// No description provided for @roleSystemAdmin.
  ///
  /// In en, this message translates to:
  /// **'System admin'**
  String get roleSystemAdmin;

  /// No description provided for @roleSemesterAdmin.
  ///
  /// In en, this message translates to:
  /// **'Semester admin'**
  String get roleSemesterAdmin;

  /// No description provided for @roleTeacher.
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get roleTeacher;

  /// No description provided for @roleStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get roleStudent;

  /// Tooltip describing the user's clearance level
  ///
  /// In en, this message translates to:
  /// **'Clearance level {level}'**
  String clearanceLevel(int level);

  /// No description provided for @communityBoardTitle.
  ///
  /// In en, this message translates to:
  /// **'Community board'**
  String get communityBoardTitle;

  /// No description provided for @communityPublishedUpdates.
  ///
  /// In en, this message translates to:
  /// **'Published community updates'**
  String get communityPublishedUpdates;

  /// No description provided for @communityPostsReviewed.
  ///
  /// In en, this message translates to:
  /// **'Your posts are reviewed before publication'**
  String get communityPostsReviewed;

  /// No description provided for @communityPost.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get communityPost;

  /// No description provided for @pendingReviewCount.
  ///
  /// In en, this message translates to:
  /// **'Pending review ({count})'**
  String pendingReviewCount(int count);

  /// No description provided for @noPublishedPosts.
  ///
  /// In en, this message translates to:
  /// **'No published posts.'**
  String get noPublishedPosts;

  /// No description provided for @postEditor.
  ///
  /// In en, this message translates to:
  /// **'Post editor'**
  String get postEditor;

  /// No description provided for @editPost.
  ///
  /// In en, this message translates to:
  /// **'Edit post'**
  String get editPost;

  /// No description provided for @addFile.
  ///
  /// In en, this message translates to:
  /// **'Add file'**
  String get addFile;

  /// No description provided for @filePathOrImageUrl.
  ///
  /// In en, this message translates to:
  /// **'File path or image URL'**
  String get filePathOrImageUrl;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @videoAttachmentsUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Video attachments are not supported.'**
  String get videoAttachmentsUnsupported;

  /// No description provided for @header.
  ///
  /// In en, this message translates to:
  /// **'Header'**
  String get header;

  /// No description provided for @body.
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get body;

  /// No description provided for @link.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get link;

  /// No description provided for @attachFile.
  ///
  /// In en, this message translates to:
  /// **'Attach file'**
  String get attachFile;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// No description provided for @linkOptional.
  ///
  /// In en, this message translates to:
  /// **'Link (optional)'**
  String get linkOptional;

  /// No description provided for @removeAttachment.
  ///
  /// In en, this message translates to:
  /// **'Remove attachment'**
  String get removeAttachment;

  /// No description provided for @publishPost.
  ///
  /// In en, this message translates to:
  /// **'Publish post'**
  String get publishPost;

  /// No description provided for @submitForApproval.
  ///
  /// In en, this message translates to:
  /// **'Submit for approval'**
  String get submitForApproval;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @submitChangesForApproval.
  ///
  /// In en, this message translates to:
  /// **'Submit changes for approval'**
  String get submitChangesForApproval;

  /// No description provided for @pendingCommunityPosts.
  ///
  /// In en, this message translates to:
  /// **'Pending community posts'**
  String get pendingCommunityPosts;

  /// No description provided for @noPostsAwaitingReview.
  ///
  /// In en, this message translates to:
  /// **'No posts awaiting review.'**
  String get noPostsAwaitingReview;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @downloadFile.
  ///
  /// In en, this message translates to:
  /// **'Download file'**
  String get downloadFile;

  /// No description provided for @closeImage.
  ///
  /// In en, this message translates to:
  /// **'Close image'**
  String get closeImage;

  /// No description provided for @imageUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Image unavailable'**
  String get imageUnavailable;

  /// No description provided for @linkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied.'**
  String get linkCopied;

  /// No description provided for @downloadLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Download link copied.'**
  String get downloadLinkCopied;

  /// No description provided for @attachedFileUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The attached file is no longer available.'**
  String get attachedFileUnavailable;

  /// No description provided for @savedTo.
  ///
  /// In en, this message translates to:
  /// **'Saved to {path}'**
  String savedTo(String path);

  /// No description provided for @enrollmentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review current and past level 4 student enrollments.'**
  String get enrollmentSubtitle;

  /// No description provided for @selectEnrollmentTable.
  ///
  /// In en, this message translates to:
  /// **'Select your table'**
  String get selectEnrollmentTable;

  /// No description provided for @currentEnrollment.
  ///
  /// In en, this message translates to:
  /// **'Current Enrollment'**
  String get currentEnrollment;

  /// No description provided for @pastEnrollment.
  ///
  /// In en, this message translates to:
  /// **'Past Enrollment'**
  String get pastEnrollment;

  /// No description provided for @enrollmentCycle.
  ///
  /// In en, this message translates to:
  /// **'Enrollment cycle'**
  String get enrollmentCycle;

  /// No description provided for @selectCycle.
  ///
  /// In en, this message translates to:
  /// **'Select cycle'**
  String get selectCycle;

  /// No description provided for @semesterFilter.
  ///
  /// In en, this message translates to:
  /// **'Apply a semester filter'**
  String get semesterFilter;

  /// No description provided for @groupFilter.
  ///
  /// In en, this message translates to:
  /// **'Apply a group filter'**
  String get groupFilter;

  /// No description provided for @customSearch.
  ///
  /// In en, this message translates to:
  /// **'Custom search'**
  String get customSearch;

  /// No description provided for @students.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get students;

  /// No description provided for @closeSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Close suggestions'**
  String get closeSuggestions;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @searchStudents.
  ///
  /// In en, this message translates to:
  /// **'Search students'**
  String get searchStudents;

  /// No description provided for @noMatches.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get noMatches;

  /// No description provided for @openStudentData.
  ///
  /// In en, this message translates to:
  /// **'Open student data'**
  String get openStudentData;

  /// No description provided for @noStudentsToShow.
  ///
  /// In en, this message translates to:
  /// **'No students to show'**
  String get noStudentsToShow;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @registrationValue.
  ///
  /// In en, this message translates to:
  /// **'Registration: {registration}'**
  String registrationValue(String registration);

  /// No description provided for @curpValue.
  ///
  /// In en, this message translates to:
  /// **'CURP: {curp}'**
  String curpValue(String curp);

  /// No description provided for @semesterGroupValue.
  ///
  /// In en, this message translates to:
  /// **'Semester {semester} | Group {group}'**
  String semesterGroupValue(int semester, String group);

  /// No description provided for @emailValue.
  ///
  /// In en, this message translates to:
  /// **'Email: {email}'**
  String emailValue(String email);

  /// No description provided for @studentEnrollment.
  ///
  /// In en, this message translates to:
  /// **'Student enrollment'**
  String get studentEnrollment;

  /// No description provided for @editStudentEnrollment.
  ///
  /// In en, this message translates to:
  /// **'Edit student enrollment'**
  String get editStudentEnrollment;

  /// No description provided for @reviewSevenStepsBeforeSaving.
  ///
  /// In en, this message translates to:
  /// **'Review all seven steps before saving.'**
  String get reviewSevenStepsBeforeSaving;

  /// No description provided for @completeSixStepsToCreateLevel4.
  ///
  /// In en, this message translates to:
  /// **'Complete the six steps to create a level 4 account.'**
  String get completeSixStepsToCreateLevel4;

  /// No description provided for @schoolData.
  ///
  /// In en, this message translates to:
  /// **'School data'**
  String get schoolData;

  /// No description provided for @studentData.
  ///
  /// In en, this message translates to:
  /// **'Student data'**
  String get studentData;

  /// No description provided for @studentContact.
  ///
  /// In en, this message translates to:
  /// **'Student contact'**
  String get studentContact;

  /// No description provided for @tutorData.
  ///
  /// In en, this message translates to:
  /// **'Tutor data'**
  String get tutorData;

  /// No description provided for @tutorContact.
  ///
  /// In en, this message translates to:
  /// **'Tutor contact'**
  String get tutorContact;

  /// No description provided for @additionalInfo.
  ///
  /// In en, this message translates to:
  /// **'Additional info'**
  String get additionalInfo;

  /// No description provided for @transferredSubjects.
  ///
  /// In en, this message translates to:
  /// **'Transferred subjects'**
  String get transferredSubjects;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @disableUser.
  ///
  /// In en, this message translates to:
  /// **'Disable user'**
  String get disableUser;

  /// No description provided for @enableUser.
  ///
  /// In en, this message translates to:
  /// **'Enable user'**
  String get enableUser;

  /// No description provided for @studentAccountEnabled.
  ///
  /// In en, this message translates to:
  /// **'Student account enabled.'**
  String get studentAccountEnabled;

  /// No description provided for @studentAccountDisabled.
  ///
  /// In en, this message translates to:
  /// **'Student account disabled.'**
  String get studentAccountDisabled;

  /// No description provided for @completeRequiredFieldsBeforeSaving.
  ///
  /// In en, this message translates to:
  /// **'Complete every required field before saving.'**
  String get completeRequiredFieldsBeforeSaving;

  /// No description provided for @studentSavedWithRegistration.
  ///
  /// In en, this message translates to:
  /// **'Student saved with registration {registration}.'**
  String studentSavedWithRegistration(String registration);

  /// No description provided for @registration.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get registration;

  /// No description provided for @semester.
  ///
  /// In en, this message translates to:
  /// **'Semester'**
  String get semester;

  /// No description provided for @group.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get group;

  /// No description provided for @groupAssignedFromArea.
  ///
  /// In en, this message translates to:
  /// **'Group is assigned from the selected area.'**
  String get groupAssignedFromArea;

  /// No description provided for @area.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get area;

  /// No description provided for @chooseAreaToAssignGroup.
  ///
  /// In en, this message translates to:
  /// **'Choose an area to assign the group.'**
  String get chooseAreaToAssignGroup;

  /// No description provided for @areaPhysics.
  ///
  /// In en, this message translates to:
  /// **'Physics'**
  String get areaPhysics;

  /// No description provided for @areaBiological.
  ///
  /// In en, this message translates to:
  /// **'Biological'**
  String get areaBiological;

  /// No description provided for @areaEconomics.
  ///
  /// In en, this message translates to:
  /// **'Economics'**
  String get areaEconomics;

  /// No description provided for @areaHumanities.
  ///
  /// In en, this message translates to:
  /// **'Humanities'**
  String get areaHumanities;

  /// No description provided for @medicalProvider.
  ///
  /// In en, this message translates to:
  /// **'Medical provider'**
  String get medicalProvider;

  /// No description provided for @medicalProviderPrivate.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get medicalProviderPrivate;

  /// No description provided for @medicalProviderMarineMilitary.
  ///
  /// In en, this message translates to:
  /// **'Marine/Military'**
  String get medicalProviderMarineMilitary;

  /// No description provided for @selectEquipmentAccess.
  ///
  /// In en, this message translates to:
  /// **'Select the ones you have access to'**
  String get selectEquipmentAccess;

  /// No description provided for @equipmentCellphone.
  ///
  /// In en, this message translates to:
  /// **'Cellphone'**
  String get equipmentCellphone;

  /// No description provided for @equipmentTablet.
  ///
  /// In en, this message translates to:
  /// **'Tablet'**
  String get equipmentTablet;

  /// No description provided for @equipmentComputer.
  ///
  /// In en, this message translates to:
  /// **'Laptop/PC'**
  String get equipmentComputer;

  /// No description provided for @equipmentInternet.
  ///
  /// In en, this message translates to:
  /// **'Internet'**
  String get equipmentInternet;

  /// No description provided for @equipmentNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get equipmentNone;

  /// No description provided for @studentFatherSurname.
  ///
  /// In en, this message translates to:
  /// **'Student father surname'**
  String get studentFatherSurname;

  /// No description provided for @studentMotherSurname.
  ///
  /// In en, this message translates to:
  /// **'Student mother surname'**
  String get studentMotherSurname;

  /// No description provided for @studentName.
  ///
  /// In en, this message translates to:
  /// **'Student name'**
  String get studentName;

  /// No description provided for @studentCurp.
  ///
  /// In en, this message translates to:
  /// **'Student CURP'**
  String get studentCurp;

  /// No description provided for @sex.
  ///
  /// In en, this message translates to:
  /// **'Sex'**
  String get sex;

  /// No description provided for @sexMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get sexMale;

  /// No description provided for @sexFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get sexFemale;

  /// No description provided for @bloodType.
  ///
  /// In en, this message translates to:
  /// **'Blood type'**
  String get bloodType;

  /// No description provided for @placeOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Place of birth'**
  String get placeOfBirth;

  /// No description provided for @curpMustBe18Characters.
  ///
  /// In en, this message translates to:
  /// **'CURP must be 18 characters'**
  String get curpMustBe18Characters;

  /// No description provided for @openMapSelector.
  ///
  /// In en, this message translates to:
  /// **'Open map selector'**
  String get openMapSelector;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @schoolEmail.
  ///
  /// In en, this message translates to:
  /// **'School email'**
  String get schoolEmail;

  /// No description provided for @cellphoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Cellphone number'**
  String get cellphoneNumber;

  /// No description provided for @privateDomicile.
  ///
  /// In en, this message translates to:
  /// **'Private domicile'**
  String get privateDomicile;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get enterValidEmail;

  /// No description provided for @relationToStudent.
  ///
  /// In en, this message translates to:
  /// **'Relation to student'**
  String get relationToStudent;

  /// No description provided for @relationMother.
  ///
  /// In en, this message translates to:
  /// **'Mother'**
  String get relationMother;

  /// No description provided for @relationFather.
  ///
  /// In en, this message translates to:
  /// **'Father'**
  String get relationFather;

  /// No description provided for @relationCousin.
  ///
  /// In en, this message translates to:
  /// **'Cousin'**
  String get relationCousin;

  /// No description provided for @relationAuntUncle.
  ///
  /// In en, this message translates to:
  /// **'Aunt/Uncle'**
  String get relationAuntUncle;

  /// No description provided for @relationCloseFriend.
  ///
  /// In en, this message translates to:
  /// **'Close friend'**
  String get relationCloseFriend;

  /// No description provided for @relationMyself.
  ///
  /// In en, this message translates to:
  /// **'Myself'**
  String get relationMyself;

  /// No description provided for @tutorFatherSurname.
  ///
  /// In en, this message translates to:
  /// **'Tutor father surname'**
  String get tutorFatherSurname;

  /// No description provided for @tutorMotherSurname.
  ///
  /// In en, this message translates to:
  /// **'Tutor mother surname'**
  String get tutorMotherSurname;

  /// No description provided for @tutorName.
  ///
  /// In en, this message translates to:
  /// **'Tutor name'**
  String get tutorName;

  /// No description provided for @tutorCurp.
  ///
  /// In en, this message translates to:
  /// **'Tutor CURP'**
  String get tutorCurp;

  /// No description provided for @occupation.
  ///
  /// In en, this message translates to:
  /// **'Occupation'**
  String get occupation;

  /// No description provided for @tutorCellphoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Tutor cellphone number'**
  String get tutorCellphoneNumber;

  /// No description provided for @tutorEmail.
  ///
  /// In en, this message translates to:
  /// **'Tutor email'**
  String get tutorEmail;

  /// No description provided for @sameDomicileAsStudent.
  ///
  /// In en, this message translates to:
  /// **'Same domicile as student'**
  String get sameDomicileAsStudent;

  /// No description provided for @tutorPrivateDomicile.
  ///
  /// In en, this message translates to:
  /// **'Tutor private domicile'**
  String get tutorPrivateDomicile;

  /// No description provided for @lastAcademicLevel.
  ///
  /// In en, this message translates to:
  /// **'Last academic level'**
  String get lastAcademicLevel;

  /// No description provided for @academicPrimary.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get academicPrimary;

  /// No description provided for @academicSecondary.
  ///
  /// In en, this message translates to:
  /// **'Secondary'**
  String get academicSecondary;

  /// No description provided for @academicHighSchool.
  ///
  /// In en, this message translates to:
  /// **'High school'**
  String get academicHighSchool;

  /// No description provided for @academicBachelor.
  ///
  /// In en, this message translates to:
  /// **'Bachelor\'s degree'**
  String get academicBachelor;

  /// No description provided for @academicMaster.
  ///
  /// In en, this message translates to:
  /// **'Master\'s degree'**
  String get academicMaster;

  /// No description provided for @academicDoctorate.
  ///
  /// In en, this message translates to:
  /// **'Doctorate'**
  String get academicDoctorate;

  /// No description provided for @civilStatus.
  ///
  /// In en, this message translates to:
  /// **'Civil status'**
  String get civilStatus;

  /// No description provided for @civilSingle.
  ///
  /// In en, this message translates to:
  /// **'Single'**
  String get civilSingle;

  /// No description provided for @civilMarried.
  ///
  /// In en, this message translates to:
  /// **'Married'**
  String get civilMarried;

  /// No description provided for @civilWidowed.
  ///
  /// In en, this message translates to:
  /// **'Widowed'**
  String get civilWidowed;

  /// No description provided for @civilFreeUnion.
  ///
  /// In en, this message translates to:
  /// **'Free union'**
  String get civilFreeUnion;

  /// No description provided for @ableToReadAndWrite.
  ///
  /// In en, this message translates to:
  /// **'Able to read and write'**
  String get ableToReadAndWrite;

  /// No description provided for @l4AccountCredentials.
  ///
  /// In en, this message translates to:
  /// **'L4 account credentials'**
  String get l4AccountCredentials;

  /// No description provided for @acknowledgeL4Credentials.
  ///
  /// In en, this message translates to:
  /// **'I acknowledge these L4 account credentials'**
  String get acknowledgeL4Credentials;

  /// No description provided for @l4CredentialsExplanation.
  ///
  /// In en, this message translates to:
  /// **'CURP is the username; registration is the password.'**
  String get l4CredentialsExplanation;

  /// No description provided for @copyField.
  ///
  /// In en, this message translates to:
  /// **'Copy {field}'**
  String copyField(String field);

  /// No description provided for @fieldCopied.
  ///
  /// In en, this message translates to:
  /// **'{field} copied.'**
  String fieldCopied(String field);

  /// No description provided for @openStreetMapSelector.
  ///
  /// In en, this message translates to:
  /// **'OpenStreetMap selector'**
  String get openStreetMapSelector;

  /// No description provided for @searchLocation.
  ///
  /// In en, this message translates to:
  /// **'Search location'**
  String get searchLocation;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @centerOnXalapa.
  ///
  /// In en, this message translates to:
  /// **'Center on Xalapa'**
  String get centerOnXalapa;

  /// No description provided for @useThisLocation.
  ///
  /// In en, this message translates to:
  /// **'Use this location'**
  String get useThisLocation;

  /// No description provided for @noMatchingLocationFound.
  ///
  /// In en, this message translates to:
  /// **'No matching location was found.'**
  String get noMatchingLocationFound;

  /// No description provided for @locationServiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The location service is unavailable.'**
  String get locationServiceUnavailable;

  /// No description provided for @addressCouldNotBeResolved.
  ///
  /// In en, this message translates to:
  /// **'The address could not be resolved.'**
  String get addressCouldNotBeResolved;

  /// No description provided for @locationSearchFailed.
  ///
  /// In en, this message translates to:
  /// **'The location search could not be completed.'**
  String get locationSearchFailed;

  /// No description provided for @selectedPointCoordinates.
  ///
  /// In en, this message translates to:
  /// **'Selected point {latitude}, {longitude}'**
  String selectedPointCoordinates(String latitude, String longitude);

  /// No description provided for @subjectsPassedAtAnotherInstitution.
  ///
  /// In en, this message translates to:
  /// **'Subjects passed at another institution'**
  String get subjectsPassedAtAnotherInstitution;

  /// No description provided for @transferredSubjectsGradeExplanation.
  ///
  /// In en, this message translates to:
  /// **'Selected subjects receive a final grade of 10 and remain editable in the grading tool.'**
  String get transferredSubjectsGradeExplanation;

  /// No description provided for @noSubjectsAvailableForSemester.
  ///
  /// In en, this message translates to:
  /// **'No subjects are available for this semester.'**
  String get noSubjectsAvailableForSemester;

  /// No description provided for @semesterValue.
  ///
  /// In en, this message translates to:
  /// **'Semester {semester}'**
  String semesterValue(int semester);

  /// No description provided for @studentSemesterSchedule.
  ///
  /// In en, this message translates to:
  /// **'Semester {semester} schedule'**
  String studentSemesterSchedule(int semester);

  /// No description provided for @academicActivitiesBySemester.
  ///
  /// In en, this message translates to:
  /// **'Academic activities by semester'**
  String get academicActivitiesBySemester;

  /// No description provided for @overrideDateAndTime.
  ///
  /// In en, this message translates to:
  /// **'Override date and time'**
  String get overrideDateAndTime;

  /// No description provided for @useCurrentCst.
  ///
  /// In en, this message translates to:
  /// **'Use current CST'**
  String get useCurrentCst;

  /// No description provided for @currentActiveCycle.
  ///
  /// In en, this message translates to:
  /// **'Current active cycle'**
  String get currentActiveCycle;

  /// No description provided for @noActiveCycle.
  ///
  /// In en, this message translates to:
  /// **'No active cycle'**
  String get noActiveCycle;

  /// No description provided for @currentDateCst.
  ///
  /// In en, this message translates to:
  /// **'Current date (CST)'**
  String get currentDateCst;

  /// No description provided for @currentHourCst.
  ///
  /// In en, this message translates to:
  /// **'Current hour (CST)'**
  String get currentHourCst;

  /// No description provided for @timeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timeline;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @noActivitiesToday.
  ///
  /// In en, this message translates to:
  /// **'No activities for today.'**
  String get noActivitiesToday;

  /// No description provided for @recess.
  ///
  /// In en, this message translates to:
  /// **'Recess'**
  String get recess;

  /// No description provided for @noActiveGroups.
  ///
  /// In en, this message translates to:
  /// **'No active groups'**
  String get noActiveGroups;

  /// No description provided for @groupNoClassAssigned.
  ///
  /// In en, this message translates to:
  /// **'Group {group}: No class assigned'**
  String groupNoClassAssigned(String group);

  /// No description provided for @groupSubjectTeacher.
  ///
  /// In en, this message translates to:
  /// **'Group {group}: {subject} - {teacher}'**
  String groupSubjectTeacher(String group, String subject, String teacher);

  /// No description provided for @semesterActivity.
  ///
  /// In en, this message translates to:
  /// **'Semester {semester} - 1 activity'**
  String semesterActivity(int semester);

  /// No description provided for @semesterActivities.
  ///
  /// In en, this message translates to:
  /// **'Semester {semester} - {count} activities'**
  String semesterActivities(int semester, int count);

  /// No description provided for @overrideScheduleClock.
  ///
  /// In en, this message translates to:
  /// **'Override schedule clock'**
  String get overrideScheduleClock;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'Hour'**
  String get hour;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @noActivitiesForDate.
  ///
  /// In en, this message translates to:
  /// **'No activities for this date.'**
  String get noActivitiesForDate;

  /// No description provided for @currentPeriod.
  ///
  /// In en, this message translates to:
  /// **'Current period'**
  String get currentPeriod;

  /// No description provided for @testApplication.
  ///
  /// In en, this message translates to:
  /// **'Test application'**
  String get testApplication;

  /// No description provided for @schoolDay.
  ///
  /// In en, this message translates to:
  /// **'School day'**
  String get schoolDay;

  /// No description provided for @noAcademicActivities.
  ///
  /// In en, this message translates to:
  /// **'No academic activities'**
  String get noAcademicActivities;

  /// No description provided for @tests.
  ///
  /// In en, this message translates to:
  /// **'Tests'**
  String get tests;

  /// No description provided for @overlap.
  ///
  /// In en, this message translates to:
  /// **'Overlap'**
  String get overlap;

  /// No description provided for @scheduleSemesterGroup.
  ///
  /// In en, this message translates to:
  /// **'Semester {semester}{group}'**
  String scheduleSemesterGroup(int semester, String group);

  /// No description provided for @yourGradedSubjects.
  ///
  /// In en, this message translates to:
  /// **'Your graded subjects'**
  String get yourGradedSubjects;

  /// No description provided for @yourAssignedSubjects.
  ///
  /// In en, this message translates to:
  /// **'Your assigned subjects'**
  String get yourAssignedSubjects;

  /// No description provided for @cycleSubjectAssignments.
  ///
  /// In en, this message translates to:
  /// **'Cycle subject assignments'**
  String get cycleSubjectAssignments;

  /// No description provided for @downloadGradedSubjectPdfs.
  ///
  /// In en, this message translates to:
  /// **'Download graded subject PDFs'**
  String get downloadGradedSubjectPdfs;

  /// No description provided for @graded.
  ///
  /// In en, this message translates to:
  /// **'Graded'**
  String get graded;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @notGraded.
  ///
  /// In en, this message translates to:
  /// **'Not graded'**
  String get notGraded;

  /// No description provided for @searchSubjects.
  ///
  /// In en, this message translates to:
  /// **'Search subjects'**
  String get searchSubjects;

  /// No description provided for @subjects.
  ///
  /// In en, this message translates to:
  /// **'Subjects'**
  String get subjects;

  /// No description provided for @pendingSubjects.
  ///
  /// In en, this message translates to:
  /// **'Pending subjects'**
  String get pendingSubjects;

  /// No description provided for @noPendingSubjects.
  ///
  /// In en, this message translates to:
  /// **'No pending subjects'**
  String get noPendingSubjects;

  /// No description provided for @noGradedSubjects.
  ///
  /// In en, this message translates to:
  /// **'No graded subjects'**
  String get noGradedSubjects;

  /// No description provided for @noAssignedSubjects.
  ///
  /// In en, this message translates to:
  /// **'No assigned subjects'**
  String get noAssignedSubjects;

  /// No description provided for @gradeAction.
  ///
  /// In en, this message translates to:
  /// **'Grade'**
  String get gradeAction;

  /// No description provided for @viewAction.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get viewAction;

  /// No description provided for @registry.
  ///
  /// In en, this message translates to:
  /// **'Behavior log'**
  String get registry;

  /// No description provided for @pendingStage.
  ///
  /// In en, this message translates to:
  /// **'Pending {stage}'**
  String pendingStage(String stage);

  /// No description provided for @noGradedSubjectsToDownload.
  ///
  /// In en, this message translates to:
  /// **'No graded subjects to download.'**
  String get noGradedSubjectsToDownload;

  /// No description provided for @pdfSavedTo.
  ///
  /// In en, this message translates to:
  /// **'PDF saved to {path}'**
  String pdfSavedTo(String path);

  /// No description provided for @couldNotSavePdf.
  ///
  /// In en, this message translates to:
  /// **'Could not save PDF: {error}'**
  String couldNotSavePdf(String error);

  /// No description provided for @subjectGradeReport.
  ///
  /// In en, this message translates to:
  /// **'Subject grade report'**
  String get subjectGradeReport;

  /// No description provided for @downloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get downloadPdf;

  /// No description provided for @noStudentsInReport.
  ///
  /// In en, this message translates to:
  /// **'No students in this report'**
  String get noStudentsInReport;

  /// No description provided for @student.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get student;

  /// No description provided for @grade.
  ///
  /// In en, this message translates to:
  /// **'Grade'**
  String get grade;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @passed.
  ///
  /// In en, this message translates to:
  /// **'Passed'**
  String get passed;

  /// No description provided for @constimixGradeReport.
  ///
  /// In en, this message translates to:
  /// **'GRADE REPORT'**
  String get constimixGradeReport;

  /// No description provided for @pageOf.
  ///
  /// In en, this message translates to:
  /// **'Page {page} of {total}'**
  String pageOf(int page, int total);

  /// No description provided for @noGradedSubjectsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No graded subjects are available.'**
  String get noGradedSubjectsAvailable;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'es':
      {
        switch (locale.countryCode) {
          case 'MX':
            return AppLocalizationsEsMx();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
