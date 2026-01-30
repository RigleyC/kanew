# Contexto do Projeto e Diretrizes para Agentes de IA

## 1. Visão Geral e Filosofia

Este é um projeto Flutter escalável que utiliza **Clean Architecture** (Clean Dart), **SOLID** e **GetIt** para injeção de dependência.
O foco é manter o código desacoplado, testável e seguindo padrões estritos de separação de responsabilidades.

**Filosofia de Implementação:**
- **Simplicidade:** Evite complexidade acidental.
- **Protocolo de Confirmação:** Antes de gerar código para uma feature, **explique a abordagem** e aguarde o "de acordo" do usuário.
- **Feature-First:** O código é organizado por features dentro das camadas.
- **Zero Lógica nas Pages:** Páginas são apenas "escutadoras" de estado. Toda lógica fica em Controllers/UseCases.

---

## 2. Tech Stack & Comandos

- **Linguagem:** Dart (Latest) & Flutter (Latest).
- **HTTP:** Dio + Retrofit.
- **DI:** GetIt (Organizado via `Injector` pattern por feature).
- **State:** `ChangeNotifier` para Controllers + `ValueNotifier<State>` para estados reativos.
- **Code Gen:** `build_runner` (JsonSerializable, Retrofit, etc).

### Comandos Essenciais
```bash
# Build Runner (Gera código para Retrofit, JsonSerializable, etc)
flutter pub run build_runner build --delete-conflicting-outputs

# Testes
flutter test
flutter test --coverage

# Análise de código
flutter analyze

# Formatação
dart format lib/ test/

# Run com Flavors
flutter run --flavor develop --dart-define-from-file=.dev.env
flutter run --flavor production --dart-define-from-file=.prod.env
```

---

## 3. Arquitetura e Camadas

O fluxo de dependência é estrito: `UI -> Presentation -> Domain <- Infra <- External`.

### 📂 Domain (Core/Regras)
*Puro Dart. Zero Flutter. Zero pacotes externos (exceto dartz/equatable).*
- **Entities:** Objetos de negócio puros.
- **UseCases:** Regra de negócio única (`call`). Retorna `Future<Either<Failure, Type>>`.
- **Repositories (Interfaces):** Contratos de acesso a dados.

### 📂 Infra (Adaptadores)
*Orquestração e tratamento de erros.*
- **Repositories (Impl):** Implementam interfaces do Domain. Capturam exceções e retornam `Failures`.
- **DataSources (Interfaces):** Contratos para acesso a dados (Remote/Local).

### 📂 External (Frameworks/Drivers)
*O mundo exterior.*
- **DataSources (Impl):** Chamam `Retrofit`, `Hive`, `SharedPreferences`, etc.
- **Models:** DTOs com métodos `fromJson`/`toJson` e mappers `toEntity`.

### 📂 Presentation (UI + Lógica de Apresentação)
*A camada de apresentação e orquestração.*
- **Pages:** Widgets que escutam estado. Usam `Navigator 1.0`. **ZERO LÓGICA DE NEGÓCIO**.
- **Controllers:**
  - Classes que orquestram chamadas aos UseCases.
  - **Extendem `ChangeNotifier`**.
  - Gerenciam o ciclo de vida da tela.
- **States:** Classes que representam os estados da tela (Loading, Success, Error, etc).
- **Stores:** `ValueNotifier<State>` ou `ChangeNotifier` que mantém o estado reativo.

### 📂 Core (Cross-Cutting)
Organizado por **pastas separadas**:
- **`di/`**: Injectors e Service Locator.
- **`errors/`**: Failures e Exceptions customizadas.
- **`ui/`**: Theme, Colors, TextStyles.
- **`routes/`**: RouteManager e RouteFactories.
- **`widgets/`**: Componentes globais (Snackbars, Dialogs, BottomSheets).
- **`utils/`**: Constants, Extensions, Helpers.

---

## 4. Estrutura de Pastas Completa

```
lib/
├── core/
│   ├── di/
│   │   ├── injector.dart                # Classe abstrata base para Injectors
│   │   └── service_locator.dart         # Setup do GetIt
│   ├── errors/
│   │   ├── failures.dart                # Classes base de Failure
│   │   └── exceptions.dart              # Exceptions customizadas
│   ├── ui/
│   │   ├── theme/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_text_styles.dart
│   │   └── app_theme.dart
│   ├── routes/
│   │   ├── my_route_factory.dart        # Interface base para Factories
│   │   ├── route_manager.dart           # Gerenciador central de rotas
│   │   └── auth_routers/
│   │       └── auth_route_factory.dart
│   ├── widgets/
│   │   ├── snackbar.dart                # showSnackbar()
│   │   ├── dialog.dart                  # showCustomDialog()
│   │   └── bottom_sheet.dart            # showBottomSheet()
│   └── utils/
│       ├── constants.dart
│       └── extensions.dart
├── features/
│   └── auth/
│       ├── domain/
│       │   ├── entities/
│       │   │   └── user_entity.dart
│       │   ├── repositories/
│       │   │   └── auth_repository.dart
│       │   └── usecases/
│       │       ├── login_usecase.dart
│       │       └── logout_usecase.dart
│       ├── infra/
│       │   ├── datasources/
│       │   │   └── auth_datasource.dart
│       │   └── repositories/
│       │       └── auth_repository_impl.dart
│       ├── external/
│       │   ├── datasources/
│       │   │   └── auth_datasource_impl.dart
│       │   └── models/
│       │       └── user_model.dart
│       ├── presentation/
│       │   ├── controllers/
│       │   │   └── login_controller.dart
│       │   ├── states/
│       │   │   └── login_state.dart
│       │   ├── stores/
│       │   │   └── login_store.dart
│       │   └── pages/
│       │       └── login_page.dart
│       └── auth_injector.dart
└── main.dart
```

### Estrutura de Testes (Espelha as Features)
```
test/
├── core/
│   └── di/
│       └── service_locator_test.dart
└── features/
    └── auth/
        ├── domain/
        │   └── usecases/
        │       └── login_usecase_test.dart
        ├── infra/
        │   └── repositories/
        │       └── auth_repository_impl_test.dart
        └── presentation/
            └── controllers/
                └── login_controller_test.dart
```

---

## 5. Padrões de Desenvolvimento

### 5.1. Injeção de Dependência (GetIt)

Utilize o padrão de **Injectors** para modularizar o registro:

```dart
// core/di/injector.dart
abstract class Injector {
  void register();
}
```

```dart
// features/auth/auth_injector.dart
import 'package:get_it/get_it.dart';
import '../../core/di/injector.dart';

class AuthInjector extends Injector {
  final GetIt _getIt = GetIt.instance;

  @override
  void register() {
    // DataSources
    _getIt.registerLazySingleton<AuthDataSource>(
      () => AuthDataSourceImpl(_getIt()),
    );

    // Repositories
    _getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(_getIt()),
    );

    // UseCases
    _getIt.registerLazySingleton(() => LoginUseCase(_getIt()));
    _getIt.registerLazySingleton(() => LogoutUseCase(_getIt()));

    // Controllers (Factory para criar nova instância a cada tela)
    _getIt.registerFactory(() => LoginController(_getIt()));
  }
}
```

```dart
// core/di/service_locator.dart
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import '../../features/auth/auth_injector.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Registra NavigatorState e BuildContext globais
  getIt.registerLazySingleton<GlobalKey<NavigatorState>>(
    () => GlobalKey<NavigatorState>(),
  );

  // Registra todos os Injectors das features
  AuthInjector().register();
  // ProfileInjector().register();
  // OrderInjector().register();
}
```

---

### 5.2. Gerenciamento de Estado

**Regra:** 
- Controllers **sempre extendem `ChangeNotifier`**.
- Estados são gerenciados via **`ValueNotifier<State>`** (Store) dentro do Controller.
- A Store é apenas um `ValueNotifier` puro - **sem métodos extras**. Use `store.value = NovoEstado()` diretamente.

#### Padrão de State (Sealed Classes)

```dart
// presentation/states/login_state.dart
sealed class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final UserEntity user;
  LoginSuccess(this.user);
}

class LoginError extends LoginState {
  final String message;
  LoginError(this.message);
}
```

#### Store (Gerenciamento Reativo)

```dart
// presentation/stores/login_store.dart
import 'package:flutter/foundation.dart';
import '../states/login_state.dart';

class LoginStore extends ValueNotifier<LoginState> {
  LoginStore() : super(LoginInitial());
}
```

#### Controller (Orquestração)

```dart
// presentation/controllers/login_controller.dart
import 'package:flutter/foundation.dart';
import '../../domain/usecases/login_usecase.dart';
import '../stores/login_store.dart';
import '../states/login_state.dart';

class LoginController extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final LoginStore store = LoginStore();

  LoginController(this._loginUseCase);

  Future<void> login(String email, String password) async {
    store.value = LoginLoading();

    final result = await _loginUseCase(LoginParams(email, password));

    result.fold(
      (failure) => store.value = LoginError(failure.message),
      (user) => store.value = LoginSuccess(user),
    );
  }

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }
}
```

#### Page (UI Reativa)

```dart
// presentation/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controllers/login_controller.dart';
import '../states/login_state.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LoginController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GetIt.instance<LoginController>();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: ValueListenableBuilder<LoginState>(
        valueListenable: _controller.store,
        builder: (context, state, _) {
          return switch (state) {
            LoginInitial() => _buildForm(),
            LoginLoading() => const Center(child: CircularProgressIndicator()),
            LoginSuccess() => const Center(child: Text('Sucesso!')),
            LoginError(message: final msg) => Center(child: Text(msg)),
          };
        },
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      spacing: 16, // Ao invés de SizedBox
      children: [
        TextField(/* email */),
        TextField(/* senha */),        
        ElevatedButton(
          onPressed: () => _controller.login('email', 'senha'),
          child: const Text('Entrar'),
        ),
      ],
    );
  }
}
```

---

### 5.3. Navegação (Navigator 1.0 + Route Factory)

#### MyRouteFactory (Interface Base)

```dart
// core/routes/my_route_factory.dart
import 'package:flutter/material.dart';

abstract class MyRouteFactory {
  Map<String, WidgetBuilder> generateRoutes(RouteSettings settings);
}
```

#### AuthRouteFactory (Exemplo de Factory)

```dart
// core/routes/auth_routers/auth_route_factory.dart
import 'package:flutter/material.dart';
import '../../../features/auth/presentation/pages/login_page.dart';
import '../my_route_factory.dart';

class AuthRouteFactory implements MyRouteFactory {
  static const String routeFamily = 'auth';

  @override
  Map<String, WidgetBuilder> generateRoutes(RouteSettings settings) {
    return {
      LoginPage.routeName: (_) => const LoginPage(),
      
      // Exemplo com argumentos
      RegisterPage.routeName: (_) {
        final args = settings.arguments;
        RegisterPageArguments? typedArgs;
        
        if (args != null && args is RegisterPageArguments) {
          typedArgs = args;
        }

        return RegisterPage(
          initialEmail: typedArgs?.initialEmail,
          onSuccess: typedArgs?.onSuccess,
        );
      },
    };
  }
}

// Classe de argumentos
class RegisterPageArguments {
  final String? initialEmail;
  final VoidCallback? onSuccess;

  RegisterPageArguments({this.initialEmail, this.onSuccess});
}
```

#### RouteManager (Gerenciador Central)

```dart
// core/routes/route_manager.dart
import 'package:flutter/material.dart';
import 'auth_routers/auth_route_factory.dart';
import 'profile_routers/profile_route_factory.dart';
import 'my_route_factory.dart';

class RouteManager {
  static Map<String, MyRouteFactory> factories = {
    AuthRouteFactory.routeFamily: AuthRouteFactory(),
    ProfileRouteFactory.routeFamily: ProfileRouteFactory(),
  };

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Route<dynamic> generateRoute(
    RouteSettings settings, {
    String defaultRoute = AuthRouteFactory.routeFamily,
  }) {
    final factory = factories[_getRouteFamily(settings.name ?? defaultRoute)];

    if (factory != null) {
      final routes = factory.generateRoutes(settings);
      final builder = routes[settings.name];
      if (builder != null) {
        return MaterialPageRoute(builder: builder);
      }
    }

    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(child: Text('Rota não encontrada: ${settings.name}')),
      ),
    );
  }

  static String _getRouteFamily(String routeName) {
    final parts = routeName.split('/');
    return parts.first;
  }

  // Métodos de navegação
  static void navigateTo(String routeName) {
    navigatorKey.currentState?.pushNamed(routeName);
  }

  static void pop<T extends Object?>([T? result]) {
    navigatorKey.currentState?.pop(result);
  }

  static void popUntilFirst() {
    navigatorKey.currentState?.popUntil((route) => route.isFirst);
  }

  static void navigateToAndRemoveUntil(String routeName) {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
    );
  }

  static Future<T?> navigateToWithArguments<T extends Object?>(
    String routeName,
    Object? arguments,
  ) async {
    return await navigatorKey.currentState?.pushNamed(
      routeName,
      arguments: arguments,
    );
  }
}
```

#### Registrando no MaterialApp

```dart
// main.dart
import 'package:flutter/material.dart';
import 'core/di/service_locator.dart';
import 'core/routes/route_manager.dart';

void main() {
  setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: RouteManager.navigatorKey,
      onGenerateRoute: RouteManager.generateRoute,
      initialRoute: '/login',
    );
  }
}
```

---

### 5.4. UI Global (Snackbars, Dialogs, Sheets)

**Regra:** Widgets globais ficam em `core/widgets/` como **funções soltas** que acessam `NavigatorState` e `BuildContext` via GetIt.

#### Registrando NavigatorState no GetIt

```dart
// core/di/service_locator.dart (já mostrado antes)
getIt.registerLazySingleton<GlobalKey<NavigatorState>>(
  () => GlobalKey<NavigatorState>(),
);
```

#### Snackbar Global

```dart
// core/widgets/snackbar.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

void showSnackbar({
  required String message,
  Color? backgroundColor,
  Duration duration = const Duration(seconds: 3),
}) {
  final context = GetIt.instance<GlobalKey<NavigatorState>>().currentContext;
  if (context == null) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      duration: duration,
    ),
  );
}

void showSuccessSnackbar({required String message}) {
  showSnackbar(message: message, backgroundColor: Colors.green);
}

void showErrorSnackbar({required String message}) {
  showSnackbar(message: message, backgroundColor: Colors.red);
}
```

#### Dialog Global

```dart
// core/widgets/dialog.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../routes/route_manager.dart';

Future<bool?> showCustomDialog({
  required String title,
  required String message,
  String confirmText = 'Confirmar',
  String cancelText = 'Cancelar',
}) async {
  final context = GetIt.instance<GlobalKey<NavigatorState>>().currentContext;
  if (context == null) return null;

  return await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => RouteManager.pop(false),
          child: Text(cancelText),
        ),
        ElevatedButton(
          onPressed: () => RouteManager.pop(true),
          child: Text(confirmText),
        ),
      ],
    ),
  );
}
```

#### Bottom Sheet Global

```dart
// core/widgets/bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

Future<T?> showCustomBottomSheet<T>({
  required Widget child,
  bool isDismissible = true,
}) async {
  final context = GetIt.instance<GlobalKey<NavigatorState>>().currentContext;
  if (context == null) return null;

  return await showModalBottomSheet<T>(
    context: context,
    isDismissible: isDismissible,
    builder: (_) => child,
  );
}
```

---

### 5.5. Tratamento de Erros

Use classes de `Failure` personalizadas no Domain:

```dart
// core/errors/failures.dart
abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure([String message = 'Erro no servidor']) : super(message);
}

class InvalidCredentialsFailure extends Failure {
  InvalidCredentialsFailure() : super('Credenciais inválidas');
}

class NetworkFailure extends Failure {
  NetworkFailure() : super('Sem conexão com a internet');
}
```

```dart
// core/errors/exceptions.dart
class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class CacheException implements Exception {}
```

No Repository (Infra), capture Exceptions e retorne Failures:

```dart
@override
Future<Either<Failure, UserEntity>> login(String email, String password) async {
  try {
    final model = await dataSource.login(email, password);
    return Right(model.toEntity());
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message));
  } on DioException catch (e) {
    if (e.response?.statusCode == 401) {
      return Left(InvalidCredentialsFailure());
    }
    return Left(NetworkFailure());
  }
}
```

---

## 6. Convenções de Código

### 6.1. Naming

- **Classes:** PascalCase (`LoginUseCaseImpl`, `AuthRepository`)
- **Arquivos:** snake_case (`login_usecase_impl.dart`, `auth_repository.dart`)
- **Sufixos obrigatórios:**
  - `Impl`: `AuthRepositoryImpl`
  - `UseCase`: `GetUserUseCase`
  - `Page`: `LoginPage`
  - `Controller`: `HomeController`
  - `Store`: `LoginStore`
  - `State`: `LoginState`

### 6.2. Imports

Organize nesta ordem:

1. Dart SDK (`dart:async`)
2. Flutter (`package:flutter/material.dart`)
3. Packages (`package:dio/dio.dart`, `package:get_it/get_it.dart`)
4. Projeto Core (`package:app/core/...`)
5. Projeto Features (imports relativos: `../../domain/...`)

**Exemplo:**
```dart
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:app/core/errors/failures.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
```

### 6.3. Flutter Best Practices

#### Spacing

```dart
// ❌ NUNCA use SizedBox para espaçamento
Column(
  children: [
    Text('Título'),
    SizedBox(height: 16),
    Text('Subtítulo'),
  ],
)

// ✅ SEMPRE use Spacing
Column(
  spacing: 16,
  children: [
    Text('Título'),
    Text('Subtítulo'),
  ],
)
```


#### Widgets Condicionais

```dart
// ❌ Evite ternários aninhados
Column(
  children: [
    isLoading ? CircularProgressIndicator() : Container(),
    hasError ? Text('Erro') : Container(),
  ],
)

// ✅ Use if dentro de listas
Column(
  children: [
    if (isLoading) CircularProgressIndicator(),
    if (hasError) Text('Erro'),
  ],
)
```

#### Performance

- Use `const` construtores sempre que possível.
- Evite `setState` para lógica complexa (use Controllers).
- Use `ListView.builder` para listas longas.

#### Outras Regras

- **Evite `!` (null assertion)** sem justificativa clara. Prefira `??` ou `?.`.
- **Prefira `final`** sobre `var` quando o tipo é inferido.
- **Use `async`/`await`** ao invés de `.then()`.

**Referência completa:** https://github.com/flutter/flutter/blob/main/docs/rules/rules.md

---

## 7. Git Workflow & Convenções

### 7.1. Branch Strategy

- **`main/master`:** Código em produção.
- **`develop`:** Integração contínua (staging).
- **`feature/nome-da-feature`:** Novas funcionalidades.
- **`fix/descricao-do-bug`:** Correções de bugs.
- **`refactor/descricao`:** Melhorias sem alterar comportamento.
- **`chore/descricao`:** Tarefas de manutenção (deps, configs).

### 7.2. Commit Messages (Conventional Commits)

```bash
feat: adiciona tela de login
feat(auth): implementa UseCase de logout
fix: corrige erro ao salvar usuário no cache
fix(profile): resolve crash ao editar dados pessoais
refactor: remove código duplicado em AuthRepository
refactor(orders): simplifica lógica de cálculo de frete
chore: atualiza dependências do pubspec
chore(ci): configura pipeline de testes automatizados
docs: adiciona documentação do UseCase
test: adiciona testes para LoginController
style: formata código com dart format
```

### 7.3. Pull Request Checklist

Antes de abrir um PR, verifique:

- [ ] Código segue os padrões de Clean Architecture
- [ ] Testes unitários adicionados/atualizados
- [ ] `flutter analyze` sem warnings
- [ ] `dart format lib/ test/` executado
- [ ] Build Runner executado (se aplicável)
- [ ] Commit messages seguem Conventional Commits
- [ ] PR tem título descritivo e contexto no corpo

---

## 8. Estratégia de Testes

### 8.1. Estrutura de Testes

A estrutura de testes **espelha a estrutura de features**:

```
test/
└── features/
    └── auth/
        ├── domain/
        │   └── usecases/
        │       └── login_usecase_test.dart
        ├── infra/
        │   └── repositories/
        │       └── auth_repository_impl_test.dart
        └── presentation/
            └── controllers/
                └── login_controller_test.dart
```

### 8.2. Regras de Testes

#### Domain (UseCases)
- **Mocke APENAS** o Repository.
- Teste cenários de **sucesso** e **falha**.

```dart
// test/features/auth/domain/usecases/login_usecase_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });

  test('deve retornar UserEntity quando login for bem-sucedido', () async {
    // Arrange
    when(() => mockRepository.login(any(), any()))
        .thenAnswer((_) async => Right(mockUser));

    // Act
    final result = await useCase(LoginParams('email', 'senha'));

    // Assert
    expect(result, Right(mockUser));
    verify(() => mockRepository.login('email', 'senha')).called(1);
  });

  test('deve retornar Failure quando credenciais forem inválidas', () async {
    // Arrange
    when(() => mockRepository.login(any(), any()))
        .thenAnswer((_) async => Left(InvalidCredentialsFailure()));

    // Act
    final result = await useCase(LoginParams('email', 'senha'));

    // Assert
    expect(result, Left(InvalidCredentialsFailure()));
  });
}
```

#### Infra (Repositories)
- **Mocke o DataSource**.
- Verifique se **Exceptions viram Failures**.

```dart
test('deve retornar ServerFailure quando DataSource lançar Exception', () async {
  // Arrange
  when(() => mockDataSource.login(any(), any()))
      .thenThrow(ServerException('Erro'));

  // Act
  final result = await repository.login('email', 'senha');

  // Assert
  expect(result, Left(ServerFailure('Erro')));
});
```

#### Presentation (Controllers)
- **Mocke o UseCase**.
- Verifique se os **estados mudam corretamente**.

```dart
test('deve atualizar store para Success quando login for bem-sucedido', () async {
  // Arrange
  when(() => mockLoginUseCase(any()))
      .thenAnswer((_) async => Right(mockUser));

  // Act
  await controller.login('email', 'senha');

  // Assert
  expect(controller.store.value, isA<LoginSuccess>());
});
```

---

## 9. Guia Passo-a-Passo para Novas Features

Antes de começar, **sempre explique a abordagem ao usuário e aguarde confirmação**.

### Passo 1: Domain (Camada Pura)
1. Crie a **Entity** (`user_entity.dart`)
2. Crie a **Interface do Repository** (`auth_repository.dart`)
3. Crie o **UseCase** (`login_usecase.dart`)

### Passo 2: Infra (Orquestração)
1. Crie a **Interface do DataSource** (`auth_datasource.dart`)
2. Crie a **Implementação do Repository** (`auth_repository_impl.dart`)

### Passo 3: External (Mundo Exterior)
1. Crie o **Model** com `fromJson`/`toJson` (`user_model.dart`)
2. Crie a **Implementação do DataSource** com Retrofit (`auth_datasource_impl.dart`)
3. Execute `build_runner` se necessário

### Passo 4: Core (Injeção)
1. Crie/Atualize o **FeatureInjector** (`auth_injector.dart`)
2. Registre no `service_locator.dart`

### Passo 5: Presentation (Lógica + UI)
1. Crie os **States** (`login_state.dart`)
2. Crie a **Store** (`login_store.dart`)
3. Crie o **Controller** (`login_controller.dart`)
4. Crie a **Page** (`login_page.dart`)

### Passo 6: Rotas
1. Crie/Atualize a **RouteFactory** da feature (`auth_route_factory.dart`)
2. Registre no `RouteManager`

### Passo 7: Testes
1. Teste o **UseCase**
2. Teste o **Repository**
3. Teste o **Controller**

---

## 10. Troubleshooting Comum

### "GetIt: Object not registered"
**Causa:** Você tentou acessar uma dependência antes de registrá-la.  
**Solução:** Verifique se o `Injector.register()` foi chamado no `service_locator.dart`.

### "Build Runner não gera arquivos"
**Causa:** Conflitos de cache ou imports errados.  
**Solução:**
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### "Null check operator used on a null value"
**Causa:** Você assumiu que uma variável nunca seria nula (`!`).  
**Solução:** Use `??` ou `?.` ao invés de `!`.

### "setState called during build"
**Causa:** Você atualizou estado dentro de um build method.  
**Solução:** Use `WidgetsBinding.instance.addPostFrameCallback`.

### "Context is null no showSnackbar"
**Causa:** `navigatorKey.currentContext` ainda não foi inicializado.  
**Solução:** Garanta que o `MaterialApp` já foi construído antes de chamar.

---

## 11. Checklist Final (Antes de Commitar)

- [ ] Código segue Clean Architecture
- [ ] Imports organizados corretamente
- [ ] Naming conventions seguidas
- [ ] Testes criados/atualizados
- [ ] `flutter analyze` sem warnings
- [ ] `dart format lib/ test/` executado
- [ ] Build Runner executado (se necessário)
- [ ] Commit message segue Conventional Commits
- [ ] Page não contém lógica de negócio
- [ ] Estados são gerenciados via Controllers/Stores
- [ ] Navegação usa RouteManager

---

## 12. Recursos Adicionais

- **Clean Architecture:** https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html
- **Clean Dart:** https://github.com/Flutterando/Clean-Dart
- **GetIt:** https://pub.dev/packages/get_it
- **Dartz:** https://pub.dev/packages/dartz
- **Flutter Style Guide:** https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo
- **Flutter Rules:** https://github.com/flutter/flutter/blob/main/docs/rules/rules.md

---

**Última Atualização:** Janeiro 2026  
**Versão:** 1.0.0
