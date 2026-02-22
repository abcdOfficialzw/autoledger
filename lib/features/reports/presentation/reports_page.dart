import 'package:flutter/material.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reports', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'You will see total spend, monthly average, cost/km, and category breakdown here.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              title: const Text('Total ownership cost'),
              subtitle: const Text('Purchase price + logged expenses'),
              trailing: Text('US\$ 0.00', style: Theme.of(context).textTheme.titleMedium),
            ),
          ),
        ],
      ),
    );
  }
}
