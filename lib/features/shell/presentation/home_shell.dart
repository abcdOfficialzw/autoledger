import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../expenses/presentation/add_expense_page.dart';
import '../../reports/presentation/reports_page.dart';
import '../../vehicles/presentation/vehicles_page.dart';
import 'navigation_cubit.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({super.key});

  static const _pages = [
    VehiclesPage(),
    AddExpensePage(),
    ReportsPage(),
    PlaceholderPage(title: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, index) {
        return Scaffold(
          body: SafeArea(child: _pages[index]),
          bottomNavigationBar: NavigationBar(
            selectedIndex: index,
            destinations: const [
              NavigationDestination(icon: Icon(Icons.directions_car), label: 'Vehicles'),
              NavigationDestination(icon: Icon(Icons.add_circle_outline), label: 'Add Expense'),
              NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Reports'),
              NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
            ],
            onDestinationSelected: (value) =>
                context.read<NavigationCubit>().setIndex(value),
          ),
        );
      },
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$title coming soon',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
