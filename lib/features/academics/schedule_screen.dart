import 'package:flutter/material.dart';

import '../../core/data/mock_repository.dart';
import '../../core/models/app_user.dart';
import '../../core/models/user_role.dart';
import '../../shared/widgets/section_header.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key, required this.currentUser});

  final AppUser currentUser;

  @override
  Widget build(BuildContext context) {
    final role = currentUser.role;
    final items = MockRepository.schedules.where((item) {
      if (role.canAccessAllSchedules) return true;
      return item.semester == currentUser.semester && item.group == currentUser.group;
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionHeader(
          title: 'Schedule',
          subtitle: role.canAccessAllSchedules
              ? 'Showing all visible groups and semesters.'
              : 'Showing your semester and group only.',
          trailing: IconButton(
            tooltip: 'Filter',
            onPressed: () {},
            icon: const Icon(Icons.filter_list),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            labelText: 'Search subject, teacher, group',
          ),
          onChanged: (_) {},
        ),
        const SizedBox(height: 16),
        for (final item in items) ...[
          Card(
            child: ListTile(
              leading: const Icon(Icons.schedule),
              title: Text(item.subject),
              subtitle: Text('${item.teacher} - ${item.day} ${item.startTime}-${item.endTime}'),
              trailing: Text('${item.semester}${item.group}'),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}
