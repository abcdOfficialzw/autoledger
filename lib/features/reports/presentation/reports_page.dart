import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/formatting/formatters.dart';
import '../../../core/presentation/liquid_glass.dart';
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
  static const _categoryPalette = [
    Color(0xFF0F766E),
    Color(0xFF2563EB),
    Color(0xFFEA580C),
    Color(0xFF9333EA),
    Color(0xFFDC2626),
    Color(0xFF65A30D),
  ];

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

  String _formatMonthLabel(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    return '${value.year}-$month';
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
        final avgMonthlySpend = state.averageMonthlySpend;

        return LiquidBackdrop(
          child: RefreshIndicator(
            onRefresh: context.read<ReportsCubit>().load,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              children: [
                _DashboardHeader(
                  onExportCsv: _exportAllCsv,
                  hasData: hasData,
                  totalOwnershipCost: state.totalOwnershipCost,
                  currencyCode: preferences.currencyCode,
                  currencySymbol: preferences.currencySymbol,
                ),
                const SizedBox(height: 16),
                _DateFilterPanel(
                  state: state,
                  onRangeSelected: (range) async {
                    if (range == ReportsDateRange.custom) {
                      await _pickCustomDateRange(state);
                      return;
                    }
                    await context.read<ReportsCubit>().setDateRange(range);
                  },
                  onPickCustom: () => _pickCustomDateRange(state),
                  onResetCustom: () {
                    context.read<ReportsCubit>().setDateRange(
                      ReportsDateRange.last30Days,
                    );
                  },
                ),
                const SizedBox(height: 16),
                if (state.status == ReportsStatus.loading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (!hasData)
                  _LargeEmptyState(
                    title: 'No report data yet',
                    message:
                        'Add vehicles and expenses to unlock trend lines, category distribution, and cost-per-$distanceUnitLabel tracking.',
                    actionLabel: 'Show all-time range',
                    onAction: () {
                      context.read<ReportsCubit>().setDateRange(
                        ReportsDateRange.allTime,
                      );
                    },
                  )
                else ...[
                  _MetricsSection(
                    preferences: preferences,
                    distanceUnitLabel: distanceUnitLabel,
                    totalOwnershipCost: state.totalOwnershipCost,
                    avgMonthlySpend: avgMonthlySpend,
                    costPerKmBaseline: state.costPerKmBaseline,
                    topCategory: topCategory,
                    monthlyDelta: monthlyDelta,
                    baselineVehicleCount: state.baselineVehicleCount,
                  ),
                  const SizedBox(height: 16),
                  _SectionCard(
                    title: 'Monthly spend trend',
                    subtitle:
                        'Line chart highlights direction while bars emphasize absolute spend.',
                    child: state.monthlyTrend.isEmpty
                        ? _SectionEmptyState(
                            icon: Icons.show_chart_outlined,
                            message: 'No monthly spend data in this range.',
                            actionLabel: 'Use all-time range',
                            onAction: () {
                              context.read<ReportsCubit>().setDateRange(
                                ReportsDateRange.allTime,
                              );
                            },
                          )
                        : _MonthlyTrendCharts(
                            monthlyTrend: state.monthlyTrend,
                            formatMonthLabel: _formatMonthLabel,
                            currencyCode: preferences.currencyCode,
                            currencySymbol: preferences.currencySymbol,
                          ),
                  ),
                  const SizedBox(height: 16),
                  _SectionCard(
                    title: 'Category distribution',
                    subtitle:
                        'Share of filtered expenses by category with top category spotlight.',
                    child: state.categoryBreakdown.isEmpty
                        ? _SectionEmptyState(
                            icon: Icons.pie_chart_outline,
                            message: 'No category distribution available.',
                            actionLabel: 'Adjust date range',
                            onAction: () => _pickCustomDateRange(state),
                          )
                        : _CategoryDistributionChart(
                            categoryBreakdown: state.categoryBreakdown,
                            currencyCode: preferences.currencyCode,
                            currencySymbol: preferences.currencySymbol,
                            palette: _categoryPalette,
                          ),
                  ),
                  const SizedBox(height: 16),
                  _SectionCard(
                    title: 'Vehicle comparison',
                    subtitle:
                        'Compare spend between vehicles in the active range.',
                    child: state.vehicleComparison.isEmpty
                        ? const _SectionEmptyState(
                            icon: Icons.directions_car_outlined,
                            message:
                                'No vehicle-level comparison data in this range.',
                          )
                        : _VehicleComparisonChart(
                            data: state.vehicleComparison,
                            currencyCode: preferences.currencyCode,
                            currencySymbol: preferences.currencySymbol,
                          ),
                  ),
                  const SizedBox(height: 16),
                  _SectionCard(
                    title: 'Reminder snapshot',
                    subtitle: 'Service and license reminder workload overview.',
                    child: _ReminderGrid(state: state),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({
    required this.onExportCsv,
    required this.hasData,
    required this.totalOwnershipCost,
    required this.currencyCode,
    required this.currencySymbol,
  });

  final VoidCallback onExportCsv;
  final bool hasData;
  final double totalOwnershipCost;
  final String currencyCode;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return LiquidGlassCard(
      padding: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [colors.primary, colors.primaryContainer],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Auto Ledger Reports',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: colors.onPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: onExportCsv,
                    icon: const Icon(Icons.download_outlined),
                    label: const Text('Export CSV'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Track total ownership cost, monthly movement, and category/vehicle drivers.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.onPrimary.withOpacity(0.92),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                hasData
                    ? Formatters.currency(
                        totalOwnershipCost,
                        currencyCode: currencyCode,
                        currencySymbol: currencySymbol,
                      )
                    : 'No spend yet',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: colors.onPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Total ownership spend in selected period',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: colors.onPrimary.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateFilterPanel extends StatelessWidget {
  const _DateFilterPanel({
    required this.state,
    required this.onRangeSelected,
    required this.onPickCustom,
    required this.onResetCustom,
  });

  final ReportsState state;
  final Future<void> Function(ReportsDateRange range) onRangeSelected;
  final VoidCallback onPickCustom;
  final VoidCallback onResetCustom;

  @override
  Widget build(BuildContext context) {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date Range',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ReportsDateRange.values
                .map(
                  (range) => ChoiceChip(
                    selected: range == state.selectedRange,
                    label: Text(range.label),
                    onSelected: (_) => onRangeSelected(range),
                  ),
                )
                .toList(growable: false),
          ),
          if (state.selectedRange == ReportsDateRange.custom) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onPickCustom,
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
                    onPressed: onResetCustom,
                    child: const Text('Reset'),
                  ),
              ],
            ),
          ],
          if (state.rangeStart != null && state.rangeEnd != null) ...[
            const SizedBox(height: 6),
            Text(
              'Applied: ${Formatters.date(state.rangeStart!)} - ${Formatters.date(state.rangeEnd!)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ] else ...[
            const SizedBox(height: 6),
            Text(
              'Applied: All-time',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}

class _MetricsSection extends StatelessWidget {
  const _MetricsSection({
    required this.preferences,
    required this.distanceUnitLabel,
    required this.totalOwnershipCost,
    required this.avgMonthlySpend,
    required this.costPerKmBaseline,
    required this.topCategory,
    required this.monthlyDelta,
    required this.baselineVehicleCount,
  });

  final AppPreferences preferences;
  final String distanceUnitLabel;
  final double totalOwnershipCost;
  final double? avgMonthlySpend;
  final double? costPerKmBaseline;
  final CategorySpend? topCategory;
  final MonthlyDeltaSummary? monthlyDelta;
  final int baselineVehicleCount;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _MetricCardData(
        title: 'Total spend',
        value: Formatters.currency(
          totalOwnershipCost,
          currencyCode: preferences.currencyCode,
          currencySymbol: preferences.currencySymbol,
        ),
        subtitle: 'Purchase + expenses in range',
        icon: Icons.account_balance_wallet_outlined,
      ),
      _MetricCardData(
        title: 'Avg monthly spend',
        value: avgMonthlySpend == null
            ? 'N/A'
            : Formatters.currency(
                avgMonthlySpend!,
                currencyCode: preferences.currencyCode,
                currencySymbol: preferences.currencySymbol,
              ),
        subtitle: avgMonthlySpend == null
            ? 'Need monthly data points'
            : 'Average of visible months',
        icon: Icons.calendar_month_outlined,
      ),
      _MetricCardData(
        title: 'Cost/$distanceUnitLabel',
        value: costPerKmBaseline == null
            ? 'N/A'
            : '${Formatters.currency(preferences.distanceUnit.fromCostPerKilometer(costPerKmBaseline!), currencyCode: preferences.currencyCode, currencySymbol: preferences.currencySymbol)}/$distanceUnitLabel',
        subtitle: costPerKmBaseline == null
            ? 'Needs odometer-based history'
            : 'From $baselineVehicleCount vehicle(s)',
        icon: Icons.speed_outlined,
      ),
      _MetricCardData(
        title: 'Top category',
        value: topCategory == null
            ? 'N/A'
            : '${topCategory!.category.label} (${Formatters.percent(topCategory!.percentage)})',
        subtitle: topCategory == null
            ? 'No expenses in selected range'
            : Formatters.currency(
                topCategory!.total,
                currencyCode: preferences.currencyCode,
                currencySymbol: preferences.currencySymbol,
              ),
        icon: Icons.category_outlined,
      ),
      _MetricCardData(
        title: 'MoM delta',
        value: monthlyDelta == null
            ? 'N/A'
            : '${monthlyDelta!.amount >= 0 ? '+' : '-'}${Formatters.currency(monthlyDelta!.amount.abs(), currencyCode: preferences.currencyCode, currencySymbol: preferences.currencySymbol)}',
        subtitle: monthlyDelta == null
            ? 'Need at least 2 months'
            : monthlyDelta!.changeRatio == null
            ? 'Previous month was zero'
            : '${Formatters.percent(monthlyDelta!.changeRatio!.abs())} vs previous month',
        icon: monthlyDelta == null
            ? Icons.trending_flat_outlined
            : (monthlyDelta!.isIncrease
                  ? Icons.trending_up
                  : (monthlyDelta!.isDecrease
                        ? Icons.trending_down
                        : Icons.trending_flat_outlined)),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key metrics',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 1100
                ? 3
                : (constraints.maxWidth >= 700 ? 2 : 1);
            final tileWidth =
                (constraints.maxWidth - ((columns - 1) * 10)) / columns;
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: cards
                  .map(
                    (card) => SizedBox(
                      width: tileWidth,
                      child: _MetricCard(data: card),
                    ),
                  )
                  .toList(growable: false),
            );
          },
        ),
      ],
    );
  }
}

class _MetricCardData {
  const _MetricCardData({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.data});

  final _MetricCardData data;

  @override
  Widget build(BuildContext context) {
    return LiquidInsetCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withOpacity(0.8),
                child: Icon(data.icon, size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  data.title,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            data.value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(data.subtitle, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _MonthlyTrendCharts extends StatelessWidget {
  const _MonthlyTrendCharts({
    required this.monthlyTrend,
    required this.formatMonthLabel,
    required this.currencyCode,
    required this.currencySymbol,
  });

  final List<MonthlySpend> monthlyTrend;
  final String Function(DateTime month) formatMonthLabel;
  final String currencyCode;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    final maxValue = monthlyTrend.fold<double>(
      0,
      (max, item) => item.total > max ? item.total : max,
    );
    final chartMax = maxValue <= 0 ? 1.0 : maxValue * 1.2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 220,
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: chartMax,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: chartMax / 4,
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 54,
                    interval: chartMax / 4,
                    getTitlesWidget: (value, _) => Text(
                      Formatters.currency(
                        value,
                        currencyCode: currencyCode,
                        currencySymbol: currencySymbol,
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 34,
                    interval: 1,
                    getTitlesWidget: (value, _) {
                      final index = value.toInt();
                      if (index < 0 || index >= monthlyTrend.length) {
                        return const SizedBox.shrink();
                      }
                      final showEvery = monthlyTrend.length > 8 ? 2 : 1;
                      if (index % showEvery != 0 &&
                          index != monthlyTrend.length - 1) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          formatMonthLabel(monthlyTrend[index].monthStart),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      );
                    },
                  ),
                ),
              ),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (spots) => spots
                      .map(
                        (spot) => LineTooltipItem(
                          Formatters.currency(
                            spot.y,
                            currencyCode: currencyCode,
                            currencySymbol: currencySymbol,
                          ),
                          Theme.of(context).textTheme.bodySmall!,
                        ),
                      )
                      .toList(growable: false),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  barWidth: 3,
                  spots: monthlyTrend
                      .asMap()
                      .entries
                      .map(
                        (entry) =>
                            FlSpot(entry.key.toDouble(), entry.value.total),
                      )
                      .toList(growable: false),
                  dotData: FlDotData(show: monthlyTrend.length <= 8),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.14),
                  ),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 190,
          child: BarChart(
            BarChartData(
              minY: 0,
              maxY: chartMax,
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    interval: 1,
                    getTitlesWidget: (value, _) {
                      final index = value.toInt();
                      if (index < 0 || index >= monthlyTrend.length) {
                        return const SizedBox.shrink();
                      }
                      return Text(
                        monthlyTrend[index].monthStart.month.toString(),
                        style: Theme.of(context).textTheme.bodySmall,
                      );
                    },
                  ),
                ),
              ),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, _, rod, __) {
                    final month = monthlyTrend[group.x].monthStart;
                    return BarTooltipItem(
                      '${formatMonthLabel(month)}\n${Formatters.currency(rod.toY, currencyCode: currencyCode, currencySymbol: currencySymbol)}',
                      Theme.of(context).textTheme.bodySmall!,
                    );
                  },
                ),
              ),
              barGroups: monthlyTrend
                  .asMap()
                  .entries
                  .map(
                    (entry) => BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.total,
                          width: 14,
                          borderRadius: BorderRadius.circular(3),
                          color: Theme.of(
                            context,
                          ).colorScheme.secondary.withOpacity(0.75),
                        ),
                      ],
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryDistributionChart extends StatelessWidget {
  const _CategoryDistributionChart({
    required this.categoryBreakdown,
    required this.currencyCode,
    required this.currencySymbol,
    required this.palette,
  });

  final List<CategorySpend> categoryBreakdown;
  final String currencyCode;
  final String currencySymbol;
  final List<Color> palette;

  @override
  Widget build(BuildContext context) {
    final topItems = categoryBreakdown.take(6).toList(growable: false);

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              pieTouchData: PieTouchData(touchCallback: (_, __) {}),
              sections: topItems
                  .asMap()
                  .entries
                  .map(
                    (entry) => PieChartSectionData(
                      color: palette[entry.key % palette.length],
                      value: entry.value.total,
                      title:
                          '${(entry.value.percentage * 100).toStringAsFixed(0)}%',
                      radius: 62,
                      titleStyle: Theme.of(context).textTheme.labelSmall
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...topItems.asMap().entries.map((entry) {
          final item = entry.value;
          return ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              radius: 7,
              backgroundColor: palette[entry.key % palette.length],
            ),
            title: Text(item.category.label),
            subtitle: Text(
              '${Formatters.percent(item.percentage)} of expenses',
            ),
            trailing: Text(
              Formatters.currency(
                item.total,
                currencyCode: currencyCode,
                currencySymbol: currencySymbol,
              ),
              style: Theme.of(context).textTheme.titleSmall,
            ),
          );
        }),
      ],
    );
  }
}

class _VehicleComparisonChart extends StatelessWidget {
  const _VehicleComparisonChart({
    required this.data,
    required this.currencyCode,
    required this.currencySymbol,
  });

  final List<VehicleSpend> data;
  final String currencyCode;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    final visible = data.take(6).toList(growable: false);
    final maxValue = visible.fold<double>(
      0,
      (max, item) => item.total > max ? item.total : max,
    );
    final chartMax = maxValue <= 0 ? 1.0 : maxValue * 1.2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 230,
          child: BarChart(
            BarChartData(
              minY: 0,
              maxY: chartMax,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: chartMax / 4,
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 52,
                    interval: chartMax / 4,
                    getTitlesWidget: (value, _) => Text(
                      Formatters.currency(
                        value,
                        currencyCode: currencyCode,
                        currencySymbol: currencySymbol,
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 42,
                    interval: 1,
                    getTitlesWidget: (value, _) {
                      final index = value.toInt();
                      if (index < 0 || index >= visible.length) {
                        return const SizedBox.shrink();
                      }
                      final label = visible[index].vehicleName;
                      final compact = label.length <= 10
                          ? label
                          : '${label.substring(0, math.min(10, label.length))}…';
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          compact,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      );
                    },
                  ),
                ),
              ),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, _, rod, __) {
                    final vehicle = visible[group.x];
                    return BarTooltipItem(
                      '${vehicle.vehicleName}\n${Formatters.currency(rod.toY, currencyCode: currencyCode, currencySymbol: currencySymbol)}',
                      Theme.of(context).textTheme.bodySmall!,
                    );
                  },
                ),
              ),
              barGroups: visible
                  .asMap()
                  .entries
                  .map(
                    (entry) => BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.total,
                          width: 18,
                          borderRadius: BorderRadius.circular(4),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF115E59), Color(0xFF0EA5A4)],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...visible.map(
          (vehicle) => ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.directions_car_outlined),
            title: Text(vehicle.vehicleName),
            trailing: Text(
              Formatters.currency(
                vehicle.total,
                currencyCode: currencyCode,
                currencySymbol: currencySymbol,
              ),
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ),
      ],
    );
  }
}

class _ReminderGrid extends StatelessWidget {
  const _ReminderGrid({required this.state});

  final ReportsState state;

  @override
  Widget build(BuildContext context) {
    final tiles = [
      _MetricCardData(
        title: 'All reminders',
        value: '${state.reminderOverdueCount} overdue',
        subtitle: '${state.reminderUpcomingCount} upcoming',
        icon: Icons.notifications_active_outlined,
      ),
      _MetricCardData(
        title: 'Service reminders',
        value: '${state.serviceReminderOverdueCount} overdue',
        subtitle: '${state.serviceReminderUpcomingCount} upcoming',
        icon: Icons.build_circle_outlined,
      ),
      _MetricCardData(
        title: 'License reminders',
        value: '${state.licenseReminderOverdueCount} overdue',
        subtitle: '${state.licenseReminderUpcomingCount} upcoming',
        icon: Icons.badge_outlined,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 760 ? 3 : 1;
        final width = (constraints.maxWidth - ((columns - 1) * 10)) / columns;
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: tiles
              .map(
                (tile) => SizedBox(
                  width: width,
                  child: _MetricCard(data: tile),
                ),
              )
              .toList(growable: false),
        );
      },
    );
  }
}

class _SectionEmptyState extends StatelessWidget {
  const _SectionEmptyState({
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return LiquidInsetCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 8),
          Text(message),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 8),
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}

class _LargeEmptyState extends StatelessWidget {
  const _LargeEmptyState({
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.insights_outlined,
            size: 28,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(message),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: onAction,
            icon: const Icon(Icons.calendar_view_month_outlined),
            label: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}
