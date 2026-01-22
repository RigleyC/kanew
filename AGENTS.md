# AGENTS.md

**Resumo:** este documento descreve regras, padrões e passos suficientes para alguém implementar uma feature nova sem conhecer a codebase. Foca em organização por feature, MVVM (com Controllers), go_router, provider, get_it, Serverpod 3.x, testes, lints e boas práticas.

---

## Objetivo

* Tornar possível implementar uma feature seguindo padrões consistentes.
* Minimizar decisões ad-hoc: siga este guia.
* Manter arquivos pequenos e fáceis de revisar.

---

## Sumário rápido (passos para agregar uma feature)

1. Criar branch `feat/<short-desc>`.
2. Criar pasta de feature em `lib/features/<feature-name>/` com subpastas (presentation, domain, data).
3. Definir models e DTOs (data layer) e, quando necessário, migrar no Serverpod.
4. Implementar repositório (interface no `domain`, implementação no `data`).
5. Implementar **Controller** (em `presentation/controllers`).
6. Registrar o Controller como `Factory` no `lib/core/di/injection.dart`.
7. Implementar UI (widgets/screen) seguindo padrões de botões e theme.
   - Use `StatefulWidget` para gerenciar o ciclo de vida do controller (`initState`/`dispose`).
   - Use `ListenableBuilder` para reagir a mudanças de estado.
8. Adicionar rotas em `go_router`.
9. Testes unitários e widget tests antes do PR.
10. PR com `feat: breve-desc` seguindo Conventional Commits.

---

## Organização de pastas (sugestão — feature-first)

```
lib/
└─ features/
   └─ payments/
      ├─ presentation/
      │  ├─ pages/
      │  │  └─ payments_page.dart
      │  ├─ widgets/
      │  │  └─ payment_card.dart
      │  └─ controllers/
      │     └─ payments_page_controller.dart
      ├─ domain/
      │  ├─ models/
      │  ├─ repositories/
      │  │  └─ payments_repository.dart
      │  └─ usecases/
      │     └─ fetch_payments.dart
      └─ data/
         ├─ datasources/
         │  └─ payments_remote_datasource.dart
         └─ repositories/
            └─ payments_repository_impl.dart
```

---

## Architecture: View-Controller Pattern

Estamos migrando para um padrão onde **Views criam e gerenciam seus Controllers**.

* **View (UI)**: Widgets + Pages.
  - Responsabilidade: Layout, criação do controller, binding de eventos.
  - Usa `StatefulWidget` para inicializar (`getIt<Controller>()`) e descartar (`controller.dispose()`) o controller.
  - Usa `ListenableBuilder` para rebuildar quando o controller notificar mudanças.

* **Controller**: Lógica de apresentação e estado.
  - Extende `ChangeNotifier`.
  - Expõe estado via getters (ex: `isLoading`, `data`, `error`).
  - Métodos retornam `Future<void>` ou `Future<T>` e atualizam estado interno.
  - Não depende de `BuildContext` (idealmente).
  - Trata erros de negócio e notifica a UI via estado (ex: `error` string).

* **Repository**: Acesso a dados.
  - Retorna `Future<Either<Failure, T>>` (usando dartz).
  - Trata exceções do Serverpod e converte para `Failure`.

---

## Injeção de dependências (get_it)

* O projeto usa **get_it como service locator principal**.

### Registros em `lib/core/di/injection.dart`

1.  **Singletons / LazySingletons**:
    -   Core services (Client, AuthManager, Config).
    -   Repositories (`AuthRepository`, `BoardRepository`).
    -   Controllers **Globais** (apenas `AuthController`, `WorkspaceController`).

2.  **Factories**:
    -   **Page Controllers** (ex: `BoardsPageController`, `CardDetailPageController`).
    -   Uma nova instância é criada cada vez que a página é aberta.

```dart
// Exemplo injection.dart
void setupDependencies() {
  // Repositories (LazySingleton)
  getIt.registerLazySingleton<PaymentsRepository>(() => PaymentsRepositoryImpl(getIt()));

  // Page Controllers (Factory)
  getIt.registerFactory<PaymentsPageController>(
    () => PaymentsPageController(repository: getIt<PaymentsRepository>()),
  );
}
```

---

## Implementação na UI (Page)

O padrão recomendado para Pages é criar o controller no `initState` e fazer dispose no `dispose`.

```dart
class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  // 1. Declare o controller
  late final PaymentsPageController _controller;

  @override
  void initState() {
    super.initState();
    // 2. Injete via GetIt (cria nova instância)
    _controller = getIt<PaymentsPageController>();
    // 3. Inicialize dados se necessário
    _controller.loadPayments();
  }

  @override
  void dispose() {
    // 4. Dispose obrigatório
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 5. Use ListenableBuilder para ouvir mudanças
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        if (_controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (_controller.error != null) {
          return Center(child: Text(_controller.error!));
        }

        return ListView.builder(
          itemCount: _controller.payments.length,
          itemBuilder: (context, index) {
            final payment = _controller.payments[index];
            return ListTile(title: Text(payment.title));
          },
        );
      },
    );
  }
}
```

---

## Navegação (go_router)

* **Centralize** a definição de rotas em `app_router.dart`.
* **RefreshListenable**: Use `Listenable.merge` com controllers globais (Auth, Workspace) para redirecionamento.
* **Passagem de Parâmetros**:
  - Use `pathParameters` para IDs/Slugs (ex: `:boardSlug`).
  - A Page recebe esses parâmetros via construtor e os passa para o Controller no `initState` (ex: `_controller.load(widget.boardSlug)`).

---

## Components, Snackbar, Dialogs, Sheets
**Centralize** os componentes em uma pasta no core, eles podem ser chamados de qualquer lugar e recebem um widget ou texto. São responsáveis apenas por exibir onde o conteudo é passado ao chamar. O context pode ser passado tambem.
---

## Separação de componentes e boas práticas
- Ao criar uma página, evite criar métodos que retornem widget, se precisar criar um componente (ex. card. chip, header etc.) verifique se ele já existe, se não existir você deve criar como componete separado, se for um componente que será usado em todo projeto, crie de forma global, se não, pode criar na pasta da feature. 
- O componente deve ser o mais agnóstico possível, permitindo a troca do mesmo com facilidade respeitando os princpios de SOLID.
- O componente dev ser chamado na página que vai ser exibido.
- Tente utilizar sempre o tema como base e os botões definidos em widgets globais, sempre verifique se algum componente já existe antes de criar outro.

---

## Tratamento de Erros e `Either`

* Repositories retornam `Either<Failure, T>`.
* Controllers tratam o `Either`:

```dart
Future<void> load() async {
  _isLoading = true; notifyListeners();
  
  final result = await _repo.fetch();
  
  result.fold(
    (failure) => _error = failure.message,
    (data) => _data = data,
  );
  
  _isLoading = false; notifyListeners();
}
```

---

## Serverpod 3.x

* Mantenha models no `kanew_client` (protocol).
* Gere código com `serverpod generate` na pasta server.
* Use `Client` injetado nos repositórios.

---

## Boas práticas Flutter

- Use a propriedade spacing para definir espaços nas Columns() e Rows().

---
## Boas práticas Comentários

- Evite comentários desncessários, use comentários que explicam apenas coisas mais complexas, comentários obvios sobre o que uma classe ou método faz não são necessários a não ser que eles sejam grandes e perteçam a um fluxo específico.
- Use comentários curtos caso seja necessário explicando o porquê daquele metodo ou classe.
- Seja objetivo ao explicar.

---
## Boas práticas desenvolvimento

- Sempre preze por formas simples de resolver um problema ou implementar uma feature.
- Pense bem antes de fazer algo analisando se aquilo está sendo feito da forma mais otimizada possível, sem tornar o código complexo de ler ou carregar algo.
- Se tiver dúvidas sobre sua própria implementação, confirme com o usuário sobre o que ele acha.
- Ao pensar em uma solução, certifique-se de que você analisou os arquivos necessários, ao investigar, analise todos os lugares onde a feature vai afetar ou onde o método é usado ou até mesmo onde a variável é usada, isso evita de propor uma solução que resolve um problema mas afeta outro lugar e acaba quebrando.
- Preze por boas práticas, sempre seguindo a arquitetura do projeto, caso seja necessário (ex. controller muito grande, estados muitos grandes no controller) você pode criar outras pastas/arquivos derivados do clean arch como UseCases, Store/State etc.
- Valide se sua proposta também segue boas práticas de mercado, as vezes a sua solução pode ser complexa e outra pessoa na internet já resolveu o problema de forma mais simples.
- Você pode usar os MCPs disponíveis como do dart, serverpod etc. caso ele nao tire sua dúvida, busque na internet em documentações oficiais ou forums, github etc.
- Ao corrigir ou implementar algo, sempre crie um branch usando as convenções padrão, feat, chore, refactor. Não faça o merge com a master enquanto o usuário não confirmar.


---

## Checklist de entrega de feature

* [ ] Controller implementado e registrado como Factory.
* [ ] Page implementada com initState/dispose e ListenableBuilder.
* [ ] Repositório usando Either.
* [ ] Testes (se aplicável).
* [ ] `flutter analyze` sem erros.
* [ ] PR seguindo convenção.
