# Lições de Arquitetura e Separação de Responsabilidades: AppFlowy vs Kanew

Este documento analisa as diferenças na separação de responsabilidades entre a implementação atual do Kanew e o padrão arquitetural observado no AppFlowy, focando em como melhorar nosso projeto.

## 1. View vs Controller: Quem constrói os dados da UI?

### O Problema no Kanew
Atualmente, a `BoardViewPage` (View) contém lógica de transformação de dados.
O método `_buildBoardData` dentro da View itera sobre as listas do domínio (`CardList`) e cria objetos da biblioteca de UI (`AppFlowyGroupData`).

```dart
// kanew_flutter/lib/features/board/presentation/pages/board_view_page.dart
void _buildBoardData() {
  _boardController.clear(); // Limpa tudo
  for (final cardList in _controller.lists) {
    // Lógica de conversão e criação de objetos de UI DENTRO da View
    final groupData = AppFlowyGroupData(...);
    _boardController.addGroup(groupData);
  }
}
```

**Problemas:**
1.  **Acoplamento:** A View conhece regras de negócio sobre como mapear Cards para Grupos.
2.  **Performance:** Toda vez que o Controller notifica uma mudança (ex: um loading terminou), a View reconstrói *todos* os dados do board do zero.
3.  **Responsabilidade:** Views devem apenas exibir dados, não transformá-los.

### A Lição do AppFlowy
No AppFlowy, a camada de apresentação (View) recebe os dados já formatados ou usa um **Presenter/Adapter** dedicado. A View apenas "binda" os dados ao componente.

**Sugestão para o Kanew:**
Mover a lógica de construção e sincronização do `AppFlowyBoardController` para dentro do `BoardViewPageController` (ou um Adapter separado). O Controller deve gerenciar o estado do *widget* de board, não apenas os dados puros.

## 2. Fluxo de Ações: Otimistic Updates vs Rebuilds

### Ação: Mover um Card

**Fluxo Atual (Kanew):**
1.  Usuário solta o card.
2.  `BoardViewPage` chama `controller.moveCard()`.
3.  Controller chama API.
4.  Controller atualiza lista local (`_allCards`).
5.  Controller chama `notifyListeners()`.
6.  `BoardViewPage` detecta mudança e chama `_buildBoardData()`.
7.  **O board inteiro é destruído e recriado.** ⚠️

**Fluxo Ideal (AppFlowy):**
1.  Usuário solta o card.
2.  A biblioteca `appflowy_board` já atualizou a UI visualmente (estado efêmero).
3.  Controller chama API em background.
4.  **Nenhum rebuild total é disparado** a menos que haja erro ou dados novos do servidor.
5.  O estado do domínio (`_allCards`) é atualizado silenciosamente ou via sincronização fina.

**Melhoria:**
Não usar `notifyListeners` para ações que a UI já resolveu visualmente (Optimistic UI), ou usar um sistema de eventos mais granular em vez de um único listener global.

## 3. Camada de Adaptação (Adapter Pattern)

O AppFlowy lida com `Database Rows` genéricas, mas o Board precisa de `Kanban Items`. Existe uma camada clara que adapta `Row` -> `Item`.

No Kanew, estamos adaptando `Card` -> `AppFlowyGroupItem` diretamente na inicialização do widget.

**Sugestão:** Criar uma classe `BoardDataAdapter`.

```dart
class BoardDataAdapter {
  final AppFlowyBoardController boardController;

  void syncFromDomain(List<CardList> lists, List<Card> cards) {
     // Lógica inteligente de Diff:
     // 1. Verificar grupos que sumiram -> remover
     // 2. Verificar grupos novos -> adicionar
     // 3. Verificar cards que mudaram de lista -> mover
     // 4. Evitar clear() + addAll()
  }
}
```

## 4. Separação de Comandos (Command Pattern)

O AppFlowy suporta atalhos de teclado e menus de contexto complexos. Isso é possível porque as ações (Delete, Move, Edit) são desacopladas da UI.

**No Kanew:**
A lógica de deletar está num callback inline:
```dart
onDelete: () async {
  await controller.deleteCard(cardItem.card.id!);
},
```

**Melhoria:**
Encapsular ações em classes ou métodos do controller que possam ser invocados por:
1.  Drag & Drop
2.  Botão de menu
3.  Atalho de teclado (Delete key)

## Status da Implementação (2026-01-18)

✅ **Refatorar `BoardViewPageController`**: Implementado.
✅ **Criar `BoardDataAdapter`**: Criado e integrado.
✅ **Implementar Optimistic Updates**: Adicionado ao `moveCard`.

O projeto agora segue um padrão mais desacoplado e performático para o Board.
