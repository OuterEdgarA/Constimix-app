import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/data/mock_repository.dart';
import '../../core/models/app_user.dart';
import '../../core/models/user_role.dart';
import '../../features/enrollment/enrollment_wizard_screen.dart';
import 'semester_admin_screen.dart';
import '../../shared/widgets/section_header.dart';

class AdminHubScreen extends StatefulWidget {
  const AdminHubScreen({super.key, required this.currentUser});

  final AppUser currentUser;

  @override
  State<AdminHubScreen> createState() => _AdminHubScreenState();
}

class _AdminHubScreenState extends State<AdminHubScreen> {
  late AppUser _profileUser;

  @override
  void initState() {
    super.initState();
    _profileUser = widget.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    const actions = [
      _AdminAction(
        icon: Icons.manage_accounts_outlined,
        title: 'Account admin',
        subtitle: 'Create staff accounts and review existing users.',
      ),
      _AdminAction(
        icon: Icons.edit_calendar_outlined,
        title: 'Scheduler editor',
        subtitle: 'Assign subjects, teachers, tests, and special test windows.',
      ),
      _AdminAction(
        icon: Icons.school_outlined,
        title: 'Semester admin',
        subtitle: 'Manage subjects, groups, grading periods, and assignments.',
      ),
      _AdminAction(
        icon: Icons.description_outlined,
        title: 'Document admin',
        subtitle: 'Add templates for the document generator.',
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionHeader(
          title: 'System admin',
          subtitle: 'Level 1 tools from the product brief.',
        ),
        const SizedBox(height: 16),
        _ProfileCustomizationBox(
          user: _profileUser,
          onSaved: (updatedUser) => setState(() => _profileUser = updatedUser),
        ),
        const SizedBox(height: 12),
        for (final action in actions) ...[
          Card(
            child: ListTile(
              leading: Icon(action.icon),
              title: Text(action.title),
              subtitle: Text(action.subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: action.title == 'Account admin'
                  ? () => Navigator.of(context).push<void>(
                        MaterialPageRoute(
                          builder: (_) => AccountAdminScreen(
                            currentUser: _profileUser,
                          ),
                        ),
                      )
                  : action.title == 'Semester admin'
                      ? () => Navigator.of(context).push<void>(
                            MaterialPageRoute(
                              builder: (_) => const SemesterAdminScreen(),
                            ),
                          )
                      : null,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _ProfileCustomizationBox extends StatefulWidget {
  const _ProfileCustomizationBox({required this.user, required this.onSaved});

  final AppUser user;
  final ValueChanged<AppUser> onSaved;

  @override
  State<_ProfileCustomizationBox> createState() =>
      _ProfileCustomizationBoxState();
}

class _ProfileCustomizationBoxState extends State<_ProfileCustomizationBox> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fatherSurnameController;
  late final TextEditingController _motherSurnameController;
  late final TextEditingController _nameController;
  late final TextEditingController _curpController;
  late final TextEditingController _passwordController;
  late final TextEditingController _descriptionController;
  late int _avatarIndex;
  bool _showPassword = false;

  static const _avatarIcons = [
    Icons.person,
    Icons.admin_panel_settings,
    Icons.school,
    Icons.badge,
    Icons.account_circle,
  ];

  @override
  void initState() {
    super.initState();
    _fatherSurnameController =
        TextEditingController(text: widget.user.fatherSurname);
    _motherSurnameController =
        TextEditingController(text: widget.user.motherSurname);
    _nameController = TextEditingController(text: widget.user.name);
    _curpController = TextEditingController(text: widget.user.curp ?? '');
    _passwordController =
        TextEditingController(text: widget.user.password ?? '');
    _descriptionController = TextEditingController(
      text: widget.user.profileDescription ?? '',
    );
    _avatarIndex = widget.user.profileAvatarIndex;
  }

  @override
  void dispose() {
    _fatherSurnameController.dispose();
    _motherSurnameController.dispose();
    _nameController.dispose();
    _curpController.dispose();
    _passwordController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: ExpansionTile(
        leading: CircleAvatar(
          child: Icon(_avatarIcons[_avatarIndex % _avatarIcons.length]),
        ),
        title: const Text('Profile customization'),
        subtitle: Text(widget.user.displayName),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _fatherSurnameController,
                  decoration:
                      const InputDecoration(labelText: 'Father surname'),
                  validator: _requiredText,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _motherSurnameController,
                  decoration:
                      const InputDecoration(labelText: 'Mother surname'),
                  validator: _requiredText,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: _requiredText,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _curpController,
                  decoration: const InputDecoration(labelText: 'CURP'),
                  inputFormatters: [UpperCaseTextFormatter()],
                  textCapitalization: TextCapitalization.characters,
                  validator: _curpValidator,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      tooltip:
                          _showPassword ? 'Hide password' : 'Show password',
                      onPressed: () => setState(
                        () => _showPassword = !_showPassword,
                      ),
                      icon: Icon(
                        _showPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                  ),
                  obscureText: !_showPassword,
                  validator: _requiredText,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (var index = 0; index < _avatarIcons.length; index++)
                      ChoiceChip(
                        selected: _avatarIndex == index,
                        showCheckmark: false,
                        label: CircleAvatar(
                          backgroundColor: _avatarIndex == index
                              ? colorScheme.primaryContainer
                              : colorScheme.surfaceContainerHighest,
                          child: Icon(_avatarIcons[index]),
                        ),
                        onSelected: (_) => setState(() => _avatarIndex = index),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration:
                      const InputDecoration(labelText: 'Small description'),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _saveProfile,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Save'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _saveProfile() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final updatedUser = MockRepository.updateUserProfile(
      userId: widget.user.id,
      fatherSurname: _fatherSurnameController.text.trim(),
      motherSurname: _motherSurnameController.text.trim(),
      name: _nameController.text.trim(),
      curp: _curpController.text.trim().toUpperCase(),
      password: _passwordController.text.trim(),
      profileAvatarIndex: _avatarIndex,
      profileDescription: _descriptionController.text.trim(),
    );
    if (updatedUser == null) return;
    widget.onSaved(updatedUser);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated.')),
    );
  }
}

class AccountAdminScreen extends StatefulWidget {
  const AccountAdminScreen({super.key, required this.currentUser});

  final AppUser currentUser;

  @override
  State<AccountAdminScreen> createState() => _AccountAdminScreenState();
}

class _AccountAdminScreenState extends State<AccountAdminScreen> {
  final _accountFormKey = GlobalKey<FormState>();
  final _fatherSurnameController = TextEditingController();
  final _motherSurnameController = TextEditingController();
  final _nameController = TextEditingController();
  final _curpController = TextEditingController();
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  UserRole _selectedRole = UserRole.level2SemesterAdmin;
  bool _credentialsReady = false;
  bool _showSuggestions = false;
  final Set<UserRole> _roleFilters = {};
  String _generatedUsername = '';
  String _generatedPassword = '';

  @override
  void dispose() {
    _fatherSurnameController.dispose();
    _motherSurnameController.dispose();
    _nameController.dispose();
    _curpController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final users = _filteredUsers;
    return Scaffold(
      appBar: AppBar(title: const Text('Account admin')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ExpansionTile(
              initiallyExpanded: true,
              leading: const Icon(Icons.person_add_alt_outlined),
              title: const Text('Staff Account Sign Up'),
              subtitle:
                  const Text('Create level 1, level 2, and level 3 accounts.'),
              childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
              children: [
                _accountDataStep(),
                const SizedBox(height: 12),
                _credentialsStep(),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _StudentAccountShortcut(onOpen: _openStudentSignup),
          const SizedBox(height: 12),
          Card(
            child: ExpansionTile(
              initiallyExpanded: true,
              leading: const Icon(Icons.manage_accounts_outlined),
              title: const Text('Accounts table'),
              subtitle: const Text('Search and manage accounts.'),
              childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
              children: [
                _roleFilterChips(),
                const SizedBox(height: 12),
                _AccountSearchBox(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  suggestions: _suggestions,
                  showSuggestions: _showSuggestions,
                  onChanged: (_) => setState(() => _showSuggestions = true),
                  onClear: () => setState(() {
                    _searchController.clear();
                    _showSuggestions = false;
                  }),
                  onCloseSuggestions: () =>
                      setState(() => _showSuggestions = false),
                  onSuggestionSelected: _openManagedUser,
                ),
                const SizedBox(height: 12),
                if (users.isEmpty)
                  const _EmptyAccounts()
                else
                  for (final user in users) ...[
                    _AccountCard(
                      user: user,
                      showManage: user.id != widget.currentUser.id,
                      onManage: () => _openManagedUser(user),
                    ),
                    const SizedBox(height: 8),
                  ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<AppUser> get _filteredUsers {
    final query = _searchController.text;
    return MockRepository.users
        .where(
          (user) =>
              (_roleFilters.isEmpty || _roleFilters.contains(user.role)) &&
              user.matchesSearch(query),
        )
        .toList(growable: false);
  }

  List<AppUser> get _suggestions {
    final query = _searchController.text.trim();
    if (!_showSuggestions || query.isEmpty) return const [];
    return MockRepository.users
        .where(
          (user) =>
              (_roleFilters.isEmpty || _roleFilters.contains(user.role)) &&
              user.matchesSearch(query),
        )
        .take(3)
        .toList(growable: false);
  }

  Widget _roleFilterChips() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final role in UserRole.values)
            FilterChip(
              label: Text('L${role.clearanceLevel}'),
              selected: _roleFilters.contains(role),
              onSelected: (_) => setState(() {
                if (!_roleFilters.add(role)) _roleFilters.remove(role);
              }),
            ),
        ],
      ),
    );
  }

  Widget _accountDataStep() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _accountFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Step 1 - Account data',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            SegmentedButton<UserRole>(
              segments: const [
                ButtonSegment(
                  value: UserRole.level1Admin,
                  label: Text('L1'),
                ),
                ButtonSegment(
                  value: UserRole.level2SemesterAdmin,
                  label: Text('L2'),
                ),
                ButtonSegment(
                  value: UserRole.level3Teacher,
                  label: Text('L3'),
                ),
              ],
              selected: {_selectedRole},
              onSelectionChanged: (selection) => setState(() {
                _selectedRole = selection.first;
                _credentialsReady = false;
              }),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _fatherSurnameController,
              decoration: const InputDecoration(labelText: 'Father surname'),
              validator: _requiredText,
              onChanged: (_) => _blockCredentials(),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _motherSurnameController,
              decoration: const InputDecoration(labelText: 'Mother surname'),
              validator: _requiredText,
              onChanged: (_) => _blockCredentials(),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: _requiredText,
              onChanged: (_) => _blockCredentials(),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _curpController,
              decoration: const InputDecoration(labelText: 'CURP'),
              inputFormatters: [UpperCaseTextFormatter()],
              textCapitalization: TextCapitalization.characters,
              validator: _curpValidator,
              onChanged: (_) => _blockCredentials(),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _generateCredentials,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _credentialsStep() {
    final blocked = !_credentialsReady;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: AbsorbPointer(
        absorbing: blocked,
        child: Opacity(
          opacity: blocked ? 0.55 : 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Step 2 - Account credentials',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              TextFormField(
                key: ValueKey('generated-username-$_generatedUsername'),
                readOnly: true,
                initialValue: _generatedUsername,
                decoration:
                    const InputDecoration(labelText: 'Generated Username'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: ValueKey('generated-password-$_generatedPassword'),
                readOnly: true,
                initialValue: _generatedPassword,
                decoration:
                    const InputDecoration(labelText: 'Generated password'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: _backToAccountData,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _createAccount,
                      icon: const Icon(Icons.person_add_alt),
                      label: const Text('Create account'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _blockCredentials() {
    if (_credentialsReady) setState(() => _credentialsReady = false);
  }

  void _generateCredentials() {
    if (!(_accountFormKey.currentState?.validate() ?? false)) return;
    setState(() {
      _generatedUsername = _uniqueUsername();
      _generatedPassword = _generatedUsername.toLowerCase() + _curpDigits();
      _credentialsReady = true;
    });
  }

  void _backToAccountData() {
    setState(() => _credentialsReady = false);
  }

  Future<void> _createAccount() async {
    if (!_credentialsReady) return;
    MockRepository.createStaffAccount(
      role: _selectedRole,
      fatherSurname: _fatherSurnameController.text.trim(),
      motherSurname: _motherSurnameController.text.trim(),
      name: _nameController.text.trim(),
      username: _generatedUsername,
      curp: _curpController.text.trim().toUpperCase(),
      password: _generatedPassword,
    );

    await _showAccountDialog();
    if (!mounted) return;
    setState(() {
      _fatherSurnameController.clear();
      _motherSurnameController.clear();
      _nameController.clear();
      _curpController.clear();
      _generatedUsername = '';
      _generatedPassword = '';
      _credentialsReady = false;
    });
  }

  Future<void> _showAccountDialog() {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Account created'),
        content: SelectableText(
          'CURP: ${_curpController.text.trim().toUpperCase()}\n'
          'Username: $_generatedUsername\n'
          'Password: $_generatedPassword',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Accept'),
          ),
          FilledButton.icon(
            onPressed: () {
              Clipboard.setData(
                ClipboardData(
                  text: 'CURP: ${_curpController.text.trim().toUpperCase()}\n'
                      'Username: $_generatedUsername\n'
                      'Password: $_generatedPassword',
                ),
              );
              Navigator.of(context).pop();
              ScaffoldMessenger.of(this.context).showSnackBar(
                const SnackBar(
                    content: Text('Credentials copied to clipboard.')),
              );
            },
            icon: const Icon(Icons.ios_share),
            label: const Text('Share'),
          ),
        ],
      ),
    );
  }

  void _openStudentSignup() {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => const EnrollmentWizardScreen(standalone: true),
      ),
    );
  }

  Future<void> _openManagedUser(AppUser user) async {
    setState(() => _showSuggestions = false);
    if (user.role == UserRole.level4Student) {
      final enrollment = MockRepository.findEnrollmentForUser(user);
      if (enrollment == null) return;
      await Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) => EnrollmentWizardScreen(
            standalone: true,
            initialEnrollment: enrollment,
            canManageActivation: widget.currentUser.role.canManageEnrollment,
            onSaved: () => setState(() {}),
          ),
        ),
      );
    } else {
      await Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) => StaffAccountManagerScreen(
            user: user,
            onSaved: () => setState(() {}),
          ),
        ),
      );
    }
    if (mounted) setState(() {});
  }

  String _uniqueUsername() {
    final name = _cleanName(_nameController.text);
    final fatherSurname = _cleanName(_fatherSurnameController.text);
    for (var length = 1; length <= name.length; length++) {
      final candidate = '${name.substring(0, length)}$fatherSurname';
      if (!MockRepository.usernameExists(candidate)) return candidate;
    }

    var counter = 2;
    var candidate = '$name$fatherSurname$counter';
    while (MockRepository.usernameExists(candidate)) {
      counter += 1;
      candidate = '$name$fatherSurname$counter';
    }
    return candidate;
  }

  String _curpDigits() {
    return RegExp(r'\d')
        .allMatches(_curpController.text)
        .map((match) => match.group(0)!)
        .take(6)
        .join();
  }
}

class StaffAccountManagerScreen extends StatefulWidget {
  const StaffAccountManagerScreen({
    super.key,
    required this.user,
    required this.onSaved,
  });

  final AppUser user;
  final VoidCallback onSaved;

  @override
  State<StaffAccountManagerScreen> createState() =>
      _StaffAccountManagerScreenState();
}

class _StaffAccountManagerScreenState extends State<StaffAccountManagerScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fatherSurnameController;
  late final TextEditingController _motherSurnameController;
  late final TextEditingController _nameController;
  late final TextEditingController _curpController;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late bool _isActive;
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _fatherSurnameController =
        TextEditingController(text: widget.user.fatherSurname);
    _motherSurnameController =
        TextEditingController(text: widget.user.motherSurname);
    _nameController = TextEditingController(text: widget.user.name);
    _curpController = TextEditingController(text: widget.user.curp ?? '');
    _usernameController = TextEditingController(text: widget.user.username);
    _passwordController =
        TextEditingController(text: widget.user.password ?? '');
    _isActive = widget.user.isActive;
  }

  @override
  void dispose() {
    _fatherSurnameController.dispose();
    _motherSurnameController.dispose();
    _nameController.dispose();
    _curpController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Staff account manager')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionHeader(
            title: widget.user.displayName,
            subtitle: '${widget.user.role.label} account',
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _fatherSurnameController,
                      decoration:
                          const InputDecoration(labelText: 'Father surname'),
                      validator: _requiredText,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _motherSurnameController,
                      decoration:
                          const InputDecoration(labelText: 'Mother surname'),
                      validator: _requiredText,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: _requiredText,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _curpController,
                      decoration: const InputDecoration(labelText: 'CURP'),
                      inputFormatters: [UpperCaseTextFormatter()],
                      textCapitalization: TextCapitalization.characters,
                      validator: _curpValidator,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(labelText: 'Username'),
                      inputFormatters: [UpperCaseTextFormatter()],
                      validator: (value) {
                        final text = value?.trim() ?? '';
                        if (text.isEmpty) return 'Required';
                        if (MockRepository.usernameExists(
                          text,
                          exceptUserId: widget.user.id,
                        )) {
                          return 'Username already exists';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          tooltip:
                              _showPassword ? 'Hide password' : 'Show password',
                          onPressed: () => setState(
                            () => _showPassword = !_showPassword,
                          ),
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                      ),
                      obscureText: !_showPassword,
                      validator: _requiredText,
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _saveData,
                            icon: const Icon(Icons.save_outlined),
                            label: const Text('Save data'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _toggleActive,
                            icon: Icon(_isActive
                                ? Icons.person_off_outlined
                                : Icons.person_add_alt),
                            label: Text(
                              _isActive ? 'Disable user' : 'Enable user',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveData() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    MockRepository.updateStaffAccount(
      userId: widget.user.id,
      fatherSurname: _fatherSurnameController.text.trim(),
      motherSurname: _motherSurnameController.text.trim(),
      name: _nameController.text.trim(),
      curp: _curpController.text.trim().toUpperCase(),
      username: _usernameController.text.trim().toUpperCase(),
      password: _passwordController.text.trim(),
    );
    widget.onSaved();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account data saved.')),
    );
    Navigator.of(context).pop();
  }

  void _toggleActive() {
    final updated = MockRepository.setUserActive(widget.user.id, !_isActive);
    if (updated == null) return;
    setState(() => _isActive = updated.isActive);
    widget.onSaved();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(_isActive ? 'Account enabled.' : 'Account disabled.')),
    );
  }
}

class _AccountSearchBox extends StatelessWidget {
  const _AccountSearchBox({
    required this.controller,
    required this.focusNode,
    required this.suggestions,
    required this.showSuggestions,
    required this.onChanged,
    required this.onClear,
    required this.onCloseSuggestions,
    required this.onSuggestionSelected,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final List<AppUser> suggestions;
  final bool showSuggestions;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final VoidCallback onCloseSuggestions;
  final ValueChanged<AppUser> onSuggestionSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: IconButton(
              tooltip: 'Close suggestions',
              onPressed: onCloseSuggestions,
              icon: const Icon(Icons.arrow_back),
            ),
            suffixIcon: IconButton(
              tooltip: 'Clear search',
              onPressed: onClear,
              icon: const Icon(Icons.close),
            ),
            hintText: 'Search accounts',
          ),
        ),
        if (showSuggestions && controller.text.trim().isNotEmpty) ...[
          const SizedBox(height: 4),
          Material(
            elevation: 3,
            borderRadius: BorderRadius.circular(8),
            color: colorScheme.surfaceContainerHighest,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 210),
              child: suggestions.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No matches'),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      itemCount: suggestions.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final user = suggestions[index];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text('L${user.role.clearanceLevel}'),
                          ),
                          title: Text(user.displayName),
                          subtitle: Text(user.curp ?? user.registration ?? ''),
                          onTap: () => onSuggestionSelected(user),
                        );
                      },
                    ),
            ),
          ),
        ],
      ],
    );
  }
}

class _StudentAccountShortcut extends StatelessWidget {
  const _StudentAccountShortcut({required this.onOpen});

  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 34,
                backgroundColor: Color(0xFF145A27),
                foregroundColor: Color(0xFFA5E9A6),
                child: Icon(Icons.person_outline, size: 42),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Student account',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text('Go to Student Sign Up',
                        style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              ),
              FilledButton.tonalIcon(
                onPressed: onOpen,
                icon: const Icon(Icons.arrow_forward),
                label: const SizedBox.shrink(),
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.primaryContainer,
                  minimumSize: const Size(64, 56),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({
    required this.user,
    required this.showManage,
    required this.onManage,
  });

  final AppUser user;
  final bool showManage;
  final VoidCallback onManage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: CircleAvatar(child: Text('L${user.role.clearanceLevel}')),
        title: Text(user.displayName),
        subtitle: Text(
          '${user.role.label} - ${user.username}\n'
          '${user.curp ?? 'No CURP'}'
          '${user.registration == null ? '' : ' - ${user.registration}'}'
          '${user.isActive ? '' : ' - Disabled'}',
        ),
        isThreeLine: true,
        trailing: showManage
            ? FilledButton.tonalIcon(
                onPressed: onManage,
                icon: const Icon(Icons.manage_accounts_outlined),
                label: const Text('Manage'),
              )
            : null,
      ),
    );
  }
}

class _EmptyAccounts extends StatelessWidget {
  const _EmptyAccounts();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text('No accounts to show',
            style: Theme.of(context).textTheme.titleMedium),
      ),
    );
  }
}

class _AdminAction {
  const _AdminAction({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;
}

String _cleanName(String value) {
  return value.trim().toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
}

String? _requiredText(String? value) {
  return value == null || value.trim().isEmpty ? 'Required' : null;
}

String? _curpValidator(String? value) {
  final text = value?.trim().toUpperCase() ?? '';
  if (text.isEmpty) return 'Required';
  if (text.length != 18) return 'CURP must be 18 characters';
  final digits = RegExp(r'\d').allMatches(text).length;
  if (digits < 6) return 'CURP must include at least 6 numbers';
  return null;
}
