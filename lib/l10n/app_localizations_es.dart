// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Constitución de 1917 Mixta';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get gradesTitle => 'Calificaciones';

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

  @override
  String get yourGradedSubjects => 'Your graded subjects';

  @override
  String get yourAssignedSubjects => 'Your assigned subjects';

  @override
  String get cycleSubjectAssignments => 'Cycle subject assignments';

  @override
  String get downloadGradedSubjectPdfs => 'Download graded subject PDFs';

  @override
  String get graded => 'Graded';

  @override
  String get pending => 'Pending';

  @override
  String get notGraded => 'Not graded';

  @override
  String get searchSubjects => 'Search subjects';

  @override
  String get subjects => 'Subjects';

  @override
  String get pendingSubjects => 'Pending subjects';

  @override
  String get noPendingSubjects => 'No pending subjects';

  @override
  String get noGradedSubjects => 'No graded subjects';

  @override
  String get noAssignedSubjects => 'No assigned subjects';

  @override
  String get gradeAction => 'Grade';

  @override
  String get viewAction => 'View';

  @override
  String get registry => 'Behavior log';

  @override
  String pendingStage(String stage) {
    return 'Pending $stage';
  }

  @override
  String get noGradedSubjectsToDownload => 'No graded subjects to download.';

  @override
  String pdfSavedTo(String path) {
    return 'PDF saved to $path';
  }

  @override
  String couldNotSavePdf(String error) {
    return 'Could not save PDF: $error';
  }

  @override
  String get subjectGradeReport => 'Subject grade report';

  @override
  String get downloadPdf => 'Download PDF';

  @override
  String get noStudentsInReport => 'No students in this report';

  @override
  String get student => 'Student';

  @override
  String get grade => 'Grade';

  @override
  String get status => 'Status';

  @override
  String get passed => 'Passed';

  @override
  String get constimixGradeReport => 'GRADE REPORT';

  @override
  String pageOf(int page, int total) {
    return 'Page $page of $total';
  }

  @override
  String get noGradedSubjectsAvailable => 'No graded subjects are available.';

  @override
  String get gradingTool => 'Grading tool';

  @override
  String get subjectData => 'Subject data';

  @override
  String get evaluationData => 'Evaluation data';

  @override
  String get grading => 'Grading';

  @override
  String get assignedTeacher => 'Assigned teacher';

  @override
  String get subjectName => 'Subject name';

  @override
  String get evaluationType => 'Evaluation type';

  @override
  String get finalEvaluation => 'Final evaluation';

  @override
  String get activitiesCount => 'Activities count';

  @override
  String get enterZeroOrPositive => 'Enter zero or a positive value.';

  @override
  String get customizeGradePercentage => 'Customize grade weighting';

  @override
  String get activitiesPercentage => 'Activities weighting';

  @override
  String get testPercentage => 'Test weighting';

  @override
  String get percentagesMustAddToTen => 'The weightings must add up to 10.';

  @override
  String currentTotal(String total) {
    return 'Current total: $total';
  }

  @override
  String get showTable => 'Show table';

  @override
  String get noStudentsInView => 'No students in this view';

  @override
  String get saveGrades => 'Save grades';

  @override
  String get downloadGradePdfTable => 'Download grade PDF table';

  @override
  String get ungradedStudents => 'Students without complete grades';

  @override
  String get oneStudentIncompleteGrade =>
      '1 student does not have a complete valid grade.';

  @override
  String studentsIncompleteGrades(int count) {
    return '$count students do not have complete valid grades.';
  }

  @override
  String get keepGrading => 'Keep grading';

  @override
  String get continueSaving => 'Continue saving';

  @override
  String get gradesSaved => 'Grades saved.';

  @override
  String get offlineGradesSaved => 'Offline draft saved and queued for upload.';

  @override
  String get gradePdfDisplayOnly => 'Grade PDF table export is display only.';

  @override
  String get absences => 'Absences';

  @override
  String get submittedActivities => 'Submitted activities';

  @override
  String maximumValue(String maximum) {
    return 'Maximum $maximum';
  }

  @override
  String get testGrade => 'Test grade';

  @override
  String get useValueZeroToTen => 'Use a value from 0 to 10.';

  @override
  String get finalGrade => 'Final grade';

  @override
  String get details => 'Details';

  @override
  String get gradeDetails => 'Grade details';

  @override
  String get activitiesNotConfiguredCalculation =>
      'Activities: no activities configured = 0.00';

  @override
  String activitiesCalculation(
      String submitted, String weight, String total, String result) {
    return 'Activities: $submitted × $weight / $total = $result';
  }

  @override
  String testCalculation(String test, String weight, String result) {
    return 'Test: $test × $weight / 10 = $result';
  }

  @override
  String finalGradeCalculation(
      String activities, String test, String finalGrade, String displayGrade) {
    return 'Final: $activities + $test = $finalGrade ($displayGrade)';
  }

  @override
  String get ok => 'OK';
}

/// The translations for Spanish Castilian, as used in Mexico (`es_MX`).
class AppLocalizationsEsMx extends AppLocalizationsEs {
  AppLocalizationsEsMx() : super('es_MX');

  @override
  String get appTitle => 'Constitución de 1917 Mixta';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get gradesTitle => 'Calificaciones';

  @override
  String get usernameOrCurp => 'Usuario o CURP';

  @override
  String get passwordOrRegistration => 'Contraseña o Matrícula';

  @override
  String get signIn => 'Iniciar Sesión';

  @override
  String get studentSignUp => 'Registro';

  @override
  String get invalidCredentials => 'Credenciales incorrectas.';

  @override
  String get navHome => 'Inicio';

  @override
  String get navBoard => 'Comunidad';

  @override
  String get navEnroll => 'Matrícula';

  @override
  String get navSchedule => 'Horario';

  @override
  String get navGrades => 'Calificaciones';

  @override
  String get navProfile => 'Perfil';

  @override
  String get navAdmin => 'Administrador';

  @override
  String get useLightMode => 'Usar modo claro';

  @override
  String get useDarkMode => 'Usar modo oscuro';

  @override
  String welcomeUser(String userName) {
    return 'Hola, $userName';
  }

  @override
  String get homeDashboardSubtitle => 'Panel principal ajustado a ti.';

  @override
  String get pendingOfflineSyncItems => 'Objetos para sincronizar';

  @override
  String accessLevel(int level) {
    return 'Nivel $level';
  }

  @override
  String get dynamicContent => 'Contenido dinámico';

  @override
  String get dynamicContentSubtitle =>
      'Módulos visibles según tu nivel de acceso.';

  @override
  String get featureCommunityBoard => 'Muro de la Comunidad';

  @override
  String get featureEnrollment => 'Matrícula';

  @override
  String get featureGradingTool => 'Evaluación';

  @override
  String get roleSystemAdmin => 'Administrador del sistema';

  @override
  String get roleSemesterAdmin => 'Administrador de semestres';

  @override
  String get roleTeacher => 'Docente';

  @override
  String get roleStudent => 'Estudiante';

  @override
  String clearanceLevel(int level) {
    return 'Nivel de acceso $level';
  }

  @override
  String get communityBoardTitle => 'Muro de la comunidad';

  @override
  String get communityPublishedUpdates => 'Publicaciones';

  @override
  String get communityPostsReviewed =>
      'Tus publicaciones se revisan antes de publicarse';

  @override
  String get communityPost => 'Publicar';

  @override
  String pendingReviewCount(int count) {
    return 'Pendientes de revisión ($count)';
  }

  @override
  String get noPublishedPosts => 'No hay publicaciones.';

  @override
  String get postEditor => 'Editor de publicaciones';

  @override
  String get editPost => 'Editar publicación';

  @override
  String get addFile => 'Agregar archivo';

  @override
  String get filePathOrImageUrl => 'Ruta del archivo o URL de la imagen';

  @override
  String get add => 'Agregar';

  @override
  String get videoAttachmentsUnsupported => 'No se admiten archivos de video.';

  @override
  String get header => 'Título';

  @override
  String get body => 'Contenido';

  @override
  String get link => 'Enlace';

  @override
  String get attachFile => 'Adjuntar archivo';

  @override
  String get requiredField => 'Obligatorio';

  @override
  String get linkOptional => 'Enlace (opcional)';

  @override
  String get removeAttachment => 'Eliminar archivo adjunto';

  @override
  String get publishPost => 'Publicar';

  @override
  String get submitForApproval => 'Enviar para revisión';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get submitChangesForApproval => 'Enviar cambios a revisión';

  @override
  String get pendingCommunityPosts => 'Publicaciones pendientes';

  @override
  String get noPostsAwaitingReview =>
      'No hay publicaciones pendientes de revisión.';

  @override
  String get reject => 'Rechazar';

  @override
  String get approve => 'Aprobar';

  @override
  String get downloadFile => 'Descargar archivo';

  @override
  String get closeImage => 'Cerrar imagen';

  @override
  String get imageUnavailable => 'Imagen no disponible';

  @override
  String get linkCopied => 'Enlace copiado.';

  @override
  String get downloadLinkCopied => 'Enlace de descarga copiado.';

  @override
  String get attachedFileUnavailable =>
      'El archivo adjunto ya no está disponible.';

  @override
  String savedTo(String path) {
    return 'Guardado en $path';
  }

  @override
  String get enrollmentSubtitle => 'Consulta la matrícula actual y anteriores.';

  @override
  String get selectEnrollmentTable => 'Selecciona la tabla';

  @override
  String get currentEnrollment => 'Actual';

  @override
  String get pastEnrollment => 'Anteriores';

  @override
  String get enrollmentCycle => 'Ciclo escolar';

  @override
  String get selectCycle => 'Selecciona un ciclo';

  @override
  String get semesterFilter => 'Filtro por semestre';

  @override
  String get groupFilter => 'Filtro por grupo';

  @override
  String get customSearch => 'Búsqueda';

  @override
  String get students => 'Estudiantes';

  @override
  String get closeSuggestions => 'Cerrar sugerencias';

  @override
  String get clearSearch => 'Limpiar búsqueda';

  @override
  String get searchStudents => 'Buscar estudiantes';

  @override
  String get noMatches => 'Sin coincidencias';

  @override
  String get openStudentData => 'Abrir datos del estudiante';

  @override
  String get noStudentsToShow => 'No hay estudiantes para mostrar';

  @override
  String get close => 'Cerrar';

  @override
  String registrationValue(String registration) {
    return 'Matrícula: $registration';
  }

  @override
  String curpValue(String curp) {
    return 'CURP: $curp';
  }

  @override
  String semesterGroupValue(int semester, String group) {
    return 'Semestre $semester | Grupo $group';
  }

  @override
  String emailValue(String email) {
    return 'Correo: $email';
  }

  @override
  String get studentEnrollment => 'Inscripción del estudiante';

  @override
  String get editStudentEnrollment => 'Editar registro del estudiante';

  @override
  String get reviewSevenStepsBeforeSaving =>
      'Revisa tus datos antes de guardarlos.';

  @override
  String get completeSixStepsToCreateLevel4 =>
      'Completa los seis pasos para inscribirte.';

  @override
  String get schoolData => 'Datos escolares';

  @override
  String get studentData => 'Datos del estudiante';

  @override
  String get studentContact => 'Datos de contacto';

  @override
  String get tutorData => 'Datos del tutor';

  @override
  String get tutorContact => 'Datos de contacto del tutor';

  @override
  String get additionalInfo => 'Información adicional';

  @override
  String get transferredSubjects => 'Equivalencia de materias';

  @override
  String get next => 'Siguiente';

  @override
  String get back => 'Atrás';

  @override
  String get disableUser => 'Desactivar usuario';

  @override
  String get enableUser => 'Activar usuario';

  @override
  String get studentAccountEnabled => 'Cuenta del estudiante activada.';

  @override
  String get studentAccountDisabled => 'Cuenta del estudiante desactivada.';

  @override
  String get completeRequiredFieldsBeforeSaving =>
      'Llena todos los campos obligatorios antes de guardar.';

  @override
  String studentSavedWithRegistration(String registration) {
    return 'Estudiante guardado, matrícula: $registration.';
  }

  @override
  String get registration => 'Matrícula';

  @override
  String get semester => 'Semestre';

  @override
  String get group => 'Grupo';

  @override
  String get groupAssignedFromArea => 'El grupo depende del área seleccionada.';

  @override
  String get area => 'Área';

  @override
  String get chooseAreaToAssignGroup => 'Selecciona un área.';

  @override
  String get areaPhysics => 'Físico-Matemáticas';

  @override
  String get areaBiological => 'Químico-Biológicas';

  @override
  String get areaEconomics => 'Económico-Administrativas';

  @override
  String get areaHumanities => 'Humanidades y ciencias sociales';

  @override
  String get medicalProvider => 'Servicio médico';

  @override
  String get medicalProviderPrivate => 'Particular';

  @override
  String get medicalProviderMarineMilitary => 'Marina/Militar';

  @override
  String get selectEquipmentAccess =>
      'Selecciona los dispositivos a los que tienes acceso';

  @override
  String get equipmentCellphone => 'Teléfono celular';

  @override
  String get equipmentTablet => 'Tableta';

  @override
  String get equipmentComputer => 'Computadora/Laptop';

  @override
  String get equipmentInternet => 'Internet';

  @override
  String get equipmentNone => 'Ninguno';

  @override
  String get studentFatherSurname => 'Apellido paterno';

  @override
  String get studentMotherSurname => 'Apellido materno';

  @override
  String get studentName => 'Nombre(s)';

  @override
  String get studentCurp => 'CURP';

  @override
  String get sex => 'Sexo';

  @override
  String get sexMale => 'Masculino';

  @override
  String get sexFemale => 'Femenino';

  @override
  String get bloodType => 'Tipo de sangre';

  @override
  String get placeOfBirth => 'Lugar de nacimiento';

  @override
  String get curpMustBe18Characters => 'La CURP debe tener 18 caracteres';

  @override
  String get openMapSelector => 'Abrir mapa';

  @override
  String get email => 'Correo electrónico';

  @override
  String get schoolEmail => 'Correo institucional';

  @override
  String get cellphoneNumber => 'Número de celular';

  @override
  String get privateDomicile => 'Domicilio';

  @override
  String get enterValidEmail => 'Ingresa un correo electrónico válido';

  @override
  String get relationToStudent => 'Parentesco';

  @override
  String get relationMother => 'Madre';

  @override
  String get relationFather => 'Padre';

  @override
  String get relationCousin => 'Primo o prima';

  @override
  String get relationAuntUncle => 'Tío o tía';

  @override
  String get relationCloseFriend => 'Amistad cercana';

  @override
  String get relationMyself => 'Yo';

  @override
  String get tutorFatherSurname => 'Apellido paterno del tutor';

  @override
  String get tutorMotherSurname => 'Apellido materno del tutor';

  @override
  String get tutorName => 'Nombre(s) del tutor';

  @override
  String get tutorCurp => 'CURP del tutor';

  @override
  String get occupation => 'Ocupación';

  @override
  String get tutorCellphoneNumber => 'Número de celular del tutor';

  @override
  String get tutorEmail => 'Correo electrónico del tutor';

  @override
  String get sameDomicileAsStudent => 'Mismo domicilio que el estudiante';

  @override
  String get tutorPrivateDomicile => 'Domicilio del tutor';

  @override
  String get lastAcademicLevel => 'Último grado académico';

  @override
  String get academicPrimary => 'Primaria';

  @override
  String get academicSecondary => 'Secundaria';

  @override
  String get academicHighSchool => 'Bachillerato';

  @override
  String get academicBachelor => 'Licenciatura';

  @override
  String get academicMaster => 'Maestría';

  @override
  String get academicDoctorate => 'Doctorado';

  @override
  String get civilStatus => 'Estado civil';

  @override
  String get civilSingle => 'Soltero(a)';

  @override
  String get civilMarried => 'Casado(a)';

  @override
  String get civilWidowed => 'Viudo(a)';

  @override
  String get civilFreeUnion => 'Unión libre';

  @override
  String get ableToReadAndWrite => 'Sabe leer y escribir';

  @override
  String get l4AccountCredentials => 'Credenciales de la cuenta';

  @override
  String get acknowledgeL4Credentials =>
      'Confirmo que he recibido estas credenciales';

  @override
  String get l4CredentialsExplanation =>
      'La CURP es usuario y matrícula es contraseña.';

  @override
  String copyField(String field) {
    return 'Copiar $field';
  }

  @override
  String fieldCopied(String field) {
    return 'Se copió $field.';
  }

  @override
  String get openStreetMapSelector => 'Selector de OpenStreetMap';

  @override
  String get searchLocation => 'Buscar ubicación';

  @override
  String get search => 'Buscar';

  @override
  String get centerOnXalapa => 'Centrar en Xalapa';

  @override
  String get useThisLocation => 'Usar esta ubicación';

  @override
  String get noMatchingLocationFound =>
      'No se encontró una ubicación coincidente.';

  @override
  String get locationServiceUnavailable =>
      'El servicio de ubicación no está disponible.';

  @override
  String get addressCouldNotBeResolved => 'No se pudo obtener la dirección.';

  @override
  String get locationSearchFailed =>
      'No se pudo completar la búsqueda de ubicación.';

  @override
  String selectedPointCoordinates(String latitude, String longitude) {
    return 'Punto seleccionado $latitude, $longitude';
  }

  @override
  String get subjectsPassedAtAnotherInstitution =>
      'Materias aprobadas en otra institución';

  @override
  String get transferredSubjectsGradeExplanation =>
      'Las materias seleccionadas recibirán una calificación final de 10 y podrán editarse posteriormente.';

  @override
  String get noSubjectsAvailableForSemester =>
      'No hay materias disponibles para este semestre.';

  @override
  String semesterValue(int semester) {
    return 'Semestre $semester';
  }

  @override
  String studentSemesterSchedule(int semester) {
    return 'Horario del semestre $semester';
  }

  @override
  String get academicActivitiesBySemester =>
      'Actividades académicas por semestre';

  @override
  String get overrideDateAndTime => 'Cambiar fecha y hora';

  @override
  String get useCurrentCst => 'Usar hora actual (CST)';

  @override
  String get currentActiveCycle => 'Ciclo escolar activo';

  @override
  String get noActiveCycle => 'No hay un ciclo escolar activo';

  @override
  String get currentDateCst => 'Fecha actual (CST)';

  @override
  String get currentHourCst => 'Hora actual (CST)';

  @override
  String get timeline => 'Horario';

  @override
  String get calendar => 'Calendario';

  @override
  String get all => 'Todos';

  @override
  String get noActivitiesToday => 'No hay actividades para hoy.';

  @override
  String get recess => 'Receso';

  @override
  String get noActiveGroups => 'No hay grupos activos';

  @override
  String groupNoClassAssigned(String group) {
    return 'Grupo $group: Sin clase asignada';
  }

  @override
  String groupSubjectTeacher(String group, String subject, String teacher) {
    return 'Grupo $group: $subject - $teacher';
  }

  @override
  String semesterActivity(int semester) {
    return 'Semestre $semester - 1 actividad';
  }

  @override
  String semesterActivities(int semester, int count) {
    return 'Semestre $semester - $count actividades';
  }

  @override
  String get overrideScheduleClock => 'Cambiar fecha y hora del horario';

  @override
  String get date => 'Fecha';

  @override
  String get hour => 'Hora';

  @override
  String get apply => 'Aplicar';

  @override
  String get noActivitiesForDate => 'No hay actividades para esta fecha.';

  @override
  String get currentPeriod => 'Periodo vigente';

  @override
  String get testApplication => 'Aplicación de exámenes';

  @override
  String get schoolDay => 'Día de clases';

  @override
  String get noAcademicActivities => 'Sin actividades académicas';

  @override
  String get tests => 'Exámenes';

  @override
  String get overlap => 'Clases y exámenes';

  @override
  String scheduleSemesterGroup(int semester, String group) {
    return 'Semestre $semester$group';
  }

  @override
  String get yourGradedSubjects => 'Tus materias calificadas';

  @override
  String get yourAssignedSubjects => 'Tus materias asignadas';

  @override
  String get cycleSubjectAssignments => 'Materias asignadas del ciclo escolar';

  @override
  String get downloadGradedSubjectPdfs => 'Descargar actas de calificaciones';

  @override
  String get graded => 'Calificadas';

  @override
  String get pending => 'Pendientes';

  @override
  String get notGraded => 'Sin calificar';

  @override
  String get searchSubjects => 'Buscar materias';

  @override
  String get subjects => 'Materias';

  @override
  String get pendingSubjects => 'Materias pendientes';

  @override
  String get noPendingSubjects => 'No hay materias pendientes';

  @override
  String get noGradedSubjects => 'No hay materias calificadas';

  @override
  String get noAssignedSubjects => 'No hay materias asignadas';

  @override
  String get gradeAction => 'Calificar';

  @override
  String get viewAction => 'Ver';

  @override
  String get registry => 'Bitácora';

  @override
  String pendingStage(String stage) {
    return 'Pendiente $stage';
  }

  @override
  String get noGradedSubjectsToDownload =>
      'No hay materias calificadas para descargar.';

  @override
  String pdfSavedTo(String path) {
    return 'PDF guardado en $path';
  }

  @override
  String couldNotSavePdf(String error) {
    return 'No se pudo guardar el PDF: $error';
  }

  @override
  String get subjectGradeReport => 'Reporte de calificaciones de la materia';

  @override
  String get downloadPdf => 'Descargar PDF';

  @override
  String get noStudentsInReport => 'No hay estudiantes en este reporte';

  @override
  String get student => 'Estudiante';

  @override
  String get grade => 'Calificación';

  @override
  String get status => 'Estado';

  @override
  String get passed => 'Aprobado';

  @override
  String get constimixGradeReport => 'REPORTE DE CALIFICACIONES';

  @override
  String pageOf(int page, int total) {
    return 'Página $page de $total';
  }

  @override
  String get noGradedSubjectsAvailable =>
      'No hay materias calificadas disponibles.';

  @override
  String get gradingTool => 'Herramienta de evaluación';

  @override
  String get subjectData => 'Datos de la materia';

  @override
  String get evaluationData => 'Datos de evaluación';

  @override
  String get grading => 'Calificación';

  @override
  String get assignedTeacher => 'Docente';

  @override
  String get subjectName => 'Materia';

  @override
  String get evaluationType => 'Tipo de evaluación';

  @override
  String get finalEvaluation => 'Evaluación final';

  @override
  String get activitiesCount => 'Número de actividades';

  @override
  String get enterZeroOrPositive => 'Ingresa cero o un valor positivo.';

  @override
  String get customizeGradePercentage => 'Personalizar evaluación';

  @override
  String get activitiesPercentage => 'Valor de actividades';

  @override
  String get testPercentage => 'Valor del examen';

  @override
  String get percentagesMustAddToTen => 'Las valuaciones deben sumar 10.';

  @override
  String currentTotal(String total) {
    return 'Total actual: $total';
  }

  @override
  String get showTable => 'Mostrar tabla';

  @override
  String get noStudentsInView => 'No hay estudiantes';

  @override
  String get saveGrades => 'Guardar calificaciones';

  @override
  String get downloadGradePdfTable =>
      'Descargar tabla de calificaciones en PDF';

  @override
  String get ungradedStudents => 'Estudiantes con calificación incompleta';

  @override
  String get oneStudentIncompleteGrade =>
      '1 estudiante no tiene una calificación válida completa.';

  @override
  String studentsIncompleteGrades(int count) {
    return '$count estudiantes no tienen una calificación válida completa.';
  }

  @override
  String get keepGrading => 'Seguir calificando';

  @override
  String get continueSaving => 'Continuar y guardar';

  @override
  String get gradesSaved => 'Calificaciones guardadas.';

  @override
  String get offlineGradesSaved =>
      'El borrador sin conexión se guardó y quedó pendiente de sincronización.';

  @override
  String get gradePdfDisplayOnly =>
      'La exportación de la tabla de calificaciones en PDF es solo demostrativa.';

  @override
  String get absences => 'Faltas';

  @override
  String get submittedActivities => 'Actividades entregadas';

  @override
  String maximumValue(String maximum) {
    return 'Máximo $maximum';
  }

  @override
  String get testGrade => 'Calificación del examen';

  @override
  String get useValueZeroToTen => 'Usa un valor de 0 a 10.';

  @override
  String get finalGrade => 'Calificación final';

  @override
  String get details => 'Detalles';

  @override
  String get gradeDetails => 'Detalle de la calificación';

  @override
  String get activitiesNotConfiguredCalculation =>
      'Actividades: no hay actividades configuradas = 0.00';

  @override
  String activitiesCalculation(
      String submitted, String weight, String total, String result) {
    return 'Actividades: $submitted × $weight / $total = $result';
  }

  @override
  String testCalculation(String test, String weight, String result) {
    return 'Examen: $test × $weight / 10 = $result';
  }

  @override
  String finalGradeCalculation(
      String activities, String test, String finalGrade, String displayGrade) {
    return 'Final: $activities + $test = $finalGrade ($displayGrade)';
  }

  @override
  String get ok => 'Aceptar';
}
