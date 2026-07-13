class PendingSyncItem {
  const PendingSyncItem({
    required this.label,
    required this.createdAt,
    required this.module,
  });

  final String label;
  final DateTime createdAt;
  final String module;
}

class SyncQueue {
  final List<PendingSyncItem> _items = [
    PendingSyncItem(
      label: 'Enrollment draft saved locally',
      createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
      module: 'Enrollment',
    ),
    PendingSyncItem(
      label: 'Grade table awaiting upload',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      module: 'Academics',
    ),
  ];

  List<PendingSyncItem> get pendingItems => List.unmodifiable(_items);
}
