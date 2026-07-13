import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/data/mock_repository.dart';
import '../../core/models/student_enrollment.dart';
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
  bool _isActive = true;

  bool get _isTutorMyself => _tutorRelation == 'Myself';
  bool get _isAdvancedSemester => _semester >= 5;
  bool get _isLastStep => _currentStep == 5;

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
    final content = Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionHeader(
              title: widget.initialEnrollment == null
                  ? 'Student enrollment'
                  : 'Edit student enrollment',
              subtitle: 'Complete the six steps to create a level 4 account.'),
          const SizedBox(height: 16),
          Stepper(
            currentStep: _currentStep,
            onStepTapped: (step) => setState(() => _currentStep = step),
            controlsBuilder: _buildControls,
            steps: [
              Step(
                  title: const Text('School data'),
                  isActive: _currentStep == 0,
                  content: _schoolDataStep()),
              Step(
                  title: const Text('Student data'),
                  isActive: _currentStep == 1,
                  content: _studentDataStep()),
              Step(
                  title: const Text('Student contact'),
                  isActive: _currentStep == 2,
                  content: _studentContactStep()),
              Step(
                  title: const Text('Tutor data'),
                  isActive: _currentStep == 3,
                  content: _tutorDataStep()),
              Step(
                  title: const Text('Tutor contact'),
                  isActive: _currentStep == 4,
                  content: _tutorContactStep()),
              Step(
                  title: const Text('Additional info'),
                  isActive: _currentStep == 5,
                  content: _additionalInfoStep()),
            ],
          ),
        ],
      ),
    );
    if (!widget.standalone) return content;
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.initialEnrollment == null
                ? 'Student sign up'
                : 'Student data')),
        body: SafeArea(child: content));
  }

  Widget _buildControls(BuildContext context, ControlsDetails details) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(children: [
        FilledButton.icon(
          onPressed: _isLastStep ? _saveEnrollment : _nextStep,
          icon: Icon(_isLastStep ? Icons.save_outlined : Icons.arrow_forward),
          label: Text(_isLastStep ? 'Save' : 'Next'),
        ),
        const SizedBox(width: 8),
        TextButton(
            onPressed: _currentStep == 0 ? null : _previousStep,
            child: const Text('Back')),
        if (widget.canManageActivation && widget.initialEnrollment != null) ...[
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: _toggleStudentActivation,
            icon: Icon(
                _isActive ? Icons.person_off_outlined : Icons.person_add_alt),
            label: Text(_isActive ? 'Disable user' : 'Enable user'),
          ),
        ],
      ]),
    );
  }

  Widget _schoolDataStep() {
    final groupOptions = _groupOptionsForSemester();
    if (!groupOptions.contains(_group)) _group = groupOptions.first;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _ReadOnlyField(label: 'Registration', value: _registration),
      const SizedBox(height: 12),
      DropdownButtonFormField<int>(
        key: ValueKey('semester-$_semester'),
        initialValue: _semester,
        decoration: const InputDecoration(labelText: 'Semester'),
        items: [
          for (var semester = 1; semester <= 6; semester++)
            DropdownMenuItem(value: semester, child: Text('$semester'))
        ],
        onChanged: (value) {
          if (value == null) return;
          setState(() {
            _semester = value;
            final groups = _groupOptionsForSemester();
            _group = groups.contains(_group) ? _group : groups.first;
          });
        },
        validator: _requiredDropdown,
      ),
      const SizedBox(height: 12),
      DropdownButtonFormField<String>(
        key: ValueKey('group-$_semester-$_group-${groupOptions.join()}'),
        initialValue: _group,
        decoration: const InputDecoration(labelText: 'Group'),
        items: [
          for (final group in groupOptions)
            DropdownMenuItem(value: group, child: Text(group))
        ],
        onChanged: (value) {
          if (value == null) return;
          setState(() => _group = value);
        },
        validator: _requiredDropdown,
      ),
      if (_isAdvancedSemester) ...[
        const SizedBox(height: 12),
        _ReadOnlyField(label: 'Area', value: _areaForGroup(_group))
      ],
      const SizedBox(height: 12),
      DropdownButtonFormField<String>(
        initialValue: _medicalProvider,
        decoration: const InputDecoration(labelText: 'Medical provider'),
        items: [
          for (final provider in _medicalProviders)
            DropdownMenuItem(value: provider, child: Text(provider))
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
      Text('Select the ones you have access to',
          style: Theme.of(context).textTheme.titleSmall),
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
    return Column(children: [
      TextFormField(
          controller: _studentFatherSurnameController,
          decoration:
              const InputDecoration(labelText: 'Student father surname'),
          textInputAction: TextInputAction.next,
          validator: _requiredText),
      const SizedBox(height: 12),
      TextFormField(
          controller: _studentMotherSurnameController,
          decoration:
              const InputDecoration(labelText: 'Student mother surname'),
          textInputAction: TextInputAction.next,
          validator: _requiredText),
      const SizedBox(height: 12),
      TextFormField(
          controller: _studentNameController,
          decoration: const InputDecoration(labelText: 'Student name'),
          textInputAction: TextInputAction.next,
          validator: _requiredText),
      const SizedBox(height: 12),
      TextFormField(
          controller: _studentCurpController,
          decoration: const InputDecoration(labelText: 'Student CURP'),
          inputFormatters: [UpperCaseTextFormatter()],
          textCapitalization: TextCapitalization.characters,
          validator: _curpValidator),
      const SizedBox(height: 12),
      DropdownButtonFormField<String>(
          initialValue: _genre,
          decoration: const InputDecoration(labelText: 'Genre'),
          items: [
            for (final genre in _genres)
              DropdownMenuItem(value: genre, child: Text(genre))
          ],
          onChanged: (value) => setState(() => _genre = value),
          validator: _requiredDropdown),
      const SizedBox(height: 12),
      DropdownButtonFormField<String>(
          initialValue: _bloodType,
          decoration: const InputDecoration(labelText: 'Blood type'),
          items: [
            for (final bloodType in _bloodTypes)
              DropdownMenuItem(value: bloodType, child: Text(bloodType))
          ],
          onChanged: (value) => setState(() => _bloodType = value),
          validator: _requiredDropdown),
      const SizedBox(height: 12),
      _AutocompleteTextField(
          controller: _placeOfBirthController,
          label: 'Place of birth',
          addressSuggestionService: _addressSuggestionService,
          validator: _requiredText),
    ]);
  }

  Widget _studentContactStep() {
    return Column(children: [
      TextFormField(
          controller: _studentEmailController,
          decoration: const InputDecoration(labelText: 'Email'),
          keyboardType: TextInputType.emailAddress,
          validator: _emailValidator),
      const SizedBox(height: 12),
      TextFormField(
          controller: _schoolEmailController,
          decoration: const InputDecoration(labelText: 'School email'),
          keyboardType: TextInputType.emailAddress),
      const SizedBox(height: 12),
      _PhoneField(
          lada: _studentLada,
          controller: _studentCellphoneController,
          label: 'Cellphone number',
          phoneCodes: _phoneCodeService.codes,
          onLadaChanged: (value) => setState(() {
                _studentLada = value;
                _syncTutorFromStudent();
              }),
          validator: _requiredText),
      const SizedBox(height: 12),
      _AutocompleteTextField(
          controller: _studentDomicileController,
          label: 'Private domicile',
          addressSuggestionService: _addressSuggestionService,
          validator: _requiredText),
    ]);
  }

  Widget _tutorDataStep() {
    return Column(children: [
      DropdownButtonFormField<String>(
        key: ValueKey('relation-$_tutorRelation'),
        initialValue: _tutorRelation,
        decoration: const InputDecoration(labelText: 'Relation to student'),
        items: [
          for (final relation in _tutorRelations)
            DropdownMenuItem(value: relation, child: Text(relation))
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
          decoration: const InputDecoration(labelText: 'Tutor father surname'),
          validator: _requiredText),
      const SizedBox(height: 12),
      TextFormField(
          controller: _tutorMotherSurnameController,
          enabled: !_isTutorMyself,
          decoration: const InputDecoration(labelText: 'Tutor mother surname'),
          validator: _requiredText),
      const SizedBox(height: 12),
      TextFormField(
          controller: _tutorNameController,
          enabled: !_isTutorMyself,
          decoration: const InputDecoration(labelText: 'Tutor name'),
          validator: _requiredText),
      const SizedBox(height: 12),
      TextFormField(
          controller: _tutorCurpController,
          enabled: !_isTutorMyself,
          decoration: const InputDecoration(labelText: 'Tutor CURP'),
          inputFormatters: [UpperCaseTextFormatter()],
          textCapitalization: TextCapitalization.characters,
          validator: _curpValidator),
      const SizedBox(height: 12),
      TextFormField(
          controller: _tutorOccupationController,
          decoration: const InputDecoration(labelText: 'Occupation'),
          validator: _requiredText),
    ]);
  }

  Widget _tutorContactStep() {
    final domicileLocked = _isTutorMyself || _sameTutorAddress;
    return Column(children: [
      _PhoneField(
          lada: _tutorLada,
          controller: _tutorCellphoneController,
          enabled: !_isTutorMyself,
          label: 'Tutor cellphone number',
          phoneCodes: _phoneCodeService.codes,
          onLadaChanged: (value) => setState(() => _tutorLada = value),
          validator: _requiredText),
      const SizedBox(height: 12),
      TextFormField(
          controller: _tutorEmailController,
          enabled: !_isTutorMyself,
          decoration: const InputDecoration(labelText: 'Tutor email'),
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
                _tutorDomicileController.text = _studentDomicileController.text;
              }
            });
          },
          title: const Text('Same domicile as student'),
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ],
      const SizedBox(height: 12),
      _AutocompleteTextField(
          controller: _tutorDomicileController,
          enabled: !domicileLocked,
          label: 'Tutor private domicile',
          addressSuggestionService: _addressSuggestionService,
          validator: _requiredText),
    ]);
  }

  Widget _additionalInfoStep() {
    return Column(children: [
      DropdownButtonFormField<String>(
          initialValue: _lastAcademicLevel,
          decoration: const InputDecoration(labelText: 'Last academic level'),
          items: [
            for (final level in _academicLevels)
              DropdownMenuItem(value: level, child: Text(level))
          ],
          onChanged: (value) => setState(() => _lastAcademicLevel = value),
          validator: _requiredDropdown),
      const SizedBox(height: 12),
      DropdownButtonFormField<String>(
          initialValue: _civilStatus,
          decoration: const InputDecoration(labelText: 'Civil status'),
          items: [
            for (final status in _civilStatuses)
              DropdownMenuItem(value: status, child: Text(status))
          ],
          onChanged: (value) => setState(() => _civilStatus = value),
          validator: _requiredDropdown),
      const SizedBox(height: 8),
      CheckboxListTile(
          value: _canReadAndWrite,
          onChanged: (value) =>
              setState(() => _canReadAndWrite = value ?? false),
          title: const Text('Able to read and write'),
          controlAffinity: ListTileControlAffinity.leading),
    ]);
  }

  void _loadInitialEnrollment() {
    final enrollment = widget.initialEnrollment;
    if (enrollment == null) return;

    _semester = enrollment.semester;
    _group = enrollment.group;
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

  void _nextStep() {
    if (_currentStep < 5) setState(() => _currentStep += 1);
  }

  void _previousStep() {
    if (_currentStep > 0) setState(() => _currentStep -= 1);
  }

  void _saveEnrollment() {
    _syncTutorFromStudent();
    final hasEquipment = _hasCellphone ||
        _hasTablet ||
        _hasComputer ||
        _hasInternet ||
        _hasNoEquipment;
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid || !hasEquipment || !_canReadAndWrite) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Complete every required field before saving.')));
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
    widget.onSaved?.call();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Student saved with registration $_registration.')));
    if (widget.standalone) Navigator.of(context).pop();
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
    final updated = MockRepository.setStudentEnrollmentActive(
      _registration,
      !_isActive,
    );
    if (updated == null) return;
    setState(() => _isActive = updated.isActive);
    widget.onSaved?.call();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(_isActive
              ? 'Student account enabled.'
              : 'Student account disabled.')),
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
      value == null || value.trim().isEmpty ? 'Required' : null;
  String? _requiredDropdown<T>(T? value) => value == null ? 'Required' : null;
  String? _emailValidator(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Required';
    if (!text.contains('@')) return 'Enter a valid email';
    return null;
  }

  String? _curpValidator(String? value) {
    final text = value?.trim().toUpperCase() ?? '';
    if (text.isEmpty) return 'Required';
    if (text.length != 18) return 'CURP must be 18 characters';
    return null;
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
                tooltip: 'Open map selector',
                onPressed: widget.enabled ? _openMapSelector : null,
                icon: const Icon(Icons.map_outlined)),
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
                    child: Text('OpenStreetMap selector',
                        style: Theme.of(context).textTheme.titleLarge)),
                _OpenStreetMapPicker(onSelected: (location) {
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
    return Column(children: [
      CheckboxListTile(
          value: hasCellphone,
          onChanged: (value) => onChanged('cellphone', value ?? false),
          title: const Text('Cellphone'),
          controlAffinity: ListTileControlAffinity.leading),
      CheckboxListTile(
          value: hasTablet,
          onChanged: (value) => onChanged('tablet', value ?? false),
          title: const Text('Tablet'),
          controlAffinity: ListTileControlAffinity.leading),
      CheckboxListTile(
          value: hasComputer,
          onChanged: (value) => onChanged('computer', value ?? false),
          title: const Text('Laptop/PC'),
          controlAffinity: ListTileControlAffinity.leading),
      CheckboxListTile(
          value: hasInternet,
          onChanged: (value) => onChanged('internet', value ?? false),
          title: const Text('Internet'),
          controlAffinity: ListTileControlAffinity.leading),
      CheckboxListTile(
          value: hasNoEquipment,
          onChanged: (value) => onChanged('none', value ?? false),
          title: const Text('None'),
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
  const _OpenStreetMapPicker({required this.onSelected});

  final ValueChanged<String> onSelected;

  @override
  State<_OpenStreetMapPicker> createState() => _OpenStreetMapPickerState();
}

class _OpenStreetMapPickerState extends State<_OpenStreetMapPicker> {
  static const int _zoom = 16;
  final TextEditingController _searchController =
      TextEditingController(text: 'xalapa');

  Offset _pin = const Offset(0.5, 0.5);
  double _latitude = 19.5438;
  double _longitude = -96.9102;
  String _selectedAddress = 'Xalapa-Enriquez, Xalapa, Veracruz, 91133, Mexico';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tile = _tileFor(_latitude, _longitude, _zoom);
    final tileUrl =
        'https://tile.openstreetmap.org/$_zoom/${tile.x}/${tile.y}.png';
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: const Color(0xFF0C0C0C),
            borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.white70),
                    hintText: 'Search location',
                    hintStyle: TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Color(0xFF111111),
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _searchLocation(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                  tooltip: 'Search',
                  onPressed: _searchLocation,
                  icon: const Icon(Icons.search)),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                  tooltip: 'Center on Xalapa',
                  onPressed: _centerOnXalapa,
                  icon: const Icon(Icons.my_location)),
            ]),
            const SizedBox(height: 8),
            AspectRatio(
              aspectRatio: 1.22,
              child: LayoutBuilder(builder: (context, constraints) {
                return GestureDetector(
                  onTapDown: (details) {
                    final width = constraints.maxWidth;
                    final height = constraints.maxHeight;
                    setState(() {
                      _pin = Offset(
                          (details.localPosition.dx / width).clamp(0, 1),
                          (details.localPosition.dy / height).clamp(0, 1));
                      _updateAddressFromPin();
                    });
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Stack(fit: StackFit.expand, children: [
                      Image.network(tileUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              CustomPaint(
                                  painter: _OpenStreetMapFallbackPainter())),
                      Positioned(
                        left: (_pin.dx * constraints.maxWidth) - 18,
                        top: (_pin.dy * constraints.maxHeight) - 42,
                        child: const Icon(Icons.location_on,
                            color: Color(0xFF2E9FE6),
                            size: 44,
                            shadows: [
                              Shadow(
                                  blurRadius: 4,
                                  color: Colors.black54,
                                  offset: Offset(0, 2))
                            ]),
                      ),
                      Positioned(
                        right: 8,
                        bottom: 8,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(3)),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            child: Text('LEAFLET | (C) OPENSTREETMAP',
                                style: TextStyle(
                                    color: Color(0xFF0078B8), fontSize: 12)),
                          ),
                        ),
                      ),
                    ]),
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: const Color(0xFF111111),
                  border: Border.all(color: const Color(0xFF222222))),
              child: Row(children: [
                const Icon(Icons.place_outlined, color: Colors.white54),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(_selectedAddress,
                        style: const TextStyle(color: Colors.white70))),
              ]),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
                onPressed: () => widget.onSelected(_selectedAddress),
                icon: const Icon(Icons.add_location_alt_outlined),
                label: const Text('Use this location')),
          ]),
        ),
      ),
    );
  }

  void _searchLocation() {
    final query = _searchController.text.trim();
    setState(() {
      _pin = const Offset(0.5, 0.5);
      if (query.toLowerCase().contains('20 de noviembre') ||
          query.toLowerCase().contains('modelo')) {
        _latitude = 19.5273;
        _longitude = -96.9228;
        _selectedAddress = AddressSuggestionService.schoolAddress;
      } else if (query.isNotEmpty) {
        _latitude = 19.5438;
        _longitude = -96.9102;
        _selectedAddress = '$query, Xalapa, Veracruz, Mexico';
      } else {
        _searchController.text = 'xalapa';
        _latitude = 19.5438;
        _longitude = -96.9102;
        _selectedAddress = 'Xalapa-Enriquez, Xalapa, Veracruz, 91133, Mexico';
      }
    });
  }

  void _centerOnXalapa() {
    setState(() {
      _searchController.text = 'xalapa';
      _pin = const Offset(0.5, 0.5);
      _latitude = 19.5438;
      _longitude = -96.9102;
      _selectedAddress = 'Xalapa-Enriquez, Xalapa, Veracruz, 91133, Mexico';
    });
  }

  void _updateAddressFromPin() {
    final latitude = _coordinateValue(_latitude, _pin.dy, invert: true);
    final longitude = _coordinateValue(_longitude, _pin.dx);
    _selectedAddress =
        'OpenStreetMap point ${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}';
  }

  double _coordinateValue(double origin, double ratio, {bool invert = false}) {
    final signedRatio = invert ? 0.5 - ratio : ratio - 0.5;
    return origin + (signedRatio * 0.018);
  }

  _TileCoordinate _tileFor(double latitude, double longitude, int zoom) {
    final latRad = latitude * math.pi / 180;
    final scale = math.pow(2, zoom).toDouble();
    final x = ((longitude + 180) / 360 * scale).floor();
    final y =
        ((1 - math.log(math.tan(latRad) + 1 / math.cos(latRad)) / math.pi) /
                2 *
                scale)
            .floor();
    return _TileCoordinate(x, y);
  }
}

class _TileCoordinate {
  const _TileCoordinate(this.x, this.y);
  final int x;
  final int y;
}

class _OpenStreetMapFallbackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()..color = const Color(0xFFE8E8E8);
    final majorRoad = Paint()
      ..color = const Color(0xFFD8E68B)
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    final minorRoad = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    final outline = Paint()
      ..color = const Color(0xFFC8C8C8)
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    canvas.drawRect(Offset.zero & size, background);
    canvas.drawLine(Offset(-20, size.height * 0.78),
        Offset(size.width * 0.85, -10), majorRoad);
    canvas.drawLine(Offset(size.width * 0.25, size.height + 20),
        Offset(size.width + 20, size.height * 0.25), majorRoad);
    for (var i = 0; i < 7; i++) {
      final y = size.height * (0.15 + (i * 0.12));
      canvas.drawLine(Offset(-10, y), Offset(size.width + 10, y - 42), outline);
      canvas.drawLine(
          Offset(-10, y), Offset(size.width + 10, y - 42), minorRoad);
    }
    for (var i = 0; i < 6; i++) {
      final x = size.width * (0.08 + (i * 0.18));
      canvas.drawLine(
          Offset(x, -10), Offset(x + 55, size.height + 10), outline);
      canvas.drawLine(
          Offset(x, -10), Offset(x + 55, size.height + 10), minorRoad);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
