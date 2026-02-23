import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/formatting/formatters.dart';
import '../../expenses/domain/expense.dart';
import '../../expenses/domain/expense_category.dart';
import '../../expenses/domain/expense_repository.dart';
import '../../expenses/domain/services/csv_export_service.dart';
import '../../reminders/domain/reminder_candidate.dart';
import '../../reminders/domain/services/reminder_computation_service.dart';
import '../../settings/domain/app_preferences.dart';
import '../../settings/presentation/cubit/settings_cubit.dart';
import '../domain/vehicle.dart';
import '../domain/vehicle_repository.dart';
import 'cubit/vehicle_detail_cubit.dart';
import 'cubit/vehicle_detail_state.dart';

class VehicleDetailPage extends StatelessWidget {
  const VehicleDetailPage({required this.vehicle, super.key});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VehicleDetailCubit(
        context.read<ExpenseRepository>(),
        context.read<VehicleRepository>(),
        vehicle,
      )..loadExpenses(vehicle.id),
      child: _VehicleDetailView(vehicle: vehicle),
    );
  }
}

class _VehicleDetailView extends StatelessWidget {
  const _VehicleDetailView({required this.vehicle});

  final Vehicle vehicle;

  int _toKilometers(double value, DistanceUnit distanceUnit) {
    if (distanceUnit == DistanceUnit.km) {
      return value.round();
    }
    return (value / 0.621371).round();
  }

  Future<void> _rescheduleReminder(
    BuildContext context, {
    required ReminderType type,
    required DistanceUnit distanceUnit,
    required VehicleReminderSnapshot snapshot,
  }) async {
    if (type == ReminderType.service) {
      final formKey = GlobalKey<FormState>();
      final initialDueMileage = snapshot.serviceNextDue?.dueMileage;
      final initialValue = initialDueMileage == null
          ? ''
          : Formatters.number(distanceUnit.fromKilometers(initialDueMileage));
      final controller = TextEditingController(text: initialValue);

      final confirmed =
          await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Reschedule service'),
                content: Form(
                  key: formKey,
                  child: TextFormField(
                    controller: controller,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText:
                          'Due mileage (${distanceUnit.shortLabel.toUpperCase()})',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Due mileage is required';
                      }
                      final parsed = double.tryParse(value.trim());
                      if (parsed == null || parsed <= 0) {
                        return 'Enter a valid mileage';
                      }
                      return null;
                    },
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
          ) ??
          false;

      if (!confirmed || !context.mounted) {
        controller.dispose();
        return;
      }

      final parsed = double.parse(controller.text.trim());
      controller.dispose();
      await context.read<VehicleDetailCubit>().rescheduleServiceReminder(
        _toKilometers(parsed, distanceUnit),
      );
      return;
    }

    final initialDate =
        snapshot.licenseNextDue?.dueDate ??
        DateTime.now().add(const Duration(days: 30));
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (picked == null || !context.mounted) {
      return;
    }
    await context.read<VehicleDetailCubit>().rescheduleLicenseReminder(picked);
  }

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

          if (state.reminderActionMessage != null &&
              state.reminderActionStatus != VehicleReminderActionStatus.idle) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.reminderActionMessage!)),
            );
          }
        },
        builder: (context, state) {
          final preferences = context.select(
            (SettingsCubit cubit) => cubit.state.preferences,
          );
          final distanceUnit = preferences.distanceUnit;
          final reminderSnapshot = context
              .read<ReminderComputationService>()
              .vehicleReminders(
                vehicle: state.vehicle,
                expenses: state.expenses,
                preferences: preferences,
              );

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
                          state.vehicle.displayName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${state.vehicle.make} ${state.vehicle.model} - ${state.vehicle.year}',
                        ),
                        const SizedBox(height: 8),
                        Text('Reg: ${state.vehicle.registrationNumber}'),
                        Text(
                          'Purchase: ${Formatters.currency(state.vehicle.purchasePrice, currencyCode: preferences.currencyCode, currencySymbol: preferences.currencySymbol)}',
                        ),
                        Text(
                          'Purchased on ${Formatters.date(state.vehicle.purchaseDate)}',
                        ),
                        Text(
                          'Initial mileage: ${Formatters.number(distanceUnit.fromKilometers(state.vehicle.initialMileage))} ${distanceUnit.shortLabel}',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _ReminderStatusCard(
                  snapshot: reminderSnapshot,
                  distanceUnit: distanceUnit,
                  onMarkDone: (type) =>
                      context.read<VehicleDetailCubit>().markReminderDone(type),
                  onSnooze: (type) =>
                      context.read<VehicleDetailCubit>().snoozeReminder(type),
                  onReschedule: (type) => _rescheduleReminder(
                    context,
                    type: type,
                    distanceUnit: distanceUnit,
                    snapshot: reminderSnapshot,
                  ),
                  isProcessing:
                      state.reminderActionStatus ==
                      VehicleReminderActionStatus.processing,
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

class _ReminderStatusCard extends StatelessWidget {
  const _ReminderStatusCard({
    required this.snapshot,
    required this.distanceUnit,
    required this.onMarkDone,
    required this.onSnooze,
    required this.onReschedule,
    required this.isProcessing,
  });

  final VehicleReminderSnapshot snapshot;
  final DistanceUnit distanceUnit;
  final ValueChanged<ReminderType> onMarkDone;
  final ValueChanged<ReminderType> onSnooze;
  final ValueChanged<ReminderType> onReschedule;
  final bool isProcessing;

  @override
  Widget build(BuildContext context) {
    final serviceDue = snapshot.service ?? snapshot.serviceNextDue;
    final licenseDue = snapshot.license ?? snapshot.licenseNextDue;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reminders', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (isProcessing) ...[
              const LinearProgressIndicator(),
              const SizedBox(height: 8),
            ],
            _ReminderActionRow(
              title: _serviceLabel(
                serviceDue,
                isInWindow: snapshot.service != null,
              ),
              onMarkDone: serviceDue == null
                  ? null
                  : () => onMarkDone(ReminderType.service),
              onSnooze: serviceDue == null
                  ? null
                  : () => onSnooze(ReminderType.service),
              onReschedule: serviceDue == null
                  ? null
                  : () => onReschedule(ReminderType.service),
            ),
            const SizedBox(height: 8),
            _ReminderActionRow(
              title: _licenseLabel(
                licenseDue,
                isInWindow: snapshot.license != null,
              ),
              onMarkDone: licenseDue == null
                  ? null
                  : () => onMarkDone(ReminderType.license),
              onSnooze: licenseDue == null
                  ? null
                  : () => onSnooze(ReminderType.license),
              onReschedule: licenseDue == null
                  ? null
                  : () => onReschedule(ReminderType.license),
            ),
          ],
        ),
      ),
    );
  }

  String _serviceLabel(ReminderCandidate? service, {required bool isInWindow}) {
    if (service == null) {
      return 'Service: no schedule set.';
    }

    final remaining = service.remainingDistanceKm ?? 0;
    final remainingInUnit = distanceUnit.fromKilometers(remaining.abs());
    final dueMileage = service.dueMileage == null
        ? null
        : distanceUnit.fromKilometers(service.dueMileage!);
    final status = service.urgency == ReminderUrgency.overdue
        ? 'overdue by'
        : isInWindow
        ? 'due in'
        : 'next due in';
    final dueMileageText = dueMileage == null
        ? ''
        : ' (target ${Formatters.number(dueMileage)} ${distanceUnit.shortLabel})';

    return 'Service: $status ${Formatters.number(remainingInUnit)} ${distanceUnit.shortLabel}$dueMileageText';
  }

  String _licenseLabel(ReminderCandidate? license, {required bool isInWindow}) {
    if (license == null) {
      return 'License: no schedule set.';
    }

    final remaining = (license.remainingDays ?? 0).abs();
    final status = license.urgency == ReminderUrgency.overdue
        ? 'expired'
        : isInWindow
        ? 'expires in'
        : 'next renewal in';
    final dueDateText = license.dueDate == null
        ? ''
        : ' (${Formatters.date(license.dueDate!)})';

    return 'License: $status $remaining day(s)$dueDateText';
  }
}

class _ReminderActionRow extends StatelessWidget {
  const _ReminderActionRow({
    required this.title,
    required this.onMarkDone,
    required this.onSnooze,
    required this.onReschedule,
  });

  final String title;
  final VoidCallback? onMarkDone;
  final VoidCallback? onSnooze;
  final VoidCallback? onReschedule;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            OutlinedButton(
              onPressed: onMarkDone,
              child: const Text('Mark done'),
            ),
            OutlinedButton(onPressed: onSnooze, child: const Text('Snooze')),
            OutlinedButton(
              onPressed: onReschedule,
              child: const Text('Reschedule'),
            ),
          ],
        ),
      ],
    );
  }
}
