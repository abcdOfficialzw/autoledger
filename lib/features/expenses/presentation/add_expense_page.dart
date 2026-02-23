import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/liquid_glass.dart';
import '../../vehicles/presentation/cubit/vehicle_cubit.dart';
import '../domain/expense_category.dart';
import 'cubit/add_expense_cubit.dart';
import 'cubit/add_expense_state.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _odometerController = TextEditingController();
  final _vendorController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _expenseDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    context.read<AddExpenseCubit>().loadVehicles();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _odometerController.dispose();
    _vendorController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _expenseDate,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 1),
    );

    if (picked != null) {
      setState(() => _expenseDate = picked);
    }
  }

  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(_amountController.text.trim());
    final odometerText = _odometerController.text.trim();
    final odometer = odometerText.isEmpty ? null : int.parse(odometerText);

    await context.read<AddExpenseCubit>().submit(
      date: _expenseDate,
      amount: amount,
      odometer: odometer,
      vendor: _vendorController.text,
      notes: _notesController.text,
    );
  }

  void _resetForm() {
    _amountController.clear();
    _odometerController.clear();
    _vendorController.clear();
    _notesController.clear();
    setState(() => _expenseDate = DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<AddExpenseCubit, AddExpenseState>(
      listener: (context, state) {
        if (state.status == AddExpenseStatus.success) {
          _resetForm();
          context.read<VehicleCubit>().loadVehicles();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Expense saved.')),
          );
        }

        if (state.status == AddExpenseStatus.failure && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: LiquidBackdrop(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                children: [
                  LiquidGlassCard(
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.colorScheme.primary.withValues(alpha: 0.16),
                          ),
                          child: Icon(
                            Icons.receipt_long_rounded,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Add Expense',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Quick, clean logging with category shortcuts.',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (state.status == AddExpenseStatus.loading)
                    const LiquidGlassCard(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  if (state.vehicles.isEmpty && state.status != AddExpenseStatus.loading)
                    LiquidGlassCard(
                      child: Text(
                        'No vehicles available. Add a vehicle first from the Vehicles tab.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  if (state.vehicles.isNotEmpty)
                    LiquidGlassCard(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButtonFormField<int>(
                              initialValue: state.selectedVehicleId,
                              decoration: const InputDecoration(labelText: 'Vehicle'),
                              items: state.vehicles
                                  .map(
                                    (vehicle) => DropdownMenuItem<int>(
                                      value: vehicle.id,
                                      child: Text(vehicle.displayName),
                                    ),
                                  )
                                  .toList(growable: false),
                              onChanged: (value) {
                                if (value != null) {
                                  context.read<AddExpenseCubit>().setSelectedVehicle(value);
                                }
                              },
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Category',
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: ExpenseCategory.values
                                  .map(
                                    (category) => ChoiceChip(
                                      label: Text(category.label),
                                      selected: state.selectedCategory == category,
                                      onSelected: (_) {
                                        context.read<AddExpenseCubit>().setSelectedCategory(category);
                                      },
                                    ),
                                  )
                                  .toList(growable: false),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _amountController,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: InkWell(
                                    onTap: _pickDate,
                                    borderRadius: BorderRadius.circular(12),
                                    child: InputDecorator(
                                      decoration: const InputDecoration(labelText: 'Date'),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              MaterialLocalizations.of(context)
                                                  .formatMediumDate(_expenseDate),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const Icon(Icons.calendar_today_outlined),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _odometerController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: 'Odometer (optional)'),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) return null;
                                final parsed = int.tryParse(value.trim());
                                if (parsed == null || parsed < 0) {
                                  return 'Enter a valid odometer';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _vendorController,
                              decoration: const InputDecoration(labelText: 'Vendor (optional)'),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _notesController,
                              minLines: 2,
                              maxLines: 4,
                              decoration: const InputDecoration(labelText: 'Notes (optional)'),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton.icon(
                                onPressed: state.status == AddExpenseStatus.submitting ? null : _saveExpense,
                                icon: const Icon(Icons.save_outlined),
                                label: Text(
                                  state.status == AddExpenseStatus.submitting
                                      ? 'Saving...'
                                      : 'Save Expense',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
