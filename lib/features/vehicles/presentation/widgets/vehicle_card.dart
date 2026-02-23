import 'package:flutter/material.dart';

import '../../../settings/domain/app_preferences.dart';
import '../../domain/vehicle.dart';
import '../../../../core/formatting/formatters.dart';

class VehicleCard extends StatelessWidget {
  const VehicleCard({
    super.key,
    required this.vehicle,
    required this.distanceUnit,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final Vehicle vehicle;
  final DistanceUnit distanceUnit;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final nickname = vehicle.nickname?.trim();
    final subtitle = nickname != null && nickname.isNotEmpty
        ? '${vehicle.make} ${vehicle.model} • ${vehicle.year}'
        : '${vehicle.year} • ${vehicle.registrationNumber}';

    return Card(
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(vehicle.displayName),
        subtitle: Text(
          '$subtitle\n${vehicle.registrationNumber} • ${Formatters.number(distanceUnit.fromKilometers(vehicle.initialMileage))} ${distanceUnit.shortLabel}',
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.chevron_right),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit();
                } else if (value == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
