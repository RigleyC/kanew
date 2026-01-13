import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';

import 'core/di/injection.dart';
import 'core/router/app_coordinator.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/viewmodel/auth_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all dependencies
  await setupDependencies();

  runApp(const KanewApp());
}

class KanewApp extends StatelessWidget {
  const KanewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide AuthViewModel at the app level
        ChangeNotifierProvider<AuthViewModel>(
          create: (_) => getIt<AuthViewModel>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Kanew',
        debugShowCheckedModeBanner: false,
        // Forui theming
        builder: (context, child) => FTheme(
          data: AppTheme.dark,
          child: FToaster(child: child ?? const SizedBox.shrink()),
        ),
        // zenRouter integration
        routerDelegate: appCoordinator.routerDelegate,
        routeInformationParser: appCoordinator.routeInformationParser,
      ),
    );
  }
}
