import 'package:flutter/material.dart';

class AddExpensePage extends StatelessWidget {
  const AddExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Add Expense', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(labelText: 'Amount')),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(labelText: 'Category (Fuel, Service...)')),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(labelText: 'Odometer (optional)')),
          const SizedBox(height: 16),
          FilledButton(onPressed: () {}, child: const Text('Save Expense')),
        ],
      ),
    );
  }
}
