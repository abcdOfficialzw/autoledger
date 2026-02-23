import 'package:flutter/material.dart';

class BackupRestoreGuidancePage extends StatelessWidget {
  const BackupRestoreGuidancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Backup & restore guidance')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _GuidanceCard(
            icon: Icons.security_outlined,
            title: 'Before you export',
            description:
                'Make sure your latest expenses and vehicle edits are saved. Export only from a trusted device.',
          ),
          SizedBox(height: 12),
          _GuidanceCard(
            icon: Icons.backup_outlined,
            title: 'Backup routine',
            description:
                'Keep at least two backups in separate locations. Rename files with a date so old versions are easy to track.',
          ),
          SizedBox(height: 12),
          _GuidanceCard(
            icon: Icons.restore_page_outlined,
            title: 'Before restore/import',
            description:
                'Verify the source file, then review current data and create a fresh export before importing another snapshot.',
          ),
          SizedBox(height: 12),
          _GuidanceCard(
            icon: Icons.warning_amber_rounded,
            title: 'Safety note',
            description:
                'Use Settings reset only for app preferences. It does not delete vehicles or expenses in storage.',
          ),
        ],
      ),
    );
  }
}

class _GuidanceCard extends StatelessWidget {
  const _GuidanceCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
