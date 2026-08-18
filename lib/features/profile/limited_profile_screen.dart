import 'package:flutter/material.dart';

import '../../core/data/mock_repository.dart';
import '../../core/models/app_user.dart';
import '../../shared/widgets/section_header.dart';

class LimitedProfileScreen extends StatefulWidget {
  const LimitedProfileScreen({
    super.key,
    required this.user,
    this.embedded = false,
    this.onSaved,
    this.onSignedOut,
  });

  final AppUser user;
  final bool embedded;
  final ValueChanged<AppUser>? onSaved;
  final VoidCallback? onSignedOut;

  @override
  State<LimitedProfileScreen> createState() => _LimitedProfileScreenState();
}

class _LimitedProfileScreenState extends State<LimitedProfileScreen> {
  static const _avatarIcons = [
    Icons.person,
    Icons.school,
    Icons.menu_book,
    Icons.badge,
    Icons.account_circle,
  ];

  late AppUser _user;
  late final TextEditingController _passwordController;
  late int _avatarIndex;
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _passwordController = TextEditingController(text: _user.password ?? '');
    _avatarIndex = _user.profileAvatarIndex;
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = ListView(
      shrinkWrap: widget.embedded,
      physics: widget.embedded ? const NeverScrollableScrollPhysics() : null,
      padding: widget.embedded ? EdgeInsets.zero : const EdgeInsets.all(16),
      children: [
        if (!widget.embedded) ...[
          const SectionHeader(
            title: 'Profile',
            subtitle: 'Account credentials and profile icon',
          ),
          const SizedBox(height: 16),
        ],
        TextFormField(
          initialValue: _user.username,
          readOnly: true,
          decoration: const InputDecoration(labelText: 'Username'),
        ),
        const SizedBox(height: 12),
        TextFormField(
          initialValue: _user.displayName,
          readOnly: true,
          decoration: const InputDecoration(labelText: 'Full name'),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _passwordController,
          obscureText: !_showPassword,
          decoration: InputDecoration(
            labelText: 'Password',
            suffixIcon: IconButton(
              tooltip: _showPassword ? 'Hide password' : 'Show password',
              onPressed: () => setState(() => _showPassword = !_showPassword),
              icon: Icon(
                _showPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('Profile icon', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (var index = 0; index < _avatarIcons.length; index++)
              ChoiceChip(
                selected: _avatarIndex == index,
                showCheckmark: false,
                label: CircleAvatar(child: Icon(_avatarIcons[index])),
                onSelected: (_) => setState(() => _avatarIndex = index),
              ),
          ],
        ),
        const SizedBox(height: 18),
        FilledButton.icon(
          onPressed: _save,
          icon: const Icon(Icons.save_outlined),
          label: const Text('Save profile'),
        ),
        if (!widget.embedded && widget.onSignedOut != null) ...[
          const SizedBox(height: 18),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.error,
              ),
              title: const Text('Sign out'),
              subtitle: const Text('Return to the sign-in screen.'),
              onTap: widget.onSignedOut,
            ),
          ),
        ],
      ],
    );

    if (!widget.embedded) return content;
    return Card(
      child: ExpansionTile(
        leading: CircleAvatar(
          child: Icon(_avatarIcons[_avatarIndex % _avatarIcons.length]),
        ),
        title: const Text('Profile'),
        subtitle: Text(_user.displayName),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [content],
      ),
    );
  }

  void _save() {
    final password = _passwordController.text.trim();
    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password is required.')),
      );
      return;
    }
    final updated = MockRepository.updateLimitedProfile(
      userId: _user.id,
      password: password,
      profileAvatarIndex: _avatarIndex,
    );
    if (updated == null) return;
    setState(() => _user = updated);
    widget.onSaved?.call(updated);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated.')),
    );
  }
}
