import 'package:flutter/material.dart';

import '../../core/models/user_role.dart';

class RoleBadge extends StatelessWidget {
  const RoleBadge({super.key, required this.role});

  final UserRole role;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: 'Clearance level ${role.clearanceLevel}',
      child: Chip(
        avatar: CircleAvatar(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          child: Text(role.clearanceLevel.toString()),
        ),
        label: Text(role.label),
        side: BorderSide(color: scheme.outlineVariant),
      ),
    );
  }
}
