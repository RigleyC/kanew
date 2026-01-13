import 'package:get_it/get_it.dart';
import 'package:kanew_client/kanew_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

import '../../config/app_config.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/viewmodel/auth_viewmodel.dart';

/// Global service locator instance
final GetIt getIt = GetIt.instance;

/// Initializes all dependencies
Future<void> setupDependencies() async {
  // ============================================================
  // CORE SERVICES
  // ============================================================

  // App configuration
  final config = await AppConfig.loadConfig();
  getIt.registerSingleton<AppConfig>(config);

  // Server URL
  const serverUrlFromEnv = String.fromEnvironment('SERVER_URL');
  final serverUrl = serverUrlFromEnv.isEmpty
      ? config.apiUrl ?? 'http://$localhost:8080/'
      : serverUrlFromEnv;

  // Auth session manager
  final authManager = FlutterAuthSessionManager();
  await authManager.initialize();
  getIt.registerSingleton<FlutterAuthSessionManager>(authManager);

  // Serverpod client
  final client = Client(serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = authManager;
  getIt.registerSingleton<Client>(client);

  // ============================================================
  // REPOSITORIES
  // ============================================================

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(client: getIt<Client>()),
  );

  // ============================================================
  // VIEWMODELS
  // ============================================================

  // AuthViewModel is registered as factory (new instance each time)
  // This allows multiple screens to have their own instance if needed
  getIt.registerFactory<AuthViewModel>(
    () => AuthViewModel(
      repository: getIt<AuthRepository>(),
      authManager: getIt<FlutterAuthSessionManager>(),
    ),
  );
}

/// Gets the Serverpod client
Client get client => getIt<Client>();

/// Gets the auth session manager
FlutterAuthSessionManager get authManager => getIt<FlutterAuthSessionManager>();
