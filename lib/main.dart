import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';

import 'core/database/local_database.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/expenses/data/isar_expense_repository.dart';
import 'features/expenses/data/services/local_csv_export_service.dart';
import 'features/expenses/domain/expense_repository.dart';
import 'features/expenses/domain/services/csv_export_service.dart';
import 'features/expenses/presentation/cubit/add_expense_cubit.dart';
import 'features/settings/data/local_settings_repository.dart';
import 'features/settings/domain/settings_repository.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'features/shell/presentation/navigation_cubit.dart';
import 'features/vehicles/data/isar_vehicle_repository.dart';
import 'features/vehicles/domain/vehicle_repository.dart';
import 'features/vehicles/presentation/cubit/vehicle_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isar = await LocalDatabase.open();
  runApp(
    AutoLedgerApp(isar: isar, settingsRepository: LocalSettingsRepository()),
  );
}

class AutoLedgerApp extends StatelessWidget {
  const AutoLedgerApp({
    this.isar,
    this.vehicleRepository,
    this.expenseRepository,
    required this.settingsRepository,
    super.key,
  }) : assert(
         isar != null ||
             (vehicleRepository != null && expenseRepository != null),
         'Provide either isar or explicit repositories.',
       );

  final Isar? isar;
  final VehicleRepository? vehicleRepository;
  final ExpenseRepository? expenseRepository;
  final SettingsRepository settingsRepository;

  @override
  Widget build(BuildContext context) {
    final resolvedVehicleRepository =
        vehicleRepository ?? IsarVehicleRepository(isar!);
    final resolvedExpenseRepository =
        expenseRepository ?? IsarExpenseRepository(isar!);
    final csvExportService = LocalCsvExportService(
      resolvedExpenseRepository,
      resolvedVehicleRepository,
    );

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<VehicleRepository>(
          create: (_) => resolvedVehicleRepository,
        ),
        RepositoryProvider<ExpenseRepository>(
          create: (_) => resolvedExpenseRepository,
        ),
        RepositoryProvider<CsvExportService>(create: (_) => csvExportService),
        RepositoryProvider<SettingsRepository>(
          create: (_) => settingsRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => NavigationCubit()),
          BlocProvider(
            create: (context) =>
                SettingsCubit(context.read<SettingsRepository>())
                  ..loadPreferences(),
          ),
          BlocProvider(
            create: (context) =>
                VehicleCubit(context.read<VehicleRepository>()),
          ),
          BlocProvider(
            create: (context) => AddExpenseCubit(
              context.read<ExpenseRepository>(),
              context.read<VehicleRepository>(),
            ),
          ),
        ],
        child: MaterialApp.router(
          title: 'Auto Ledger',
          theme: AppTheme.light,
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter,
        ),
      ),
    );
  }
}
