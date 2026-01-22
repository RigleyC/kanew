# Plano de Refatoração: Arquitetura do Board (Adapter & Diffing)

Este documento detalha o plano para desacoplar a lógica de dados da UI e implementar atualizações eficientes no Board do Kanew, seguindo as lições aprendidas com o AppFlowy.

## Objetivos
1.  **Separar Responsabilidades:** Remover a lógica de construção de dados da `BoardViewPage`.
2.  **Otimizar Performance:** Substituir o rebuild total (`clear` + `addAll`) por um algoritmo de Diff.
3.  **Melhorar UX:** Implementar atualizações otimistas (Optimistic UI) para drag & drop imediato.

---

## 1. Criar `BoardDataAdapter`
Esta classe servirá como ponte entre o Domínio (`Card`, `CardList`) e a UI Library (`AppFlowyBoardController`).

**Local:** `lib/features/board/presentation/utils/board_data_adapter.dart` (nova pasta utils ou logic)

**Responsabilidades:**
- Manter referência ao `AppFlowyBoardController`.
- Método `sync(List<CardList> lists, List<Card> cards)`: Sincroniza o estado atual com os novos dados usando Diffing.
- Métodos auxiliares para converter `Card` -> `AppFlowyGroupItem`.

## 2. Implementar Algoritmo de Diffing
Em vez de limpar o board, o `BoardDataAdapter` comparará o estado atual do `AppFlowyBoardController` com os novos dados.

**Lógica de Sincronização (`sync`):**

### A. Sincronização de Grupos (Listas)
1.  **Identificar Removidos:** IDs de grupos no controller que não existem na nova lista -> `controller.removeGroup`.
2.  **Identificar Adicionados:** IDs na nova lista que não existem no controller -> `controller.addGroup`.
3.  **Reordenar:** Verificar se a ordem mudou e reordenar visualmente (se a lib suportar ou remover/adicionar na ordem certa).

### B. Sincronização de Itens (Cards)
Para cada grupo:
1.  Obter itens atuais do grupo.
2.  **Diff:** Comparar com a nova lista de cards para aquele grupo.
3.  **CRUD:**
    - Se card não existe mais -> `controller.removeGroupItem`.
    - Se card é novo -> `controller.addGroupItem`.
    - Se card mudou (título, prioridade, etc.) -> Atualizar o item (requer que `CardBoardItem` seja mutável ou substituível).

## 3. Refatorar `BoardViewPage` (View)
Limpar a View para que ela apenas inicialize e conecte as peças.

**Mudanças:**
1.  Instanciar `BoardDataAdapter` no `initState`, passando o `_boardController` (da lib).
2.  No `ListenableBuilder` (ou listener do controller), chamar `_adapter.sync(_controller.lists, _controller.allCards)`.
3.  Remover todo o método `_buildBoardData` antigo.

## 4. Refatorar `BoardViewPageController` (ViewModel)
Preparar o controller para suportar updates otimistas e expor dados de forma amigável para o Adapter.

**Mudanças:**
1.  **Expor Dados:** Garantir getters claros para `lists` e `getCardsForList` (já existem, mas validar eficiência).
2.  **Optimistic Updates (Move Card):**
    - Ao mover um card, atualizar a lista local `_allCards` *imediatamente* antes de chamar o repositório.
    - Chamar `notifyListeners()` para que o Adapter reflita a mudança (ou, se o Adapter for inteligente, ele nem precisará fazer nada se a lib de UI já moveu visualmente, apenas confirmará o estado).
    - **Rollback:** Se a API falhar, reverter a mudança local e notificar novamente.

## Passo a Passo da Implementação

### Passo 1: Setup do Adapter
- [ ] Criar arquivo `board_data_adapter.dart`.
- [ ] Implementar conversão básica `Card` -> `CardBoardItem`.
- [ ] Implementar estrutura inicial de `sync` (ainda com clear/add para teste inicial).
- [ ] Conectar na `BoardViewPage` substituindo a lógica atual.

### Passo 2: Lógica de Diffing (Grupos)
- [ ] Implementar diff de Grupos (Adicionar/Remover listas sem limpar tudo).
- [ ] Testar criando/deletando listas.

### Passo 3: Lógica de Diffing (Cards)
- [ ] Implementar diff de Cards dentro dos grupos.
- [ ] Garantir que edições de cards (título, cor) reflitam sem recriar o grupo.

### Passo 4: Optimistic Updates
- [ ] Ajustar `BoardViewPageController.moveCard`:
    - Atualizar `_allCards` localmente (mudando `listId`).
    - Notificar.
    - Chamar Repo.
    - Tratamento de erro (reverter).
- [ ] Ajustar Drag & Drop callbacks na View para não dependerem de reload completo.

---
**Resultado Esperado:** O board não deve "piscar" (recarregar loading) ao mover cards ou criar listas. A UI deve ser fluida e reativa.
