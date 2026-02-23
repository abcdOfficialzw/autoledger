import 'package:go_router/go_router.dart';

import '../../features/shell/presentation/home_shell.dart';

final appRouter = GoRouter(
  routes: [GoRoute(path: '/', builder: (context, state) => const HomeShell())],
);
