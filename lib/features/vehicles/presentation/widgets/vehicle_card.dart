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
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
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
                    const SizedBox(width: 14),
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
                          const SizedBox(height: 9),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final wide = constraints.maxWidth >= 330;
                              final tileWidth = wide
                                  ? (constraints.maxWidth - 8) / 2
                                  : constraints.maxWidth;

                              return Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  _InfoStatTile(
                                    width: tileWidth,
                                    icon: Icons.build_circle_outlined,
                                    title: 'Next service',
                                    value: nextServiceDate == null
                                        ? 'Not set'
                                        : Formatters.date(nextServiceDate),
                                  ),
                                  _InfoStatTile(
                                    width: tileWidth,
                                    icon: Icons.event_available_outlined,
                                    title: 'License renewal',
                                    value: licenseRenewalDate == null
                                        ? 'Not set'
                                        : Formatters.date(licenseRenewalDate),
                                  ),
                                  _InfoStatTile(
                                    width: wide ? constraints.maxWidth : tileWidth,
                                    icon: Icons.speed_outlined,
                                    title: 'Accrued mileage',
                                    value:
                                        '${Formatters.number(distanceUnit.fromKilometers(accruedMileage))} ${distanceUnit.shortLabel}',
                                  ),
                                ],
                              );
                            },
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

class _InfoStatTile extends StatelessWidget {
  const _InfoStatTile({
    required this.width,
    required this.icon,
    required this.title,
    required this.value,
  });

  final double width;
  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.46),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.72)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              Icon(icon, size: 15, color: theme.colorScheme.primary),
              const SizedBox(width: 7),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
