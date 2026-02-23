import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../expenses/presentation/cubit/add_expense_cubit.dart';
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
  final _currency = NumberFormat.simpleCurrency();

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
        final vehicles = state.vehicles;

        return Scaffold(
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: context.read<VehicleCubit>().loadVehicles,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'Vehicles',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Track each vehicle and open details for latest expense history.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  if (state.status == VehicleStatus.loading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (vehicles.isEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'No vehicles yet',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Add your first vehicle to start logging expenses and reports.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 12),
                            FilledButton.icon(
                              onPressed: _openCreateForm,
                              icon: const Icon(Icons.add),
                              label: const Text('Add Vehicle'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...vehicles.map(
                      (vehicle) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: VehicleCard(
                          vehicle: vehicle,
                          onTap: () => _openVehicleDetail(vehicle),
                          onEdit: () => _openEditForm(vehicle),
                          onDelete: () => _confirmDelete(vehicle),
                        ),
                      ),
                    ),
                  if (vehicles.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
                      child: Text(
                        'Total purchase value: ${_currency.format(vehicles.fold<double>(0, (sum, v) => sum + v.purchasePrice))}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _openCreateForm,
            icon: const Icon(Icons.add),
            label: const Text('Add Vehicle'),
          ),
        );
      },
    );
  }
}
