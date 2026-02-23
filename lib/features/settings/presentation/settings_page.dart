import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../expenses/domain/expense.dart';
import '../../expenses/domain/expense_repository.dart';
import '../../reminders/domain/reminder_candidate.dart';
import '../../reminders/domain/services/reminder_computation_service.dart';
import '../../vehicles/domain/vehicle_repository.dart';
import '../domain/app_preferences.dart';
import 'backup_restore_guidance_page.dart';
import 'cubit/settings_cubit.dart';
import 'cubit/settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.actionVersion != current.actionVersion,
      listener: (context, state) {
        if (state.status == SettingsStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          return;
        }

        if (state.actionMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.actionMessage!)));
        }
      },
      builder: (context, state) {
        final preferences = state.preferences;
        final selectedCurrency = preferences.selectedCurrency;

        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Settings',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Control currency, units, reminders, and data safety actions.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Currency',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<CurrencyOption>(
                          initialValue: selectedCurrency,
                          decoration: const InputDecoration(
                            labelText: 'Currency code and symbol',
                          ),
                          items: CurrencyOption.values
                              .map(
                                (currency) => DropdownMenuItem(
                                  value: currency,
                                  child: Text(
                                    '${currency.code} (${currency.symbol}) - ${currency.label}',
                                  ),
                                ),
                              )
                              .toList(growable: false),
                          onChanged: (value) async {
                            if (value == null) {
                              return;
                            }
                            await context.read<SettingsCubit>().setCurrency(
                              value,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Distance unit',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        SegmentedButton<DistanceUnit>(
                          segments: const [
                            ButtonSegment(
                              value: DistanceUnit.km,
                              label: Text('Kilometers (km)'),
                            ),
                            ButtonSegment(
                              value: DistanceUnit.mi,
                              label: Text('Miles (mi)'),
                            ),
                          ],
                          selected: {preferences.distanceUnit},
                          onSelectionChanged: (selection) async {
                            final value = selection.first;
                            await context.read<SettingsCubit>().setDistanceUnit(
                              value,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reminders (MVP)',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Service reminders'),
                          subtitle: const Text(
                            'Enable service due reminder flags.',
                          ),
                          value: preferences.serviceReminderEnabled,
                          onChanged: (value) async {
                            await context
                                .read<SettingsCubit>()
                                .setServiceReminderEnabled(value);
                          },
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('License reminders'),
                          subtitle: const Text(
                            'Enable license renewal reminder flags.',
                          ),
                          value: preferences.licenseReminderEnabled,
                          onChanged: (value) async {
                            await context
                                .read<SettingsCubit>()
                                .setLicenseReminderEnabled(value);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.upload_file),
                        title: const Text('Export data'),
                        subtitle: const Text(
                          'Create a portable data package entry point.',
                        ),
                        onTap: () => context
                            .read<SettingsCubit>()
                            .triggerExportEntryPoint(),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.file_download_outlined),
                        title: const Text('Import data'),
                        subtitle: const Text(
                          'Restore data from an external package entry point.',
                        ),
                        onTap: () => context
                            .read<SettingsCubit>()
                            .triggerImportEntryPoint(),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.health_and_safety_outlined),
                        title: const Text('Backup & restore guidance'),
                        subtitle: const Text(
                          'Recommended workflow before export/import.',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const BackupRestoreGuidancePage(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        key: const Key('settings-reset-tile'),
                        leading: const Icon(Icons.warning_amber_rounded),
                        title: const Text('Reset settings'),
                        subtitle: const Text(
                          'Revert app preferences to safe defaults.',
                        ),
                        textColor: Theme.of(context).colorScheme.error,
                        iconColor: Theme.of(context).colorScheme.error,
                        onTap: () async {
                          final shouldReset = await showDialog<bool>(
                            context: context,
                            builder: (_) => const _ResetSettingsDialog(),
                          );

                          if (shouldReset == true && context.mounted) {
                            await context
                                .read<SettingsCubit>()
                                .resetPreferencesToDefaults();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _ReminderSummaryCard(preferences: preferences),
                if (state.status == SettingsStatus.loading) ...[
                  const SizedBox(height: 12),
                  const LinearProgressIndicator(),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ReminderSummaryCard extends StatefulWidget {
  const _ReminderSummaryCard({required this.preferences});

  final AppPreferences preferences;

  @override
  State<_ReminderSummaryCard> createState() => _ReminderSummaryCardState();
}

class _ReminderSummaryCardState extends State<_ReminderSummaryCard> {
  late Future<ReminderSummary> _summaryFuture;

  @override
  void initState() {
    super.initState();
    _summaryFuture = _loadSummary();
  }

  @override
  void didUpdateWidget(covariant _ReminderSummaryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.preferences != widget.preferences) {
      _summaryFuture = _loadSummary();
    }
  }

  Future<ReminderSummary> _loadSummary() async {
    final vehicleRepository = context.read<VehicleRepository>();
    final expenseRepository = context.read<ExpenseRepository>();
    final reminderService = context.read<ReminderComputationService>();

    final vehicles = await vehicleRepository.getVehicles();
    final expenses = await Future.wait(
      vehicles.map(
        (vehicle) => expenseRepository.getExpensesForVehicle(vehicle.id),
      ),
    );
    final expensesByVehicle = <int, List<Expense>>{
      for (var index = 0; index < vehicles.length; index++)
        vehicles[index].id: expenses[index],
    };

    return reminderService.summarize(
      vehicles: vehicles,
      expensesByVehicle: expensesByVehicle,
      preferences: widget.preferences,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<ReminderSummary>(
          future: _summaryFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text('Loading reminder summary...'),
                ],
              );
            }

            final summary = snapshot.data ?? const ReminderSummary();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reminder summary',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Overdue: ${summary.totalOverdue} • Upcoming: ${summary.totalUpcoming}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  'Service ${summary.serviceOverdue} overdue / ${summary.serviceUpcoming} upcoming',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  'License ${summary.licenseOverdue} overdue / ${summary.licenseUpcoming} upcoming',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ResetSettingsDialog extends StatefulWidget {
  const _ResetSettingsDialog();

  @override
  State<_ResetSettingsDialog> createState() => _ResetSettingsDialogState();
}

class _ResetSettingsDialogState extends State<_ResetSettingsDialog> {
  String _confirmationText = '';

  @override
  Widget build(BuildContext context) {
    final canReset = _confirmationText.trim() == 'RESET';

    return AlertDialog(
      title: const Text('Reset settings'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This only resets settings preferences. Type RESET to continue.',
          ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('reset-confirm-input'),
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(
              labelText: 'Confirmation text',
              hintText: 'RESET',
            ),
            onChanged: (value) {
              setState(() {
                _confirmationText = value;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: canReset ? () => Navigator.of(context).pop(true) : null,
          child: const Text('Reset now'),
        ),
      ],
    );
  }
}
