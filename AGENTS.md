# AGENTS.md

**Resumo:** Guia completo para implementar, corrigir ou rodar qualquer feature do projeto. Contém estrutura, padrões, comandos e referências necessárias.

---

## 1. Quick Start

### Comandos Essenciais

```bash
# Rodar o app
flutter run

# Com flavors
flutter run --flavor develop --dart-define-from-file=.dev.env
flutter run --flavor production --dart-define-from-file=.prod.env

# Análise
flutter analyze

# Formatação
dart format lib/

# Testes
flutter test
flutter test --coverage

# Serverpod (backend)
cd kanew_server
serverpod generate
dart run bin/main.dart
```

###上下文中文字符

O contexto do projeto está nos arquivos:
- `AGENTS.md` - Este arquivo
- `RULES.md` - Regras e boas práticas
- `plan.md` - Especificação do produto
- `ARCHITECTURE.md` - Decisões arquiteturais

---

## 2. Stack Tecnológica

| Componente | Tecnologia | Propósito |
|------------|------------|-----------|
| Frontend | Flutter 3.x | UI multiplataforma (iOS, Android, Web, Desktop) |
| Backend | Serverpod 3.x | API + WebSockets + Auth + Banco |
| Database | PostgreSQL | Dados persistentes |
| DI | GetIt | Injeção de dependência |
| Navegação | go_router | Roteamento declarativo |
| State | ChangeNotifier + Sealed Classes | Gerenciamento de estado |
| Errors | dartz (Either) | Tratamento funcional de erros |

---

## 3. Arquitetura

```
┌─────────────────────────────────────────────────────────────┐
│                      Presentation (UI)                       │
│  Pages → Controllers → States/Stores → Components          │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                         Domain                              │
│  UseCases → Repository Interfaces → Entities               │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                           Data                              │
│  Repository Implementations → Serverpod Client              │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      Serverpod Backend                       │
│  Endpoints → Models → PostgreSQL                            │
└─────────────────────────────────────────────────────────────┘
```

**Fluxo de dados:** Page → Controller → UseCase → Repository → Serverpod → Database

---

## 4. Estrutura de Pastas

```
lib/
├── core/
│   ├── di/              # injection.dart (setup do GetIt)
│   ├── error/           # failures.dart (classes de erro)
│   ├── router/          # app_router.dart (go_router config)
│   ├── theme/           # app_theme.dart
│   ├── widgets/         # snackbar, dialog, bottom_sheet
│   └── utils/           # helpers, extensions
└── features/
    └── auth/
        ├── data/
        │   └── repositories/
        │       └── auth_repository_impl.dart
        ├── domain/
        │   ├── models/
        │   ├── repositories/
        │   │   └── auth_repository.dart
        │   └── usecases/
        │       ├── login_usecase.dart
        │       └── logout_usecase.dart
        ├── presentation/
        │   ├── controllers/
        │   │   └── login_controller.dart
        │   ├── states/
        │   │   └── login_state.dart
        │   ├── stores/
        │   │   └── login_store.dart
        │   ├── pages/
        │   │   └── login_page.dart
        │   ├── components/
        │   └── dialogs/           # Dialogs de feature
        │       └── invite_user_dialog.dart
        └── auth_injector.dart   # Registro de dependências
```

---

## 5. Padrões de Implementação

### 5.1 States (Sealed Classes - OBRIGATÓRIO)

```dart
// features/auth/presentation/states/login_state.dart
sealed class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  final UserEntity user;
  const LoginSuccess(this.user);
}

class LoginError extends LoginState {
  final String message;
  const LoginError(this.message);
}
```

### 5.2 Stores

```dart
// features/auth/presentation/stores/login_store.dart
class LoginStore extends ValueNotifier<LoginState> {
  LoginStore() : super(const LoginInitial());
}
```

### 5.3 Controllers

```dart
// features/auth/presentation/controllers/login_controller.dart
class LoginController extends ChangeNotifier {
  final LoginUseCase _useCase;
  final LoginStore _store;
  
  LoginController({
    required LoginUseCase useCase,
    required LoginStore store,
  })  : _useCase = useCase,
        _store = store;
  
  LoginState get state => _store.value;
  
  Future<void> login(String email, String password) async {
    _store.value = const LoginLoading();
    
    final result = await _useCase(LoginParams(email, password));
    
    result.fold(
      (failure) => _store.value = LoginError(failure.message),
      (user) => _store.value = LoginSuccess(user),
    );
  }
  
  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }
}
```

### 5.4 Repositories (Either Pattern)

```dart
// features/auth/data/repositories/auth_repository_impl.dart
class AuthRepositoryImpl implements AuthRepository {
  final Client _client;
  
  AuthRepositoryImpl({required Client client}) : _client = client;
  
  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) async {
    try {
      final result = await _client.emailIdp.login(email: email, password: password);
      return Right(result);
    } on Exception catch (e, s) {
      return Left(ServerFailure('Erro no login', e, s));
    }
  }
}
```

### 5.5 UseCases

```dart
// features/auth/domain/usecases/login_usecase.dart
class LoginUseCase {
  final AuthRepository _repository;
  
  LoginUseCase({required AuthRepository repository}) : _repository = repository;
  
  Future<Either<Failure, UserEntity>> call(String email, String password) async {
    if (email.isEmpty) {
      return const Left(ValidationFailure('Email é obrigatório'));
    }
    return await _repository.login(email, password);
  }
}
```

### 5.6 Pages

```dart
// features/auth/presentation/pages/login_page.dart
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LoginController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = getIt<LoginController>();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<LoginState>(
        valueListenable: _controller._store,
        builder: (context, state, _) {
          return switch (state) {
            LoginInitial() => const LoginForm(),
            LoginLoading() => const Center(child: CircularProgressIndicator()),
            LoginSuccess(user: final user) => HomePage(user: user),
            LoginError(message: final msg) => ErrorWidget(message: msg),
          };
        },
      ),
    );
  }
}
```

### 5.7 Feature Injectors (OBRIGATÓRIO)

```dart
// features/auth/auth_injector.dart
class AuthInjector extends Injector {
  final GetIt _getIt = getIt;
  
  @override
  void register() {
    _getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(client: _getIt<Client>()),
    );
    
    _getIt.registerLazySingleton(() => LoginUseCase(repository: _getIt()));
    _getIt.registerLazySingleton(() => LogoutUseCase(repository: _getIt()));
    
    _getIt.registerFactory<LoginStore>(() => LoginStore());
    _getIt.registerFactory<LoginController>(
      () => LoginController(useCase: _getIt(), store: _getIt()),
    );
  }
}
```

```dart
// core/di/injection.dart
final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  getIt.registerSingleton(Client());
  getIt.registerSingleton(FlutterAuthSessionManager());
  
  AuthInjector().register();
  BoardInjector().register();
  WorkspaceInjector().register();
  CardInjector().register();
  
  getIt.registerLazySingleton<BoardStore>(() => BoardStore());
  getIt.registerLazySingleton<AuthController>(() => AuthController(
    repository: getIt<AuthRepository>(),
    authManager: getIt<FlutterAuthSessionManager>(),
  ));
}
```

---

## 6. Failures (Core)

```dart
// core/error/failures.dart
sealed class Failure {
  final String message;
  final dynamic originalError;
  final StackTrace? stackTrace;
  const Failure(this.message, [this.originalError, this.stackTrace]);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Erro no servidor']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Sem conexão com a internet']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Não encontrado']);
}

class PermissionFailure extends Failure {
  const PermissionFailure([super.message = 'Sem permissão']);
}
```

---

## 7. Navegação (go_router)

```dart
// core/router/app_router.dart
final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  refreshListenable: Listenable.merge([
    getIt<AuthController>(),
    getIt<WorkspaceController>(),
  ]),
  redirect: (context, state) {
    final auth = getIt<AuthController>();
    final isLogin = state.uri.path == '/login';
    
    if (!auth.isAuthenticated && !isLogin) return '/login';
    if (auth.isAuthenticated && isLogin) return '/workspaces';
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
    GoRoute(path: '/workspaces', builder: (_, __) => const WorkspacesPage()),
    GoRoute(
      path: '/w/:workspaceSlug',
      builder: (context, state) => BoardsPage(
        workspaceSlug: state.pathParameters['workspaceSlug']!,
      ),
    ),
    GoRoute(
      path: '/w/:workspaceSlug/b/:boardSlug',
      builder: (context, state) => BoardPage(
        workspaceSlug: state.pathParameters['workspaceSlug']!,
        boardSlug: state.pathParameters['boardSlug']!,
      ),
    ),
    GoRoute(
      path: '/w/:workspaceSlug/b/:boardSlug/c/:cardUuid',
      builder: (context, state) => CardDetailPage(
        workspaceSlug: state.pathParameters['workspaceSlug']!,
        boardSlug: state.pathParameters['boardSlug']!,
        cardUuid: state.pathParameters['cardUuid']!,
      ),
    ),
  ],
);
```

---

## 8. Banco de Dados (Serverpod)

### 8.1 Estrutura

Models ficam em `kanew_server/config/tables/`

```yaml
# kanew_server/config/tables/card.yaml
class: Card
table: card
fields:
  id: UuidValue
  workspaceId: UuidValue
  boardId: UuidValue
  listId: UuidValue
  title: String
  description: String?
  priority: CardPriority
  rank: String
  deletedAt: DateTime?
  createdAt: DateTime, default=now
```

### 8.2 Soft Deletes (OBRIGATÓRIO)

Toda entidade DEVE ter `deletedAt` para soft delete:

```yaml
fields:
  deletedAt: DateTime?  # ← Obrigatório
```

**No Repository:** SEMPRE filtre registros deletados:

```dart
Future<List<Card>> getCards(int listId) async {
  return (await _client.card.getCardsByListId(listId))
    .where((card) => card.deletedAt == null)
    .toList();
}
```

### 8.3 Activity Tracking (OBRIGATÓRIO)

```yaml
class: Activity
table: activity
fields:
  id: UuidValue
  cardId: UuidValue
  actorId: UuidValue
  type: String        # card.created, card.title.changed, etc.
  payload: Map<String, dynamic>  # { 'from': 'Old', 'to': 'New' }
  createdAt: DateTime, default=now
```

**Crie activity para:**
- Criação de entidades
- Mudanças de campos
- Movimentação de cards
- Adição/remoção de labels, membros
- Comentários
- Checklists

### 8.4 LexoRank (Ordenação)

Cards são ordenados por:

```sql
ORDER BY priority DESC, rank ASC
```

### 8.5 Gerando Código

```bash
cd kanew_server
serverpod generate
```

---

## 9. Segurança

### 9.1 UUIDs Públicos (OBRIGATÓRIO)

**NUNCA exponha IDs internos do banco em URLs ou APIs externas:**

```dart
// ❌ ERRADO - ID interno
GoRoute(path: '/card/:id')

// ✅ CORRETO - UUID público
GoRoute(path: '/c/:cardUuid')
```

### 9.2 Autorização (OBRIGATÓRIO)

```dart
// Em TODO endpoint protegido:
Future<CardDetail?> getCardDetail(Session session, String cardUuid) async {
  // 1. Verificar autenticação
  final userId = await session.auth.authenticatedUserId;
  if (userId == null) throw UnauthorizedException();
  
  // 2. Verificar acesso ao workspace
  final hasAccess = await _workspaceService.userInWorkspace(
    userId: userId,
    workspaceId: card.workspaceId,
  );
  if (!hasAccess) throw ForbiddenException();
  
  return card;
}
```

### 9.3 Tratamento de Erros HTTP

| Código | Uso |
|--------|-----|
| `UNAUTHORIZED` | Não autenticado |
| `FORBIDDEN` | Sem permissão |
| `NOT_FOUND` | Recurso não existe |
| `BAD_REQUEST` | Validação falhou |
| `INTERNAL_SERVER_ERROR` | Erro inesperado |

---

## 10. Widgets Globais

### 10.1 Snackbar

```dart
// core/widgets/snackbar.dart
void showSnackbar(String message, [Color? color]) {
  final context = getIt<GlobalKey<NavigatorState>>().currentContext;
  ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: color,
  ));
}
```

### 10.2 Dialog Genérico

```dart
// core/widgets/dialog.dart
Future<T?> showAppDialog<T>({
  required Widget child,
  bool barrierDismissible = true,
}) async {
  final context = getIt<GlobalKey<NavigatorState>>().currentContext;
  return showDialog<T>(
    context: context!,
    barrierDismissible: barrierDismissible,
    builder: (_) => child,
  );
}
```

### 10.3 Dialogs de Feature

Cada feature cria seus próprios diálogos em `presentation/dialogs/`:

```
features/auth/presentation/dialogs/
└── invite_user_dialog.dart
```

**Estrutura do dialog:**

```dart
// features/auth/presentation/dialogs/invite_user_dialog.dart
class InviteUserDialog extends StatefulWidget {
  final String workspaceSlug;
  
  const InviteUserDialog({super.key, required this.workspaceSlug});
  
  @override
  State<InviteUserDialog> createState() => _InviteUserDialogState();
}

class _InviteUserDialogState extends State<InviteUserDialog> {
  late final InviteUserController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = getIt<InviteUserController>();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Convidar usuário'),
      content: ValueListenableBuilder<InviteUserState>(
        valueListenable: _controller.store,
        builder: (context, state, _) {
          return switch (state) {
            InviteUserInitial() => InviteUserForm(controller: _controller),
            InviteUserLoading() => const Center(child: CircularProgressIndicator()),
            InviteUserSuccess() => const Text('Convite enviado!'),
            InviteUserError(message: final msg) => Text(msg, style: const TextStyle(color: Colors.red)),
          };
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () => _controller.sendInvite(widget.workspaceSlug),
          child: const Text('Enviar'),
        ),
      ],
    );
  }
}
```

**Como usar:**

```dart
// Na Page ou Component
onPressed: () async {
  await showAppDialog(
    child: const InviteUserDialog(workspaceSlug: widget.workspaceSlug),
  );
},
```

### 10.4 Bottom Sheet

```dart
// core/widgets/bottom_sheet.dart
Future<T?> showAppBottomSheet<T>({required Widget child, bool dismissible = true}) async {
  final context = getIt<GlobalKey<NavigatorState>>().currentContext;
  return showModalBottomSheet<T>(context: context!, builder: (_) => child, isDismissible: dismissible);
}
```

---

## 11. Adicionando uma Feature (Passo a Passo)

### Passo 1: Banco de Dados
1. Crie/atualize o model no `kanew_server/config/tables/`
2. Execute `serverpod generate`
3. Crie migrations se necessário

### Passo 2: Domain
1. Crie entities em `features/<feature>/domain/models/`
2. Crie interfaces de repository em `features/<feature>/domain/repositories/`
3. Crie UseCases em `features/<feature>/domain/usecases/`

### Passo 3: Data
1. Implemente o repository em `features/<feature>/data/repositories/`

### Passo 4: Presentation
1. Crie States em `features/<feature>/presentation/states/`
2. Crie Stores em `features/<feature>/presentation/stores/`
3. Crie Controllers em `features/<feature>/presentation/controllers/`
4. Crie Pages em `features/<feature>/presentation/pages/`
5. Crie Components em `features/<feature>/presentation/components/`
6. Crie Dialogs em `features/<feature>/presentation/dialogs/`

### Passo 5: DI
1. Crie/Atualize o Feature Injector
2. Registre no `core/di/injection.dart`

### Passo 6: Navegação
1. Adicione rotas no `core/router/app_router.dart`

### Passo 7: Testes
1. Testes unitários para Controllers
2. Testes para UseCases

---

## 12. Troubleshooting Comum

| Problema | Solução |
|----------|---------|
| "GetIt: Object not registered" | Verifique se o Injector foi chamado no `setupDependencies()` |
| "Null check operator on null value" | Use `??` ou `?.` ao invés de `!` |
| "setState called during build" | Use `WidgetsBinding.instance.addPostFrameCallback` |
| Serverpod não gera código | Execute `serverpod generate` na pasta server |
| flutter analyze com erros | Execute `flutter clean && flutter pub get` |

---

## 13. Convenções de Código

### Naming

| Conceito | Formato | Exemplo |
|----------|---------|---------|
| Pages | `XxxPage` | `BoardsPage` |
| Controllers | `XxxController` | `BoardsPageController` |
| States | `XxxState` (sealed) | `BoardsState` |
| Stores | `XxxStore` | `BoardsStore` |
| Repositories | `XxxRepository` | `BoardRepository` |
| UseCases | `XxxUseCase` | `CreateBoardUseCase` |
| Failures | `XxxFailure` | `ServerFailure` |
| Injectors | `XxxInjector` | `BoardInjector` |
| Activities | `entity.action` | `card.title.changed` |
| Arquivos | `snake_case.dart` | `boards_page_controller.dart` |

### Imports

```dart
// Ordem obrigatória
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'package:kanew_flutter/core/error/failures.dart';

import '../../domain/repositories/board_repository.dart';
```

---

## 14. Testes

### Estrutura

```
test/
├── core/
└── features/
    └── auth/
        ├── domain/
        │   └── usecases/
        │       └── login_usecase_test.dart
        ├── data/
        │   └── repositories/
        │       └── auth_repository_impl_test.dart
        └── presentation/
            └── controllers/
                └── login_controller_test.dart
```

### Exemplo

```dart
void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;
  
  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });
  
  test('deve retornar usuário quando login bem-sucedido', () async {
    when(() => mockRepository.login(any(), any()))
        .thenAnswer((_) async => Right(mockUser));
    
    final result = await useCase('email', 'senha');
    
    expect(result, Right(mockUser));
  });
}
```

---

## 15. Referências

- Flutter Docs: https://docs.flutter.dev/
- Dart Docs: https://dart.dev/
- Serverpod: https://serverpod.dev/
- go_router: https://pub.dev/packages/go_router
- dartz: https://pub.dev/packages/dartz
- GetIt: https://pub.dev/packages/get_it
- Clean Dart: https://github.com/Flutterando/Clean-Dart

---

**Última Atualização:** Fevereiro 2026
