# Lista de Modificações no Banco de Dados

## 📋 Resumo das Mudanças Necessárias

Baseado na análise do plano (`plan.md`) e boas práticas do Serverpod, seguem as modificações necessárias:

---

## 1. ✅ Workspace - Manter como está

**Status:** OK
- `title` está correto (mais semântico que `name`)
- `uuid` para identificação única ✅
- `slug` global único ✅
- `ownerId` como `int` (decisão arquitetural válida) ✅
- Soft delete implementado ✅

**Ação:** Nenhuma modificação necessária.

---

## 2. 🔧 WorkspaceMember - Adicionar campo `role`

**Problema:** O plano especifica `role: String` (owner/admin/member), mas a implementação só tem `status: MemberStatus` (active/invited/suspended).

**Solução:** Adicionar campo `role` mantendo `status`.

**Modificações:**
- Adicionar campo `role: String` (owner, admin, member)
- Manter `status: MemberStatus` (active, invited, suspended)
- `role` define hierarquia, `status` define estado

**Ação:** Criar enum `MemberRole` e adicionar campo ao modelo.

---

## 3. 🔧 WorkspaceInvite - Ajustar campos conforme plano

**Problemas:**
1. Tem `expiresAt`, mas plano diz que não expira
2. Falta `acceptedAt`, `revokedAt`, `createdBy`
3. `email` deveria ser opcional (plano diz que não é vinculado ao e-mail)

**Modificações:**
- Remover `expiresAt` (convites não expiram)
- Adicionar `acceptedAt: DateTime?`
- Adicionar `revokedAt: DateTime?` (em vez de `deletedAt`)
- Adicionar `createdBy: int`
- Tornar `email: String?` opcional

**Ação:** Atualizar modelo removendo `expiresAt` e adicionando campos faltantes.

---

## 4. 🔧 Attachment - Adicionar `workspaceId` e `storageKey`

**Problemas:**
1. Falta `workspaceId` (necessário para controle de acesso)
2. Tem `fileUrl`, mas plano especifica `storageKey` (chave no storage)

**Modificações:**
- Adicionar `workspaceId: int, relation(parent=workspace)`
- Adicionar `storageKey: String` (chave no S3/MinIO)
- Manter `fileUrl: String?` como opcional (URL pública se necessário)
- Renomear `uploadedBy` para `uploaderId` (conforme plano)
- Renomear `fileType` para `mimeType` (conforme plano)
- Renomear `sizeBytes` para `size` (conforme plano)

**Ação:** Atualizar modelo com novos campos e renomeações.

---

## 5. 🔧 Card - Adicionar `boardId` e `updatedAt`

**Problemas:**
1. Falta `boardId` direto (pode ser necessário para queries)
2. Falta `updatedAt` (especificado no plano)

**Modificações:**
- Adicionar `boardId: int, relation(parent=board)` (redundante mas útil para queries)
- Adicionar `updatedAt: DateTime?`
- Manter `descriptionDocument` (correto para AppFlowy)

**Ação:** Adicionar campos ao modelo.

---

## 6. ✅ CardActivity - Manter como está

**Status:** OK
- `details: String?` (JSON) é válido no Serverpod
- `userId` está correto (pode ser renomeado para `actorId` se preferir, mas não é crítico)

**Ação:** Nenhuma modificação necessária (opcional: renomear `userId` para `actorId`).

---

## 7. ✅ UserPreference - Manter como está

**Status:** OK
- Todos os campos necessários estão presentes

**Ação:** Nenhuma modificação necessária.

---

## 8. 🔧 Checklist - Adicionar `rank` e `updatedAt`

**Verificar:** O plano especifica `rank: String` (LexoRank) para checklists.

**Ação:** Verificar se já existe e adicionar se necessário.

---

## 9. 🔧 Comment - Ajustar nomenclatura

**Verificar:** O plano usa `content`, implementação pode usar `text`.

**Ação:** Verificar e padronizar.

---

## 📊 Resumo das Ações

### Modelos a Modificar:
1. ✅ `workspace_member.spy.yaml` - Adicionar `role`
2. ✅ `workspace_invite.spy.yaml` - Remover `expiresAt`, adicionar `acceptedAt`, `revokedAt`, `createdBy`, tornar `email` opcional
3. ✅ `attachment.spy.yaml` - Adicionar `workspaceId`, `storageKey`, renomear campos
4. ✅ `card.spy.yaml` - Adicionar `boardId`, `updatedAt`
5. ⚠️ `checklist.spy.yaml` - Verificar `rank`
6. ⚠️ `comment.spy.yaml` - Verificar nomenclatura

### Enums a Criar:
1. ✅ `member_role.spy.yaml` - Enum para role (owner, admin, member)

---

## 🎯 Prioridades

**Alta:**
- WorkspaceMember.role
- WorkspaceInvite (remover expiresAt, adicionar campos)
- Attachment.workspaceId

**Média:**
- Card.boardId e updatedAt
- Attachment.storageKey

**Baixa:**
- Renomeações de campos (cosméticas)
