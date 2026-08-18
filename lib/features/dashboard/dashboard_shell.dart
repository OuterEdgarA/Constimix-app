import 'package:flutter/material.dart';

import '../../core/data/mock_repository.dart';
import '../../core/models/app_user.dart';
import '../../core/models/user_role.dart';
import '../../core/services/sync_queue.dart';
import '../../features/academics/grades_screen.dart';
import '../../features/academics/schedule_screen.dart';
import '../../features/admin/admin_hub_screen.dart';
import '../../features/admin/semester_admin_screen.dart';
import '../../features/community/community_board_screen.dart';
import '../../features/enrollment/enrollment_table_screen.dart';

import '../../features/profile/limited_profile_screen.dart';
import '../../shared/widgets/role_badge.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/status_tile.dart';

class DashboardShell extends StatefulWidget {
  const DashboardShell({
    super.key,
    required this.currentUser,
    required this.onSignedOut,
    this.isDarkMode = false,
    this.onThemeChanged,
  });

  final AppUser currentUser;
  final VoidCallback onSignedOut;
  final bool isDarkMode;
  final ValueChanged<bool>? onThemeChanged;

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  final SyncQueue _syncQueue = SyncQueue();
  int _selectedIndex = 0;

  late final List<_Destination> _destinations = [
    _Destination(
      label: 'Home',
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      builder: (_) => _HomeScreen(
        user: widget.currentUser,
        syncQueue: _syncQueue,
      ),
    ),
    _Destination(
      label: 'Board',
      icon: Icons.forum_outlined,
      selectedIcon: Icons.forum,
      builder: (_) => CommunityBoardScreen(currentUser: widget.currentUser),
    ),
    if (widget.currentUser.role.canManageEnrollment)
      _Destination(
        label: 'Enroll',
        icon: Icons.app_registration_outlined,
        selectedIcon: Icons.app_registration,
        builder: (_) => const EnrollmentTableScreen(canManageActivation: true),
      ),
    _Destination(
      label: 'Schedule',
      icon: Icons.calendar_month_outlined,
      selectedIcon: Icons.calendar_month,
      builder: (_) => ScheduleScreen(currentUser: widget.currentUser),
    ),
    _Destination(
      label: 'Grades',
      icon: Icons.fact_check_outlined,
      selectedIcon: Icons.fact_check,
      builder: (_) => GradesScreen(currentUser: widget.currentUser),
    ),
    if (widget.currentUser.role == UserRole.level3Teacher ||
        widget.currentUser.role == UserRole.level4Student)
      _Destination(
        label: 'Profile',
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        builder: (_) => LimitedProfileScreen(
          user: MockRepository.users.firstWhere(
            (user) => user.id == widget.currentUser.id,
          ),
          onSignedOut: widget.onSignedOut,
        ),
      ),
    if (widget.currentUser.role == UserRole.level1Admin ||
        widget.currentUser.role == UserRole.level2SemesterAdmin)
      _Destination(
        label: 'Admin',
        icon: Icons.admin_panel_settings_outlined,
        selectedIcon: Icons.admin_panel_settings,
        builder: (_) => widget.currentUser.role == UserRole.level1Admin
            ? AdminHubScreen(
                currentUser: widget.currentUser,
                onSignedOut: widget.onSignedOut,
              )
            : SemesterAdminScreen(
                currentUser: widget.currentUser,
                onSignedOut: widget.onSignedOut,
              ),
      ),
  ];

  @override
  Widget build(BuildContext context) {
    final selected = _destinations[_selectedIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('#YoSoyConstiMix'),
        actions: [
          Tooltip(
            message: widget.isDarkMode ? 'Use light mode' : 'Use dark mode',
            child: Switch.adaptive(
              value: widget.isDarkMode,
              onChanged: widget.onThemeChanged,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: selected.builder(context),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: [
          for (final destination in _destinations)
            NavigationDestination(
              icon: Icon(destination.icon),
              selectedIcon: Icon(destination.selectedIcon),
              label: destination.label,
            ),
        ],
      ),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen({required this.user, required this.syncQueue});

  final AppUser user;
  final SyncQueue syncQueue;

  @override
  Widget build(BuildContext context) {
    final role = user.role;
    final cycle = MockRepository.activeCycle;
    final welcomeName = [user.fatherSurname, user.name]
        .where((part) => part.trim().isNotEmpty)
        .join(' ');

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionHeader(
          title:
              'Welcome, ${welcomeName.isEmpty ? user.displayName : welcomeName}',
          subtitle: 'Your school overview',
          trailing: RoleBadge(role: role),
        ),
        const SizedBox(height: 16),
        StatusTile(
          icon: Icons.calendar_month_outlined,
          value: cycle?.name ?? 'No cycle selected',
          label: 'Active cycle',
        ),
        const SizedBox(height: 8),
        StatusTile(
          icon: Icons.cloud_off_outlined,
          value: '${syncQueue.totalPendingCount}',
          label: 'Pending offline sync items',
          onTap: () => _showPendingSync(context),
        ),
        const SizedBox(height: 8),
        StatusTile(
          icon: Icons.security_outlined,
          value: 'Level ${role.clearanceLevel}',
          label: role.label,
          color: Theme.of(context).colorScheme.secondary,
        ),
        const SizedBox(height: 16),
        const SectionHeader(title: 'Available tools'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            const Chip(label: Text('Community board')),
            const Chip(label: Text('Schedule')),
            const Chip(label: Text('Grades')),
            if (role.canManageEnrollment) const Chip(label: Text('Enrollment')),
            if (role.canGrade &&
                (role != UserRole.level3Teacher ||
                    MockRepository.gradingPeriodActive))
              const Chip(label: Text('Grading tool')),
            if (role == UserRole.level1Admin) const Chip(label: Text('Admin')),
          ],
        ),
      ],
    );
  }

  Future<void> _showPendingSync(BuildContext context) {
    final items = syncQueue.pendingItems;
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Pending offline sync',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              if (items.isEmpty)
                const ListTile(
                  leading: Icon(Icons.cloud_done_outlined),
                  title: Text('Everything is synced'),
                )
              else
                for (final item in items)
                  ListTile(
                    leading: Icon(
                      switch (item.module) {
                        'Enrollment' => Icons.person_add_alt_outlined,
                        'Grades' => Icons.fact_check_outlined,
                        _ => Icons.menu_book_outlined,
                      },
                    ),
                    title: Text(item.label),
                    subtitle: Text(item.module),
                    trailing: Text('${item.count}'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Destination {
  const _Destination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.builder,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final WidgetBuilder builder;
}
