# Nested Navigation Implementation Plan

> REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Reestruturar as rotas do app para usar navegação aninhada, permitindo deep linking para páginas internas do workspace enquanto mantém a sidebar persistente.

**Architecture:** O `WorkspaceShell` será o shell compartilhado que renderiza sidebar + conteúdo. As rotas `/w/:slug/boards`, `/w/:slug/members`, `/w/:slug/settings` serão parseadas pelo coordinator e passadas ao shell, que renderiza o conteúdo apropriado baseado na sub-rota.

**Tech Stack:** Flutter, zenrouter, Provider

---

## Problema Atual

1. **Rotas mal definidas:** `BoardsRoute`, `MembersRoute`, `SettingsRoute` estão como rotas standalone (`/boards`, `/members`, `/settings`) ao invés de aninhadas (`/w/:slug/boards`)

2. **Navegação quebrada:** Sidebar usa `coordinator.push(BoardsRoute())` que abre página nova em cima do shell, ao invés de trocar apenas o conteúdo interno

3. **Deep linking impossível:** Não há como compartilhar link direto para boards/members de um workspace específico

---

## Estrutura de Rotas Final

| Rota | Componente | Descrição |
|------|------------|-----------|
| `/` | HomeRoute → AuthGate → WorkspaceShell | Redireciona para último workspace |
| `/w/:slug` | WorkspaceRoute → WorkspaceShell(boards) | Workspace home (default: boards) |
| `/w/:slug/boards` | WorkspaceRoute → WorkspaceShell(boards) | Lista de boards |
| `/w/:slug/members` | WorkspaceRoute → WorkspaceShell(members) | Gestão de membros |
| `/w/:slug/settings` | WorkspaceRoute → WorkspaceShell(settings) | Configurações |

---

## Task 1: Atualizar Definição de Rotas

**Files:**
- Modify: `lib/core/router/app_routes.dart`

**Step 1.1: Remover rotas standalone**

Remover as classes `BoardsRoute`, `MembersRoute`, `SettingsRoute` pois não serão mais rotas independentes.

```dart
// REMOVER estas classes (linhas 183-214):
// class BoardsRoute extends AppRoute { ... }
// class MembersRoute extends AppRoute { ... }
// class SettingsRoute extends AppRoute { ... }
```

**Step 1.2: Adicionar enum para sub-páginas do workspace**

```dart
/// Sub-páginas do workspace
enum WorkspacePage { boards, members, settings }
```

**Step 1.3: Atualizar WorkspaceRoute para incluir sub-página**

```dart
/// Workspace route - shows workspace with sidebar
class WorkspaceRoute extends AppRoute {
  final String workspaceSlug;
  final WorkspacePage page;

  WorkspaceRoute({
    required this.workspaceSlug,
    this.page = WorkspacePage.boards,
  });

  @override
  Uri toUri() {
    final basePath = '/w/$workspaceSlug';
    return switch (page) {
      WorkspacePage.boards => Uri.parse('$basePath/boards'),
      WorkspacePage.members => Uri.parse('$basePath/members'),
      WorkspacePage.settings => Uri.parse('$basePath/settings'),
    };
  }

  @override
  Widget build(Coordinator coordinator, BuildContext context) {
    return AuthGate(
      authenticatedChild: WorkspaceShell(
        coordinator: coordinator,
        workspaceSlug: workspaceSlug,
        currentPage: page,
      ),
      unauthenticatedChild: LoginScreen(coordinator: coordinator),
    );
  }
}
```

**Step 1.4: Commit**

```bash
git add lib/core/router/app_routes.dart
git commit -m "refactor: update WorkspaceRoute to support nested pages"
```

---

## Task 2: Atualizar App Coordinator

**Files:**
- Modify: `lib/core/router/app_coordinator.dart`

**Step 2.1: Atualizar parseRouteFromUri**

```dart
class AppCoordinator extends Coordinator<AppRoute> {
  @override
  AppRoute parseRouteFromUri(Uri uri) {
    final segments = uri.pathSegments;

    return switch (segments) {
      // Home
      [] => HomeRoute(),

      // Workspace routes com sub-páginas
      ['w', final slug] => WorkspaceRoute(
          workspaceSlug: slug,
          page: WorkspacePage.boards,
        ),
      ['w', final slug, 'boards'] => WorkspaceRoute(
          workspaceSlug: slug,
          page: WorkspacePage.boards,
        ),
      ['w', final slug, 'members'] => WorkspaceRoute(
          workspaceSlug: slug,
          page: WorkspacePage.members,
        ),
      ['w', final slug, 'settings'] => WorkspaceRoute(
          workspaceSlug: slug,
          page: WorkspacePage.settings,
        ),

      // Auth routes
      ['auth', 'login'] => LoginRoute(),
      ['auth', 'signup'] => SignupRoute(),
      ['auth', 'forgot-password'] => ForgotPasswordRoute(),
      ['auth', 'reset-password'] => ResetPasswordRoute(
          email: uri.queryParameters['email'] ?? '',
          accountRequestId: uri.queryParameters['accountRequestId'] ?? '',
        ),
      ['auth', 'verification'] => VerificationRoute(
          email: uri.queryParameters['email'] ?? '',
          accountRequestId: uri.queryParameters['accountRequestId'] ?? '',
        ),
      ['auth', 'set-password'] => SetPasswordRoute(
          email: uri.queryParameters['email'] ?? '',
          registrationToken: uri.queryParameters['token'] ?? '',
        ),

      // Not found
      _ => NotFoundRoute(),
    };
  }
}
```

**Step 2.2: Commit**

```bash
git add lib/core/router/app_coordinator.dart
git commit -m "refactor: update coordinator to parse workspace sub-routes"
```

---

## Task 3: Refatorar WorkspaceShell

**Files:**
- Modify: `lib/features/workspace/view/workspace_shell.dart`

**Step 3.1: Receber página via construtor ao invés de estado interno**

```dart
/// Main shell layout with sidebar (Route-based navigation)
class WorkspaceShell extends StatefulWidget {
  final Coordinator coordinator;
  final String? workspaceSlug;
  final WorkspacePage currentPage;

  const WorkspaceShell({
    super.key,
    required this.coordinator,
    this.workspaceSlug,
    this.currentPage = WorkspacePage.boards,
  });

  @override
  State<WorkspaceShell> createState() => _WorkspaceShellState();
}
```

**Step 3.2: Simplificar estado interno**

```dart
class _WorkspaceShellState extends State<WorkspaceShell> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final viewModel = getIt<WorkspaceViewModel>();

    if (!viewModel.hasWorkspaces) {
      await viewModel.loadWorkspaces();
    }

    if (widget.workspaceSlug != null) {
      await viewModel.setCurrentWorkspaceBySlug(widget.workspaceSlug!);
    }
  }

  Widget _buildCurrentPage() {
    return switch (widget.currentPage) {
      WorkspacePage.boards => const BoardsPage(),
      WorkspacePage.members => const MembersPage(),
      WorkspacePage.settings => const SettingsPage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: getIt<WorkspaceViewModel>()),
      ],
      child: SidebarStateWidget(
        defaultOpen: true,
        child: Scaffold(
          body: Row(
            children: [
              _Sidebar(
                coordinator: widget.coordinator,
                workspaceSlug: widget.workspaceSlug,
                currentPage: widget.currentPage,
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: KeyedSubtree(
                    key: ValueKey('page_${widget.currentPage}'),
                    child: _buildCurrentPage(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Step 3.3: Remover código obsoleto**

Remover:
- `_WorkspaceNavigatorState` class
- `_setPageFromRoute()` method
- `_navigateToPage()` method
- `_currentPage` state variable

**Step 3.4: Commit**

```bash
git add lib/features/workspace/view/workspace_shell.dart
git commit -m "refactor: make WorkspaceShell route-driven instead of state-driven"
```

---

## Task 4: Atualizar Sidebar para Navegação por Rota

**Files:**
- Modify: `lib/features/workspace/view/workspace_shell.dart` (classe `_Sidebar`)

**Step 4.1: Atualizar construtor do _Sidebar**

```dart
class _Sidebar extends StatelessWidget {
  final Coordinator coordinator;
  final String? workspaceSlug;
  final WorkspacePage currentPage;

  const _Sidebar({
    required this.coordinator,
    required this.workspaceSlug,
    required this.currentPage,
  });
```

**Step 4.2: Atualizar _buildSidebarItems para navegação por rota**

```dart
List<Widget> _buildSidebarItems(BuildContext context) {
  final slug = workspaceSlug ?? '';
  
  return [
    SidebarGroup(
      children: [
        SidebarItem(
          icon: const Icon(Icons.dashboard_rounded),
          label: 'Boards',
          selected: currentPage == WorkspacePage.boards,
          onPress: () => coordinator.push(WorkspaceRoute(
            workspaceSlug: slug,
            page: WorkspacePage.boards,
          )),
        ),
        SidebarItem(
          icon: const Icon(Icons.people_rounded),
          label: 'Membros',
          selected: currentPage == WorkspacePage.members,
          onPress: () => coordinator.push(WorkspaceRoute(
            workspaceSlug: slug,
            page: WorkspacePage.members,
          )),
        ),
        SidebarItem(
          icon: const Icon(Icons.settings_rounded),
          label: 'Configurações',
          selected: currentPage == WorkspacePage.settings,
          onPress: () => coordinator.push(WorkspaceRoute(
            workspaceSlug: slug,
            page: WorkspacePage.settings,
          )),
        ),
      ],
    ),
  ];
}
```

**Step 4.3: Commit**

```bash
git add lib/features/workspace/view/workspace_shell.dart
git commit -m "feat: sidebar navigates via workspace routes with deep linking"
```

---

## Task 5: Adicionar Import do Enum

**Files:**
- Modify: `lib/features/workspace/view/workspace_shell.dart`

**Step 5.1: Adicionar import**

```dart
import '../../../core/router/app_routes.dart';
```

**Step 5.2: Commit**

```bash
git add lib/features/workspace/view/workspace_shell.dart
git commit -m "chore: add missing import for WorkspacePage enum"
```

---

## Verification Plan

### Manual Testing

> [!IMPORTANT]
> Como o projeto não possui testes automatizados de navegação configurados, a verificação será manual.

**Pré-requisitos:**
1. App rodando localmente com `flutter run -d chrome` (ou dispositivo de preferência)
2. Usuário autenticado com pelo menos um workspace

**Teste 1: Navegação da Sidebar**

1. Acesse a home do workspace (deve redirecionar para `/w/{slug}/boards`)
2. Clique em "Membros" na sidebar
3. **Verificar:** 
   - URL muda para `/w/{slug}/members`
   - Sidebar permanece visível
   - Conteúdo muda para MembersPage
4. Clique em "Configurações"
5. **Verificar:**
   - URL muda para `/w/{slug}/settings`
   - Sidebar permanece visível

**Teste 2: Deep Linking**

1. Copie a URL `/w/{slug}/members`
2. Abra uma nova aba do navegador
3. Cole a URL e acesse
4. **Verificar:**
   - App carrega diretamente na página Members
   - Sidebar visível com "Membros" selecionado

**Teste 3: Navegação do Browser**

1. Navegue: Boards → Members → Settings
2. Clique no botão "Voltar" do navegador
3. **Verificar:**
   - Retorna para Members
   - Sidebar atualiza seleção corretamente
4. Clique "Voltar" novamente
5. **Verificar:**
   - Retorna para Boards

**Teste 4: Sem Erros**

1. Durante todos os testes acima
2. **Verificar:**
   - Console não mostra erros de Provider/Context
   - Nenhum crash ou tela branca

---

## Arquivos Modificados (Resumo)

| Arquivo | Alteração |
|---------|-----------|
| `lib/core/router/app_routes.dart` | Adicionar enum `WorkspacePage`, atualizar `WorkspaceRoute`, remover rotas standalone |
| `lib/core/router/app_coordinator.dart` | Atualizar parser para sub-rotas aninhadas |
| `lib/features/workspace/view/workspace_shell.dart` | Receber página por parâmetro, navegar via rotas |
