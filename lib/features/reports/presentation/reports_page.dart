import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/formatting/formatters.dart';
import '../../expenses/domain/expense_repository.dart';
import '../../expenses/domain/services/csv_export_service.dart';
import '../../reminders/domain/services/reminder_computation_service.dart';
import '../../settings/domain/app_preferences.dart';
import '../../settings/domain/settings_repository.dart';
import '../../settings/presentation/cubit/settings_cubit.dart';
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
        context.read<SettingsRepository>(),
        context.read<ReminderComputationService>(),
      )..load(),
      child: const _ReportsView(),
    );
  }
}

class _ReportsView extends StatefulWidget {
  const _ReportsView();

  @override
  State<_ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<_ReportsView> {
  Future<void> _pickCustomDateRange(ReportsState state) async {
    final now = DateTime.now();
    final current = DateTimeRange(
      start:
          state.customStart ??
          DateTime(
            now.year,
            now.month,
            now.day,
          ).subtract(const Duration(days: 29)),
      end: state.customEnd ?? now,
    );

    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: current,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 1),
    );

    if (picked == null || !mounted) {
      return;
    }

    await context.read<ReportsCubit>().setCustomRange(picked.start, picked.end);
  }

  Future<void> _exportAllCsv() async {
    try {
      final file = await context
          .read<CsvExportService>()
          .exportAllExpensesCsv();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('CSV exported to ${file.path}')));
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to export CSV.')));
    }
  }

  @override
  Widget build(BuildContext context) {
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
        final preferences = context.select(
          (SettingsCubit cubit) => cubit.state.preferences,
        );
        final distanceUnitLabel = preferences.distanceUnit.shortLabel;
        final hasData = state.totalExpenses > 0 || state.totalPurchase > 0;

        return RefreshIndicator(
          onRefresh: context.read<ReportsCubit>().load,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Reports',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Export CSV',
                    onPressed: _exportAllCsv,
                    icon: const Icon(Icons.download_outlined),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Portfolio totals, category split, and monthly spend trends.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ReportsDateRange.values
                    .map((range) {
                      return ChoiceChip(
                        selected: range == state.selectedRange,
                        label: Text(range.label),
                        onSelected: (_) async {
                          if (range == ReportsDateRange.custom) {
                            await _pickCustomDateRange(state);
                            return;
                          }
                          await context.read<ReportsCubit>().setDateRange(
                            range,
                          );
                        },
                      );
                    })
                    .toList(growable: false),
              ),
              if (state.rangeStart != null && state.rangeEnd != null) ...[
                const SizedBox(height: 8),
                Text(
                  '${Formatters.date(state.rangeStart!)} - ${Formatters.date(state.rangeEnd!)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 16),
              if (state.status == ReportsStatus.loading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 36),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (!hasData)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'No report data yet',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add vehicles and expenses to see totals, trends, and cost per $distanceUnitLabel.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                )
              else ...[
                _SummaryCard(
                  title: 'Total ownership cost',
                  subtitle: 'Purchase totals + filtered expenses',
                  value: Formatters.currency(
                    state.totalOwnershipCost,
                    currencyCode: preferences.currencyCode,
                    currencySymbol: preferences.currencySymbol,
                  ),
                ),
                _SummaryCard(
                  title: 'Total purchase value',
                  value: Formatters.currency(
                    state.totalPurchase,
                    currencyCode: preferences.currencyCode,
                    currencySymbol: preferences.currencySymbol,
                  ),
                ),
                _SummaryCard(
                  title: 'Total logged expenses',
                  value: Formatters.currency(
                    state.totalExpenses,
                    currencyCode: preferences.currencyCode,
                    currencySymbol: preferences.currencySymbol,
                  ),
                ),
                _SummaryCard(
                  title: 'Cost/$distanceUnitLabel baseline',
                  subtitle: state.costPerKmBaseline == null
                      ? 'Insufficient odometer records in this range. Add odometer readings to expenses.'
                      : 'Based on ${state.baselineVehicleCount} vehicle(s) with mileage logs.',
                  value: state.costPerKmBaseline == null
                      ? 'N/A'
                      : '${Formatters.currency(preferences.distanceUnit.fromCostPerKilometer(state.costPerKmBaseline!), currencyCode: preferences.currencyCode, currencySymbol: preferences.currencySymbol)}/$distanceUnitLabel',
                ),
                _SummaryCard(
                  title: 'Reminder summary',
                  subtitle: 'Settings-driven service and license candidates.',
                  value:
                      '${state.reminderOverdueCount} overdue • ${state.reminderUpcomingCount} upcoming',
                ),
                _SummaryCard(
                  title: 'Service reminders',
                  value:
                      '${state.serviceReminderOverdueCount} overdue • ${state.serviceReminderUpcomingCount} upcoming',
                ),
                _SummaryCard(
                  title: 'License reminders',
                  value:
                      '${state.licenseReminderOverdueCount} overdue • ${state.licenseReminderUpcomingCount} upcoming',
                ),
                const SizedBox(height: 12),
                Text(
                  'Category breakdown',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (state.categoryBreakdown.isEmpty)
                  const _InlineMessage(
                    message: 'No expenses in this date range.',
                  )
                else
                  ...state.categoryBreakdown.map(
                    (entry) => Card(
                      child: ListTile(
                        title: Text(entry.category.label),
                        subtitle: Text(Formatters.percent(entry.percentage)),
                        trailing: Text(
                          Formatters.currency(
                            entry.total,
                            currencyCode: preferences.currencyCode,
                            currencySymbol: preferences.currencySymbol,
                          ),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                Text(
                  'Monthly trend',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (state.monthlyTrend.isEmpty)
                  const _InlineMessage(
                    message: 'No monthly trend data available.',
                  )
                else
                  ...state.monthlyTrend.map(
                    (entry) => Card(
                      child: ListTile(
                        title: Text(
                          '${entry.monthStart.year}-${entry.monthStart.month.toString().padLeft(2, '0')}',
                        ),
                        trailing: Text(
                          Formatters.currency(
                            entry.total,
                            currencyCode: preferences.currencyCode,
                            currencySymbol: preferences.currencySymbol,
                          ),
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

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.title, required this.value, this.subtitle});

  final String title;
  final String value;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: subtitle == null ? null : Text(subtitle!),
        trailing: Text(value, style: Theme.of(context).textTheme.titleSmall),
      ),
    );
  }
}

class _InlineMessage extends StatelessWidget {
  const _InlineMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
      ),
    );
  }
}
