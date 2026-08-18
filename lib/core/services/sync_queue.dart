import '../data/mock_repository.dart';

class PendingSyncItem {
  const PendingSyncItem({
    required this.label,
    required this.count,
    required this.module,
  });

  final String label;
  final int count;
  final String module;
}

class SyncQueue {
  List<PendingSyncItem> get pendingItems => [
        if (MockRepository.pendingEnrollmentUploadCount > 0)
          PendingSyncItem(
            label: 'Student sign-up drafts',
            count: MockRepository.pendingEnrollmentUploadCount,
            module: 'Enrollment',
          ),
        if (MockRepository.pendingGradeUploadCount > 0)
          PendingSyncItem(
            label: 'Grading records',
            count: MockRepository.pendingGradeUploadCount,
            module: 'Grades',
          ),
        if (MockRepository.pendingRegistryUploadCount > 0)
          PendingSyncItem(
            label: 'Registry tabs',
            count: MockRepository.pendingRegistryUploadCount,
            module: 'Registry',
          ),
      ];

  int get totalPendingCount =>
      pendingItems.fold(0, (total, item) => total + item.count);
}
