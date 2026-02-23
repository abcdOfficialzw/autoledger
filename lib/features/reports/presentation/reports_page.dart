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
      helpText: 'Select report range',
      confirmText: 'Apply',
      saveText: 'Apply',
      fieldStartHintText: 'Start date',
      fieldEndHintText: 'End date',
    );

    if (picked == null || !mounted) {
      return;
    }

    await context.read<ReportsCubit>().setCustomRange(picked.start, picked.end);
  }

  String _formatMonth(DateTime value) {
    return '${value.year}-${value.month.toString().padLeft(2, '0')}';
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
        final topCategory = state.topCostCategory;
        final monthlyDelta = state.monthlyDeltaSummary;

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
              if (state.selectedRange == ReportsDateRange.custom) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _pickCustomDateRange(state),
                        icon: const Icon(Icons.date_range_outlined),
                        label: Text(
                          state.customStart != null && state.customEnd != null
                              ? '${Formatters.date(state.customStart!)} - ${Formatters.date(state.customEnd!)}'
                              : 'Pick custom date range',
                        ),
                      ),
                    ),
                    if (state.customStart != null && state.customEnd != null)
                      TextButton(
                        onPressed: () {
                          context.read<ReportsCubit>().setDateRange(
                            ReportsDateRange.last30Days,
                          );
                        },
                        child: const Text('Reset'),
                      ),
                  ],
                ),
              ],
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
                        Icon(
                          Icons.insights_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'No report data yet',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add vehicles and expenses to see totals, trends, and cost per $distanceUnitLabel.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: () {
                            context.read<ReportsCubit>().setDateRange(
                              ReportsDateRange.allTime,
                            );
                          },
                          icon: const Icon(Icons.calendar_view_month_outlined),
                          label: const Text('Show all-time range'),
                        ),
                      ],
                    ),
                  ),
                )
              else ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _InsightChip(
                      icon: Icons.category_outlined,
                      title: 'Top cost category',
                      value: topCategory == null
                          ? 'No expenses in range'
                          : '${topCategory.category.label} • ${Formatters.currency(topCategory.total, currencyCode: preferences.currencyCode, currencySymbol: preferences.currencySymbol)}',
                    ),
                    _InsightChip(
                      icon: monthlyDelta == null
                          ? Icons.trending_flat_outlined
                          : (monthlyDelta.isIncrease
                                ? Icons.trending_up
                                : (monthlyDelta.isDecrease
                                      ? Icons.trending_down
                                      : Icons.trending_flat_outlined)),
                      title: 'Monthly delta',
                      value: monthlyDelta == null
                          ? 'Need at least 2 months'
                          : '${monthlyDelta.amount >= 0 ? '+' : '-'}${Formatters.currency(monthlyDelta.amount.abs(), currencyCode: preferences.currencyCode, currencySymbol: preferences.currencySymbol)}${monthlyDelta.changeRatio == null ? '' : ' (${Formatters.percent(monthlyDelta.changeRatio!.abs())})'}',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
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
                const _Legend(
                  items: [
                    _LegendItemData(
                      color: Colors.teal,
                      label: 'Amount in selected range',
                    ),
                    _LegendItemData(
                      color: Colors.blueGrey,
                      label: 'Share of filtered expenses',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (state.categoryBreakdown.isEmpty)
                  _InlineMessage(
                    icon: Icons.pie_chart_outline,
                    message: 'No category data in this date range.',
                    actionLabel: 'Adjust range',
                    onAction: () => _pickCustomDateRange(state),
                  )
                else
                  ...state.categoryBreakdown.asMap().entries.map((entryPair) {
                    final index = entryPair.key;
                    final entry = entryPair.value;
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 8,
                          backgroundColor: index == 0
                              ? Colors.teal
                              : Colors.blueGrey.shade400,
                        ),
                        title: Text(entry.category.label),
                        subtitle: Text(
                          '${Formatters.percent(entry.percentage)} of expenses',
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              Formatters.currency(
                                entry.total,
                                currencyCode: preferences.currencyCode,
                                currencySymbol: preferences.currencySymbol,
                              ),
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            if (index == 0)
                              Text(
                                'Top',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                const SizedBox(height: 12),
                Text(
                  'Monthly trend',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                const _Legend(
                  items: [
                    _LegendItemData(
                      color: Colors.green,
                      label: 'Up vs previous month',
                    ),
                    _LegendItemData(
                      color: Colors.red,
                      label: 'Down vs previous month',
                    ),
                    _LegendItemData(
                      color: Colors.blueGrey,
                      label: 'First month / no comparison',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (state.monthlyTrend.isEmpty)
                  _InlineMessage(
                    icon: Icons.show_chart_outlined,
                    message: 'No monthly trend data in this range.',
                    actionLabel: 'Use all-time range',
                    onAction: () {
                      context.read<ReportsCubit>().setDateRange(
                        ReportsDateRange.allTime,
                      );
                    },
                  )
                else
                  ...state.monthlyTrend.asMap().entries.map((entryPair) {
                    final index = entryPair.key;
                    final entry = entryPair.value;
                    final previous = index == 0
                        ? null
                        : state.monthlyTrend[index - 1];
                    final difference = previous == null
                        ? null
                        : entry.total - previous.total;
                    final color = difference == null
                        ? Colors.blueGrey
                        : (difference >= 0 ? Colors.green : Colors.red);
                    return Card(
                      child: ListTile(
                        leading: Icon(
                          difference == null
                              ? Icons.horizontal_rule
                              : (difference >= 0
                                    ? Icons.trending_up
                                    : Icons.trending_down),
                          color: color,
                        ),
                        title: Text(_formatMonth(entry.monthStart)),
                        subtitle: Text(
                          difference == null
                              ? 'First visible month'
                              : '${difference >= 0 ? '+' : '-'}${Formatters.currency(difference.abs(), currencyCode: preferences.currencyCode, currencySymbol: preferences.currencySymbol)} vs ${_formatMonth(previous!.monthStart)}',
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
                    );
                  }),
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
  const _InlineMessage({
    required this.message,
    this.icon = Icons.info_outline,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(message, style: Theme.of(context).textTheme.bodyMedium),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 8),
              TextButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

class _InsightChip extends StatelessWidget {
  const _InsightChip({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: SizedBox(
        width: 230,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.labelSmall),
            Text(value, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

class _LegendItemData {
  const _LegendItemData({required this.color, required this.label});

  final Color color;
  final String label;
}

class _Legend extends StatelessWidget {
  const _Legend({required this.items});

  final List<_LegendItemData> items;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 6,
      children: items
          .map(
            (item) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(radius: 5, backgroundColor: item.color),
                const SizedBox(width: 6),
                Text(item.label, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          )
          .toList(growable: false),
    );
  }
}
