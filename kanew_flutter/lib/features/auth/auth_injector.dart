import 'package:get_it/get_it.dart';
import 'package:kanew_client/kanew_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../core/di/injection.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/finish_password_reset_usecase.dart';
import 'domain/usecases/finish_registration_usecase.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/logout_usecase.dart';
import 'domain/usecases/start_password_reset_usecase.dart';
import 'domain/usecases/start_registration_usecase.dart';
import 'domain/usecases/verify_password_reset_code_usecase.dart';
import 'domain/usecases/verify_registration_code_usecase.dart';
import 'presentation/controllers/auth_controller.dart';
import 'presentation/stores/auth_store.dart';

class AuthInjector {
  final GetIt _getIt = getIt;

  void register() {
    _getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(client: _getIt<Client>()),
    );

    _getIt.registerLazySingleton(() => LoginUseCase(repository: _getIt()));
    _getIt.registerLazySingleton(
      () => StartRegistrationUseCase(repository: _getIt()),
    );
    _getIt.registerLazySingleton(
      () => VerifyRegistrationCodeUseCase(repository: _getIt()),
    );
    _getIt.registerLazySingleton(
      () => FinishRegistrationUseCase(repository: _getIt()),
    );
    _getIt.registerLazySingleton(
      () => StartPasswordResetUseCase(repository: _getIt()),
    );
    _getIt.registerLazySingleton(
      () => VerifyPasswordResetCodeUseCase(repository: _getIt()),
    );
    _getIt.registerLazySingleton(
      () => FinishPasswordResetUseCase(repository: _getIt()),
    );
    _getIt.registerLazySingleton(
      () => LogoutUseCase(authManager: _getIt<FlutterAuthSessionManager>()),
    );

    _getIt.registerFactory(() => AuthStore());
    _getIt.registerLazySingleton<AuthController>(
      () => AuthController(
        loginUseCase: _getIt(),
        startRegistrationUseCase: _getIt(),
        verifyRegistrationCodeUseCase: _getIt(),
        finishRegistrationUseCase: _getIt(),
        startPasswordResetUseCase: _getIt(),
        verifyPasswordResetCodeUseCase: _getIt(),
        finishPasswordResetUseCase: _getIt(),
        logoutUseCase: _getIt(),
        authManager: _getIt<FlutterAuthSessionManager>(),
        store: _getIt(),
      ),
    );
  }
}
