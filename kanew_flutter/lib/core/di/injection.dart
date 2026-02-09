import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:kanew_client/kanew_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

import '../../config/app_config.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/viewmodel/auth_controller.dart';
import '../../features/board/data/board_repository.dart';
import '../../features/board/data/list_repository.dart';
import '../../features/board/data/card_repository.dart';
import '../../features/board/data/checklist_repository.dart';
import '../../features/board/data/comment_repository.dart';
import '../../features/board/data/activity_repository.dart';
import '../../features/board/data/label_repository.dart';
import '../../features/board/data/attachment_repository.dart';
import '../../features/board/data/board_stream_service.dart';
import '../../features/board/presentation/controllers/boards_page_controller.dart';
import '../../features/board/presentation/controllers/board_view_controller.dart';
import '../../features/board/presentation/controllers/card_detail_controller.dart';
import '../../features/board/presentation/store/board_store.dart';
import '../../features/board/presentation/store/board_filter_store.dart';
import '../../features/workspace/data/workspace_repository.dart';
import '../../features/workspace/domain/repositories/member_repository.dart';
import '../../features/workspace/data/repositories/member_repository_impl.dart';
import '../../features/workspace/viewmodel/workspace_controller.dart';
import '../../features/workspace/presentation/controllers/members_page_controller.dart';
import '../services/file_picker_service.dart';

/// Global service locator instance
final GetIt getIt = GetIt.instance;

/// Initializes all dependencies
Future<void> setupDependencies() async {
  // App configuration
  final config = await AppConfig.loadConfig();
  getIt.registerSingleton<AppConfig>(config);

  // Server URL
  const serverUrlFromEnv = String.fromEnvironment('SERVER_URL');
  final serverUrl = serverUrlFromEnv.isEmpty
      ? config.apiUrl ?? 'http://$localhost:8080/'
      : serverUrlFromEnv;

  debugPrint('[DI] Connecting to server: $serverUrl');

  // Create auth session manager (but don't initialize yet)
  final authManager = FlutterAuthSessionManager();

  // Create Serverpod client and attach auth manager
  final client = Client(serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = authManager;

  // NOW initialize the auth manager (after it's attached to client)
  // This restores any existing session and validates with server
  await authManager.initialize();
  // SessionManager.instance = authManager;
  debugPrint(
    '[DI] Auth manager initialized, isAuth=${authManager.isAuthenticated}',
  );

  // Register singletons
  getIt.registerSingleton<FlutterAuthSessionManager>(authManager);
  getIt.registerSingleton<Client>(client);

  // FilePickerService - platform-agnostic file picker
  getIt.registerLazySingleton<FilePickerService>(() => FilePickerService());

  // ============================================================
  // REPOSITORIES
  // ============================================================

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(client: getIt<Client>()),
  );

  getIt.registerLazySingleton<WorkspaceRepository>(
    () => WorkspaceRepository(client: getIt<Client>()),
  );

getIt.registerLazySingleton<MemberRepository>(
      () => MemberRepositoryImpl(client: getIt<Client>()),
    );

  getIt.registerLazySingleton<BoardRepository>(
    () => BoardRepository(client: getIt<Client>()),
  );

  // ============================================================
  // VIEWMODELS
  // ============================================================

  getIt.registerLazySingleton<AuthController>(
    () => AuthController(
      repository: getIt<AuthRepository>(),
      authManager: getIt<FlutterAuthSessionManager>(),
    ),
  );

  getIt.registerLazySingleton<WorkspaceController>(
    () => WorkspaceController(
      repository: getIt<WorkspaceRepository>(),
    ),
  );

  // Keep workspace state consistent with authentication changes.
  // - On sign-out: clear cached workspaces to avoid leaking stale state.
  // - On sign-in: (re)load workspaces.
  final workspaceController = getIt<WorkspaceController>();
  var lastIsAuthenticated = authManager.isAuthenticated;
  authManager.authInfoListenable.addListener(() {
    final isAuthenticated = authManager.isAuthenticated;
    if (isAuthenticated == lastIsAuthenticated) return;
    lastIsAuthenticated = isAuthenticated;

    if (!isAuthenticated) {
      workspaceController.clear();
      return;
    }

    unawaited(workspaceController.init());
  });

  if (authManager.isAuthenticated) {
    unawaited(workspaceController.init());
  }

  getIt.registerLazySingleton<ListRepository>(
    () => ListRepository(client: getIt<Client>()),
  );

  // NOTE: ListController now requires boardId param - created in BoardScope

  getIt.registerLazySingleton<CardRepository>(
    () => CardRepository(client: getIt<Client>()),
  );

  getIt.registerLazySingleton<ChecklistRepository>(
    () => ChecklistRepository(client: getIt<Client>()),
  );

  getIt.registerLazySingleton<CommentRepository>(
    () => CommentRepository(client: getIt<Client>()),
  );

  getIt.registerLazySingleton<ActivityRepository>(
    () => ActivityRepository(client: getIt<Client>()),
  );

  getIt.registerLazySingleton<LabelRepository>(
    () => LabelRepository(client: getIt<Client>()),
  );

  getIt.registerLazySingleton<AttachmentRepository>(
    () => AttachmentRepository(client: getIt<Client>()),
  );

  getIt.registerLazySingleton<BoardStore>(
    () => BoardStore(),
  );

  getIt.registerLazySingleton<BoardFilterStore>(
    () => BoardFilterStore(),
  );

  // ============================================================
  // PAGE CONTROLLERS (Factories)

  // ============================================================

  getIt.registerFactory<BoardsPageController>(
    () => BoardsPageController(repository: getIt<BoardRepository>()),
  );

  // Register BoardStreamService as Factory (new instance per board)
  getIt.registerFactory<BoardStreamService>(
    () => BoardStreamService(client: getIt<Client>()),
  );

  getIt.registerFactory<BoardViewPageController>(
    () => BoardViewPageController(
      boardRepo: getIt<BoardRepository>(),
      listRepo: getIt<ListRepository>(),
      cardRepo: getIt<CardRepository>(),
      boardStore: getIt<BoardStore>(),
      streamService: getIt<BoardStreamService>(),
    ),
  );

  getIt.registerFactory<CardDetailPageController>(
    () => CardDetailPageController(
      repository: getIt<CardRepository>(),
      checklistRepo: getIt<ChecklistRepository>(),
      commentRepo: getIt<CommentRepository>(),
      activityRepo: getIt<ActivityRepository>(),
      labelRepo: getIt<LabelRepository>(),
      attachmentRepo: getIt<AttachmentRepository>(),
      filePicker: getIt<FilePickerService>(),
      boardStore: getIt<BoardStore>(),
    ),
  );

getIt.registerFactory<MembersPageController>(
      () => MembersPageController(
        repository: getIt<MemberRepository>(),
        workspaceRepository: getIt<WorkspaceRepository>(),
      ),
    );
}

/// Gets the Serverpod client
Client get client => getIt<Client>();

/// Gets the auth session manager
FlutterAuthSessionManager get authManager => getIt<FlutterAuthSessionManager>();
