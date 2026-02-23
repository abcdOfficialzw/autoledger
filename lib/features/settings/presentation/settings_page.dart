import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/app_preferences.dart';
import 'cubit/settings_cubit.dart';
import 'cubit/settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (state.status == SettingsStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
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
                  'Control currency, distance units, and reminders.',
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
