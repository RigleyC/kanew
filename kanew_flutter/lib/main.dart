import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all dependencies
  await setupDependencies();

  // Initialize locale data for date formatting
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
