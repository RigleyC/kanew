# RULES.md

**Resumo:** Regras de desenvolvimento, boas práticas, performance e padrões Flutter. Consultar ao implementar features e fazer code review.

---

## 1. Filosofia de Desenvolvimento

### Princípios Fundamentais

1. **Simplicidade Pragmática**
   - Evite complexidade acidental
   - Adicione camadas apenas quando agregarem valor real

2. **Manutenibilidade**
   - Código deve ser fácil de entender
   - Mudanças devem ser localizadas
   - Nomes devem ser descritivos

3. **Testabilidade**
   - Dependências devem ser injetáveis
   - Lógica de negócio deve ser testável
   - Evite efeitos colaterais ocultos

4. **Performance como Requisito**
   - Pense em performance desde o início
   - Otimize apenas quando necessário (métrica)
   - Evite workarounds para problemas arquiteturais

---

## 2. Regras Flutter

### 2.1 Widgets

#### DO ✅

```dart
// Use ListenableBuilder para estado gerenciado
return ListenableBuilder(
  listenable: controller,
  builder: (context, _) => Text(controller.value),
);

// Use const quando possível
return const SizedBox(height: 16);

// Use spacing em Column/Row
return Column(
  spacing: 16,
  children: [
    Text('Título'),
    Text('Subtítulo'),
  ],
);
```

#### DON'T ❌

```dart
// NÃO use SizedBox para espaçamento
return Column(
  children: [
    Text('Título'),
    SizedBox(height: 16),
    Text('Subtítulo'),
  ],
);

// NÃO use StatefulWidget para estado de controller
class MyWidget extends StatefulWidget { ... }  // ❌
// Use StatelessWidget + controller injetado
```

### 2.2 State Management

**Regras:**

1. **Use ChangeNotifier para Controllers**
   - Extenda `ChangeNotifier`
   - Use `notifyListeners()` para atualizar UI

2. **Use Sealed Classes para Estados**
   - Exhaustivo via switch/case
   - Type-safe

3. **Prefira Controller sobre setState**
   - setState causa rebuild de toda a subtree
   - Controller + ListenableBuilder é mais granular

4. **Stores são ValueNotifier**
   - Apenas armazenam estado
   - Sem lógica de negócio

### 2.3 Build Performance

```dart
// ❌ ERRADO - rebuild de todo o widget
setState(() {
  _value = newValue;
});

// ✅ CORRETO - ListenableBuilder
ValueListenableBuilder(
  valueListenable: controller.store,
  builder: (context, value, _) => Text(value),
);

// ✅ Extraia widgets stateless
class MyButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  
  const MyButton({super.key, required this.onTap, required this.text});
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onTap, child: Text(text));
  }
}

// ❌ Evite closures no build
return ListView.builder(
  itemBuilder: (context, index) {
    return MyWidget(onTap: () => doSomething(index));  // closure
  },
);

// ✅ CORRETO
return ListView.builder(
  itemBuilder: (context, index) => MyWidget(
    onTap: () => doSomething(index),
  ),
  itemCount: items.length,
);
```

---

## 3. Regras de Arquitetura

### 3.1 Camadas

```
Presentation → Domain → Data → Serverpod → Database
```

**Regras:**
- Page nunca chama Client diretamente
- Controller nunca acessa Client (usa Repository)
- Repository implementa interface do Domain
- UseCase contém regra de negócio

### 3.2 Separação de Responsabilidades

| Camada | Responsabilidade | Exemplos |
|--------|------------------|----------|
| Page | UI + eventos | OnPressed, initState |
| Controller | Orquestração | Chamar useCases, atualizar store |
| Store | Estado reativo | ValueNotifier |
| UseCase | Regra de negócio | Validação, transformação |
| Repository | Acesso a dados | CRUD, transformações |
| Serverpod | Comunicação | Endpoints, models |

### 3.3 Injeção de Dependência

**Core Services** → LazySingleton
- Client
- AuthManager
- Config

**Repositories** → LazySingleton
- AuthRepository
- BoardRepository

**Global Controllers** → LazySingleton
- AuthController
- WorkspaceController

**Shared Stores** → LazySingleton
- BoardStore

**Page Controllers** → Factory
- Nova instância por página
- Dispose ao sair da página

---

## 4. Regras de Código

### 4.1 Naming Conventions

| Conceito | Formato | Exemplo |
|----------|---------|---------|
| Pages | XxxPage | BoardsPage |
| Controllers | XxxController | BoardsPageController |
| States | XxxState (sealed) | BoardsState |
| Stores | XxxStore | BoardsStore |
| Repositories | XxxRepository | BoardRepository |
| UseCases | XxxUseCase | CreateBoardUseCase |
| Failures | XxxFailure | ServerFailure |
| Injectors | XxxInjector | BoardInjector |
| Activities | entity.action | card.title.changed |
| Arquivos | snake_case.dart | boards_page_controller.dart |

### 4.2 Imports

```dart
// Ordem obrigatória
import 'dart:async';                              // 1. Dart SDK

import 'package:flutter/material.dart';           // 2. Flutter

import 'package:dartz/dartz.dart';                // 3. Packages
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'package:kanew_flutter/core/error/failures.dart';  // 4. Core

import '../../domain/repositories/board_repository.dart';  // 5. Features (relativo)
```

### 4.3 Tratamento de Erros

```dart
// ✅ Use Either para operações que podem falhar
Future<Either<Failure, T>> fetchData() async {
  try {
    final result = await client.api.getData();
    return Right(result);
  } catch (e, s) {
    return Left(ServerFailure('Erro', e, s));
  }
}

// ✅ Trate o Either no Controller
result.fold(
  (failure) => store.value = ErrorState(failure.message),
  (data) => store.value = LoadedState(data),
);

// ❌ NÃO ignore erros
try {
  await operation();
} catch (e) {
  // Silenciado!
}
```

### 4.4 Null Safety

```dart
// ✅ Prefira null safety
String? nullable;
String nonNullable = nullable ?? 'default';

// ✅ Use ?. para chains
final length = user?.posts?.length ?? 0;

// ❌ Evite ! sem justificativa
final value = someNullable!.toUpperCase();  // Perigoso
```

---

## 5. Performance

### 5.1 Listas

```dart
// ✅ Use ListView.builder para listas grandes
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(item: items[index]),
);

// ❌ Evite ListView para listas grandes
ListView(
  children: items.map((e) => ItemWidget(item: e)).toList(),
);

// ✅ Use keys para performance em reordenações
ListView.builder(
  itemBuilder: (context, index) => DraggableItem(
    key: ValueKey(items[index].id),
    item: items[index],
  ),
);
```

### 5.2 Imagens

```dart
// ✅ Use cache padrão
Image.network(
  url,
  cacheWidth: 400,
  cacheHeight: 400,
);

// ✅ Use loading indicators
FadeInImage(
  placeholder: AssetImage('assets/placeholder.png'),
  image: NetworkImage(url),
);
```

### 5.3 Operações Assíncronas

```dart
// ✅ Mostre loading states
Future<void> loadData() async {
  store.value = const LoadingState();
  final result = await repository.fetch();
  result.fold(
    (f) => store.value = ErrorState(f.message),
    (d) => store.value = LoadedState(d),
  );
}

// ✅ Trate erros adequadamente
try {
  await operation();
} on SpecificException catch (e) {
  handleSpecificError(e);
} catch (e, s) {
  log('Erro inesperado: $e', stackTrace: s);
  store.value = const ErrorState('Algo deu errado');
}
```

---

## 6. Regras de Testes

### 6.1 Estrutura

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

### 6.2 Padrões de Teste

```dart
// Teste de UseCase
void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;
  
  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });
  
  test('deve retornar usuário quando login bem-sucedido', () async {
    // Arrange
    when(() => mockRepository.login(any(), any()))
        .thenAnswer((_) async => Right(mockUser));
    
    // Act
    final result = await useCase(LoginParams('email', 'senha'));
    
    // Assert
    expect(result, Right(mockUser));
  });
}

// Teste de Controller
void main() {
  late LoginController controller;
  late MockLoginUseCase mockUseCase;
  
  setUp(() {
    mockUseCase = MockLoginUseCase();
    controller = LoginController(
      useCase: mockUseCase,
      store: LoginStore(),
    );
  });
  
  test('deve mudar estado para Success após login', () async {
    // Arrange
    when(() => mockUseCase(any()))
        .thenAnswer((_) async => Right(mockUser));
    
    // Act
    await controller.login('email', 'senha');
    
    // Assert
    expect(controller.state, isA<LoginSuccess>());
  });
}
```

### 6.3 Regras de Teste

1. **Teste comportamento, não implementação**
2. **Mocke as dependências**
3. **Cubra happy path e erros**
4. **Nomeie testes descritivamente**

---

## 7. Regras de Documentação

### 7.1 Quando Comentar

```dart
// ✅ Comente o PORQUÊ, não o QUÊ
// O usuário só pode ver cards do seu workspace
final visibleCards = cards.where((c) => c.workspaceId == user.workspaceId);

// ✅ Comente código complexo
// LexoRank: calcula posição entre dois ranks
String calculateMiddleRank(String lower, String upper) { ... }

// ❌ NÃO comente óbvio
// Incrementa o contador
counter++;
```

### 7.2 O que Documentar

1. **APIs públicas** (comenta em `.dart`)
2. **Decisões arquiteturais** (doc comments)
3. **Workarounds** (comente o problema original)
4. **Constantes magic numbers**

### 7.3 O que NÃO Documentar

1. Getters/setters óbvios
2. Nomes descritivos
3. Código auto-explicativo

---

## 8. Regras de Git

### 8.1 Conventional Commits

```
feat: adiciona tela de login
fix(auth): corrige validação de email
refactor(board): simplifica lógica de ordenação
docs: atualiza AGENTS.md
style: formata código com dart format
test: adiciona testes para LoginController
chore: atualiza dependências
```

### 8.2 Branch Strategy

```
main/master   → Produção
develop       → Staging
feat/xxx      → Features
fix/xxx       → Correções
refactor/xxx  → Refatorações
```

### 8.3 PR Checklist

- [ ] Código formatado (`dart format`)
- [ ] Análise limpa (`flutter analyze`)
- [ ] Testes passando
- [ ] Commit messages seguem convenção
- [ ] PR descritivo

---

## 9. Code Review Checklist

### Arquitetura
- [ ] Camadas respeitadas (Domain → Data → Presentation)
- [ ] Controller não acessa Client diretamente (usa Repository)
- [ ] UseCase criado quando há regra de negócio

### Código
- [ ] Nomes descritivos
- [ ] Imports organizados
- [ ] Sem código duplicado
- [ ] Tratamento de erros adequado

### Flutter
- [ ] StatelessWidgets quando possível
- [ ] const constructors
- [ ] ListenableBuilder em vez de setState
- [ ] builders otimizados

### Performance
- [ ] ListView.builder para listas
- [ ] Keys em StatefulWidgets
- [ ] Sem closures no build

### Testes
- [ ] Testes unitários para UseCases
- [ ] Testes para Controllers
- [ ] Mocks adequados

---

## 10. Patterns e Anti-Patterns

### 10.1 PATTERNS ✅

**Controller Pattern**
```dart
class MyController extends ChangeNotifier {
  final MyStore _store;
  
  void load() async {
    _store.value = const Loading();
    final result = await repository.fetch();
    result.fold(
      (f) => _store.value = Error(f.message),
      (d) => _store.value = Loaded(d),
    );
  }
}
```

**Either Pattern**
```dart
Future<Either<Failure, T>> operation() async {
  try {
    return Right(await riskyOperation());
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}
```

**Feature Injector**
```dart
class FeatureInjector extends Injector {
  @override
  void register() {
    getIt.registerFactory<Controller>(() => Controller(repo: getIt()));
  }
}
```

### 10.2 ANTI-PATTERNS ❌

**God Controller**
```dart
// ❌ MUITO GRANDE - mais de 200 linhas
class BoardPageController extends ChangeNotifier {
  // 50+ métodos, 20+ estados...
}
```

**Nested Ternaries**
```dart
// ❌ DIFÍCIL DE LER
return state is Loading 
  ? CircularProgressIndicator()
  : state is Error 
    ? ErrorWidget(state.message)
    : state is Success 
      ? SuccessView(state.data)
      : Container();
```

**Hard-coded Strings**
```dart
// ❌ DIFÍCIL DE TRADUZIR
return Text('Salvar');

// ✅ CORRETO
return Text(t.save);
```

**Callback Hell**
```dart
// ❌
fetchData().then((result) {
  process(result).then((processed) {
    save(processed).then((saved) {
      notify(saved);
    });
  });
});

// ✅
final result = await fetchData();
final processed = await process(result);
final saved = await save(processed);
notify(saved);
```

**N+1 Queries**
```dart
// ❌
for (final card in cards) {
  final labels = await getLabels(card.id);  // Query por card!
}

// ✅
final allLabels = await getAllLabelsForCards(cards.map((c) => c.id).toList());
```

**Ignorar errors**
```dart
// ❌
void load() async {
  try {
    await repository.fetch();
  } catch (e) {
    // Silenciado!
  }
}

// ✅
void load() async {
  final result = await repository.fetch();
  result.fold(
    (f) => store.value = Error(f.message),
    (d) => store.value = Loaded(d),
  );
}
```

---

## 11. Workflow Orchestration

### 11.1 Plan Mode Default
- Entre em plan mode para QUALQUER tarefa não trivial (3+ passos ou decisões arquiteturais)
- Se algo der errado, PARE e replaneje imediatamente - não continue empurrando
- Use plan mode para passos de verificação, não apenas construção
- Escreva specs detalhadas antes para reduzir ambiguidade

### 2. Subagent Strategy
- Use subagents liberally to keep main context window clean
- Offload research, exploration, and parallel analysis to subagents
- For complex problems, throw more compute at it via subagents
- One task per subagent for focused execution

### 11.3 Self-Improvement Loop
- APÓS QUALQUER correção do usuário: atualize `tasks/lessons.md` com o padrão
- Escreva regras para você mesmo que previnam o mesmo erro
- Itere nessas lições sem dó até a taxa de erros cair
- Revise lições no início da sessão para projetos relevantes

### 11.4 Verification Before Done
- Nunca marque uma tarefa como completa sem provar que funciona
- Compare comportamento entre main e suas mudanças quando relevante
- Pergunte-se: "Um engenheiro sênior aprovaria isso?"
- Rode testes, verifique logs, demonstre corretude

### 11.5 Demand Elegance (Equilibrado)
- Para mudanças não triviais: pause e pergunte "há uma forma mais elegante?"
- Se um fix parece hack: "Sabendo tudo que sei agora, implemente a solução elegante"
- Pule isso para fixes simples e óbvios - não over-engineer
- Desafie seu próprio trabalho antes de apresentar

### 11.6 Autonomous Bug Fixing
- Quando receber um report de bug: apenas conserte. Não peça ajuda
- Aponte logs, erros, testes falhando - então resolva
- Zero trocas de contexto necessárias do usuário
- Vá consertar testes de CI falhando sem ser mandando como fazer

### 11.7 MCP
- Sempre verifique se existem um MCP instalado que pode te ajudar a coinseguir alguma informação ou realizar alguma alteração.

---

## 12. Task Management

1. **Plan First**: Escreva plano em `tasks/todo.md` com itens checkáveis
2. **Verify Plan**: Check antes de começar implementação
3. **Track Progress**: Marque itens completos conforme avança
4. **Explain Changes**: Resumo de alto nível em cada passo
5. **Document Results**: Adicione seção de review em `tasks/todo.md`
6. **Capture Lessons**: Atualize `tasks/lessons.md` após correções

---

## 13. Core Principles

- **Simplicity First**: Faça cada mudança o mais simples possível. Impacte código mínimo.
- **No Laziness**: Encontre causas raiz. Sem fixes temporários. Padrão de desenvolvedor sênior.
- **Minimal Impact**: Mudanças devem tocar apenas o necessário. Evite introduzir bugs.

---

## 14. Recursos de Aprendizado

### Documentação Oficial
- Flutter Docs: https://docs.flutter.dev/
- Dart Docs: https://dart.dev/guides
- Serverpod: https://serverpod.dev/

---

**Última Atualização:** Fevereiro 2026
