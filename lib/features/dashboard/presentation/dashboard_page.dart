import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/formatting/formatters.dart';
import '../../expenses/domain/expense_repository.dart';
import '../../expenses/presentation/add_expense_page.dart';
import '../../settings/domain/app_preferences.dart';
import '../../settings/presentation/cubit/settings_cubit.dart';
import '../../shell/presentation/navigation_cubit.dart';
import '../../vehicles/domain/vehicle.dart';
import '../../vehicles/domain/vehicle_repository.dart';
import '../../vehicles/presentation/cubit/vehicle_cubit.dart';
import '../../vehicles/presentation/cubit/vehicle_state.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<_DashboardMetrics> _metricsFuture;

  @override
  void initState() {
    super.initState();
    _metricsFuture = _loadMetrics();
    context.read<VehicleCubit>().loadVehicles();
  }

  Future<void> _refreshSnapshot() async {
    final vehicleCubit = context.read<VehicleCubit>();
    setState(() {
      _metricsFuture = _loadMetrics();
    });
    await vehicleCubit.loadVehicles();
    await _metricsFuture;
  }

  Future<_DashboardMetrics> _loadMetrics() async {
    final vehicleRepository = context.read<VehicleRepository>();
    final expenseRepository = context.read<ExpenseRepository>();
    final vehicles = await vehicleRepository.getVehicles();
    final allExpenses = await expenseRepository.getAllExpenses();
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);

    final totalVehicleValue = vehicles.fold<double>(
      0,
      (sum, vehicle) => sum + vehicle.purchasePrice,
    );
    final monthExpenses = allExpenses
        .where((expense) => !expense.date.isBefore(monthStart))
        .fold<double>(0, (sum, expense) => sum + expense.amount);
    final totalExpenses = allExpenses.fold<double>(
      0,
      (sum, expense) => sum + expense.amount,
    );

    return _DashboardMetrics(
      vehicleCount: vehicles.length,
      totalVehicleValue: totalVehicleValue,
      monthExpenses: monthExpenses,
      totalExpenses: totalExpenses,
    );
  }

  void _goToTab(int index) {
    context.read<NavigationCubit>().setIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    final preferences = context.select(
      (SettingsCubit cubit) => cubit.state.preferences,
    );

    return BlocBuilder<VehicleCubit, VehicleState>(
      builder: (context, state) {
        final vehicles = state.vehicles;
        return DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFE2F3EF), Color(0xFFF3F8FF), Color(0xFFF6F5FF)],
            ),
          ),
          child: RefreshIndicator(
            onRefresh: _refreshSnapshot,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 120),
              children: [
                const _HeroPanel(),
                const SizedBox(height: 16),
                _ActionPanel(
                  onAddExpense: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const AddExpensePage(),
                      ),
                    );
                  },
                  onVehicles: () => _goToTab(1),
                  onReports: () => _goToTab(2),
                ),
                const SizedBox(height: 16),
                FutureBuilder<_DashboardMetrics>(
                  future: _metricsFuture,
                  builder: (context, snapshot) {
                    final metrics = snapshot.data;
                    return _MetricsPanel(
                      isLoading:
                          snapshot.connectionState == ConnectionState.waiting &&
                          metrics == null,
                      vehicleCount: metrics?.vehicleCount ?? vehicles.length,
                      totalVehicleValue:
                          metrics?.totalVehicleValue ??
                          vehicles.fold<double>(
                            0,
                            (sum, vehicle) => sum + vehicle.purchasePrice,
                          ),
                      monthExpenses: metrics?.monthExpenses ?? 0,
                      totalExpenses: metrics?.totalExpenses ?? 0,
                      currencyCode: preferences.currencyCode,
                      currencySymbol: preferences.currencySymbol,
                    );
                  },
                ),
                const SizedBox(height: 16),
                _VehicleSnapshotPanel(
                  vehicles: vehicles,
                  distanceUnitLabel: preferences.distanceUnit.shortLabel,
                  onOpenVehicles: () => _goToTab(1),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel();

  @override
  Widget build(BuildContext context) {
    return _GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dashboard', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 6),
          Text(
            'Quick pulse of your fleet and costs.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _ActionPanel extends StatelessWidget {
  const _ActionPanel({
    required this.onAddExpense,
    required this.onVehicles,
    required this.onReports,
  });

  final VoidCallback onAddExpense;
  final VoidCallback onVehicles;
  final VoidCallback onReports;

  @override
  Widget build(BuildContext context) {
    return _GlassPanel(
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          FilledButton.icon(
            onPressed: onAddExpense,
            icon: const Icon(Icons.add_card),
            label: const Text('Add expense'),
          ),
          FilledButton.tonalIcon(
            onPressed: onVehicles,
            icon: const Icon(Icons.directions_car),
            label: const Text('Go to vehicles'),
          ),
          FilledButton.tonalIcon(
            onPressed: onReports,
            icon: const Icon(Icons.bar_chart),
            label: const Text('Go to reports'),
          ),
        ],
      ),
    );
  }
}

class _MetricsPanel extends StatelessWidget {
  const _MetricsPanel({
    required this.isLoading,
    required this.vehicleCount,
    required this.totalVehicleValue,
    required this.monthExpenses,
    required this.totalExpenses,
    required this.currencyCode,
    required this.currencySymbol,
  });

  final bool isLoading;
  final int vehicleCount;
  final double totalVehicleValue;
  final double monthExpenses;
  final double totalExpenses;
  final String currencyCode;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const _GlassPanel(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 18),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final metrics = [
      ('Vehicles', '$vehicleCount'),
      (
        'Fleet value',
        Formatters.currency(
          totalVehicleValue,
          currencyCode: currencyCode,
          currencySymbol: currencySymbol,
        ),
      ),
      (
        'This month',
        Formatters.currency(
          monthExpenses,
          currencyCode: currencyCode,
          currencySymbol: currencySymbol,
        ),
      ),
      (
        'Lifetime spend',
        Formatters.currency(
          totalExpenses,
          currencyCode: currencyCode,
          currencySymbol: currencySymbol,
        ),
      ),
    ];

    return _GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick overview', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: metrics.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.2,
            ),
            itemBuilder: (context, index) => _MetricTile(
              label: metrics[index].$1,
              value: metrics[index].$2,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.64),
        border: Border.all(color: Colors.white.withOpacity(0.7)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 6),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _VehicleSnapshotPanel extends StatelessWidget {
  const _VehicleSnapshotPanel({
    required this.vehicles,
    required this.distanceUnitLabel,
    required this.onOpenVehicles,
  });

  final List<Vehicle> vehicles;
  final String distanceUnitLabel;
  final VoidCallback onOpenVehicles;

  @override
  Widget build(BuildContext context) {
    return _GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Vehicle snapshots',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextButton(
                onPressed: onOpenVehicles,
                child: const Text('View all'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (vehicles.isEmpty)
            Text(
              'No vehicles yet. Use "Go to vehicles" to add your first one.',
              style: Theme.of(context).textTheme.bodyMedium,
            )
          else
            ...vehicles.take(4).map(
              (vehicle) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.7),
                        Colors.white.withOpacity(0.52),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.75),
                    ),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.directions_car_filled_outlined),
                    title: Text(vehicle.displayName),
                    subtitle: Text(
                      '${vehicle.registrationNumber} • ${Formatters.number(vehicle.initialMileage)} $distanceUnitLabel',
                    ),
                    trailing: Text('${vehicle.year}'),
                    onTap: onOpenVehicles,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _GlassPanel extends StatelessWidget {
  const _GlassPanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.72)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.66),
                Colors.white.withOpacity(0.42),
              ],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Padding(padding: const EdgeInsets.all(16), child: child),
        ),
      ),
    );
  }
}

class _DashboardMetrics {
  const _DashboardMetrics({
    required this.vehicleCount,
    required this.totalVehicleValue,
    required this.monthExpenses,
    required this.totalExpenses,
  });

  final int vehicleCount;
  final double totalVehicleValue;
  final double monthExpenses;
  final double totalExpenses;
}
