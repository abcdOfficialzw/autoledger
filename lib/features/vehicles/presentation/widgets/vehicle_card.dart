import 'dart:ui';

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
    final theme = Theme.of(context);
    final nickname = vehicle.nickname?.trim();
    final currentKnownMileage = (vehicle.lastServiceMileage != null &&
            vehicle.lastServiceMileage! > vehicle.initialMileage)
        ? vehicle.lastServiceMileage!
        : vehicle.initialMileage;
    final accruedMileage = currentKnownMileage - vehicle.initialMileage;
    final nextServiceDate =
        vehicle.serviceReminderRescheduledDate ??
        (vehicle.lastServiceDate?.add(const Duration(days: 180)));
    final serviceBaseMileage =
        vehicle.lastServiceMileage ?? vehicle.initialMileage;
    final nextServiceMileage = vehicle.serviceIntervalKm == null
        ? null
        : serviceBaseMileage + vehicle.serviceIntervalKm!;
    final nextServiceLabel = nextServiceDate != null
        ? Formatters.date(nextServiceDate)
        : nextServiceMileage != null
            ? 'At ${Formatters.number(distanceUnit.fromKilometers(nextServiceMileage))} ${distanceUnit.shortLabel}'
            : 'Not set';
    final licenseRenewalDate = vehicle.licenseExpiryDate;
    final subtitle = nickname != null && nickname.isNotEmpty
        ? '${vehicle.make} ${vehicle.model} • ${vehicle.year}'
        : '${vehicle.year} • ${vehicle.registrationNumber}';
    final seed = vehicle.id.hashCode ^ vehicle.displayName.hashCode;
    final avatarBase = HSLColor.fromAHSL(
      1,
      (seed % 360).toDouble(),
      0.72,
      0.58,
    ).toColor();

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.42),
              width: 1.1,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.23),
                Colors.white.withValues(alpha: 0.1),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.16),
                blurRadius: 24,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(24),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.56),
                          width: 1.1,
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            avatarBase.withValues(alpha: 0.95),
                            avatarBase.withValues(alpha: 0.45),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: avatarBase.withValues(alpha: 0.38),
                            blurRadius: 12,
                            offset: const Offset(0, 7),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.directions_car_filled_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            vehicle.displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${vehicle.registrationNumber} • ${Formatters.number(distanceUnit.fromKilometers(vehicle.initialMileage))} ${distanceUnit.shortLabel}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              _InfoChipCompact(
                                icon: Icons.build_circle_outlined,
                                text: 'Service: $nextServiceLabel',
                              ),
                              _InfoChipCompact(
                                icon: Icons.event_available_outlined,
                                text: licenseRenewalDate == null
                                    ? 'License: Not set'
                                    : 'License: ${Formatters.date(licenseRenewalDate)}',
                              ),
                              _InfoChipCompact(
                                icon: Icons.speed_outlined,
                                text:
                                    'Accrued: ${Formatters.number(distanceUnit.fromKilometers(accruedMileage))} ${distanceUnit.shortLabel}',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right_rounded),
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
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoChipCompact extends StatelessWidget {
  const _InfoChipCompact({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.68)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12.5, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 4),
            Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
