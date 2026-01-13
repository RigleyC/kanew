# Kan Clone

## 1. Visão Geral do Projeto

O **Kan Clone** é uma plataforma de gerenciamento de projetos baseada na metodologia Kanban (semelhante ao Trello), focada em performance, privacidade (self-hosted) e controle granular de acessos. O sistema permite a criação de Workspaces, Quadros, Listas e Cartões, com suporte a colaboração em tempo real.

## 2. Tecnologias e Bibliotecas (Stack)

- **Backend:** Serverpod (Dart).
- **Banco de Dados:** PostgreSQL (Relacional).
- **Frontend:** Flutter (Web, Mobile).
- **Libs Principais (Sugestão):**
    - *Auth:* `serverpod_auth` (Nativo).
    
    - **Roteamento:** `zenrouter` (Baseado em path, ideal para suporte a Slugs).
    - **Editor de Texto:** `appflowy_editor` (Para descrições ricas e documentos).
    - *Drag and Drop:* `appflowy_board.`
    - *Ordenação:* Implementação de algoritmo **Lexorank**.

## 3. Arquitetura

- **Client-Server:** Comunicação via Serverpod Client (gerado automaticamente).
- **Real-time:** Uso de WebSockets (Serverpod Streams) para atualizações instantâneas de movimentação de cards.
- **Segurança:** Autenticação via Session Token. Autorização via verificação de permissões no Backend (RBAC customizado) antes de qualquer operação de escrita.
- **Soft Delete:** Entidades principais nunca são deletadas fisicamente, apenas marcadas com `deletedAt`.

## 4. Banco de Dados (Resumo)

Modelagem baseada em 4 pilares:

1. **Core:** Workspace -> Board -> List -> Card.
2. **Detalhes:** Labels, Checklists, Comentários, Anexos, Atividades (Logs).
3. **Segurança:** Usuários, Membros, Permissões Granulares (Tabela Pivô), Convites.
4. **Sistema:** Assinaturas, Integrações.

---

## 5. Especificação de Funcionalidades

Vamos iniciar o detalhamento.

### 🔐 Funcionalidade 01 — Autenticação e Gestão de Conta

**(Serverpod 3.x + UI Custom com forui)**

---

## 1. Objetivo

Gerenciar autenticação, identidade e sessões dos usuários, desacoplado totalmente da UI nativa do Serverpod, utilizando:

- **Backend:** Serverpod 3.x + `serverpod_auth`
- **Frontend:** Flutter + **forui**
- **UI:** 100% custom (login, signup, reset, confirmação)

O Serverpod atua **exclusivamente como provedor de autenticação e sessão**, sem fornecer componentes visuais.

---

## 2. Princípios Arquiteturais

- ❌ Nenhum widget pronto do Serverpod será utilizado
- ✅ Toda UI é responsabilidade do frontend
- ✅ Backend fornece apenas:
    - Endpoints
    - Validações
    - Sessões
    - Tokens
- ✅ Frontend controla:
    - Estados de tela
    - Mensagens
    - Fluxos de navegação

---

## 3. Entidades Envolvidas (Serverpod 3.x)

### 3.1. Nativas (`serverpod_auth`)

- `UserInfo`
- `UserAuth`
- `Session`
- `EmailAuthCode` (confirmação / reset)

### 3.2. Customizadas

- `Workspace`
- `WorkspaceMember`
- `Invite`
- `MemberPermission`
- `UserPreference`
    - `lastWorkspaceId`
    - `theme`

---

## 4. Fluxo 01 — Cadastro Orgânico (Sign Up)

### 4.1. Frontend (forui)

**Tela de Cadastro**

- Inputs:
    - Nome completo
    - Email
    - Senha
- Estados:
    - `idle`
    - `loading`
    - `error`
    - `success`

Validações básicas são feitas **no frontend** antes do envio.

---

### 4.2. Backend (Serverpod 3.x)

### Passo a passo

1. **Validação**
    - Verifica se o e-mail já existe (`UserInfo.email`)
    - Se existir → erro explícito
2. **Criação do Usuário**
    - Cria `UserInfo`
    - Cria `UserAuth` com hash seguro
    - Define `emailVerified = false`
3. **Criação Automática do Workspace**
    - Workspace criado **sempre** no backend
    - Nome padrão: `Workspace de {Primeiro Nome}`
    - Slug:
        - Global
        - Com fallback incremental (`1`, `2`, etc)
    - Usuário é:
        - Criado como **Owner**
        - Com todas as permissões
        - Permissões não removíveis
4. **Preferências**
    - Cria `UserPreference`
    - Define `lastWorkspaceId`
5. **Confirmação de E-mail**
    - Backend gera código
    - Envia e-mail

---

### 4.3. Pós-Cadastro (Frontend)

- Usuário é autenticado
- Redirecionado ao workspace padrão
- Caso `emailVerified == false`:
    - Banner persistente:
        
        > “Seu e-mail ainda não foi confirmado”
        > 
    - Ações:
        - Inserir código
        - Reenviar confirmação

📌 O usuário **pode usar o sistema normalmente**, com aviso visível.

---

## 5. Fluxo 02 — Cadastro via Convite

### 5.1. Acesso

Rota:

```
/invite/{inviteCode}
```

Frontend chama endpoint de validação.

---

### 5.2. Regras do Convite

- Convite:
    - Não expira
    - Pode ser revogado
    - Só pode ser aceito uma vez
- **Não é vinculado ao e-mail**
- Aceito por **quem estiver autenticado no momento do clique**

---

### 5.3. Usuário Não Autenticado

Frontend oferece:

- Login
- Cadastro

Após autenticação, o fluxo do convite continua automaticamente.

---

### 5.4. Backend — Aceitação do Convite

1. Verifica validade
2. Se usuário já for membro:
    - Convite é invalidado
    - Usuário redirecionado ao workspace
3. Caso contrário:
    - Cria `WorkspaceMember`
    - Copia permissões do `Invite`
    - Marca convite como aceito

---

## 6. Fluxo 03 — Login (Sign In)

### 6.1. Frontend (forui)

**Tela de Login**

- Inputs:
    - Email
    - Senha
- Estados:
    - `idle`
    - `loading`
    - `error`
    - `success`

---

### 6.2. Backend

- Valida credenciais
- Cria sessão
- Sessão é **infinita**, até logout manual

---

### 6.3. Redirecionamento Pós-Login

- Backend retorna dados do usuário
- Frontend:
    - Se `lastWorkspaceId` existe → redireciona
    - Caso contrário → workspace padrão

---

### 6.4. E-mail Não Confirmado

- Login permitido
- Banner persistente com ações:
    - Inserir código
    - Reenviar confirmação

---

## 7. Fluxo 04 — Confirmação de E-mail

### 7.1. Frontend

Tela dedicada:

- Input de código
- Estados:
    - `loading`
    - `error`
    - `success`

---

### 7.2. Backend

- Valida código
- Marca `emailVerified = true`

Mensagens distintas para:

- Código inválido
- Código expirado
- Código já usado

---

## 8. Fluxo 05 — Recuperação de Senha

### 8.1. Solicitação

- Usuário informa e-mail
- Backend gera token (1h)
- Envia link:

```
/reset-password?token=XYZ

```

---

### 8.2. Reset

- Frontend:
    - Nova senha (2x)
- Backend:
    - Atualiza senha
    - Invalida token
    - **Invalida todas as sessões do usuário (default)**

---

## 9. Logout

- Logout manual invalida apenas a sessão atual
- Reset de senha invalida todas

---

### 🏢 Funcionalidade 02 — Gestão de Workspaces

**(Serverpod 3.x + RBAC Granular)**

---

## 1. Objetivo

O Workspace é a **unidade máxima de organização e isolamento** do sistema.

Tudo no Kan Clone existe **dentro de um Workspace**.

Responsabilidades:

- Agrupar boards e membros
- Definir permissões (RBAC)
- Controlar acesso, visibilidade e ownership
- Servir como boundary de segurança (tenant)

---

## 2. Princípios Arquiteturais

- Um usuário pode pertencer a **múltiplos workspaces**
- Todo usuário **sempre pertence a pelo menos um workspace**
- Slug do workspace é:
    - **Global**
    - Usado como base do routing
- Todas as verificações de permissão acontecem:
    - **No backend**
    - Antes de qualquer operação de escrita ou leitura sensível

---

## 3. Entidades Envolvidas

### 3.1. Core

### `Workspace`

- `id`
- `name`
- `slug` (único global)
- `ownerId`
- `createdAt`
- `deletedAt` (soft delete)
- `deletedBy`

---

### `WorkspaceMember`

- `id`
- `workspaceId`
- `userId`
- `role` (`owner`, `member`)
- `joinedAt`
- `removedAt` (soft remove)

---

### 3.2. Permissões

### `Permission`

- `id`
- `slug`
    
    Ex:
    
    - `workspace.read`
    - `board.create`
    - `card.delete`

---

### `MemberPermission`

- `id`
- `workspaceMemberId`
- `permissionId`

---

## 4. Fluxo 01 — Criação de Workspace

### 4.1. Gatilhos

- Automático após cadastro orgânico
- Manual via botão **“Novo Workspace”**

---

### 4.2. Frontend (forui)

**Modal de Criação**

- Campos:
    - Nome (obrigatório)
    - Slug (opcional)
- Estados:
    - `idle`
    - `loading`
    - `error`
    - `success`

---

### 4.3. Backend (Serverpod 3.x)

### Passo a passo

1. **Validação**
    - Nome obrigatório
    - Slug (se fornecido):
        - Normalizado
        - Verificado globalmente
2. **Resolução de Colisão**
    - Se slug já existir:
        - Incrementa automaticamente (`1`, `2`, …)
    - Processo é **determinístico e automático**
3. **Criação**
    - Cria Workspace
    - Define usuário como `owner`
4. **Permissões**
    - Owner recebe:
        - Todas as permissões
        - Não removíveis
        - Não editáveis

---

## 5. Navegação e Acesso

### 5.1. Rota Base

```
/:w/:workspace_slug
```

---

### 5.2. Middleware de Segurança (Backend)

Antes de qualquer request:

1. Verifica sessão válida
2. Verifica se usuário é membro do workspace
3. Se não for:
    - Retorna `403` ou `404` (decisão de segurança)

📌 O frontend **nunca confia apenas na UI**.

---

## 6. Fluxo 02 — Listagem de Workspaces

### 6.1. Frontend

- Sidebar ou tela dedicada
- Lista:
    - Avatar (iniciais + cor)
    - Nome
    - Slug
- Destaque para workspace ativo

---

### 6.2. Backend

- Retorna apenas workspaces:
    - Onde `WorkspaceMember` existe
    - `removedAt IS NULL`
    - `deletedAt IS NULL`

---

## 7. Fluxo 03 — Gestão de Membros

### 7.1. Tela `/members`

**Lista de membros**

- Avatar
- Nome
- Email
- Role
- Status

---

### 7.2. Regras Importantes

- Owner:
    - Não pode ser removido
    - Não pode perder permissões
- Membros:
    - Podem ser removidos
    - Podem ter permissões alteradas

---

## 8. Fluxo 04 — Matriz de Permissões (RBAC)

### 8.1. Interface

Tabela de permissões:

| Entidade | Read | Create | Update | Delete |
| --- | --- | --- | --- | --- |
| Workspace | ☑️ | ❌ | ☑️ | ❌ |
| Board | ☑️ | ☑️ | ☑️ | ☑️ |
| List | ☑️ | ☑️ | ☑️ | ☑️ |
| Card | ☑️ | ☑️ | ☑️ | ☑️ |
- Checkboxes
- Algumas células são **N/A** (desabilitadas)

---

### 8.2. Mapeamento Técnico

Cada checkbox corresponde a um `Permission.slug`.

Exemplo:

- `card.delete`
- `list.create`

---

### 8.3. Modelo de Hierarquia

Permissões seguem **hierarquia lógica**, mas:

> ⚠️ O enforcement é explícito
> 

Exemplo:

- `card.delete` **não concede automaticamente** `card.read`
- Backend valida **todas** as permissões necessárias

---

## 9. Fluxo 05 — Convites para Workspace

### 9.1. Criação de Convite

- Apenas usuários com `workspace.invite`
- Define:
    - Workspace
    - Permissões
- Gera código único

---

### 9.2. Aceitação

- Convite:
    - Não expira
    - Pode ser revogado
    - Só pode ser aceito uma vez
- Aceito por:
    - Usuário autenticado no momento do clique

---

## 10. Fluxo 06 — Configurações do Workspace

### 10.1. Geral

- Editar:
    - Nome
    - Slug
- Alterar slug:
    - Mostra aviso de quebra de link
    - Backend valida colisão global

---

### 10.2. Exclusão (Soft Delete)

- Apenas Owner
- Marca:
    - `deletedAt`
    - `deletedBy`
- Workspace entra em período de retenção (30 dias)

---

## 11. Edge Cases Tratados

- Usuário sem workspace → **não existe**
- Slug duplicado → resolvido automaticamente
- Owner removido → **impossível**
- Permissão incoerente → backend bloqueia
- Convite duplicado → invalidado
- Membro removido → perde acesso imediato

# 🗂️ Funcionalidade 03 — Gestão de Boards (Quadros)

**(Serverpod 3.x · Permissões Herdadas · Kanban Único)**

---

## 1. Objetivo

Os **Boards** representam os quadros de trabalho onde o fluxo Kanban acontece.

Eles existem **dentro de um Workspace**, herdam suas permissões e são o principal ponto de entrada para a operação diária do sistema.

Neste MVP:

- Um board possui **apenas uma visualização** (Kanban)
- Não há templates nem múltiplas views (Table, Calendar, etc.)

---

## 2. Princípios Arquiteturais

- Todo Board pertence a **um único Workspace**
- Boards **herdam permissões** do Workspace
- Slug do Board é:
    - Único **dentro do Workspace**
    - Usado para roteamento
- Boards utilizam **soft delete**
- Usuários sem acesso ao Workspace **nunca** acessam seus Boards

---

## 3. Entidade Principal

### 3.1. `Board`

Campos principais:

- `id`
- `workspaceId`
- `title`
- `slug`
- `background` (URL)
- `visibility` (`workspace`)
- `createdAt`

- `deletedAt`

📌 **Restrições**

- `(workspaceId, slug)` é único
- `deletedAt != null` → board inacessível

---

## 4. Fluxo 01 — Criação de Board

### 4.1. Gatilho

- Botão **“Novo Board”** na tela de listagem de boards do Workspace

---

### 4.2. Frontend (Flutter + forui)

**Modal de Criação**

- Campo:
    - Título do Board (obrigatório)
- Estados:
    - `idle`
    - `loading`
    - `error`
    - `success`

Não há configuração avançada no MVP.

---

### 4.3. Backend (Serverpod 3.x)

### Passo a passo

1. **Validação**
    - Usuário deve ter permissão `board.create`
    - Título obrigatório
2. **Slug**
    - Gerado automaticamente a partir do título
    - Normalizado (`marketing q1` → `marketing-q1`)
    - Verificado **dentro do workspace**
    - Em caso de colisão:
        - Incremento automático (`1`, `2`, …)
3. **Configuração Automática**
    - `background`:
        - Valor fixo padrão
            
            Ex: `/assets/default-board-bg.jpg`
            
    - `visibility`:
        - `workspace`
4. **Persistência**
    - Board é criado
    - `deletedAt = null`
5. **Resposta**
    - Retorna slug e id
    - Frontend redireciona imediatamente para o board

---

## 5. Fluxo 02 — Listagem de Boards

### 5.1. Frontend

Tela “Boards” do Workspace:

- Grid ou lista simples
- Cada item exibe:
    - Background
    - Título
- Clique redireciona para o board

---

### 5.2. Backend

Retorna:

- Boards do workspace
- Onde:
    - `deletedAt IS NULL`
- Ordenação:
    - Por `createdAt DESC` (MVP)

---

## 6. Navegação e Roteamento

### 6.1. Rota do Board

```
/w/:workspace_slug/b/:board_slug
```

---

### 6.2. Segurança (Middleware)

Para qualquer rota de board:

1. Verifica sessão válida
2. Resolve `workspace_slug`
3. Verifica se usuário é membro do workspace
4. Verifica permissão `board.read`
5. Se falhar:
    - Retorna `403` ou `404`

📌 A UI **não controla segurança**.

---

## 7. Fluxo 03 — Visualização do Board (Kanban)

### 7.1. Interface

- Visualização única: **Kanban**
- Listas exibidas horizontalmente
- Cards empilhados verticalmente
- Scroll:
    - Horizontal → Listas
    - Vertical → Cards

---

### 7.2. Estado Inicial

Ao abrir um board recém-criado:

- Board **não possui listas**
- Exibe CTA:
    
    > “Adicione sua primeira lista”
    > 

---

## 8. Sidebar do Workspace (Contexto do Board)

Sidebar fixa com **3 itens**:

1. 🟦 **Boards**
2. 👥 **Membros**
3. ⚙️ **Configurações**

📌 A sidebar **não muda** ao entrar em um board.

---

## 9. Fluxo 04 — Exclusão de Board (Soft Delete)

### 9.1. Ação

- Disponível para usuários com `board.delete`
- Ação feita via menu contextual do board

---

### 9.2. Backend

1. Valida permissão
2. Marca:
    - `deletedAt = now()`
3. Board:
    - Some da listagem
    - Não pode mais ser acessado por rota

---

### 9.3. Acesso Pós-Exclusão

- Qualquer tentativa de acesso ao slug:
    - Retorna `404`

📌 Restore **não faz parte do MVP**, mas é possível futuramente.

---

## 10. Permissões Envolvidas

Boards **não possuem permissões próprias** no MVP.

Permissões aplicáveis (herdadas do Workspace):

- `board.read`
- `board.create`
- `board.update`
- `board.delete`

📌 O backend valida explicitamente cada ação.

---

## 11. Edge Cases Tratados

- Slug duplicado no mesmo workspace → resolvido automaticamente
- Slug duplicado em outro workspace → permitido
- Usuário removido do workspace → perde acesso imediato
- Board deletado → rota retorna 404
- Usuário sem permissão → bloqueio backend

# 📋 Funcionalidade 04 — Listas do Board (Columns)

**(Kanban · Ordem Manual · Realtime Simples)**

---

## 1. Objetivo

As **Listas** representam as colunas do Kanban (ex: *A Fazer*, *Em Progresso*, *Concluído*).

Elas organizam os cards dentro de um Board e são **ordenáveis horizontalmente**.

---

## 2. Princípios Arquiteturais

- Toda Lista pertence a **um único Board**
- Listas:
    - Não têm permissões próprias
    - Herdam permissões do Board/Workspace
- A **ordem é controlada manualmente**
- Alterações de ordem são sincronizadas em realtime
- Exclusão é **soft delete**

---

## 3. Entidade Principal

### 3.1. `BoardList`

Campos principais:

- `id`
- `boardId`
- `title`
- `position` (int)
- `createdAt`
- `deletedAt`

📌 **Regras**

- `position` define a ordem horizontal
- Não há slug para listas
- `deletedAt != null` → lista invisível

---

## 4. Fluxo 01 — Criação de Lista

### 4.1. Frontend (Flutter + forui)

No board:

- Botão **“+ Adicionar lista”** no final das colunas
- Input inline:
    - Título obrigatório
- Estados:
    - `idle`
    - `loading`
    - `error`
    - `success`

---

### 4.2. Backend (Serverpod 3.x)

### Passos

1. **Validação**
    - Sessão válida
    - Permissão `board.update`
    - Título obrigatório
2. **Definição de posição**
    - Nova lista recebe:
        
        ```
        position = max(position) + 1
        
        ```
        
    - Considerando apenas listas não deletadas
3. **Persistência**
    - Lista criada
    - `deletedAt = null`
4. **Realtime**
    - Evento emitido para o board:
        - `list.created`

---

## 5. Fluxo 02 — Listagem de Listas

### 5.1. Backend

Ao carregar o board:

- Retorna listas:
    - Onde `deletedAt IS NULL`
    - Ordenadas por `position ASC`

---

### 5.2. Frontend

- Renderiza listas horizontalmente
- Cada lista:
    - Cabeçalho com título
    - Área de cards (vazia inicialmente)

---

## 6. Fluxo 03 — Renomear Lista

### 6.1. Frontend

- Clique no título → modo edição
- Input inline
- Confirmação:
    - Enter ou blur

---

### 6.2. Backend

1. Valida `board.update`
2. Atualiza `title`
3. Emite evento:
    - `list.updated`

---

## 7. Fluxo 04 — Reordenar Listas (Drag & Drop)

### 7.1. Frontend

- Drag horizontal entre listas
- Ao soltar:
    - Envia nova ordem completa

---

### 7.2. Backend

### Estratégia (simples e previsível)

- Recebe array ordenado de IDs
- Atualiza todas as listas do board:
    
    ```
    position = index
    ```
    

📌 Não há cálculo incremental nem otimização no MVP.

---

### 7.3. Realtime

- Evento emitido:
    - `list.reordered`
- Payload:
    - Lista de IDs ordenados

📌 **Regra definida por você**:

> Quem sincronizou por último vence, e o cliente re-renderiza tudo.
> 

---

## 8. Fluxo 05 — Exclusão de Lista

### 8.1. Ação

- Menu contextual no cabeçalho da lista
- Ação disponível apenas se:
    - Usuário tem `board.update`

---

### 8.2. Backend

1. Marca:
    - `deletedAt = now()`
2. **Cards da lista**:
    - Permanecem no banco
    - Ficam inacessíveis (via FK lógica)
3. Emite evento:
    - `list.deleted`

📌 Restore **fora do escopo do MVP**.

---

## 9. Permissões Envolvidas

Listas **não têm permissões próprias**.

Permissões usadas:

- `board.read`
- `board.update`

---

## 10. Edge Cases Tratados

- Board deletado → listas não carregam
- Usuário removido do workspace → acesso bloqueado
- Lista deletada:
    - Some imediatamente da UI
    - Rota do board continua válida
- Conflito de reorder:
    - Última gravação vence

---

## 11. Realtime (Resumo)

Eventos emitidos:

- `list.created`
- `list.updated`
- `list.reordered`
- `list.deleted`

Cliente:

- Rebusca estado do board
- Re-render completo

---

# 🧩 Funcionalidade 05: Cards (Unidade Central de Trabalho)

Os **Cards** representam as tarefas/unidades de trabalho dentro de um Board. Eles concentram contexto, comunicação, progresso e histórico, sendo projetados para **alto volume**, **movimentação frequente** e **consistência em tempo real**.

O sistema prioriza:

- Performance no drag & drop
- Consistência de ordenação (LexoRank)
- Controle explícito de permissões
- Experiência fluida em colaboração simultânea

---

## A. Permissões de Card (RBAC)

### A.1. Modelo de Permissão

Os Cards utilizam permissões específicas, mesmo que no MVP elas sejam herdadas do Workspace.

Permissões disponíveis:

- `card.read`
- `card.create`
- `card.update`
- `card.delete`

📌 **Regras gerais**

- Todas as operações são **validadas no backend (Serverpod 3.x)**.
- O frontend apenas esconde ações visualmente.
- Permissões são herdadas do Workspace, mas **avaliadas explicitamente por entidade**.

---

### A.2. Mapeamento de Ações

| Ação | Permissão Necessária |
| --- | --- |
| Visualizar card | `card.read` |
| Criar card | `card.create` |
| Editar / mover / mudar prioridade | `card.update` |
| Arquivar ou deletar | `card.delete` |

📌 Usuários sem permissão:

- Não conseguem executar a ação
- Recebem resposta `403` do backend

---

## B. Estrutura do Card

Campos principais da entidade Card:

- `id`
- `workspaceId`
- `boardId`
- `listId`
- `title`
- `description`
- `rank` (LexoRank)
- `priority`
- `archived`
- `deletedAt`
- `createdAt`
- `updatedAt`

---

## C. Ordenação e Posicionamento (LexoRank)

### C.1. Decisão Arquitetural

A ordenação dos Cards utiliza **LexoRank**, evitando:

- Reindexação global
- Problemas de concorrência
- Limitações de `int position`

Campo:

- `rank: String`

Exemplo:

```
0|hzzzzz
0|i00000
0|i0000z
```

---

### C.2. Regra de Ordenação

Os Cards **sempre** são ordenados por:

```
ORDER BY priority DESC, rank ASC
```

📌 A lista é renderizada como um único bloco lógico, mas internamente agrupada por prioridade.

---

### C.3. Criação de Card

- Ao criar um Card:
    - Ele herda a prioridade padrão
    - O `rank` é gerado **após o último card da mesma prioridade**
- O backend retorna o Card já com rank válido

---

### C.4. Drag & Drop Inteligente

### 1. Movimento dentro da mesma prioridade

- Apenas o `rank` é recalculado
- Prioridade permanece inalterada

### 2. Movimento entre prioridades (mudança implícita)

- O sistema detecta o grupo do card vizinho
- Atualiza automaticamente:
    - `priority`
    - `rank` compatível com o novo grupo

📌 Não existe ação explícita “mudar prioridade” no board — o gesto resolve.

---

### C.5. Concorrência e Realtime

- Estratégia: **Last write wins**
- Se dois usuários moverem cards ao mesmo tempo:
    - O último update persiste
    - O cliente re-renderiza o estado final recebido via stream

---

## D. Prioridade do Card

### D.1. Valores

Enum `priority`:

- `urgent`
- `high`
- `medium`
- `low`
- `none`(default)

---

### D.2. Comportamento

- Prioridade:
    - Afeta **ordem visual**
    - Afeta **regra de drag & drop**
- Visualmente representada por:
    - Barra lateral colorida no card
- Editável:
    - Pelo drag & drop
    - Pela página de detalhes do Card

---

## E. Visualização do Card no Board

O Card exibe informações resumidas para decisão rápida:

- Barra de prioridade (esquerda)
- Título
- Indicadores:
    - Descrição
    - Checklists (x/y)
    - Anexos
    - Etiquetas
    - Membros

📌 Cards sem permissão `card.read`:

- Não são renderizados no board

---

## F. Arquivamento e Exclusão

- **Arquivar**
    - Marca `archived = true`
    - Remove do board
- **Deletar**
    - Soft delete (`deletedAt`)
    - Apenas com `card.delete`

---

## G. Realtime

Eventos emitidos:

- `card.created`
- `card.updated`
- `card.moved`
- `card.archived`

Payload inclui:

- `rank`
- `priority`
- `listId`

Cliente:

- Reordena localmente
- Re-renderiza a lista afetada

# Funcionalidade 03.1 — Filtros Avançados no Board (Cascading Menu)

Os **Filtros Avançados** são um mecanismo **exclusivamente client-side**, projetado para ajudar o usuário a **focar rapidamente** em subconjuntos relevantes de cards sem alterar estado do servidor, URL ou persistência.

Eles funcionam como uma **camada de visualização**, nunca como uma mutação de dados.

---

## A. Objetivo Técnico

- Evitar roundtrips ao backend
- Garantir performance mesmo com muitos cards
- Não impactar ordenação (LexoRank + Prioridade continuam válidos)
- Não interferir em realtime (eventos continuam chegando normalmente)

---

## B. Interface e Comportamento Visual

### B.1. Gatilho

- Botão **“Filtros”** na toolbar do Board
- Exibe:
    - Ícone
    - Badge numérico indicando quantidade de filtros ativos

Exemplo:

```
Filtros (3)
```

---

### B.2. Componente (Cascading Menu)

Implementado via:

- `Overlay` / `MenuAnchor` (Flutter)
- Controle de estado via `Riverpod`

### Nível 1 — Categorias

Lista vertical simples:

- 👤 Membros
- 🏷️ Etiquetas
- 🚦 Prioridade
- 📅 Data

📌 Nenhuma requisição backend ocorre aqui.

---

### Nível 2 — Opções

Ao **hover ou click** em uma categoria:

- Abre painel lateral (efeito cascata)
- Contém:

### Header fixo

- `TextField` de busca
- Filtra apenas as opções daquela categoria

### Corpo

- Lista scrollável de opções
- Cada opção com `Checkbox`

Exemplos:

- Lista de membros
- Lista de labels
- Lista de prioridades (`urgent`, `high`, `medium`, `low`)

---

## C. Estado dos Filtros (Client-side)

### C.1. Armazenamento

- Mantido **em memória**
- Provider Riverpod, exemplo lógico:

```dart
BoardFilterState {
  members: Set<UserId>
  labels: Set<LabelId>
  priorities: Set<Priority>
  dueDate: DateFilter?
}

```

📌 Não:

- Salva no backend
- Persiste entre reloads
- Altera URL

---

### C.2. Regra de Aplicação

Um Card é exibido **somente se**:

- Satisfaz **TODOS** os filtros ativos (AND lógico)
- Dentro de uma categoria:
    - Basta satisfazer **UM** item selecionado (OR)

Exemplo:

- Membro: João OU Maria
- Prioridade: High
    
    → Card precisa ser `(João OR Maria) AND High`
    

---

## D. Impacto na Renderização

### D.1. Estratégia

- Cards que **não passam no filtro**:
    - Não são renderizados (`display: none`)
    - São removidos da árvore de widgets
- A lista “encolhe” naturalmente

📌 Não há placeholders nem cards “acinzentados”.

---

### D.2. Ordenação

Filtros **não alteram**:

- `ORDER BY priority DESC, rank ASC`
- Agrupamento visual por prioridade

Apenas reduzem o conjunto renderizado.

---

## E. Integração com Realtime

### E.1. Recebimento de Eventos

Mesmo com filtros ativos:

- O cliente continua recebendo:
    - `card.created`
    - `card.updated`
    - `card.moved`

### E.2. Regra

- Evento chega
- Estado local é atualizado
- Filtro é reaplicado
- Card:
    - Aparece, desaparece ou se move conforme o caso

📌 Não há “pausa” de realtime por filtro ativo.

---

## F. Limpar Filtros

### F.1. UI

- Quando houver pelo menos 1 filtro ativo:
    - Exibir botão **“Limpar Filtros”**
- Ação:
    - Zera o estado do provider
    - Re-render imediato

---

## G. Edge Cases Importantes

### G.1. Usuário sem permissão

- Cards sem `card.read`:
    - Nunca entram no conjunto filtrável
    - Não contam para filtros de membro, label, etc.

---

### G.2. Card atualizado perde compatibilidade

Exemplo:

- Card tinha label X
- Outro usuário remove a label
- Filtro ativo exige X

Resultado:

- Card desaparece instantaneamente

---

### G.3. Filtro vazio

- Nenhum filtro ativo:
    - Board se comporta normalmente
    - Nenhum custo adicional de renderização

---

## H. Não-Objetivos (Explícito)

Esta feature **não**:

- Salva filtros como “views”
- Compartilha filtros entre usuários
- Afeta backend
- Altera permissão ou dados

Esses itens ficam para versões futuras.

---

# Funcionalidade — Realtime & Sincronização de Estado

O sistema oferece colaboração em tempo real usando **Serverpod Streams (WebSockets)**, garantindo que múltiplos usuários possam interagir simultaneamente com Workspaces, Boards, Listas e Cards de forma consistente e previsível.

O foco é:

- Simplicidade operacional
- Consistência de dados
- Performance no cliente
- Resolução determinística de conflitos

---

## A. Arquitetura Realtime

### A.1. Tecnologia

- **Serverpod 3.x Streams**
- Comunicação bidirecional via WebSocket
- Canal por entidade lógica (Workspace / Board)

📌 Não é utilizado CRDT ou OT neste MVP.

---

### A.2. Modelo Mental

- Backend é a **única fonte da verdade**
- Cliente:
    - Executa ações
    - Recebe eventos
    - Re-renderiza estado

📌 Não existe sincronização parcial ou merge inteligente.

---

## B. Escopo de Sincronização

### B.1. Nível de Canal

Os clientes se conectam a streams específicas:

| Canal | Descrição |
| --- | --- |
| `workspace:{id}` | Eventos globais (membros, permissões) |
| `board:{id}` | Eventos de listas e cards |

📌 Usuário só consegue se inscrever se for membro.

---

### B.2. Controle de Acesso

Antes de permitir:

- `stream.subscribe(board:{id})`

O backend valida:

- Sessão válida
- `board.read` / `card.read`

Caso contrário:

- Conexão recusada

---

## C. Tipos de Eventos

### C.1. Eventos de Card

| Evento | Disparo |
| --- | --- |
| `card.created` | Novo card |
| `card.updated` | Edição |
| `card.moved` | Lista, rank ou prioridade |
| `card.archived` | Arquivamento |
| `card.deleted` | Soft delete |

Payload mínimo:

```json
{
  "cardId": "uuid",
  "boardId": "uuid",
  "listId": "uuid",
  "rank": "0|i0000z",
  "priority": "high",
  "updatedAt": "2026-01-08T12:00:00Z"
}

```

---

### C.2. Eventos de Lista

| Evento | Disparo |
| --- | --- |
| `list.created` | Nova lista |
| `list.updated` | Rename |
| `list.moved` | Rank alterado |
| `list.archived` | Soft delete |

---

### C.3. Eventos de Board / Workspace

- `member.added`
- `member.removed`
- `permission.updated`
- `board.updated`

📌 Eventos administrativos não forçam reload completo automaticamente.

---

## D. Estratégia de Conflito

### D.1. Regra Oficial

> Last write wins
> 
- O último update persistido no banco é considerado válido
- Não há lock otimista nem versionamento por campo

---

### D.2. Exemplo Prático

1. Usuário A move Card X
2. Usuário B move Card X quase ao mesmo tempo
3. Backend processa:
    - A → update
    - B → update (vence)
4. Evento final chega a todos
5. Cliente re-renderiza estado final

📌 Nenhuma tentativa de merge é feita.

---

## E. Estratégia de Renderização no Cliente

### E.1. Comportamento

Ao receber um evento:

1. Atualiza estado local
2. Reordena:
    - `priority DESC`
    - `rank ASC`
3. Re-renderiza apenas listas afetadas

📌 Não há debounce nem batching no MVP.

---

### E.2. Drag & Drop Local

Durante drag:

- O cliente faz reorder otimista
- Ao receber evento:
    - Estado é substituído

Se houver divergência:

- O card “salta” para posição correta

---

## F. Reconexão e Falhas

### F.1. Desconexão

- WebSocket pode cair a qualquer momento
- Cliente detecta:
    - Mostra indicador “Reconectando…”

---

### F.2. Reconexão

Ao reconectar:

1. Cliente refaz subscribe
2. Executa **fetch completo do board**
3. Substitui estado local

📌 Eventos perdidos **não são reprocessados**.

---

## G. Sessão e Segurança

- Streams respeitam:
    - Sessão ativa
    - Logout invalida socket
- Se usuário for removido do workspace:
    - Streams são encerradas
    - UI redireciona

---

## H. Edge Cases Importantes

### H.1. Permissão revogada em tempo real

- Evento `permission.updated`
- Cliente:
    - Remove ações
    - Se perder `card.read`, board fecha

---

### H.2. Card removido enquanto aberto

- Se card aberto em modal ou página:
    - Evento `card.deleted`
    - UI exibe aviso
    - Fecha automaticamente

---

### H.3. Alto volume de eventos

No MVP:

- Não há:
    - Rate limit por stream
    - Backpressure
- Cliente deve aguentar bursts

📌 Evolução futura pode incluir batching.

# Funcionalidade — Card em Página Dedicada (Deep Links & Refresh)

Os **Cards** são sempre visualizados em uma **página dedicada**, ocupando a tela inteira.

Não existe visualização em modal ou overlay.

Essa decisão garante:

- Arquitetura mais simples
- Menos estado implícito no frontend
- Deep links naturais
- Refresh seguro em qualquer ponto

---

## A. Rota Canônica do Card

### A.1. Definição Única

Todo Card possui uma **rota única e obrigatória**:

```
/w/:workspace_slug/b/:board_slug/c/:card_uuid
```

📌 Esta rota **sempre renderiza uma página**, nunca um modal.

---

## B. Navegação a partir do Board

### B.1. Fluxo

1. Usuário está no Board
2. Clica em um Card
3. App navega para a rota do Card
4. Board é desmontado
5. Página do Card é renderizada

📌 Não há overlay, backdrop ou estado de retorno implícito.

---

### B.2. Voltar ao Board

- A página do Card exibe:
    - Botão **“Voltar ao Board”**
- Ação:
    - Redireciona para:
        
        ```
        /w/:workspace_slug/b/:board_slug
        ```
        
- O Board é carregado novamente

📌 Não existe preservação de scroll ou posição anterior.

---

## C. Acesso Direto e Refresh

### C.1. Acesso Direto

Usuário pode:

- Abrir link diretamente
- Colar URL
- Receber link de outro membro

Resultado:

- Página do Card renderiza normalmente
- Não depende do Board estar carregado

---

### C.2. Refresh (F5)

- Recarrega a página do Card
- Backend valida:
    - Sessão
    - `card.read`
- Estado é reconstruído do zero

---

## D. Permissões e Segurança

### D.1. Validação

Antes de renderizar:

- Backend valida:
    - Usuário autenticado
    - Membro do Workspace
    - Permissão `card.read`

Se falhar:

- Retorna erro controlado (`403` ou `404`)

---

### D.2. Permissão Revogada em Tempo Real

- Evento `permission.updated`
- Se perder `card.read`:
    - UI exibe aviso
    - Redireciona automaticamente para o Board ou lista de Workspaces

---

## E. Realtime na Página do Card

### E.1. Eventos Recebidos

Mesmo fora do Board, a página do Card recebe:

- `card.updated`
- `comment.created`
- `attachment.added`
- `checklist.updated`

---

### E.2. Atualização de UI

- Estado local é atualizado
- Re-render parcial
- Sem dependência de contexto do Board

---

## F. Edge Cases Importantes

### F.1. Card deletado enquanto aberto

- Evento `card.deleted`
- UI:
    - Exibe mensagem clara
    - Redireciona para o Board

---

### F.2. Board ou Workspace removido

- Se Board for arquivado:
    - Card não abre
- Se Workspace for removido:
    - Redireciona para lista de Workspaces

---

### F.3. Card movido de lista

- Atualiza:
    - Breadcrumb
    - Metadados
- Página permanece aberta

---

## G. Breadcrumbs

Exemplo:

```
Workspace > Board > Card
```

- Breadcrumb do Board é clicável
- Facilita retorno manual

---

## H. Não-Objetivos

Esta feature **não**:

- Usa modal
- Preserva scroll do board
- Sincroniza múltiplas abas abertas do mesmo card

# Funcionalidade — Checklists do Card

As **Checklists** permitem quebrar um Card em tarefas menores e rastrear progresso de forma visual e objetiva.

Elas são **sempre associadas a um Card** e existem apenas dentro do contexto da **Página Dedicada do Card**.

---

## A. Escopo e Princípios

- Uma Checklist **não existe fora de um Card**
- Um Card pode ter:
    - Nenhuma
    - Uma
    - Múltiplas Checklists
- O estado é sincronizado em tempo real
- Progresso é sempre derivado (não persistido)

---

## B. Permissões

Checklists utilizam permissões do Card:

| Ação | Permissão |
| --- | --- |
| Ver checklist | `card.read` |
| Criar checklist | `card.update` |
| Editar / reordenar | `card.update` |
| Marcar item | `card.update` |
| Excluir checklist | `card.update` |

📌 Não existem permissões separadas no MVP.

---

## C. Estrutura de Dados

### C.1. Entidade Checklist

Campos:

- `id`
- `cardId`
- `title`
- `rank` (LexoRank)
- `createdAt`
- `updatedAt`
- `deletedAt`

---

### C.2. Entidade ChecklistItem

Campos:

- `id`
- `checklistId`
- `content`
- `isCompleted`
- `rank` (LexoRank)
- `createdAt`
- `updatedAt`
- `deletedAt`

📌 Tanto checklists quanto itens utilizam **LexoRank** para ordenação.

---

## D. Ordenação (LexoRank)

### D.1. Regra

- Checklists:
    
    ```
    ORDER BY rank ASC
    
    ```
    
- Itens:
    
    ```
    ORDER BY rank ASC
    
    ```
    

📌 Não há `position int`.

---

### D.2. Drag & Drop

- Usuário pode:
    - Reordenar itens dentro da checklist
    - Reordenar checklists entre si
- Cada movimento:
    - Recalcula apenas o `rank` afetado

---

## E. Criação de Checklist

### E.1. Fluxo

1. Usuário clica em **“Adicionar checklist”**
2. Input de título aparece
3. Usuário confirma
4. Backend:
    - Cria checklist
    - Gera rank ao final
5. Evento realtime é emitido

---

## F. Itens da Checklist

### F.1. Criação

- Input inline no final da checklist
- Enter cria item
- Rank é gerado automaticamente

---

### F.2. Conclusão

- Checkbox marca `isCompleted = true`
- Atualização é instantânea
- Evento realtime disparado

📌 Não há confirmação extra.

---

## G. Progresso

### G.1. Cálculo

Progresso é sempre **derivado no cliente**:

```
(itens concluídos / total de itens) * 100

```

---

### G.2. UI

- Exibir:
    - Texto: `3/7`
    - `CircularProgressIndicator`

📌 Valor não é salvo no banco.

---

## H. Realtime

### H.1. Eventos

| Evento | Disparo |
| --- | --- |
| `checklist.created` | Nova checklist |
| `checklist.updated` | Rename |
| `checklist.deleted` | Soft delete |
| `checklist.item.created` | Novo item |
| `checklist.item.updated` | Check/uncheck |
| `checklist.item.moved` | Rank alterado |

---

### H.2. Comportamento

- Página do Card recebe eventos
- Atualiza apenas checklist afetada
- Re-render mínimo

---

## I. Edge Cases Importantes

### I.1. Checklist vazia

- Exibe progresso `0/0`
- Barra fica vazia
- Nenhum erro

---

### I.2. Item deletado enquanto marcado

- Estado é removido
- Progresso recalculado

---

### I.3. Permissão revogada

- Se perder `card.update`:
    - Checkboxes ficam desabilitados
    - Drag & drop bloqueado

---

### I.4. Concorrência

- Dois usuários marcando item ao mesmo tempo:
    - Última escrita vence
    - Estado final sincronizado

---

## J. Arquivamento e Exclusão

- Excluir checklist:
    - Soft delete (`deletedAt`)
- Itens seguem a checklist

---

## K. Não-Objetivos

Checklists **não**:

- Têm responsáveis
- Têm datas
- São reutilizáveis
- Existem fora do Card

# Feature — Comentários e Atividades (Card)

Esta funcionalidade fornece **comunicação contextual** e **auditoria completa** das ações realizadas em um Card.

Ela é parte essencial da **Página Dedicada do Card** e funciona de forma **totalmente integrada ao Realtime**.

---

## 1. Objetivos

- Permitir comunicação direta entre membros do Card
- Registrar automaticamente todas as ações relevantes
- Garantir rastreabilidade (quem fez, o que fez, quando)
- Manter regras claras de permissão
- Evitar ruído e eventos irrelevantes

---

## 2. Escopo

### Incluído

- Comentários
- Histórico de atividades (audit log)
- Realtime
- Permissões
- Soft delete
- Paginação

### Fora do escopo (MVP)

- Menções (@user)
- Reações
- Notificações
- Rich text
- Edição de atividades

---

## 3. Permissões

### 3.1 Permissões envolvidas

- `card.read`
- `card.update`

---

### 3.2 Matriz de permissões — Comentários

| Ação | Autor | Admin do Workspace | Outros |
| --- | --- | --- | --- |
| Ver comentários | ✅ | ✅ | `card.read` |
| Criar comentário | ✅ | ✅ | `card.update` |
| Editar comentário | ✅ | ❌ | ❌ |
| Excluir comentário | ✅ | ✅ | ❌ |

📌 Observações:

- Apenas o **autor** pode editar
- **Admin nunca edita**, apenas exclui
- Dono do workspace segue regra de admin

---

### 3.3 Atividades

- Qualquer usuário com `card.read` pode visualizar
- Nenhuma permissão de escrita exposta

---

## 4. Comentários

### 4.1 Modelo de Dados

**Comment**

- `id`
- `cardId`
- `authorId`
- `content`
- `createdAt`
- `updatedAt`
- `deletedAt`

📌 Soft delete obrigatório.

---

### 4.2 Criação

Fluxo:

1. Usuário envia comentário
2. Backend valida `card.update`
3. Comentário é persistido
4. Atividade `comment.created` é registrada
5. Evento realtime emitido

---

### 4.3 Edição

- Inline
- Apenas autor
- Atualiza `updatedAt`
- **Não gera atividade**

📌 Justificativa: evita poluição do histórico.

---

### 4.4 Exclusão

- Soft delete
- Pode ser feita por:
    - Autor
    - Admin
- Gera atividade `comment.deleted`

---

## 5. Atividades (Audit Log)

### 5.1 Conceito

Atividades são:

- Automáticas
- Imutáveis
- Criadas apenas pelo sistema

---

### 5.2 Modelo de Dados

**Activity**

- `id`
- `cardId`
- `actorId` (usuário ou sistema)
- `type` (enum)
- `payload` (JSON)
- `createdAt`

---

### 5.3 Tipos de Atividade (Obrigatórios)

### Card

- `card.created`
- `card.title.changed`
- `card.description.changed`
- `card.moved`
- `card.priority.changed`
- `card.property.changed`

---

### Checklists

- `checklist.created`
- `checklist.updated`
- `checklist.deleted`
- `checklist.item.created`
- `checklist.item.completed`
- `checklist.item.uncompleted`
- `checklist.item.updated`
- `checklist.item.deleted`

---

### Comentários

- `comment.created`
- `comment.deleted`

---

### 5.4 Payloads

Os payloads **devem conter sempre estado anterior e novo**, quando aplicável.

Exemplo:

```json
{
  "field": "title",
  "from": "Old title",
  "to": "New title"
}

```

Checklist item:

```json
{
  "checklistId": "uuid",
  "itemId": "uuid",
  "completed": true
}

```

---

## 6. Realtime

### 6.1 Eventos Emitidos

| Evento | Uso |
| --- | --- |
| `comment.created` | Atualizar comentários |
| `comment.deleted` | Remover comentário |
| `activity.created` | Atualizar histórico |

---

### 6.2 Comportamento no Cliente

- Apenas o Card aberto reage
- Atualização incremental
- Re-render seletivo

📌 Nenhum refresh global.

---

## 7. UI / UX

### 7.1 Página do Card

- Aba **Comentários**
- Aba **Histórico**

---

### 7.2 Comentários

- Ordem cronológica
- Avatar + nome
- Data relativa
- Ações inline (editar/excluir conforme permissão)

---

### 7.3 Atividades

- Texto montado no frontend
- Baseado em `type + payload`

Exemplo:

```
Maria completou um item da checklist

```

---

## 8. Paginação e Performance

- Comentários:
    - Paginação por cursor ou offset
- Atividades:
    - Sempre paginadas

---

## 9. Edge Cases

### 9.1 Permissão removida

- Input desabilitado
- Conteúdo visível

---

### 9.2 Usuário removido do workspace

- Comentários permanecem
- Nome exibido como “Usuário removido”

---

### 9.3 Conflitos

- Última escrita vence
- Sem lock

---

## 10. Regras Importantes

- Atividades nunca são editadas
- Atividades nunca são deletadas
- Comentários deletados não aparecem
- Histórico é fonte de verdade

# Feature — Anexos (Card Attachments)

Os **Anexos** permitem associar arquivos a um Card, servindo como material de apoio, evidência ou referência.

Eles são parte do contexto do Card e **participam do histórico de atividades e do realtime**.

---

## 1. Objetivos

- Permitir upload e visualização de arquivos
- Garantir controle de acesso por Card
- Registrar atividades automaticamente
- Integrar com realtime
- Ser escalável para múltiplos storages

---

## 2. Escopo

### Incluído

- Upload de arquivos
- Download seguro
- Listagem de anexos
- Remoção (soft delete)
- Atividades
- Realtime

### Fora do escopo (MVP)

- Versionamento
- Preview avançado (PDF, vídeo)
- Compartilhamento público
- Drag & drop entre Cards

---

## 3. Permissões

### 3.1 Permissões envolvidas

- `card.read`
- `card.update`

---

### 3.2 Matriz de permissões

| Ação | Quem pode |
| --- | --- |
| Ver anexos | `card.read` |
| Adicionar anexo | `card.update` |
| Remover anexo | Autor ou Admin |

📌 Regras:

- Autor pode remover seus próprios anexos
- Admin do workspace pode remover qualquer anexo
- Ninguém pode editar um anexo

---

## 4. Modelo de Dados

### 4.1 Attachment

Campos:

- `id`
- `cardId`
- `workspaceId`
- `uploaderId`
- `fileName`
- `mimeType`
- `size`
- `storageKey`
- `createdAt`

📌 O arquivo físico **é apagado**

---

## 5. Upload

### 5.1 Fluxo

1. Usuário seleciona arquivo
2. Frontend solicita URL de upload
3. Backend valida:
    - Autenticação
    - `card.update`
4. Backend gera URL pré-assinada
5. Frontend envia o arquivo direto ao storage
6. Frontend confirma upload
7. Backend cria registro do anexo
8. Atividade registrada
9. Evento realtime emitido

---

### 5.2 Limites

- Tamanho máximo por arquivo: configurável (ex: 20MB)
- Tipos permitidos:
    - Imagens
    - PDF
    - Docs
    - ZIP (opcional)

📌 Validação dupla: frontend + backend.

---

## 6. Download

### 6.1 Acesso

- Download sempre via backend
- Backend valida `card.read`
- URL temporária (signed)

---

### 6.2 Segurança

- URLs nunca públicas
- Expiração curta (ex: 1–5 minutos)
- Storage isolado por workspace

---

## 7. Remoção

### 7.1 Regras

- Delete real
- Remove da UI imediatamente
- Arquivo permanece no storage

---

### 7.2 Atividade

Gera:

```
attachment.deleted

```

Payload:

```json
{
  "fileName": "contrato.pdf"
}

```

---

## 8. Atividades (Audit Log)

### Eventos registrados

- `attachment.added`
- `attachment.deleted`

📌 Download **não gera atividade**.

---

## 9. Realtime

### Eventos

| Evento | Uso |
| --- | --- |
| `attachment.added` | Atualizar lista |
| `attachment.deleted` | Remover da UI |
| `activity.created` | Histórico |

---

### Comportamento

- Página do Card atualiza em tempo real
- Não recarrega o Card inteiro

---

## 10. UI / UX

### 10.1 Página do Card

Seção **Anexos** contendo:

- Ícone por tipo
- Nome
- Tamanho
- Autor
- Data

---

### 10.2 Ações

- Clique → download
- Menu:
    - Remover (se permitido)

---

## 11. Edge Cases

### 11.1 Upload incompleto

- Registro só é criado após confirmação
- Upload abandonado é ignorado

---

### 11.2 Permissão revogada durante upload

- Confirmação falha
- Anexo não é criado

---

### 11.3 Usuário removido

- Anexo permanece
- Autor exibido como “Usuário removido”

---

## 12. Performance

- Lista paginada (opcional)
- Metadados primeiro
- Arquivos sempre sob demanda

---

## 13. Regras Importantes

- Anexos não são editáveis
- Sem versionamento no MVP
- Exclusão nao é reversível no banco
- Storage pode ser S3, MinIO

---

# Modelagem Completa do Banco — Kan Clone (Serverpod 3.x)

## 🧑 Usuários (Auth)

### Fonte da verdade

Você **não cria um model User do zero**.

O usuário vem do:

```
serverpod_auth.user_info
```

Tabela gerada pelo próprio Serverpod.

### Como você usa no seu domínio

Você **referencia usuários por `userId (UuidValue)`** em TODAS as tabelas de negócio.

✔️ Correto

✔️ Alinhado com Serverpod

✔️ Evita duplicação de dados

---

### (Opcional, mas recomendado) — Perfil do Usuário

Para dados que **não pertencem ao auth**:

```yaml
class: UserProfile
table: user_profile
fields:
  id: UuidValue, defaultModel=random
  userId: UuidValue
  displayName: String
  avatarUrl: String?
  createdAt: DateTime, default=now
  updatedAt: DateTime?

```

📌 Nunca duplicar email ou senha aqui.

---

## 🏢 Workspaces

```yaml
class: Workspace
table: workspace
fields:
  id: UuidValue, defaultModel=random
  name: String
  slug: String
  ownerId: UuidValue
  createdAt: DateTime, default=now
  deletedAt: DateTime?

```

### Regras implícitas

- `slug` **global**
- `ownerId`:
    - tem **todas as permissões**
    - não pode ser removido
    - permissões não podem ser revogadas

---

## 👥 Workspace Members

```yaml
class: WorkspaceMember
table: workspace_member
fields:
  id: UuidValue, defaultModel=random
  workspaceId: UuidValue
  userId: UuidValue
  role: String
  joinedAt: DateTime, default=now

```

📌 `role` é apenas **semântico** (`owner`, `admin`, `member`)

📌 **Não decide permissão sozinho** — RBAC faz isso

---

## 🔐 Permissões (RBAC explícito)

### Permissões possíveis

```yaml
class: Permission
table: permission
fields:
  id: UuidValue, defaultModel=random
  slug: String
  description: String

```

Exemplos:

```
workspace.read
board.create
card.update
comment.delete

```

---

### Permissões por membro

```yaml
class: MemberPermission
table: member_permission
fields:
  id: UuidValue, defaultModel=random
  workspaceMemberId: UuidValue
  permissionId: UuidValue

```

📌 Enforcement **sempre no backend**

---

## ✉️ Convites

```yaml
class: WorkspaceInvite
table: workspace_invite
fields:
  id: UuidValue, defaultModel=random
  workspaceId: UuidValue
  email: String?
  code: String
  createdBy: UuidValue
  acceptedAt: DateTime?
  revokedAt: DateTime?
  createdAt: DateTime, default=now

```

### Regras cobertas

- Pode aceitar **quem estiver logado**
- Aceito uma única vez
- Não expira
- Pode ser revogado manualmente

---

## 🗂 Boards

```yaml
class: Board
table: board
fields:
  id: UuidValue, defaultModel=random
  workspaceId: UuidValue
  title: String
  slug: String
  background: String?
  visibility: String
  createdAt: DateTime, default=now
  deletedAt: DateTime?

```

---

## 📋 Lists (Colunas)

```yaml
class: BoardList
table: board_list
fields:
  id: UuidValue, defaultModel=random
  boardId: UuidValue
  title: String
  rank: String
  archivedAt: DateTime?
  createdAt: DateTime, default=now

```

📌 `rank` = **LexoRank**

---

## 🃏 Cards

```yaml
class: Card
table: card
fields:
  id: UuidValue, defaultModel=random
  boardId: UuidValue
  listId: UuidValue
  title: String
  description: String?
  priority: CardPriority
  rank: String
  dueDate: DateTime?
  createdBy: UuidValue
  createdAt: DateTime, default=now
  deletedAt: DateTime?

```

### Ordenação efetiva

```sql
ORDER BY priority DESC, rank ASC

```

---

## 🏷 Labels

```yaml
class: Label
table: label
fields:
  id: UuidValue, defaultModel=random
  workspaceId: UuidValue
  name: String
  color: String
  createdAt: DateTime, default=now
  deletedAt: DateTime?

```

```yaml
class: CardLabel
table: card_label
fields:
  id: UuidValue, defaultModel=random
  cardId: UuidValue
  labelId: UuidValue

```

---

## 👤 Card Assignments (Responsáveis)

```yaml
class: CardAssignment
table: card_assignment
fields:
  id: UuidValue, defaultModel=random
  cardId: UuidValue
  userId: UuidValue

```

📌 **Não controla permissão**, apenas atribuição.

---

## ☑️ Checklists

```yaml
class: Checklist
table: checklist
fields:
  id: UuidValue, defaultModel=random
  cardId: UuidValue
  title: String
  rank: String
  createdAt: DateTime, default=now
  deletedAt: DateTime?

```

```yaml
class: ChecklistItem
table: checklist_item
fields:
  id: UuidValue, defaultModel=random
  checklistId: UuidValue
  content: String
  isCompleted: bool, default=false
  rank: String
  createdAt: DateTime, default=now
  deletedAt: DateTime?

```

---

## 💬 Comentários

```yaml
class: Comment
table: comment
fields:
  id: UuidValue, defaultModel=random
  cardId: UuidValue
  authorId: UuidValue
  content: String
  createdAt: DateTime, default=now
  updatedAt: DateTime?
  deletedAt: DateTime?

```

### Regras

- Autor: editar + excluir
- Admin: excluir
- Editar **não gera atividade**

---

## 📎 Anexos

```yaml
class: Attachment
table: attachment
fields:
  id: UuidValue, defaultModel=random
  cardId: UuidValue
  workspaceId: UuidValue
  uploaderId: UuidValue
  fileName: String
  mimeType: String
  size: int
  storageKey: String
  createdAt: DateTime, default=now
  deletedAt: DateTime?

```

---

## 📜 Activities (Audit Log)

```yaml
class: Activity
table: activity
fields:
  id: UuidValue, defaultModel=random
  cardId: UuidValue
  actorId: UuidValue
  type: String
  payload: Map<String, dynamic>
  createdAt: DateTime, default=now

```

📌 Registro de:

- Movimento
- Prioridade
- Checklist
- Descrição
- Título
- Anexos
- Atribuições

---

## 🔔 Realtime (Base)

```yaml
class: RealtimeEvent
table: realtime_event
fields:
  id: UuidValue, defaultModel=random
  workspaceId: UuidValue
  entityType: String
  entityId: UuidValue
  payload: Map<String, dynamic>
  createdAt: DateTime, default=now

```

📌 Cliente **re-renderiza sempre o estado mais recente**