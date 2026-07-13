import 'package:flutter/material.dart';

class StatusTile extends StatelessWidget {
  const StatusTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tileColor = color ?? scheme.primary;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: tileColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(label),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
