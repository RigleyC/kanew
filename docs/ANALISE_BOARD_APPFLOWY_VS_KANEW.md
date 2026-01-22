# Análise Comparativa: AppFlowy vs Kanew - Implementação de Board

## Resumo Executivo

Este documento compara a implementação de boards/kanban do AppFlowy com a atual implementação do Kanew, identificando oportunidades de melhoria e boas práticas.

---

## 1. Arquitetura de Dados

### AppFlowy

**Conceito Central: Database Views Compartilhadas**
- Grid, Board e Calendar compartilham a mesma estrutura de dados
- Database Fields (colunas) podem ter diferentes `FieldType`
- Rows representam cards com células que correspondem a fields específicos
- Views são apenas representações visuais diferentes dos mesmos dados

**FieldTypes Suportados:**
- Single-Select, Multi-Select, URL, Checkbox, Date/Time
- Cada Field tem seu próprio `TypeOption` para configuração
- Sistema flexível para adicionar novos tipos

**Grouping Dinâmico:**
- Boards podem ser agrupados por qualquer Field compatível
- Checkbox = 2 grupos (checked/unchecked)
- Date = grupos por recência (last month, next 7 days, etc.)
- Select/URL = grupos por opção/valor
- "No Status" group especial para valores vazios

### Kanew

**Conceito Atual: Estrutura Fixa**
- Board → CardList (colunas fixas) → Card (itens)
- Fields hardcodeados: title, description, priority, dueDate, isCompleted
- Cada Card tem todas as propriedades disponíveis
- Não existe conceito de "Database Views" compartilhadas

**Avaliação:**
❌ **Menos flexível**: Hard para adicionar novos campos sem alterar o banco de dados
✅ **Mais simples**: Estrutura mais direta para caso de uso Trello-like

---

## 2. Drag & Drop e Reordering

### AppFlowy

**Implementação:**
- Sistema de `rank` otimizado para inserção entre itens
- Suporta reordering de groups (lists) e items (cards)
- Drag entre groups move automaticamente o grouping field value
- Usa eventos assíncronos para sincronização com backend

**Ranking:**
```rust
// AppFlowy usa rank strings como "0.5", "0.25", etc.
// Permite inserção entre quaisquer dois itens sem recalcular tudo
fn insert_between(rank_before: &str, rank_after: &str) -> String
```

### Kanew

**Implementação:**
- Usa `appflowy_board` package (exatamente o do AppFlowy!)
- `BoardViewPage` gerencia callbacks de drag & drop
- Reordering calcula `afterRank` e `beforeRank` baseado nos vizinhos
- Move card + atualiza listId quando solta em outro grupo

**Avaliação:**
✅ **Boa implementação**: Usa mesmo widget da fonte
⚠️ **Otimização possível**: Rebuilding do board data acontece a cada notifyListeners

**Problema Identificado (board_view_page.dart:250-254):**
```dart
// Rebuild do board acontece a cada mudança de estado
if (!_boardBuilt || _controller.lists.isNotEmpty) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (mounted) _buildBoardData(); // ← Pode ser excessivo
  });
}
```

---

## 3. Propriedades e Customização de Cards

### AppFlowy

**Sistema de Propriedades:**
- Cada Field é uma propriedade diferente
- Cards podem ter N propriedades (checkboxes, dates, selects, text, etc.)
- Propriedades são definidas dinamicamente pelo tipo de Field
- Suporte a "custom properties" extensíveis

**Visualização:**
- Cards mostram preview das primeiras N propriedades
- Clique abre overlay com editor completo (rich text)
- Tags/labels vêm de Multi-Select fields

### Kanew

**Propriedades Fixas:**
```dart
// card.dart - propriedades hardcodeadas
String title;
String? descriptionDocument;
CardPriority priority; // Enum: none, low, medium, high
String rank;
DateTime? dueDate;
bool isCompleted;
```

**Visualização:**
- Card mostra: título, prioridade (barra colorida), due date, indicador de descrição
- Apenas 4 propriedades visíveis no preview
- Menu popup para exclusão

**Avaliação:**
❌ **Limitado**: Não pode adicionar campos customizados sem migration
❌ **Extensão difícil**: Novos tipos (tags, assignees, attachments) requer mudança de schema
⚠️ **Preview limitado**: Não mostra propriedades adicionais

---

## 4. Shortcuts e Acessibilidade

### AppFlowy

**Shortcuts Implementados:**
```
↑ / ↓           Navegar entre cards
Shift + ↑/↓     Expandir seleção
Esc               Limpar seleção
Backspace/Del     Deletar cards selecionados
Enter              Abrir detalhes do card
E                 Editar card
N                 Adicionar novo card
Shift + Enter      Criar card abaixo
Cmd+Shift+↑      Criar card acima
,                 Mover para lista anterior
.                 Mover para próxima lista
```

**UX Avançada:**
- Seleção múltipla com retângulo
- Auto-scroll durante navegação por teclado
- Foco automático em campos relevantes

### Kanew

**Shortcuts Implementados:**
- ❌ Nenhum atalho de teclado customizado
- Apenas comportamentos padrão do Flutter

**Avaliação:**
❌ **Lacuna significativa**: Usuários avançados dependem de mouse
❌ **Baixa produtividade**: Sem atalhos para operações comuns

---

## 5. Performance e Otimização

### AppFlowy

**Otimizações:**
- Virtual scrolling para grandes boards
- Lazy loading de groups/items
- Diff updates (só atualiza o que mudou)
- Backend em Rust para performance

**Notificações:**
- Sistema de eventos para updates incrementais
- Sync otimizado sem recarregar tudo

### Kanew

**Performance:**
- Loading de board inteiro de uma vez
- Rebuild completo do board data a cada mudança (board_view_page.dart:193-211)
- Sem lazy loading ou virtual scrolling

**Problemas Identificados:**
```dart
// board_view_controller.dart:52-55
// Carrega tudo de uma vez
final results = await Future.wait([
  _listRepo.getLists(_board!.id!),
  _cardRepo.getCardsByBoard(_board!.id!),
]);

// board_view_page.dart:193-211
// Rebuild completo ao invés de diff
void _buildBoardData() {
  _boardController.clear(); // ← Perde todo estado interno
  for (final cardList in _controller.lists) {
    // Reconstrói tudo
  }
}
```

**Avaliação:**
⚠️ **Escalabilidade**: Boards com muitas lists/cards serão lentos
❌ **Rebuilds desnecessários**: AppFlowyBoard controller é reconstruído totalmente

---

## 6. Erros e Validação

### AppFlowy

**Tratamento:**
- Validações por Field type (ex: data futura para Date field)
- Mensagens de erro contextuais
- Toasts para feedback imediato
- Estados de loading separados por operação

### Kanew

**Tratamento:**
- Repositories retornam `Either<Failure, T>` ✅
- Controller expõe `_error` string
- UI mostra erro via conditionais no ListenableBuilder

**Avaliação:**
✅ **Padrão correto**: Either pattern bem aplicado
⚠️ **Feedback limitado**: Apenas mensagem de erro, sem validações contextuais

---

## 7. Código Reutilizável e Modulares

### AppFlowy

**Arquitetura:**
- `AppFlowyBoardController` genérico e reutilizável
- Builders customizáveis para header/footer/card
- Separado como package próprio (`appflowy_board`)
- Abstração sobre `AppFlowyGroupItem`

### Kanew

**Arquitetura:**
- Usa o mesmo `appflowy_board` package ✅
- `CardBoardItem` adapta `Card` para `AppFlowyGroupItem`
- Segue MVVM com Controller factory ✅

**Avaliação:**
✅ **Boa separação**: View, Controller, Repository bem separados
✅ **Injeção de dependências**: getIt para DI
⚠️ **Adapter mínimo**: `CardBoardItem` poderia ter mais lógica

---

## 8. Recursos Faltantes vs AppFlowy

| Recurso | AppFlowy | Kanew | Prioridade |
|----------|-----------|--------|------------|
| **Dynamic Grouping** | ✅ Por qualquer Field | ❌ Apenas lists fixas | Alta |
| **Custom Properties** | ✅ Fields configuráveis | ❌ Schema fixo | Alta |
| **Hidden Groups** | ✅ Ocultar grupos | ❌ | Média |
| **Group Actions** | ✅ Rename/delete/reorder | ✅ Delete/reorder | - |
| **Multi-select** | ✅ Selecionar múltiplos cards | ❌ | Média |
| **Keyboard Shortcuts** | ✅ 10+ atalhos | ❌ | Alta |
| **Auto-scroll** | ✅ Scroll inteligente | ⚠️ Manual | Média |
| **Filtering/Sorting** | ✅ Por qualquer Field | ❌ | Alta |
| **Rich Text Editor** | ✅ Document editor | ⚠️ descriptionDocument | Média |
| **Tags/Labels** | ✅ Multi-Select fields | ❌ | Média |
| **Assignees** | ✅ Relation fields | ❌ | Alta |
| **Attachments** | ✅ | ❌ | Média |
| **Checklists** | ✅ | ❌ | Média |
| **Card Templates** | ✅ | ❌ | Baixa |
| **Board Templates** | ✅ isTemplate flag | ⚠️ Flag existe | Baixa |

---

## 9. Recomendações de Melhorias (Priorizadas)

### 🔴 ALTA PRIORIDADE

#### 1. Implementar Sistema de Shortcuts
**Impacto:** Produtividade significativa
**Implementação:**
```dart
// keyboard/shortcuts_service.dart
class BoardShortcuts {
  static const cardUp = SingleActivator(LogicalKeyboardKey.arrowUp);
  static const cardDown = SingleActivator(LogicalKeyboardKey.arrowDown);
  static const deleteCard = SingleActivator(LogicalKeyboardKey.delete);
  // ...
}

// Integrate no board_view_page.dart
Shortcuts(
  shortcuts: <LogicalKeySet, Intent>{
    BoardShortcuts.cardUp: const _CardUpIntent(),
    BoardShortcuts.deleteCard: const _DeleteCardIntent(),
  },
  child: Actions(
    actions: <Type, Action<Intent>>{
      _CardUpIntent: _CardUpAction(_controller),
      _DeleteCardIntent: _DeleteCardAction(_controller),
    },
    child: AppFlowyBoard(...),
  ),
)
```

#### 2. Otimizar Rebuilds do Board
**Problema:** Rebuild completo a cada mudança
**Solução:** Diff updates + partial rebuild
```dart
// board_view_page.dart - versão otimizada
void _buildBoardData() {
  final currentGroupIds = _boardController.groupIds;
  final newGroupIds = _controller.lists.map((l) => l.id.toString()).toSet();

  // Apenas remove grupos que não existem mais
  for (final id in currentGroupIds) {
    if (!newGroupIds.contains(id)) {
      _boardController.removeGroup(id);
    }
  }

  // Apenas adiciona/atualiza grupos novos
  for (final cardList in _controller.lists) {
    final groupId = cardList.id.toString();
    if (!currentGroupIds.contains(groupId)) {
      // Novo grupo
      _buildAndAddGroup(cardList);
    } else {
      // Atualiza grupo existente se cards mudaram
      _updateGroupIfNeeded(cardList);
    }
  }

  _boardBuilt = true;
}
```

#### 3. Adicionar Campos Customizáveis (Extensível)
**Arquitetura:** System semelhante ao AppFlowy Fields
```dart
// protocol/board_field.dart
enum FieldType {
  text,
  checkbox,
  singleSelect,
  multiSelect,
  date,
  // ...
}

class BoardField {
  int id;
  String name;
  FieldType type;
  Map<String, dynamic> options; // Configuração específica do tipo
}

// protocol/card.dart - adaptar
class Card {
  Map<String, dynamic> fields; // Dynamic ao invés de campos fixos
  int? listId;
  int boardId;
  String rank;
  // ...
}
```

### 🟡 MÉDIA PRIORIDADE

#### 4. Implementar Filtragem e Sorting
**UI:** Header com dropdowns de filter/sort
**Backend:** Endpoint suporta `filterBy` e `sortBy`
```dart
// card_repository.dart
Future<Either<Failure, List<Card>>> getCards(
  int boardId, {
  Map<String, dynamic>? filters,
  String? sortBy,
}) async {
  final cards = await _client.card.getCards(
    boardId,
    filters: filters,
    sortBy: sortBy,
  );
  return Right(cards);
}
```

#### 5. Adicionar Seleção Múltipla
**Feature:** Shift+click para selecionar cards
**Ações em massa:** Delete, move, change status
```dart
class BoardViewPageController extends ChangeNotifier {
  final Set<int> _selectedCardIds = {};
  bool get hasSelection => _selectedCardIds.isNotEmpty;

  void toggleCardSelection(int cardId) {
    if (_selectedCardIds.contains(cardId)) {
      _selectedCardIds.remove(cardId);
    } else {
      _selectedCardIds.add(cardId);
    }
    notifyListeners();
  }

  Future<void> deleteSelectedCards() async {
    for (final id in _selectedCardIds) {
      await _cardRepo.deleteCard(id);
    }
    _selectedCardIds.clear();
  }
}
```

#### 6. Hidden Groups Feature
**UX:** Botão "Hidden Groups" no header do board
**Backend:** Campo `archived` em CardList
```dart
// list_repository.dart - já tem archiveList!
// Apenas precisa ser exposto na UI
class BoardViewPageController {
  List<CardList> get archivedLists =>
      _lists.where((l) => l.archived).toList();
  List<CardList> get visibleLists =>
      _lists.where((l) => !l.archived).toList();
}
```

### 🟢 BAIXA PRIORIDADE

#### 7. Rich Text Editor para Descrição
**Package:** `flutter_quill` ou similar
**Backend:** Salvar como JSON ou HTML

#### 8. Tags/Labels System
**Implementação:** Multi-Select Field
**UI:** Badges coloridos no card

#### 9. Assignees (Relation Field)
**Implementação:** Many-to-many relation com users
**UI:** Avatars no card

#### 10. Checklists em Cards
**Modelo:** `Checklist` e `ChecklistItem` entities
**UI:** Inline checklist no card preview

---

## 10. Arquitetura Recomendada (Próximos Passos)

### Database Schema Evolution

**Atual:**
```
Board → CardList (fixo) → Card (fields fixos)
```

**Recomendado:**
```
Board → [Dynamic Fields]
      ↓
Database (rows = Cards, columns = Fields)
      ↓
Views: BoardView, GridView, CalendarView (futuras)
```

### Camadas de Implementação

**1. Protocol Layer (kanew_client):**
```dart
// Adicionar
protocol/board_field.dart
protocol/card_field_value.dart
protocol/database_view.dart
```

**2. Repository Layer:**
```dart
// Otimizar
class CardRepository {
  // Batch operations
  Future<Either<Failure, List<Card>>> batchMoveCards(...);
  Future<Either<Failure, List<Card>>> batchUpdate(...);
}
```

**3. Controller Layer:**
```dart
// Adicionar
class BoardViewPageController {
  final CardSelectionController _selection;
  final KeyboardNavigationController _keyboard;
  final FilterController _filter;
}
```

**4. UI Layer:**
```dart
// Componentes reutilizáveis
widgets/board_shortcuts_handler.dart
widgets/board_filter_bar.dart
widgets/bulk_actions_bar.dart
```

---

## 11. Estimativa de Esforço

| Melhoria | Complexidade | Horas | Valor |
|-----------|---------------|---------|--------|
| Keyboard Shortcuts | Média | 16h | Alto |
| Otimizar Rebuilds | Média | 12h | Alto |
| Filtragem/Sorting | Alta | 24h | Alto |
| Seleção Múltipla | Média | 16h | Médio |
| Hidden Groups | Baixa | 8h | Médio |
| Custom Fields | Muito Alta | 40h+ | Muito Alto |
| Tags/Labels | Média | 16h | Médio |
| Assignees | Alta | 20h | Alto |
| Checklists | Alta | 20h | Médio |
| Rich Text Editor | Média | 16h | Baixo |

**Total Alta Prioridade:** ~52 horas
**Total Média Prioridade:** ~60 horas

---

## 12. Conclusão

### Pontos Fortes do Kanew Atual
✅ Arquitetura limpa (MVVM, DI, Repository pattern)
✅ Uso do `appflowy_board` package (widget robusto)
✅ Tratamento de erros com `Either`
✅ Drag & drop funcional
✅ Ranking system apropriado

### Principais Lacunas vs AppFlowy
❌ Falta de keyboard shortcuts (produtividade)
❌ Campos fixos (extensibilidade limitada)
❌ Performance em boards grandes (no lazy loading)
❌ Ausência de filtragem/sorting
❌ UI não suporta seleção múltipla

### Roadmap Sugerida
1. **Fase 1 (Produtividade):** Shortcuts + Otimização de rebuilds
2. **Fase 2 (Features Core):** Filtering + Sorting + Seleção múltipla
3. **Fase 3 (Extensibilidade):** Custom fields + Tags + Assignees
4. **Fase 4 (Features Avançadas):** Checklists + Rich text + Calendar view

---

**Documento gerado:** 2026-01-18
**Análise baseada em:** AppFlowy docs e código, Kanew código atual
