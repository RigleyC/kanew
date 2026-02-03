import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:forui/forui.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Use path-based URLs (e.g., /invite/code instead of /#/invite/code)
  usePathUrlStrategy();

  await setupDependencies();

  await initializeDateFormatting('pt_BR', null);

  runApp(const KanewApp());
}

class KanewApp extends StatelessWidget {
  const KanewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      builder: (context, child) =>
          FToaster(child: child ?? const SizedBox.shrink()),
      routerConfig: appRouter,
    );
  }
}
