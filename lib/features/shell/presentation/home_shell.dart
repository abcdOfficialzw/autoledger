import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dashboard/presentation/dashboard_page.dart';
import '../../expenses/presentation/add_expense_page.dart';
import '../../reports/presentation/reports_page.dart';
import '../../settings/presentation/settings_page.dart';
import '../../vehicles/presentation/vehicles_page.dart';
import 'navigation_cubit.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({super.key});

  static const _pages = [
    DashboardPage(),
    VehiclesPage(),
    ReportsPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, index) {
        return Scaffold(
          extendBody: true,
          body: SafeArea(child: _pages[index]),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
            child: Row(
              children: [
                Expanded(
                  child: _FloatingNavBar(
                    selectedIndex: index,
                    onTap: (value) =>
                        context.read<NavigationCubit>().setIndex(value),
                  ),
                ),
                const SizedBox(width: 10),
                _AddFab(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const AddExpensePage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FloatingNavBar extends StatelessWidget {
  const _FloatingNavBar({required this.selectedIndex, required this.onTap});

  final int selectedIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    Icons.home_outlined,
    Icons.directions_car_outlined,
    Icons.bar_chart_outlined,
    Icons.settings_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: const Color(0x1A000000), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: List.generate(_items.length, (index) {
            final icon = _items[index];
            final isSelected = selectedIndex == index;
            return Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => onTap(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: isSelected
                        ? const Color(0xFFE7E8ED)
                        : Colors.transparent,
                  ),
                  child: Icon(
                    icon,
                    size: 22,
                    color: isSelected
                        ? colorScheme.primary
                        : const Color(0xFF111111),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _AddFab extends StatelessWidget {
  const _AddFab({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 10,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: const SizedBox(
          width: 66,
          height: 66,
          child: Icon(Icons.add, size: 31),
        ),
      ),
    );
  }
}
