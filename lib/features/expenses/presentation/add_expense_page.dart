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
    if (!_formKey.currentState!.validate()) {
      return;
    }

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
    return BlocConsumer<AddExpenseCubit, AddExpenseState>(
      listener: (context, state) {
        if (state.status == AddExpenseStatus.success) {
          _resetForm();
          context.read<VehicleCubit>().loadVehicles();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Expense saved.')));
        }

        if (state.status == AddExpenseStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Add Expense',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Log expenses in under 10 seconds.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (state.status == AddExpenseStatus.loading)
                    const LiquidGlassCard(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  if (state.vehicles.isEmpty &&
                      state.status != AddExpenseStatus.loading)
                    LiquidGlassCard(
                      child: Text(
                        'No vehicles available. Add a vehicle first from the Vehicles tab.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  if (state.vehicles.isNotEmpty)
                    LiquidGlassCard(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            DropdownButtonFormField<int>(
                              initialValue: state.selectedVehicleId,
                              decoration: const InputDecoration(
                                labelText: 'Vehicle',
                              ),
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
                                  context
                                      .read<AddExpenseCubit>()
                                      .setSelectedVehicle(value);
                                }
                              },
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _amountController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: const InputDecoration(
                                labelText: 'Amount',
                              ),
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
                              initialValue: state.selectedCategory,
                              decoration: const InputDecoration(
                                labelText: 'Category',
                              ),
                              items: ExpenseCategory.values
                                  .map(
                                    (category) =>
                                        DropdownMenuItem<ExpenseCategory>(
                                          value: category,
                                          child: Text(category.label),
                                        ),
                                  )
                                  .toList(growable: false),
                              onChanged: (value) {
                                if (value != null) {
                                  context
                                      .read<AddExpenseCubit>()
                                      .setSelectedCategory(value);
                                }
                              },
                            ),
                            const SizedBox(height: 12),
                            InkWell(
                              onTap: _pickDate,
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Date',
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      MaterialLocalizations.of(
                                        context,
                                      ).formatMediumDate(_expenseDate),
                                    ),
                                    const Icon(Icons.calendar_today_outlined),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _odometerController,
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
                              controller: _vendorController,
                              decoration: const InputDecoration(
                                labelText: 'Vendor (optional)',
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _notesController,
                              minLines: 2,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                labelText: 'Notes (optional)',
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                onPressed:
                                    state.status == AddExpenseStatus.submitting
                                    ? null
                                    : _saveExpense,
                                child: Text(
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
