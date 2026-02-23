import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../expenses/domain/expense_repository.dart';
import '../../vehicles/domain/vehicle_repository.dart';
import 'cubit/reports_cubit.dart';
import 'cubit/reports_state.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReportsCubit(
        context.read<VehicleRepository>(),
        context.read<ExpenseRepository>(),
      )..load(),
      child: const _ReportsView(),
    );
  }
}

class _ReportsView extends StatelessWidget {
  const _ReportsView();

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.simpleCurrency();

    return BlocConsumer<ReportsCubit, ReportsState>(
      listener: (context, state) {
        if (state.status == ReportsStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: context.read<ReportsCubit>().load,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Reports', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                'Portfolio totals, category spend, and baseline running cost per km.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              if (state.status == ReportsStatus.loading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: CircularProgressIndicator()),
                )
              else ...[
                Card(
                  child: ListTile(
                    title: const Text('Total ownership cost'),
                    subtitle: const Text(
                      'Purchase totals + all logged expenses',
                    ),
                    trailing: Text(
                      currency.format(state.totalOwnershipCost),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text('Total purchase value'),
                    trailing: Text(
                      currency.format(state.totalPurchase),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text('Total logged expenses'),
                    trailing: Text(
                      currency.format(state.totalExpenses),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text('Cost/km baseline'),
                    subtitle: Text(
                      state.costPerKmBaseline == null
                          ? 'No odometer data yet. Add mileage on expenses to unlock this metric.'
                          : 'Based on ${state.baselineVehicleCount} vehicle(s) with mileage logs.',
                    ),
                    trailing: Text(
                      state.costPerKmBaseline == null
                          ? 'N/A'
                          : '${currency.format(state.costPerKmBaseline)}/km',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Category breakdown',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (state.categoryBreakdown.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'No expenses logged yet.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  )
                else
                  ...state.categoryBreakdown.map(
                    (entry) => Card(
                      child: ListTile(
                        title: Text(entry.category.label),
                        trailing: Text(
                          currency.format(entry.total),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                    ),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }
}
