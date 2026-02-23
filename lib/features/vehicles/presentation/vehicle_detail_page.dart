import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/formatting/formatters.dart';
import '../../expenses/domain/expense.dart';
import '../../expenses/domain/expense_category.dart';
import '../../expenses/domain/expense_repository.dart';
import '../../expenses/domain/services/csv_export_service.dart';
import '../../settings/domain/app_preferences.dart';
import '../../settings/presentation/cubit/settings_cubit.dart';
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

  Future<void> _exportVehicleCsv(BuildContext context) async {
    try {
      final file = await context
          .read<CsvExportService>()
          .exportVehicleExpensesCsv(vehicle.id);
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('CSV exported to ${file.path}')));
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to export CSV.')));
    }
  }

  Future<void> _confirmDeleteExpense(
    BuildContext context,
    Expense expense,
  ) async {
    final shouldDelete =
        await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Delete expense?'),
              content: const Text('This action cannot be undone.'),
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

    if (!shouldDelete || !context.mounted) {
      return;
    }

    await context.read<VehicleDetailCubit>().deleteExpense(expense.id);
  }

  Future<void> _openEditExpenseDialog(
    BuildContext context,
    Expense expense,
  ) async {
    final formKey = GlobalKey<FormState>();
    final amountController = TextEditingController(
      text: expense.amount.toStringAsFixed(2),
    );
    final odometerController = TextEditingController(
      text: expense.odometer?.toString() ?? '',
    );
    final vendorController = TextEditingController(text: expense.vendor ?? '');
    final notesController = TextEditingController(text: expense.notes ?? '');

    var selectedDate = expense.date;
    var selectedCategory = expense.category;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit expense'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(labelText: 'Amount'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Amount is required';
                          }
                          final parsed = double.tryParse(value.trim());
                          if (parsed == null || parsed <= 0) {
                            return 'Enter a valid amount';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<ExpenseCategory>(
                        initialValue: selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                        ),
                        items: ExpenseCategory.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(category.label),
                              ),
                            )
                            .toList(growable: false),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() => selectedCategory = value);
                        },
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(DateTime.now().year - 10),
                            lastDate: DateTime(DateTime.now().year + 1),
                          );
                          if (picked == null) {
                            return;
                          }
                          setState(() => selectedDate = picked);
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(labelText: 'Date'),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(Formatters.date(selectedDate)),
                              const Icon(Icons.calendar_today_outlined),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: odometerController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Odometer (optional)',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return null;
                          }
                          final parsed = int.tryParse(value.trim());
                          if (parsed == null || parsed < 0) {
                            return 'Enter a valid odometer';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: vendorController,
                        decoration: const InputDecoration(
                          labelText: 'Vendor (optional)',
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: notesController,
                        minLines: 2,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Notes (optional)',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != true || !context.mounted) {
      amountController.dispose();
      odometerController.dispose();
      vendorController.dispose();
      notesController.dispose();
      return;
    }

    final odometerText = odometerController.text.trim();
    final vendorText = vendorController.text.trim();
    final notesText = notesController.text.trim();

    final updated = expense.copyWith(
      date: selectedDate,
      amount: double.parse(amountController.text.trim()),
      category: selectedCategory,
      odometer: odometerText.isEmpty ? null : int.parse(odometerText),
      clearOdometer: odometerText.isEmpty,
      vendor: vendorText,
      clearVendor: vendorText.isEmpty,
      notes: notesText,
      clearNotes: notesText.isEmpty,
    );

    amountController.dispose();
    odometerController.dispose();
    vendorController.dispose();
    notesController.dispose();

    await context.read<VehicleDetailCubit>().updateExpense(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(vehicle.displayName),
        actions: [
          IconButton(
            tooltip: 'Export CSV',
            onPressed: () => _exportVehicleCsv(context),
            icon: const Icon(Icons.download_outlined),
          ),
        ],
      ),
      body: BlocConsumer<VehicleDetailCubit, VehicleDetailState>(
        listener: (context, state) {
          if (state.status == VehicleDetailStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }

          if (state.actionMessage != null &&
              state.actionStatus != VehicleExpenseActionStatus.idle) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.actionMessage!)));
          }
        },
        builder: (context, state) {
          final preferences = context.select(
            (SettingsCubit cubit) => cubit.state.preferences,
          );
          final distanceUnit = preferences.distanceUnit;

          final sortedExpenses = List<Expense>.from(state.expenses)
            ..sort((a, b) => b.date.compareTo(a.date));

          final totalSpent = sortedExpenses.fold<double>(
            0,
            (sum, item) => sum + item.amount,
          );
          final fuelSpent = sortedExpenses
              .where((expense) => expense.category == ExpenseCategory.fuel)
              .fold<double>(0, (sum, item) => sum + item.amount);
          final maintenanceSpent = sortedExpenses
              .where(
                (expense) => {
                  ExpenseCategory.service,
                  ExpenseCategory.repairs,
                  ExpenseCategory.tires,
                  ExpenseCategory.carWash,
                }.contains(expense.category),
              )
              .fold<double>(0, (sum, item) => sum + item.amount);

          final categoryTotals = <ExpenseCategory, double>{};
          for (final expense in sortedExpenses) {
            categoryTotals.update(
              expense.category,
              (value) => value + expense.amount,
              ifAbsent: () => expense.amount,
            );
          }
          final topCategoryEntry = categoryTotals.entries.isEmpty
              ? null
              : (categoryTotals.entries.toList()
                      ..sort((a, b) => b.value.compareTo(a.value)))
                    .first;

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
                          '${vehicle.make} ${vehicle.model} - ${vehicle.year}',
                        ),
                        const SizedBox(height: 8),
                        Text('Reg: ${vehicle.registrationNumber}'),
                        Text(
                          'Purchase: ${Formatters.currency(vehicle.purchasePrice, currencyCode: preferences.currencyCode, currencySymbol: preferences.currencySymbol)}',
                        ),
                        Text(
                          'Purchased on ${Formatters.date(vehicle.purchaseDate)}',
                        ),
                        Text(
                          'Initial mileage: ${Formatters.number(distanceUnit.fromKilometers(vehicle.initialMileage))} ${distanceUnit.shortLabel}',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Insights',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Total spent: ${Formatters.currency(totalSpent, currencyCode: preferences.currencyCode, currencySymbol: preferences.currencySymbol)}',
                        ),
                        Text(
                          'Fuel vs maintenance: ${Formatters.currency(fuelSpent, currencyCode: preferences.currencyCode, currencySymbol: preferences.currencySymbol)} / ${Formatters.currency(maintenanceSpent, currencyCode: preferences.currencyCode, currencySymbol: preferences.currencySymbol)}',
                        ),
                        Text(
                          topCategoryEntry == null
                              ? 'Top category: N/A'
                              : 'Top category: ${topCategoryEntry.key.label} (${Formatters.currency(topCategoryEntry.value, currencyCode: preferences.currencyCode, currencySymbol: preferences.currencySymbol)})',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Expense history',
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
                else ...[
                  if (state.actionStatus ==
                      VehicleExpenseActionStatus.processing)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: LinearProgressIndicator(),
                    ),
                  ...sortedExpenses.map(
                    (expense) => Card(
                      child: ListTile(
                        title: Text(expense.category.label),
                        subtitle: Text(
                          [
                            Formatters.date(expense.date),
                            if (expense.vendor != null &&
                                expense.vendor!.trim().isNotEmpty)
                              expense.vendor!.trim(),
                            if (expense.odometer != null)
                              '${Formatters.number(distanceUnit.fromKilometers(expense.odometer!))} ${distanceUnit.shortLabel}',
                          ].join(' - '),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              Formatters.currency(
                                expense.amount,
                                currencyCode: preferences.currencyCode,
                                currencySymbol: preferences.currencySymbol,
                              ),
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            IconButton(
                              tooltip: 'Edit expense',
                              onPressed: () =>
                                  _openEditExpenseDialog(context, expense),
                              icon: const Icon(Icons.edit_outlined),
                            ),
                            IconButton(
                              tooltip: 'Delete expense',
                              onPressed: () =>
                                  _confirmDeleteExpense(context, expense),
                              icon: const Icon(Icons.delete_outline),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
