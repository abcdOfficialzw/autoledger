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
    AddExpensePage(),
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
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: _FloatingNavBar(
              selectedIndex: index,
              onTap: (value) => context.read<NavigationCubit>().setIndex(value),
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
    (Icons.dashboard_outlined, 'Dashboard'),
    (Icons.directions_car_outlined, 'Vehicles'),
    (Icons.add_circle_outline, 'Add Expense'),
    (Icons.bar_chart_outlined, 'Reports'),
    (Icons.settings_outlined, 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(36),
        border: Border.all(color: const Color(0x22000000), width: 1.4),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final isSelected = selectedIndex == index;
              return Expanded(
                child: Semantics(
                  button: true,
                  selected: isSelected,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () => onTap(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: isSelected
                            ? const Color(0xFFDDE0E5)
                            : Colors.transparent,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            item.$1,
                            size: 22,
                            color: isSelected
                                ? colorScheme.primary
                                : const Color(0xFF111111),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.$2,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: isSelected
                                      ? colorScheme.primary
                                      : const Color(0xFF111111),
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
