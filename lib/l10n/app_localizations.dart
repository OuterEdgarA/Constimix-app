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
