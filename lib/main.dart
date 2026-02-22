import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/shell/presentation/navigation_cubit.dart';

void main() {
  runApp(const AutoLedgerApp());
}

class AutoLedgerApp extends StatelessWidget {
  const AutoLedgerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NavigationCubit()),
      ],
      child: MaterialApp.router(
        title: 'Auto Ledger',
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
      ),
    );
  }
}
