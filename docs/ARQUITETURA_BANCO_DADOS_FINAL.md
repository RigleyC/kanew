# Arquitetura Final do Banco de Dados - Kan Clone

## 📋 Resumo

Após as modificações baseadas no plano (`plan.md`) e boas práticas do Serverpod, a arquitetura do banco de dados foi atualizada e está alinhada com as especificações.

**Migration criada:** `20260108204453607`

---

## 🗄️ Estrutura Completa das Tabelas

### 1. Workspace

**Tabela:** `workspace`

```yaml
class: Workspace
fields:
  uuid: UuidValue              # Identificador único UUID
  title: String                # Nome do workspace
  slug: String                 # URL amigável (global, único)
  ownerId: int                 # ID do usuário dono
  createdAt: DateTime          # Data de criação
  deletedAt: DateTime?         # Soft delete
  deletedBy: int?              # Quem deletou
```

**Índices:**
- `workspace_uuid_idx` (único)
- `workspace_slug_idx` (único, global)

**Observações:**
- ✅ Slug é global e único
- ✅ Owner tem todas as permissões automaticamente
- ✅ Soft delete implementado

---

### 2. WorkspaceMember

**Tabela:** `workspace_member`

```yaml
class: WorkspaceMember
fields:
  userInfoId: int              # ID do usuário (referência ao Serverpod Auth)
  workspaceId: int             # ID do workspace
  role: MemberRole             # owner, admin, member (NOVO)
  status: MemberStatus         # active, invited, suspended
  joinedAt: DateTime           # Quando entrou
  deletedAt: DateTime?         # Soft delete
  deletedBy: int?              # Quem removeu
```

**Índices:**
- `workspace_member_unique_idx` (userInfoId, workspaceId) - único

**Observações:**
- ✅ **NOVO:** Campo `role` adicionado para hierarquia (owner/admin/member)
- ✅ `status` define estado do membro (active/invited/suspended)
- ✅ Relação única por usuário/workspace

---

### 3. WorkspaceInvite

**Tabela:** `workspace_invite`

```yaml
class: WorkspaceInvite
fields:
  email: String?               # Opcional (não vinculado ao e-mail)
  code: String                 # Código único do convite
  workspaceId: int             # ID do workspace
  createdBy: int               # Quem criou (NOVO)
  initialPermissions: List<int> # Permissões iniciais (JSON)
  acceptedAt: DateTime?        # Quando foi aceito (NOVO)
  revokedAt: DateTime?         # Quando foi revogado (NOVO, substitui deletedAt)
  createdAt: DateTime          # Data de criação
```

**Índices:**
- `workspace_invite_code_idx` (code) - único

**Modificações:**
- ❌ **REMOVIDO:** `expiresAt` (convites não expiram conforme plano)
- ❌ **REMOVIDO:** `deletedAt` (substituído por `revokedAt`)
- ✅ **ADICIONADO:** `acceptedAt` (rastreamento de aceitação)
- ✅ **ADICIONADO:** `revokedAt` (rastreamento de revogação)
- ✅ **ADICIONADO:** `createdBy` (quem criou o convite)
- ✅ `email` agora é opcional (não vinculado ao e-mail)

---

### 4. Board

**Tabela:** `board`

```yaml
class: Board
fields:
  uuid: UuidValue              # Identificador único UUID
  workspaceId: int              # ID do workspace
  title: String                # Título do board
  slug: String                 # URL amigável (único dentro do workspace)
  visibility: BoardVisibility  # Visibilidade do board
  backgroundUrl: String?       # URL da imagem de fundo
  isTemplate: bool             # Se é template
  createdAt: DateTime          # Data de criação
  createdBy: int               # Quem criou
  deletedAt: DateTime?           # Soft delete
  deletedBy: int?              # Quem deletou
```

**Índices:**
- `board_uuid_idx` (único)
- `board_slug_idx` (workspaceId, slug) - único dentro do workspace

**Observações:**
- ✅ Slug é único dentro do workspace (não global)
- ✅ Soft delete implementado

---

### 5. CardList

**Tabela:** `card_list`

```yaml
class: CardList
fields:
  uuid: UuidValue              # Identificador único UUID
  boardId: int                  # ID do board
  title: String                 # Título da lista
  rank: String                  # LexoRank para ordenação
  archived: bool                 # Se está arquivada
  createdAt: DateTime           # Data de criação
  deletedAt: DateTime?           # Soft delete
  deletedBy: int?                # Quem deletou
```

**Índices:**
- `card_list_uuid_idx` (único)

**Observações:**
- ✅ Usa LexoRank para ordenação horizontal

---

### 6. Card

**Tabela:** `card`

```yaml
class: Card
fields:
  uuid: UuidValue               # Identificador único UUID
  listId: int                    # ID da lista
  boardId: int                  # ID do board (NOVO - redundante mas útil)
  title: String                 # Título do card
  descriptionDocument: String?  # JSON do AppFlowy Editor
  priority: CardPriority         # Prioridade (urgent, high, medium, low, none)
  rank: String                  # LexoRank para ordenação
  dueDate: DateTime?            # Data de vencimento
  isCompleted: bool             # Se está completo
  createdAt: DateTime           # Data de criação
  createdBy: int                # Quem criou
  updatedAt: DateTime?          # Data de atualização (NOVO)
  deletedAt: DateTime?          # Soft delete
  deletedBy: int?               # Quem deletou
```

**Índices:**
- `card_uuid_idx` (único)

**Modificações:**
- ✅ **ADICIONADO:** `boardId` (redundante mas útil para queries diretas)
- ✅ **ADICIONADO:** `updatedAt` (conforme plano)

**Observações:**
- ✅ Ordenação: `ORDER BY priority DESC, rank ASC`
- ✅ `descriptionDocument` armazena JSON do AppFlowy Editor

---

### 7. Attachment

**Tabela:** `attachment`

```yaml
class: Attachment
fields:
  cardId: int                   # ID do card
  workspaceId: int              # ID do workspace (NOVO)
  fileName: String              # Nome do arquivo
  mimeType: String              # Tipo MIME (RENOMEADO de fileType)
  size: int                     # Tamanho em bytes (RENOMEADO de sizeBytes)
  storageKey: String            # Chave no storage S3/MinIO (NOVO)
  fileUrl: String?               # URL pública (opcional, NOVO)
  uploaderId: int               # Quem fez upload (RENOMEADO de uploadedBy)
  createdAt: DateTime           # Data de criação
  deletedAt: DateTime?           # Soft delete
```

**Modificações:**
- ✅ **ADICIONADO:** `workspaceId` (necessário para controle de acesso)
- ✅ **ADICIONADO:** `storageKey` (chave no storage conforme plano)
- ✅ **ADICIONADO:** `fileUrl` (opcional, pode ser gerada a partir de storageKey)
- ✅ **RENOMEADO:** `fileType` → `mimeType`
- ✅ **RENOMEADO:** `sizeBytes` → `size`
- ✅ **RENOMEADO:** `uploadedBy` → `uploaderId`

**Observações:**
- ✅ `storageKey` é a fonte da verdade (chave no S3/MinIO)
- ✅ `fileUrl` é opcional e pode ser gerada sob demanda

---

### 8. CardActivity

**Tabela:** `card_activity`

```yaml
class: CardActivity
fields:
  cardId: int                   # ID do card
  actorId: int                  # ID do usuário que executou (RENOMEADO de userId)
  type: ActivityType            # Tipo de atividade
  details: String?               # JSON com detalhes
  createdAt: DateTime           # Data de criação
```

**Modificações:**
- ✅ **RENOMEADO:** `userId` → `actorId` (conforme plano)

**Observações:**
- ✅ `details` é String (JSON) porque Serverpod não suporta `Map<String, dynamic>` diretamente
- ✅ Registra todas as atividades do card para auditoria

---

### 9. Comment

**Tabela:** `comment`

```yaml
class: Comment
fields:
  cardId: int                   # ID do card
  authorId: int                 # ID do autor (RENOMEADO de userId)
  content: String                # Conteúdo do comentário (RENOMEADO de text)
  createdAt: DateTime            # Data de criação
  updatedAt: DateTime?           # Data de atualização
  deletedAt: DateTime?           # Soft delete
```

**Modificações:**
- ✅ **RENOMEADO:** `userId` → `authorId` (conforme plano)
- ✅ **RENOMEADO:** `text` → `content` (conforme plano)

**Observações:**
- ✅ Edição não gera atividade (conforme plano)
- ✅ Soft delete implementado

---

### 10. Checklist

**Tabela:** `checklist`

```yaml
class: Checklist
fields:
  cardId: int                   # ID do card
  title: String                  # Título da checklist
  rank: String                  # LexoRank para ordenação (NOVO)
  createdAt: DateTime            # Data de criação (NOVO)
  updatedAt: DateTime?           # Data de atualização (NOVO)
  deletedAt: DateTime?           # Soft delete
```

**Modificações:**
- ✅ **ADICIONADO:** `rank` (LexoRank para ordenação)
- ✅ **ADICIONADO:** `createdAt`
- ✅ **ADICIONADO:** `updatedAt`

**Observações:**
- ✅ Usa LexoRank para ordenação entre checklists

---

### 11. ChecklistItem

**Tabela:** `checklist_item`

```yaml
class: ChecklistItem
fields:
  checklistId: int              # ID da checklist
  title: String                 # Conteúdo do item
  isChecked: bool               # Se está marcado
  rank: String                  # LexoRank para ordenação
  deletedAt: DateTime?           # Soft delete
```

**Observações:**
- ✅ Usa LexoRank para ordenação entre itens

---

### 12. Permission

**Tabela:** `permission`

```yaml
class: Permission
fields:
  slug: String                  # Slug único (ex: workspace.read)
  description: String?          # Descrição da permissão
```

**Índices:**
- `permission_slug_idx` (slug) - único

**Observações:**
- ✅ Permissões são seedadas no banco
- ✅ Exemplos: `workspace.read`, `board.create`, `card.update`, etc.

---

### 13. MemberPermission

**Tabela:** `member_permission`

```yaml
class: MemberPermission
fields:
  workspaceMemberId: int        # ID do membro
  permissionId: int             # ID da permissão
  scopeBoardId: int?            # Escopo opcional (board específico)
```

**Índices:**
- `mem_perm_unique_idx` (workspaceMemberId, permissionId, scopeBoardId) - único

**Observações:**
- ✅ Permissões podem ser globais (workspace) ou específicas (board)
- ✅ Owner tem todas as permissões automaticamente

---

### 14. UserPreference

**Tabela:** `user_preference`

```yaml
class: UserPreference
fields:
  userInfoId: int               # ID do usuário
  lastWorkspaceId: int?         # Último workspace acessado
  theme: String?                # Tema preferido
  createdAt: DateTime           # Data de criação
  updatedAt: DateTime           # Data de atualização
```

**Índices:**
- `user_info_id_unique_idx` (userInfoId) - único

**Observações:**
- ✅ Uma preferência por usuário
- ✅ Usado para redirecionamento pós-login

---

## 🔄 Enums Criados

### MemberRole

```yaml
enum: MemberRole
values:
  - owner
  - admin
  - member
```

**Uso:** Define hierarquia do membro no workspace.

---

### MemberStatus

```yaml
enum: MemberStatus
values:
  - active
  - invited
  - suspended
```

**Uso:** Define estado do membro (já existia, mantido).

---

## 📊 Relacionamentos Principais

```
Workspace (1) ──< (N) WorkspaceMember ──< (N) MemberPermission ──> (1) Permission
    │
    ├──< (N) Board
    │      │
    │      ├──< (N) CardList
    │      │      │
    │      │      └──< (N) Card
    │      │             │
    │      │             ├──< (N) Attachment
    │      │             ├──< (N) Comment
    │      │             ├──< (N) Checklist
    │      │             │      └──< (N) ChecklistItem
    │      │             ├──< (N) CardActivity
    │      │             └──< (N) CardLabel ──> (1) LabelDef
    │      │
    │      └──< (N) LabelDef
    │
    └──< (N) WorkspaceInvite
```

---

## ✅ Conformidade com o Plano

### Campos Adicionados/Modificados

1. ✅ **WorkspaceMember.role** - Adicionado (owner/admin/member)
2. ✅ **WorkspaceInvite** - Removido `expiresAt`, adicionado `acceptedAt`, `revokedAt`, `createdBy`
3. ✅ **Attachment** - Adicionado `workspaceId`, `storageKey`; renomeado campos
4. ✅ **Card** - Adicionado `boardId`, `updatedAt`
5. ✅ **CardActivity** - Renomeado `userId` → `actorId`
6. ✅ **Comment** - Renomeado `userId` → `authorId`, `text` → `content`
7. ✅ **Checklist** - Adicionado `rank`, `createdAt`, `updatedAt`

### Decisões Arquiteturais

1. **IDs como `int` vs `UuidValue`**: Mantido `int` para IDs de relacionamento (decisão arquitetural válida). UUIDs são usados apenas para identificadores únicos expostos (`uuid`).

2. **`boardId` redundante no Card**: Adicionado para facilitar queries diretas, mesmo sendo redundante (já existe via `listId`).

3. **`storageKey` vs `fileUrl`**: `storageKey` é a fonte da verdade. `fileUrl` é opcional e pode ser gerada sob demanda.

4. **`details` como String (JSON)**: Serverpod não suporta `Map<String, dynamic>` diretamente em modelos, então usamos String com JSON.

---

## 🚀 Próximos Passos

1. ✅ Migration criada: `20260108204453607`
2. ⚠️ **ATENÇÃO:** Esta migration recria algumas tabelas completamente (dados serão perdidos em desenvolvimento)
3. 🔄 Atualizar código que referencia campos renomeados:
   - `attachment.fileType` → `attachment.mimeType`
   - `attachment.sizeBytes` → `attachment.size`
   - `attachment.uploadedBy` → `attachment.uploaderId`
   - `comment.userId` → `comment.authorId`
   - `comment.text` → `comment.content`
   - `card_activity.userId` → `card_activity.actorId`
4. 🔄 Atualizar `WorkspaceService` para criar `UserPreference` após criar workspace
5. 🔄 Atualizar código que cria `WorkspaceMember` para incluir `role`

---

## 📝 Notas Finais

- ✅ Arquitetura alinhada com `plan.md`
- ✅ Boas práticas do Serverpod seguidas
- ✅ Soft delete implementado em todas as entidades principais
- ✅ Índices únicos configurados corretamente
- ✅ Relacionamentos foreign key corretos
- ✅ Enums criados para type safety

**Status:** ✅ Pronto para desenvolvimento
