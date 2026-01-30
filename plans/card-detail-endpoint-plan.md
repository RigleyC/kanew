# Plano: Corrigir Bug Card e Melhorar Endpoint CardDetail

## Status: ✅ IMPLEMENTADO

### O que foi feito:
1. ✅ Removido campo `labels` do modelo `Card` (já estava feito)
2. ✅ Criado endpoint `getCardsByBoardDetail` (já existia)
3. ✅ Completada migração do frontend para usar `CardDetail`
4. ✅ Removido endpoint legado `getCardsByBoard`
5. ✅ Documentação atualizada

---

## Problema Original

### Bug
- O modelo `Card` tinha campo `labels: List<LabelDef>?` que **não existia** na tabela do banco de dados
- Isso causava erro: `DatabaseQueryException: column card.labels does not exist`
- O Serverpod tentava selecionar a coluna `labels` ao executar `Card.db.find()`

### Arquitetura Atual
- `Card` = modelo base (tabela `card`)
- `CardDetail` = modelo de agregação com todos os dados relacionados
- `CardLabel` = tabela de junção para relacionar cards e labels

## Solução Implementada

### 1. Correção do Bug
O campo `labels` foi removido do modelo `Card` e agora os labels são acessados via `CardDetail.cardLabels`.

### 2. Endpoint `getCardsByBoardDetail`
O endpoint retorna `List<CardDetail>` com todos os dados necessários para a página do board:
- Card com todos os metadados
- Lista atual do card
- Board e Workspace
- Todas as listas do board
- Todos os labels do board
- Membros do workspace
- Checklists com itens
- Anexos
- Labels do card
- Comentários recentes e total
- Atividades recentes e total
- Permissão de edição

### 3. Frontend Atualizado
- `BoardDataAdapter` usa `CardDetail` em vez de `Card`
- `KanbanCard` recebe `CardDetail` e extrai labels automaticamente
- `BoardStore` gerencia `List<CardDetail>`
- `BoardViewPageController` carrega via `getCardsByBoardDetail`
- `CardDetailPageController` usa `_buildCardDetail()` para atualizações

### 4. Código Legado Removido
- Endpoint `getCardsByBoard` removido do servidor
- Método `getCardsByBoard` removido do client
- Testes atualizados

## Resumo das Alterações

| Arquivo | Alteração |
|---------|-----------|
| `kanew_server/lib/src/endpoints/card_endpoint.dart` | Removido `getCardsByBoard` |
| `kanew_server/lib/src/generated/protocol.yaml` | Removido `getCardsByBoard` |
| `kanew_server/lib/src/generated/endpoints.dart` | Removido `getCardsByBoard` |
| `kanew_client/lib/src/protocol/client.dart` | Removido `getCardsByBoard` |
| `kanew_flutter/lib/features/board/data/card_repository.dart` | Removido `getCardsByBoard` |
| `kanew_flutter/lib/features/board/presentation/utils/board_data_adapter.dart` | Usa `CardDetail` |
| `kanew_flutter/lib/features/board/presentation/widgets/kanban_card.dart` | Usa `CardDetail` |
| `kanew_flutter/lib/features/board/presentation/widgets/kanban_board.dart` | Usa `CardDetail` |
| `kanew_flutter/lib/features/board/presentation/store/board_store.dart` | Atualizado para `CardDetail` |
| `kanew_flutter/lib/features/board/presentation/controllers/board_view_controller.dart` | Usa `CardDetail` |
| `kanew_flutter/lib/features/board/presentation/controllers/card_detail_controller.dart` | Usa `CardDetail` |
| `docs/ANALISE_BOARD_APPFLOWY_VS_KANEW.md` | Documentação atualizada |

## Benefícios

1. ✅ Bug corrigido (`column card.labels does not exist`)
2. ✅ Board page faz apenas 1 requisição em vez de várias
3. ✅ Frontend tem acesso a todos os dados relacionados via `CardDetail`
4. ✅ Arquitetura mais simples e performática
5. ✅ Código legado removido
