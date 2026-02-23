import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/formatting/formatters.dart';
import '../../expenses/presentation/cubit/add_expense_cubit.dart';
import '../../settings/presentation/cubit/settings_cubit.dart';
import '../domain/vehicle.dart';
import 'vehicle_detail_page.dart';
import 'cubit/vehicle_cubit.dart';
import 'cubit/vehicle_state.dart';
import 'widgets/vehicle_card.dart';
import 'widgets/vehicle_form_page.dart';

class VehiclesPage extends StatefulWidget {
  const VehiclesPage({super.key});

  @override
  State<VehiclesPage> createState() => _VehiclesPageState();
}

class _VehiclesPageState extends State<VehiclesPage> {
  @override
  void initState() {
    super.initState();
    context.read<VehicleCubit>().loadVehicles();
  }

  Future<void> _openCreateForm() async {
    final result = await Navigator.of(context).push<VehicleFormResult>(
      MaterialPageRoute(builder: (_) => const VehicleFormPage()),
    );

    if (result == null || !mounted) {
      return;
    }

    await context.read<VehicleCubit>().addVehicle(
      make: result.make,
      model: result.model,
      year: result.year,
      registrationNumber: result.registrationNumber,
      purchaseDate: result.purchaseDate,
      purchasePrice: result.purchasePrice,
      initialMileage: result.initialMileage,
      nickname: result.nickname,
      serviceIntervalKm: result.serviceIntervalKm,
      lastServiceMileage: result.lastServiceMileage,
      lastServiceDate: result.lastServiceDate,
      licenseExpiryDate: result.licenseExpiryDate,
    );
    if (mounted) {
      await context.read<AddExpenseCubit>().loadVehicles();
    }
  }

  Future<void> _openEditForm(Vehicle vehicle) async {
    final result = await Navigator.of(context).push<VehicleFormResult>(
      MaterialPageRoute(
        builder: (_) => VehicleFormPage(initialVehicle: vehicle),
      ),
    );

    if (result == null || !mounted) {
      return;
    }

    await context.read<VehicleCubit>().updateVehicle(
      Vehicle(
        id: vehicle.id,
        make: result.make,
        model: result.model,
        year: result.year,
        registrationNumber: result.registrationNumber,
        purchaseDate: result.purchaseDate,
        purchasePrice: result.purchasePrice,
        initialMileage: result.initialMileage,
        nickname: result.nickname,
        serviceIntervalKm: result.serviceIntervalKm,
        lastServiceMileage: result.lastServiceMileage,
        lastServiceDate: result.lastServiceDate,
        licenseExpiryDate: result.licenseExpiryDate,
        serviceReminderSnoozedUntil: vehicle.serviceReminderSnoozedUntil,
        serviceReminderRescheduledMileage:
            vehicle.serviceReminderRescheduledMileage,
        serviceReminderRescheduledDate: vehicle.serviceReminderRescheduledDate,
        serviceReminderLastDoneAt: vehicle.serviceReminderLastDoneAt,
        licenseReminderSnoozedUntil: vehicle.licenseReminderSnoozedUntil,
        licenseReminderRescheduledDate: vehicle.licenseReminderRescheduledDate,
        licenseReminderLastDoneAt: vehicle.licenseReminderLastDoneAt,
      ),
    );
    if (mounted) {
      await context.read<AddExpenseCubit>().loadVehicles();
    }
  }

  Future<void> _confirmDelete(Vehicle vehicle) async {
    final shouldDelete =
        await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Delete vehicle?'),
              content: Text(
                'This will also remove expenses for ${vehicle.displayName}.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        ) ??
        false;

    if (!shouldDelete || !mounted) {
      return;
    }

    await context.read<VehicleCubit>().deleteVehicle(vehicle.id);
    if (mounted) {
      await context.read<AddExpenseCubit>().loadVehicles();
    }
  }

  Future<void> _openVehicleDetail(Vehicle vehicle) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(builder: (_) => VehicleDetailPage(vehicle: vehicle)),
    );
    if (mounted) {
      await context.read<VehicleCubit>().loadVehicles();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VehicleCubit, VehicleState>(
      listener: (context, state) {
        if (state.status == VehicleStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (context, state) {
        final theme = Theme.of(context);
        final preferences = context.select(
          (SettingsCubit cubit) => cubit.state.preferences,
        );
        final vehicles = state.vehicles;
        final totalPurchaseValue = vehicles.fold<double>(
          0,
          (sum, v) => sum + v.purchasePrice,
        );

        return Scaffold(
          backgroundColor: const Color(0xFFF2F6FB),
          body: SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: -90,
                  right: -80,
                  child: _BackgroundOrb(
                    diameter: 220,
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  ),
                ),
                Positioned(
                  top: 100,
                  left: -75,
                  child: _BackgroundOrb(
                    diameter: 170,
                    color: theme.colorScheme.tertiary.withValues(alpha: 0.18),
                  ),
                ),
                Positioned(
                  bottom: -95,
                  right: -45,
                  child: _BackgroundOrb(
                    diameter: 210,
                    color: theme.colorScheme.secondary.withValues(alpha: 0.16),
                  ),
                ),
                RefreshIndicator(
                  onRefresh: context.read<VehicleCubit>().loadVehicles,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    children: [
                      _GlassSection(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Vehicles',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Track every ride, expenses, and reminders with a cleaner overview.',
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                FilledButton.icon(
                                  onPressed: _openCreateForm,
                                  icon: const Icon(Icons.add),
                                  label: const Text('Add Vehicle'),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    '${vehicles.length} registered',
                                    textAlign: TextAlign.right,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      if (vehicles.isNotEmpty)
                        _GlassSection(
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: theme.colorScheme.primary.withValues(
                                    alpha: 0.14,
                                  ),
                                ),
                                child: Icon(
                                  Icons.payments_rounded,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total purchase value',
                                      style: theme.textTheme.labelLarge,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      Formatters.currency(
                                        totalPurchaseValue,
                                        currencyCode: preferences.currencyCode,
                                        currencySymbol:
                                            preferences.currencySymbol,
                                      ),
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 14),
                      if (state.status == VehicleStatus.loading)
                        const Padding(
                          padding: EdgeInsets.all(32),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (vehicles.isEmpty)
                        _GlassSection(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'No vehicles yet',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Add your first vehicle to start logging expenses, reminders, and reports.',
                                style: theme.textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 14),
                              FilledButton.icon(
                                onPressed: _openCreateForm,
                                icon: const Icon(Icons.add),
                                label: const Text('Add Vehicle'),
                              ),
                            ],
                          ),
                        )
                      else
                        ...vehicles.map(
                          (vehicle) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: VehicleCard(
                              vehicle: vehicle,
                              distanceUnit: preferences.distanceUnit,
                              onTap: () => _openVehicleDetail(vehicle),
                              onEdit: () => _openEditForm(vehicle),
                              onDelete: () => _confirmDelete(vehicle),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BackgroundOrb extends StatelessWidget {
  const _BackgroundOrb({required this.diameter, required this.color});

  final double diameter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}

class _GlassSection extends StatelessWidget {
  const _GlassSection({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
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
                Colors.white.withValues(alpha: 0.27),
                Colors.white.withValues(alpha: 0.11),
              ],
            ),
          ),
          child: Padding(padding: const EdgeInsets.all(18), child: child),
        ),
      ),
    );
  }
}
