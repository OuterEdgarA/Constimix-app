import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../core/models/user_role.dart';

class RoleBadge extends StatelessWidget {
  const RoleBadge({super.key, required this.role});

  final UserRole role;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    final roleLabel = switch(role) {
      UserRole.level1Admin => l10n.roleSystemAdmin,
      UserRole.level2SemesterAdmin => l10n.roleSemesterAdmin,
      UserRole.level3Teacher => l10n.roleTeacher,
      UserRole.level4Student => l10n.roleStudent,
    };

    return Tooltip(
      message: l10n.clearanceLevel(role.clearanceLevel),
      child: Chip(
        avatar: CircleAvatar(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          child: Text(role.clearanceLevel.toString()),
        ),
        label: Text(roleLabel),
        side: BorderSide(color: scheme.outlineVariant),
      ),
    );
  }
}
