import 'package:flutter_map/flutter_map.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';

import '../../core/data/mock_repository.dart';
import '../../core/models/cycle_subject_assignment.dart';
import '../../core/models/student_enrollment.dart';
import '../../l10n/app_localizations.dart';
import '../../core/services/address_suggestion_service.dart';
import '../../core/services/phone_code_service.dart';
import '../../shared/widgets/section_header.dart';

class EnrollmentWizardScreen extends StatefulWidget {
  const EnrollmentWizardScreen({
    super.key,
    this.standalone = false,
    this.initialEnrollment,
    this.onSaved,
    this.canManageActivation = false,
  });

  final bool standalone;
  final StudentEnrollment? initialEnrollment;
  final VoidCallback? onSaved;
  final bool canManageActivation;

  @override
  State<EnrollmentWizardScreen> createState() => _EnrollmentWizardScreenState();
}

class _EnrollmentWizardScreenState extends State<EnrollmentWizardScreen> {
  static const _medicalProviders = [
    'IMSS',
    'ISSTE',
    'Seguro Popular',
    'INSABI',
    'Private',
    'PEMEX',
    'Marine/Military'
  ];
  static const _genres = ['Male', 'Female'];
  static const _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  static const _tutorRelations = [
    'Mother',
    'Father',
    'Cousin',
    'Aunt/Uncle',
    'Close friend',
    'Myself'
  ];
  static const _academicLevels = [
    'Primaria',
    'Secundaria',
    'Bachillerato',
    'Licenciatura',
    'Maestria',
    'Doctorado'
  ];
  static const _civilStatuses = ['Single', 'Married', 'Widowed', 'Free Union'];
  static const _areas = [
    'Physics',
    'Biological',
    'Economics',
    'Humanities',
  ];

  final _formKey = GlobalKey<FormState>();
  late final String _registration;
  final _addressSuggestionService = AddressSuggestionService();
  final _phoneCodeService = PhoneCodeService();
  final _nssController = TextEditingController();
  final _studentFatherSurnameController = TextEditingController();
  final _studentMotherSurnameController = TextEditingController();
  final _studentNameController = TextEditingController();
  final _studentCurpController = TextEditingController();
  final _placeOfBirthController = TextEditingController();
  final _studentEmailController = TextEditingController();
  final _schoolEmailController = TextEditingController();
  final _studentCellphoneController = TextEditingController();
  final _studentDomicileController = TextEditingController();
  final _tutorFatherSurnameController = TextEditingController();
  final _tutorMotherSurnameController = TextEditingController();
  final _tutorNameController = TextEditingController();
  final _tutorCurpController = TextEditingController();
  final _tutorOccupationController = TextEditingController();
  final _tutorCellphoneController = TextEditingController();
  final _tutorEmailController = TextEditingController();
  final _tutorDomicileController = TextEditingController();

  int _currentStep = 0;
  int _semester = 1;
  String _group = 'A';
  String? _area;
  String? _medicalProvider;
  String? _genre;
  String? _bloodType;
  String _studentLada = '+52';
  String _tutorLada = '+52';
  String? _tutorRelation;
  String? _lastAcademicLevel;
  String? _civilStatus;
  bool _sameTutorAddress = false;
  bool _hasCellphone = false;
  bool _hasTablet = false;
  bool _hasComputer = false;
  bool _hasInternet = false;
  bool _hasNoEquipment = false;
  bool _canReadAndWrite = false;
  bool _credentialsAcknowledged = false;
  bool _isActive = true;
  final Set<String> _transferredSubjectIds = {};

  bool get _isTutorMyself => _tutorRelation == 'Myself';
  bool get _isAdvancedSemester => _semester >= 5;
  bool get _canManageTransferredSubjects =>
      widget.initialEnrollment != null && widget.canManageActivation;
  int get _lastStepIndex => _canManageTransferredSubjects ? 6 : 5;
  bool get _isLastStep => _currentStep == _lastStepIndex;
  List<CycleSubjectAssignment> get _transferableSubjects =>
      MockRepository.transferableSubjectsForStudent(
        widget.initialEnrollment!.copyWith(semester: _semester, group: _group),
      );

  @override
  void initState() {
    super.initState();
    _registration = widget.initialEnrollment?.registration ??
        MockRepository.previewNextRegistration();
    _loadInitialEnrollment();
    _studentFatherSurnameController.addListener(_syncTutorFromStudent);
    _studentMotherSurnameController.addListener(_syncTutorFromStudent);
    _studentNameController.addListener(_syncTutorFromStudent);
    _studentCurpController.addListener(_syncTutorFromStudent);
    _studentCellphoneController.addListener(_syncTutorFromStudent);
    _studentEmailController.addListener(_syncTutorFromStudent);
    _studentDomicileController.addListener(_syncTutorFromStudent);
  }

  @override
  void dispose() {
    for (final controller in [
      _nssController,
      _studentFatherSurnameController,
      _studentMotherSurnameController,
      _studentNameController,
      _studentCurpController,
      _placeOfBirthController,
      _studentEmailController,
      _schoolEmailController,
      _studentCellphoneController,
      _studentDomicileController,
      _tutorFatherSurnameController,
      _tutorMotherSurnameController,
      _tutorNameController,
      _tutorCurpController,
      _tutorOccupationController,
      _tutorCellphoneController,
      _tutorEmailController,
      _tutorDomicileController,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final content = Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionHeader(
              title: widget.initialEnrollment == null
                  ? l10n.studentEnrollment
                  : l10n.editStudentEnrollment,
              subtitle: _canManageTransferredSubjects
                  ? l10n.reviewSevenStepsBeforeSaving
                  : l10n.completeSixStepsToCreateLevel4),
          const SizedBox(height: 16),
          Stepper(
            currentStep: _currentStep,
            onStepTapped: (step) => setState(() => _currentStep = step),
            controlsBuilder: _buildControls,
            steps: [
              Step(
                  title: Text(l10n.schoolData),
                  isActive: _currentStep == 0,
                  content: _schoolDataStep()),
              Step(
                  title: Text(l10n.studentData),
                  isActive: _currentStep == 1,
                  content: _studentDataStep()),
              Step(
                  title: Text(l10n.studentContact),
                  isActive: _currentStep == 2,
                  content: _studentContactStep()),
              Step(
                  title: Text(l10n.tutorData),
                  isActive: _currentStep == 3,
                  content: _tutorDataStep()),
              Step(
                  title: Text(l10n.tutorContact),
                  isActive: _currentStep == 4,
                  content: _tutorContactStep()),
              Step(
                  title: Text(l10n.additionalInfo),
                  isActive: _currentStep == 5,
                  content: _additionalInfoStep()),
              if (_canManageTransferredSubjects)
                Step(
                  title: Text(l10n.transferredSubjects),
                  isActive: _currentStep == 6,
                  content: _transferredSubjectsStep(),
                ),
            ],
          ),
        ],
      ),
    );
    if (!widget.standalone) return content;
    return Scaffold(
        appBar: AppBar(
            title: Text(
              widget.initialEnrollment == null
                ? l10n.studentSignUp
                : l10n.studentData,
            ),
        ),
        body: SafeArea(child: content),
    );
  }

  Widget _buildControls(BuildContext context, ControlsDetails details) {
    final l10n = AppLocalizations.of(context)!;
  
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          FilledButton.icon(
            onPressed: _isLastStep
                ? (_credentialsAcknowledged ? _saveEnrollment : null)
                : _nextStep,
            icon: Icon(
              _isLastStep ? Icons.save_outlined : Icons.arrow_forward,
            ),
            label: Text(
              _isLastStep ? l10n.save : l10n.next,
            ),
          ),
          TextButton(
            onPressed: _currentStep == 0 ? null : _previousStep,
            child: Text(l10n.back),
          ),
          if (widget.canManageActivation &&
              widget.initialEnrollment != null)
            OutlinedButton.icon(
              onPressed: _toggleStudentActivation,
              icon: Icon(
                _isActive
                    ? Icons.person_off_outlined
                    : Icons.person_add_alt,
              ),
              label: Text(
                _isActive
                    ? l10n.disableUser
                    : l10n.enableUser,
              ),
            ),
        ],
      ),
    );
  }

  Widget _schoolDataStep() {
    final l10n = AppLocalizations.of(context)!;
    final groupOptions = _groupOptionsForSemester();
    if (!groupOptions.contains(_group)) _group = groupOptions.first;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _ReadOnlyField(
        label: l10n.registration,
        value: _registration,
      ),
      const SizedBox(height: 12),
      DropdownButtonFormField<int>(
        key: ValueKey('semester-$_semester'),
        initialValue: _semester,
        decoration: InputDecoration(
          labelText: l10n.semester,
        ),
        items: [
          for (var semester = 1; semester <= 6; semester++)
            DropdownMenuItem(value: semester, child: Text('$semester'))
        ],
        onChanged: (value) {
          if (value == null) return;
          setState(() {
            final wasAdvanced = _isAdvancedSemester;
            if (_semester != value) _transferredSubjectIds.clear();
            _semester = value;
            if (_isAdvancedSemester) {
              if (!wasAdvanced) _area = null;
              if (_area != null) _group = _groupForArea(_area!);
            } else {
              _area = null;
              final groups = _groupOptionsForSemester();
              _group = groups.contains(_group) ? _group : groups.first;
            }
          });
        },
        validator: _requiredDropdown,
      ),
      const SizedBox(height: 12),
      DropdownButtonFormField<String>(
        key: ValueKey(
          'group-$_semester-$_group-${groupOptions.join()}-${_area ?? 'none'}',
        ),
        initialValue: _isAdvancedSemester && _area == null ? null : _group,
        decoration: InputDecoration(
          labelText: l10n.group,
          helperText: _isAdvancedSemester
              ? l10n.groupAssignedFromArea
              : null,
        ),
        items: [
          for (final group in groupOptions)
            DropdownMenuItem(value: group, child: Text(group))
        ],
        onChanged: _isAdvancedSemester
            ? null
            : (value) {
                if (value == null) return;
                setState(() => _group = value);
              },
        validator: _requiredDropdown,
      ),
      if (_isAdvancedSemester) ...[
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          key: ValueKey('area-$_semester-${_area ?? 'none'}'),
          initialValue: _area,
          decoration: InputDecoration(
            labelText: l10n.area,
            helperText: l10n.chooseAreaToAssignGroup,
          ),
          items: [
            for (final area in _areas)
              DropdownMenuItem(
                value: area,
                child: Text(_areaLabel(l10n, area)),
            ),
          ],
          onChanged: (value) {
            if (value == null) return;
            setState(() {
              _area = value;
              _group = _groupForArea(value);
            });
          },
          validator: _requiredDropdown,
        ),
      ],
      const SizedBox(height: 12),
      DropdownButtonFormField<String>(
        initialValue: _medicalProvider,
        decoration: InputDecoration(
          labelText: l10n.medicalProvider,
        ),
        items: [
          for (final provider in _medicalProviders)
            DropdownMenuItem(
              value: provider,
              child: Text(
                _medicalProviderLabel(l10n, provider),
              ),
            )
        ],
        onChanged: (value) => setState(() => _medicalProvider = value),
        validator: _requiredDropdown,
      ),
      const SizedBox(height: 12),
      TextFormField(
          controller: _nssController,
          decoration: const InputDecoration(
              labelText: 'NSS',
              prefixIcon: Icon(Icons.medical_information_outlined)),
          validator: _requiredText),
      const SizedBox(height: 16),
      Text(
          l10n.selectEquipmentAccess,
          style: Theme.of(context).textTheme.titleSmall,
      ),
      const SizedBox(height: 8),
      _EquipmentPicker(
          hasCellphone: _hasCellphone,
          hasTablet: _hasTablet,
          hasComputer: _hasComputer,
          hasInternet: _hasInternet,
          hasNoEquipment: _hasNoEquipment,
          onChanged: _updateEquipment),
    ]);
  }

  Widget _studentDataStep() {
    final l10n = AppLocalizations.of(context)!;
    return Column(children: [
      TextFormField(
          controller: _studentFatherSurnameController,
          decoration: InputDecoration(
            labelText: l10n.studentFatherSurname,
          ),
          textInputAction: TextInputAction.next,
          validator: _requiredText,
      ),
      const SizedBox(height: 12),
      TextFormField(
          controller: _studentMotherSurnameController,
          decoration: InputDecoration(
            labelText: l10n.studentMotherSurname,
          ),
          textInputAction: TextInputAction.next,
          validator: _requiredText),
      const SizedBox(height: 12),
      TextFormField(
          controller: _studentNameController,
          decoration: InputDecoration(
            labelText: l10n.studentName,
          ),
          textInputAction: TextInputAction.next,
          validator: _requiredText),
      const SizedBox(height: 12),
      TextFormField(
          controller: _studentCurpController,
          decoration: InputDecoration(
            labelText: l10n.studentCurp,
            ),
          inputFormatters: [UpperCaseTextFormatter()],
          textCapitalization: TextCapitalization.characters,
          validator: _curpValidator,
      ),
      const SizedBox(height: 12),
      DropdownButtonFormField<String>(
          initialValue: _genre,
          decoration: InputDecoration(
            labelText: l10n.sex,
          ),
          items: [
            for (final genre in _genres)
              DropdownMenuItem(
                value: genre,
                child: Text(_sexLabel(l10n, genre)),
              ),
          ],
          onChanged: (value) => setState(() => _genre = value),
          validator: _requiredDropdown,
      ),
      const SizedBox(height: 12),
      DropdownButtonFormField<String>(
          initialValue: _bloodType,
          decoration: InputDecoration(
            labelText: l10n.bloodType,
          ),
          items: [
            for (final bloodType in _bloodTypes)
              DropdownMenuItem(value: bloodType, child: Text(bloodType))
          ],
          onChanged: (value) => setState(() => _bloodType = value),
          validator: _requiredDropdown),
      const SizedBox(height: 12),
      _AutocompleteTextField(
          controller: _placeOfBirthController,
          label: l10n.placeOfBirth,
          addressSuggestionService: _addressSuggestionService,
          validator: _requiredText,
      ),
    ]);
  }

  Widget _studentContactStep() {
    final l10n = AppLocalizations.of(context)!;
    return Column(children: [
      TextFormField(
          controller: _studentEmailController,
          decoration: InputDecoration(
            labelText: l10n.email,
            ),
          keyboardType: TextInputType.emailAddress,
          validator: _emailValidator),
      const SizedBox(height: 12),
      TextFormField(
          controller: _schoolEmailController,
          decoration: InputDecoration(
            labelText: l10n.schoolEmail,
            ),
          keyboardType: TextInputType.emailAddress),
      const SizedBox(height: 12),
      _PhoneField(
          lada: _studentLada,
          controller: _studentCellphoneController,
          label: l10n.cellphoneNumber,
          phoneCodes: _phoneCodeService.codes,
          onLadaChanged: (value) => setState(() {
                _studentLada = value;
                _syncTutorFromStudent();
              }),
          validator: _requiredText),
      const SizedBox(height: 12),
      _AutocompleteTextField(
          controller: _studentDomicileController,
          label: l10n.privateDomicile,
          addressSuggestionService: _addressSuggestionService,
          validator: _requiredText),
    ]);
  }

  Widget _tutorDataStep() {
    final l10n = AppLocalizations.of(context)!;
    return Column(children: [
      DropdownButtonFormField<String>(
        key: ValueKey('relation-$_tutorRelation'),
        initialValue: _tutorRelation,
        decoration: InputDecoration(labelText: l10n.relationToStudent,
        ),
        items: [
          for (final relation in _tutorRelations)
            DropdownMenuItem(
              value: relation,
              child: Text(
                _tutorRelationLabel(l10n, relation),
              ),
            )
        ],
        onChanged: (value) {
          final wasTutorMyself = _isTutorMyself;
          setState(() {
            _tutorRelation = value;
            if (_isTutorMyself) {
              _sameTutorAddress = true;
              _syncTutorFromStudent();
            } else if (wasTutorMyself) {
              _clearCopiedTutorFields();
            }
          });
        },
        validator: _requiredDropdown,
      ),
      const SizedBox(height: 12),
      TextFormField(
          controller: _tutorFatherSurnameController,
          enabled: !_isTutorMyself,
          decoration: InputDecoration(
            labelText: l10n.tutorFatherSurname,
          ),
          validator: _requiredText),
      const SizedBox(height: 12),
      TextFormField(
          controller: _tutorMotherSurnameController,
          enabled: !_isTutorMyself,
          decoration: InputDecoration(
            labelText: l10n.tutorMotherSurname,
          ),
          validator: _requiredText),
      const SizedBox(height: 12),
      TextFormField(
          controller: _tutorNameController,
          enabled: !_isTutorMyself,
          decoration: InputDecoration(
            labelText: l10n.tutorName,
          ),
          validator: _requiredText),
      const SizedBox(height: 12),
      TextFormField(
          controller: _tutorCurpController,
          enabled: !_isTutorMyself,
          decoration: InputDecoration(
            labelText: l10n.tutorCurp,
          ),
          inputFormatters: [UpperCaseTextFormatter()],
          textCapitalization: TextCapitalization.characters,
          validator: _curpValidator),
      const SizedBox(height: 12),
      TextFormField(
          controller: _tutorOccupationController,
          decoration: InputDecoration(
            labelText: l10n.occupation,
          ),
          validator: _requiredText),
    ]);
  }

  Widget _tutorContactStep() {
    final l10n = AppLocalizations.of(context)!;
    final domicileLocked = _isTutorMyself || _sameTutorAddress;
    return Column(children: [
      _PhoneField(
          lada: _tutorLada,
          controller: _tutorCellphoneController,
          enabled: !_isTutorMyself,
          label: l10n.tutorCellphoneNumber,
          phoneCodes: _phoneCodeService.codes,
          onLadaChanged: (value) => 
          setState(() => _tutorLada = value),
          validator: _requiredText,
          ),
      const SizedBox(height: 12),
      TextFormField(
          controller: _tutorEmailController,
          enabled: !_isTutorMyself,
          decoration: InputDecoration(labelText: l10n.tutorEmail),
          keyboardType: TextInputType.emailAddress,
          validator: _emailValidator),
      if (!_isTutorMyself) ...[
        const SizedBox(height: 8),
        CheckboxListTile(
          value: _sameTutorAddress,
          onChanged: (value) {
            setState(() {
              _sameTutorAddress = value ?? false;
              if (_sameTutorAddress) {
                _tutorDomicileController.text = 
                  _studentDomicileController.text;
              }
            });
          },
          title: Text(l10n.sameDomicileAsStudent),
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ],
      const SizedBox(height: 12),
      _AutocompleteTextField(
          controller: _tutorDomicileController,
          enabled: !domicileLocked,
          label: l10n.tutorPrivateDomicile,
          addressSuggestionService: _addressSuggestionService,
          validator: _requiredText),
    ]);
  }

  Widget _additionalInfoStep() {
    final l10n = AppLocalizations.of(context)!;
    return Column(children: [
      DropdownButtonFormField<String>(
          initialValue: _lastAcademicLevel,
          decoration: InputDecoration(
            labelText: l10n.lastAcademicLevel,
          ),
          items: [
            for (final level in _academicLevels)
              DropdownMenuItem(
                value: level, 
                child: Text(
                  _academicLevelLabel(l10n, level),
                ),
              ),
          ],
          onChanged: (value) => 
            setState(() => _lastAcademicLevel = value),
          validator: _requiredDropdown,
      ),
      const SizedBox(height: 12),
      DropdownButtonFormField<String>(
          initialValue: _civilStatus,
          decoration: InputDecoration(
            labelText: l10n.civilStatus,
          ),
          items: [
            for (final status in _civilStatuses)
              DropdownMenuItem(
                value: status,
                 child: Text(
                  _civilStatusLabel(l10n, status),
                  ),
              ),
          ],
          onChanged: (value) => 
            setState(() => _civilStatus = value),
          validator: _requiredDropdown
          ),
      const SizedBox(height: 8),
      CheckboxListTile(
          value: _canReadAndWrite,
          onChanged: (value) =>
              setState(() => _canReadAndWrite = value ?? false),
          title: Text(l10n.ableToReadAndWrite),
          controlAffinity: ListTileControlAffinity.leading
          ),
      const Divider(height: 28),
      Text(
        l10n.l4AccountCredentials,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: 12),
      _CredentialField(
        label: 'CURP',
        value: _studentCurpController.text.trim().toUpperCase(),
        onCopy: () => _copyCredential(
          'CURP',
          _studentCurpController.text.trim().toUpperCase(),
        ),
      ),
      const SizedBox(height: 12),
      _CredentialField(
        label: l10n.registration,
        value: _registration,
        onCopy: () => _copyCredential(
          l10n.registration,
          _registration,
        ),
      ),
      const SizedBox(height: 8),
      CheckboxListTile(
        value: _credentialsAcknowledged,
        onChanged: (value) => setState(
          () => _credentialsAcknowledged = value ?? false,
        ),
        title: Text(
          l10n.acknowledgeL4Credentials,
        ),
        subtitle: Text(
          l10n.l4CredentialsExplanation,
        ),
        controlAffinity: ListTileControlAffinity.leading,
      ),
    ]);
  }

  Widget _transferredSubjectsStep() {
    final subjects = _transferableSubjects;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Subjects passed at another institution',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 6),
        const Text(
          'Selected subjects receive a final grade of 10 and remain editable in the grading tool.',
        ),
        const SizedBox(height: 12),
        if (subjects.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Text('No subjects are available for this semester.'),
          )
        else
          for (final subject in subjects)
            CheckboxListTile(
              value: _transferredSubjectIds.contains(subject.subjectId),
              title: Text(subject.subjectName),
              subtitle: Text('Semester ${subject.semester}'),
              controlAffinity: ListTileControlAffinity.trailing,
              onChanged: (selected) => setState(() {
                if (selected ?? false) {
                  _transferredSubjectIds.add(subject.subjectId);
                } else {
                  _transferredSubjectIds.remove(subject.subjectId);
                }
              }),
            ),
      ],
    );
  }

  void _loadInitialEnrollment() {
    final enrollment = widget.initialEnrollment;
    if (enrollment == null) return;

    _semester = enrollment.semester;
    _group = enrollment.group;
    _area = _semester >= 5 ? _areaForGroup(_group) : null;
    _medicalProvider = enrollment.medicalProvider;
    _genre = enrollment.genre;
    _bloodType = enrollment.bloodType;
    _studentLada = enrollment.studentLada;
    _tutorLada = enrollment.tutorLada;
    _tutorRelation = enrollment.tutorRelation;
    _lastAcademicLevel = enrollment.lastAcademicLevel;
    _civilStatus = enrollment.civilStatus;
    _hasCellphone = enrollment.hasCellphoneAccess;
    _hasTablet = enrollment.hasTabletAccess;
    _hasComputer = enrollment.hasComputerAccess;
    _hasInternet = enrollment.hasInternetAccess;
    _hasNoEquipment = enrollment.hasNoEquipmentAccess;
    _canReadAndWrite = enrollment.canReadAndWrite;
    _isActive = enrollment.isActive;
    _transferredSubjectIds
      ..clear()
      ..addAll(MockRepository.transferredSubjectIdsFor(
        enrollment.registration,
      ));
    _sameTutorAddress = enrollment.tutorRelation == 'Myself' ||
        enrollment.tutorDomicile == enrollment.studentDomicile;

    _nssController.text = enrollment.nss;
    _studentFatherSurnameController.text = enrollment.studentFatherSurname;
    _studentMotherSurnameController.text = enrollment.studentMotherSurname;
    _studentNameController.text = enrollment.studentName;
    _studentCurpController.text = enrollment.studentCurp;
    _placeOfBirthController.text = enrollment.placeOfBirth;
    _studentEmailController.text = enrollment.studentEmail;
    _schoolEmailController.text = enrollment.schoolEmail;
    _studentCellphoneController.text = enrollment.studentCellphone;
    _studentDomicileController.text = enrollment.studentDomicile;
    _tutorFatherSurnameController.text = enrollment.tutorFatherSurname;
    _tutorMotherSurnameController.text = enrollment.tutorMotherSurname;
    _tutorNameController.text = enrollment.tutorName;
    _tutorCurpController.text = enrollment.tutorCurp;
    _tutorOccupationController.text = enrollment.tutorOccupation;
    _tutorCellphoneController.text = enrollment.tutorCellphone;
    _tutorEmailController.text = enrollment.tutorEmail;
    _tutorDomicileController.text = enrollment.tutorDomicile;
  }

  List<String> _groupOptionsForSemester() {
    if (_isAdvancedSemester) return const ['A', 'B', 'C', 'D'];
    return MockRepository.availableGroupsForSemester(_semester);
  }

  String _areaForGroup(String group) {
    return switch (group) {
      'A' => 'Physics',
      'B' => 'Biological',
      'C' => 'Economics',
      'D' => 'Humanities',
      _ => '',
    };
  }

  String _groupForArea(String area) {
    return switch (area) {
      'Physics' => 'A',
      'Biological' => 'B',
      'Economics' => 'C',
      'Humanities' => 'D',
      _ => 'A',
    };
  }

  String _areaLabel(AppLocalizations l10n, String area) {
    return switch (area) {
      'Physics' => l10n.areaPhysics,
      'Biological' => l10n.areaBiological,
      'Economics' => l10n.areaEconomics,
      'Humanities' => l10n.areaHumanities,
      _ => area,
    };
  }

  String _medicalProviderLabel(
    AppLocalizations l10n,
    String provider,
  ) {
    return switch (provider) {
      'Private' => l10n.medicalProviderPrivate,
      'Marine/Military' => l10n.medicalProviderMarineMilitary,
      _ => provider,
    };
  }

  String _sexLabel(AppLocalizations l10n, String value) {
    return switch (value) {
      'Male' => l10n.sexMale,
      'Female' => l10n.sexFemale,
      _ => value,
    };
  }

  String _tutorRelationLabel(
    AppLocalizations l10n,
    String relation,
  ) {
    return switch (relation) {
      'Mother' => l10n.relationMother,
      'Father' => l10n.relationFather,
      'Cousin' => l10n.relationCousin,
      'Aunt/Uncle' => l10n.relationAuntUncle,
      'Close friend' => l10n.relationCloseFriend,
      'Myself' => l10n.relationMyself,
      _ => relation,
    };
  }

  String _academicLevelLabel(
    AppLocalizations l10n,
    String level,
  ) {
    return switch (level) {
      'Primaria' => l10n.academicPrimary,
      'Secundaria' => l10n.academicSecondary,
      'Bachillerato' => l10n.academicHighSchool,
      'Licenciatura' => l10n.academicBachelor,
      'Maestria' => l10n.academicMaster,
      'Doctorado' => l10n.academicDoctorate,
      _ => level,
    };
  }

  String _civilStatusLabel(
    AppLocalizations l10n,
    String status,
  ) {
    return switch (status) {
      'Single' => l10n.civilSingle,
      'Married' => l10n.civilMarried,
      'Widowed' => l10n.civilWidowed,
      'Free Union' => l10n.civilFreeUnion,
      _ => status,
    };
  }

  void _nextStep() {
    if (_currentStep < _lastStepIndex) {
      setState(() => _currentStep += 1);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) setState(() => _currentStep -= 1);
  }

  void _saveEnrollment() {
    final l10n = AppLocalizations.of(context)!;
    _syncTutorFromStudent();
    final hasEquipment = _hasCellphone ||
        _hasTablet ||
        _hasComputer ||
        _hasInternet ||
        _hasNoEquipment;
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid ||
        !hasEquipment ||
        !_canReadAndWrite ||
        !_credentialsAcknowledged) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.completeRequiredFieldsBeforeSaving,
          ),
        ),
      );
      return;
    }

    final enrollment = StudentEnrollment(
      registration: _registration,
      semester: _semester,
      group: _group,
      medicalProvider: _medicalProvider!,
      nss: _nssController.text.trim(),
      hasCellphoneAccess: _hasCellphone,
      hasTabletAccess: _hasTablet,
      hasComputerAccess: _hasComputer,
      hasInternetAccess: _hasInternet,
      hasNoEquipmentAccess: _hasNoEquipment,
      studentFatherSurname: _studentFatherSurnameController.text.trim(),
      studentMotherSurname: _studentMotherSurnameController.text.trim(),
      studentName: _studentNameController.text.trim(),
      studentCurp: _studentCurpController.text.trim().toUpperCase(),
      genre: _genre!,
      bloodType: _bloodType!,
      placeOfBirth: _placeOfBirthController.text.trim(),
      studentEmail: _studentEmailController.text.trim(),
      schoolEmail: _schoolEmailController.text.trim(),
      studentLada: _studentLada,
      studentCellphone: _studentCellphoneController.text.trim(),
      studentDomicile: _studentDomicileController.text.trim(),
      tutorRelation: _tutorRelation!,
      tutorFatherSurname: _tutorFatherSurnameController.text.trim(),
      tutorMotherSurname: _tutorMotherSurnameController.text.trim(),
      tutorName: _tutorNameController.text.trim(),
      tutorCurp: _tutorCurpController.text.trim().toUpperCase(),
      tutorOccupation: _tutorOccupationController.text.trim(),
      tutorLada: _tutorLada,
      tutorCellphone: _tutorCellphoneController.text.trim(),
      tutorEmail: _tutorEmailController.text.trim(),
      tutorDomicile: _tutorDomicileController.text.trim(),
      lastAcademicLevel: _lastAcademicLevel!,
      civilStatus: _civilStatus!,
      canReadAndWrite: _canReadAndWrite,
      createdAt: widget.initialEnrollment?.createdAt ?? DateTime.now(),
      isActive: _isActive,
    );

    MockRepository.saveStudentEnrollment(enrollment);
    if (_canManageTransferredSubjects) {
      MockRepository.setTransferredPassedSubjects(
        enrollment,
        _transferredSubjectIds,
      );
    }
    widget.onSaved?.call();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.studentSavedWithRegistration(_registration),
        ),
      ),
    );
    if (widget.standalone) Navigator.of(context).pop();
  }

  void _copyCredential(String label, String value) {
    final l10n = AppLocalizations.of(context)!;

    Clipboard.setData(
      ClipboardData(text: value),
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.fieldCopied(label),
        ),
      ),
    );
  }

  void _syncTutorFromStudent() {
    if (_isTutorMyself) {
      _tutorFatherSurnameController.text = _studentFatherSurnameController.text;
      _tutorMotherSurnameController.text = _studentMotherSurnameController.text;
      _tutorNameController.text = _studentNameController.text;
      _tutorCurpController.text = _studentCurpController.text;
      _tutorLada = _studentLada;
      _tutorCellphoneController.text = _studentCellphoneController.text;
      _tutorEmailController.text = _studentEmailController.text;
      _tutorDomicileController.text = _studentDomicileController.text;
    } else if (_sameTutorAddress) {
      _tutorDomicileController.text = _studentDomicileController.text;
    }
  }

  void _clearCopiedTutorFields() {
    _tutorFatherSurnameController.clear();
    _tutorMotherSurnameController.clear();
    _tutorNameController.clear();
    _tutorCurpController.clear();
    _tutorCellphoneController.clear();
    _tutorEmailController.clear();
    _sameTutorAddress = false;
  }

  void _toggleStudentActivation() {
    final l10n = AppLocalizations.of(context)!;
    final updated = MockRepository.setStudentEnrollmentActive(
      _registration,
      !_isActive,
    );
    if (updated == null) return;
    setState(() => _isActive = updated.isActive);
    widget.onSaved?.call();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
            _isActive
              ? l10n.studentAccountEnabled
              : l10n.studentAccountDisabled,
          ),
      ),
    );
  }

  void _updateEquipment(String key, bool value) {
    setState(() {
      if (key == 'none' && value) {
        _hasCellphone = false;
        _hasTablet = false;
        _hasComputer = false;
        _hasInternet = false;
        _hasNoEquipment = true;
        return;
      }
      _hasNoEquipment = false;
      switch (key) {
        case 'cellphone':
          _hasCellphone = value;
          break;
        case 'tablet':
          _hasTablet = value;
          break;
        case 'computer':
          _hasComputer = value;
          break;
        case 'internet':
          _hasInternet = value;
          break;
      }
    });
  }

  String? _requiredText(String? value) =>
      value == null || value.trim().isEmpty
        ? AppLocalizations.of(context)!.requiredField
        : null;

  String? _requiredDropdown<T>(T? value) =>
    value == null
    ? AppLocalizations.of(context)!.requiredField
    : null;
  
  String? _emailValidator(String? value) {
    final l10n = AppLocalizations.of(context)!;
    final text = value?.trim() ?? '';
    if (text.isEmpty){ 
      return l10n.requiredField;
    } 
    if (!text.contains('@')){
      return l10n.enterValidEmail;
    } 
    return null;
  }

  String? _curpValidator(String? value) {
    final l10n = AppLocalizations.of(context)!;
    final text = value?.trim().toUpperCase() ?? '';
    if (text.isEmpty) {
      return l10n.requiredField;
    }
    if (text.length != 18) {
      return l10n.curpMustBe18Characters;
    }

    return null;
  }
}

class _CredentialField extends StatelessWidget {
  const _CredentialField({
    required this.label,
    required this.value,
    required this.onCopy,
  });

  final String label;
  final String value;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      key: ValueKey('credential-$label-$value'),
      initialValue: value,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          tooltip: l10n.copyField(label),
          onPressed: value.isEmpty ? null : onCopy,
          icon: const Icon(Icons.copy_outlined),
        ),
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        initialValue: value,
        readOnly: true,
        decoration: InputDecoration(labelText: label));
  }
}

class _PhoneField extends StatelessWidget {
  const _PhoneField(
      {required this.lada,
      required this.controller,
      required this.label,
      required this.onLadaChanged,
      required this.validator,
      required this.phoneCodes,
      this.enabled = true});

  final String lada;
  final TextEditingController controller;
  final String label;
  final ValueChanged<String> onLadaChanged;
  final FormFieldValidator<String> validator;
  final List<PhoneCode> phoneCodes;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        width: 136,
        child: DropdownButtonFormField<String>(
          initialValue: lada,
          decoration: const InputDecoration(labelText: 'LADA'),
          items: [
            for (final code in phoneCodes)
              DropdownMenuItem(value: code.dialCode, child: Text(code.label))
          ],
          onChanged: enabled ? (value) => onLadaChanged(value ?? '+52') : null,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
          child: TextFormField(
              controller: controller,
              enabled: enabled,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: label),
              validator: validator)),
    ]);
  }
}

class _AutocompleteTextField extends StatefulWidget {
  const _AutocompleteTextField(
      {required this.controller,
      required this.label,
      required this.addressSuggestionService,
      required this.validator,
      this.enabled = true});

  final TextEditingController controller;
  final String label;
  final AddressSuggestionService addressSuggestionService;
  final FormFieldValidator<String> validator;
  final bool enabled;

  @override
  State<_AutocompleteTextField> createState() => _AutocompleteTextFieldState();
}

class _AutocompleteTextFieldState extends State<_AutocompleteTextField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<String>(
      textEditingController: widget.controller,
      focusNode: _focusNode,
      optionsBuilder: (value) =>
          widget.addressSuggestionService.search(value.text),
      onSelected: (option) => widget.controller.text = option,
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          enabled: widget.enabled,
          decoration: InputDecoration(
            labelText: widget.label,
            suffixIcon: IconButton(
                tooltip: AppLocalizations.of(context)!.openMapSelector,
                onPressed: widget.enabled ? _openMapSelector : null,
                icon: const Icon(Icons.map_outlined),
            ),
          ),
          validator: widget.validator,
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220, maxWidth: 360),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return ListTile(
                      title: Text(option), onTap: () => onSelected(option));
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _openMapSelector() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: FractionallySizedBox(
            heightFactor: 0.86,
            child: ListView(
              padding: const EdgeInsets.only(bottom: 16),
              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Text(
                      AppLocalizations.of(context)!.openStreetMapSelector,
                        style: Theme.of(context).textTheme.titleLarge,
                    ),
                ),
                _OpenStreetMapPicker(
                    addressService: widget.addressSuggestionService,
                    onSelected: (location) {
                      widget.controller.text = location;
                      Navigator.of(context).pop();
                    }),
                const Divider(),
                for (final option in AddressSuggestionService.suggestions)
                  ListTile(
                      leading: const Icon(Icons.place_outlined),
                      title: Text(option),
                      onTap: () {
                        widget.controller.text = option;
                        Navigator.of(context).pop();
                      }),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EquipmentPicker extends StatelessWidget {
  const _EquipmentPicker(
      {required this.hasCellphone,
      required this.hasTablet,
      required this.hasComputer,
      required this.hasInternet,
      required this.hasNoEquipment,
      required this.onChanged});

  final bool hasCellphone;
  final bool hasTablet;
  final bool hasComputer;
  final bool hasInternet;
  final bool hasNoEquipment;
  final void Function(String key, bool value) onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(children: [
      CheckboxListTile(
          value: hasCellphone,
          onChanged: (value) => onChanged('cellphone', value ?? false),
          title: Text(l10n.equipmentCellphone),
          controlAffinity: ListTileControlAffinity.leading),
      CheckboxListTile(
          value: hasTablet,
          onChanged: (value) => onChanged('tablet', value ?? false),
          title: Text(l10n.equipmentTablet),
          controlAffinity: ListTileControlAffinity.leading),
      CheckboxListTile(
          value: hasComputer,
          onChanged: (value) => onChanged('computer', value ?? false),
          title: Text(l10n.equipmentComputer),
          controlAffinity: ListTileControlAffinity.leading),
      CheckboxListTile(
          value: hasInternet,
          onChanged: (value) => onChanged('internet', value ?? false),
          title: Text(l10n.equipmentInternet),
          controlAffinity: ListTileControlAffinity.leading),
      CheckboxListTile(
          value: hasNoEquipment,
          onChanged: (value) => onChanged('none', value ?? false),
          title: Text(l10n.equipmentNone),
          controlAffinity: ListTileControlAffinity.leading),
    ]);
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(
        text: newValue.text.toUpperCase(), selection: newValue.selection);
  }
}

class _OpenStreetMapPicker extends StatefulWidget {
  const _OpenStreetMapPicker({
    required this.onSelected,
    required this.addressService,
  });

  final ValueChanged<String> onSelected;
  final AddressSuggestionService addressService;

  @override
  State<_OpenStreetMapPicker> createState() => _OpenStreetMapPickerState();
}

class _OpenStreetMapPickerState extends State<_OpenStreetMapPicker> {
  static const _xalapa = LatLng(19.5438, -96.9102);

  final MapController _mapController = MapController();
  final TextEditingController _searchController =
      TextEditingController(text: 'xalapa');

  LatLng _selectedPoint = _xalapa;
  String _selectedAddress = 'Xalapa-Enriquez, Xalapa, Veracruz, Mexico';
  bool _isLoading = false;
  String? _lookupError;

  @override
  void dispose() {
    _mapController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border.all(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: l10n.searchLocation,
                      ),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => _searchLocation(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    tooltip: l10n.search,
                    onPressed: _isLoading ? null : _searchLocation,
                    icon: const Icon(Icons.search),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    tooltip: l10n.centerOnXalapa,
                    onPressed: _centerOnXalapa,
                    icon: const Icon(Icons.my_location),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AspectRatio(
                aspectRatio: 1.22,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: FlutterMap(
                    key: const ValueKey('openstreetmap-interactive-map'),
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _selectedPoint,
                      initialZoom: 16,
                      minZoom: 2,
                      maxZoom: 19,
                      onTap: (_, point) => _selectPoint(point),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: const String.fromEnvironment(
                          'MAP_TILE_URL',
                          defaultValue:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        ),
                        userAgentPackageName:
                            'mx.edu.constitucion1917.yosoyconstimix',
                        maxNativeZoom: 19,
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _selectedPoint,
                            width: 48,
                            height: 48,
                            alignment: Alignment.topCenter,
                            child: const Icon(
                              Icons.location_on,
                              color: Color(0xFF2E9FE6),
                              size: 44,
                              shadows: [
                                Shadow(
                                  blurRadius: 4,
                                  color: Colors.black54,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const RichAttributionWidget(
                        attributions: [
                          TextSourceAttribution('OpenStreetMap contributors'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (_isLoading) const LinearProgressIndicator(minHeight: 3),
              if (_lookupError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _lookupError!,
                    style: TextStyle(color: colorScheme.error),
                  ),
                ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: Row(
                  children: [
                    Icon(Icons.place_outlined, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Expanded(child: Text(_selectedAddress)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: _isLoading
                    ? null
                    : () => widget.onSelected(_selectedAddress),
                icon: const Icon(Icons.add_location_alt_outlined),
                label: Text(l10n.useThisLocation),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _searchLocation() async {
    final l10n = AppLocalizations.of(context)!;
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    setState(() {
      _isLoading = true;
      _lookupError = null;
    });
    try {
      final result = await widget.addressService.searchLocation(query);
      if (!mounted) return;
      if (result == null) {
        setState(() => _lookupError = l10n.noMatchingLocationFound);
        return;
      }
      final point = LatLng(result.latitude, result.longitude);
      setState(() {
        _selectedPoint = point;
        _selectedAddress = result.displayName;
      });
      _mapController.move(point, 16);
    } on AddressLookupException {
      if (mounted) {
        setState(
          () => _lookupError = l10n.locationSearchFailed,
          );
      } 
    } on Exception {
      if (mounted) {
        setState(() => _lookupError = l10n.locationServiceUnavailable);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _selectPoint(LatLng point) async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _selectedPoint = point;
      _selectedAddress = l10n.selectedPointCoordinates(
        point.latitude.toStringAsFixed(5),
        point.longitude.toStringAsFixed(5),
        );
      _isLoading = true;
      _lookupError = null;
    });
    try {
      final result = await widget.addressService.reverseLocation(
        latitude: point.latitude,
        longitude: point.longitude,
      );
      if (!mounted || point != _selectedPoint) return;
      if (result != null) {
        setState(() => _selectedAddress = result.displayName);
      }
    } on AddressLookupException {
      if (mounted) {
        setState(
          () => _lookupError =
          l10n.addressCouldNotBeResolved,
        );
      }       
    } on Exception {
      if (mounted) {
        setState(
          () => _lookupError =
          l10n.addressCouldNotBeResolved,
        );
      }
    } finally {
      if (mounted && point == _selectedPoint) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _centerOnXalapa() {
    setState(() {
      _searchController.text = 'xalapa';
      _selectedPoint = _xalapa;
      _selectedAddress = 'Xalapa-Enríquez, Xalapa, Veracruz, México';
      _lookupError = null;
    });
    _mapController.move(_xalapa, 16);
  }
}
