import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../expenses/domain/expense.dart';
import '../../expenses/domain/expense_repository.dart';
import '../domain/vehicle.dart';
import 'cubit/vehicle_detail_cubit.dart';
import 'cubit/vehicle_detail_state.dart';

class VehicleDetailPage extends StatelessWidget {
  const VehicleDetailPage({required this.vehicle, super.key});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          VehicleDetailCubit(context.read<ExpenseRepository>())
            ..loadExpenses(vehicle.id),
      child: _VehicleDetailView(vehicle: vehicle),
    );
  }
}

class _VehicleDetailView extends StatelessWidget {
  const _VehicleDetailView({required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.simpleCurrency();
    final dateFormat = MaterialLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(vehicle.displayName)),
      body: BlocConsumer<VehicleDetailCubit, VehicleDetailState>(
        listener: (context, state) {
          if (state.status == VehicleDetailStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        builder: (context, state) {
          final sortedExpenses = List<Expense>.from(state.expenses)
            ..sort((a, b) => b.date.compareTo(a.date));

          return RefreshIndicator(
            onRefresh: () =>
                context.read<VehicleDetailCubit>().loadExpenses(vehicle.id),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vehicle.displayName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${vehicle.make} ${vehicle.model} • ${vehicle.year}',
                        ),
                        const SizedBox(height: 8),
                        Text('Reg: ${vehicle.registrationNumber}'),
                        Text(
                          'Purchase: ${currency.format(vehicle.purchasePrice)}',
                        ),
                        Text(
                          'Purchased on ${dateFormat.formatMediumDate(vehicle.purchaseDate)}',
                        ),
                        Text('Initial mileage: ${vehicle.initialMileage} km'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Latest Expenses',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (state.status == VehicleDetailStatus.loading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (sortedExpenses.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'No expenses logged for this vehicle yet.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  )
                else
                  ...sortedExpenses
                      .take(10)
                      .map(
                        (expense) => Card(
                          child: ListTile(
                            title: Text(expense.category.label),
                            subtitle: Text(
                              [
                                dateFormat.formatMediumDate(expense.date),
                                if (expense.vendor != null &&
                                    expense.vendor!.trim().isNotEmpty)
                                  expense.vendor!.trim(),
                                if (expense.odometer != null)
                                  '${expense.odometer} km',
                              ].join(' • '),
                            ),
                            trailing: Text(
                              currency.format(expense.amount),
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
