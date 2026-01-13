# Análise: Plano vs Implementação Atual

## 📋 Resumo Executivo

Este documento compara o plano detalhado em `plan.md` com a implementação atual do projeto Kan Clone, identificando divergências, inconsistências e pontos de atenção.

---

## 1. 🗄️ Análise do Banco de Dados

### 1.1. Workspace

**Plano (plan.md:2800-2813):**
```yaml
class: Workspace
fields:
  id: UuidValue
  name: String
  slug: String (global, único)
  ownerId: UuidValue
  createdAt: DateTime
  deletedAt: DateTime?
```

**Implementação Atual:**
```yaml
class: Workspace
fields:
  uuid: UuidValue
  title: String  # ❌ DIFERENTE: plano diz "name"
  slug: String (global, único) ✅
  ownerId: int  # ❌ DIFERENTE: plano diz UuidValue, mas implementação usa int
  createdAt: DateTime ✅
  deletedAt: DateTime? ✅
  deletedBy: int? ✅ (extra)
```

**⚠️ Problemas Identificados:**
1. **Campo `name` vs `title`**: O plano especifica `name`, mas a implementação usa `title`. Isso pode causar confusão.
2. **`ownerId` como `int` vs `UuidValue`**: A implementação usa `int` porque está mapeando o UUID do Serverpod Auth para um ID numérico. Isso é uma decisão arquitetural, mas não está documentada no plano.

**✅ Conformidade:** Parcialmente conforme. A diferença de `name`/`title` é cosmética, mas o `ownerId` como `int` precisa ser justificado.

---

### 1.2. WorkspaceMember

**Plano (plan.md:2826-2837):**
```yaml
class: WorkspaceMember
fields:
  id: UuidValue
  workspaceId: UuidValue
  userId: UuidValue
  role: String (owner, admin, member)
  joinedAt: DateTime
  removedAt: DateTime? (soft remove)
```

**Implementação Atual:**
```yaml
class: WorkspaceMember
fields:
  userInfoId: int  # ❌ DIFERENTE: plano diz userId: UuidValue
  workspaceId: int  # ❌ DIFERENTE: plano diz UuidValue
  joinedAt: DateTime ✅
  status: MemberStatus  # ❌ DIFERENTE: plano diz role: String
  deletedAt: DateTime?  # ❌ DIFERENTE: plano diz removedAt
  deletedBy: int? ✅ (extra)
```

**⚠️ Problemas Identificados:**
1. **Campo `role` ausente**: O plano especifica `role: String` com valores `owner`, `admin`, `member`, mas a implementação usa `status: MemberStatus`. **NOTA**: `MemberStatus` é um enum com valores `active`, `invited`, `suspended`, que é diferente de `role`. O plano pode estar esperando ambos: `role` (owner/admin/member) para definir hierarquia e `status` (active/invited/suspended) para estado do membro. A implementação atual não distingue entre owner/admin/member via campo `role`.
2. **`removedAt` vs `deletedAt`**: Nomenclatura diferente, mas funcionalidade equivalente.
3. **IDs como `int`**: Novamente, a implementação usa IDs numéricos em vez de UUIDs.

**✅ Conformidade:** Parcialmente conforme. A ausência de `role` pode ser um problema se o plano espera essa distinção.

---

### 1.3. Card

**Plano (plan.md:2951-2969):**
```yaml
class: Card
fields:
  id: UuidValue
  boardId: UuidValue
  listId: UuidValue
  title: String
  description: String?
  priority: CardPriority
  rank: String (LexoRank)
  dueDate: DateTime?
  createdBy: UuidValue
  createdAt: DateTime
  updatedAt: DateTime
  deletedAt: DateTime?
```

**Implementação Atual:**
```yaml
class: Card
fields:
  uuid: UuidValue ✅
  listId: int  # ❌ DIFERENTE: plano diz UuidValue
  title: String ✅
  descriptionDocument: String?  # ❌ DIFERENTE: plano diz description, implementação usa descriptionDocument (JSON do AppFlowy)
  priority: CardPriority ✅
  rank: String ✅ (LexoRank)
  dueDate: DateTime? ✅
  isCompleted: bool  # ✅ EXTRA: não no plano, mas útil
  createdBy: int  # ❌ DIFERENTE: plano diz UuidValue
  createdAt: DateTime ✅
  deletedAt: DateTime? ✅
  deletedBy: int? ✅ (extra)
```

**⚠️ Problemas Identificados:**
1. **`boardId` ausente**: O plano especifica `boardId`, mas a implementação não tem esse campo diretamente. O card está ligado à lista, que está ligada ao board. Isso pode ser intencional (normalização), mas precisa ser verificado.
2. **`description` vs `descriptionDocument`**: O plano usa `description: String?`, mas a implementação usa `descriptionDocument: String?` (provavelmente JSON do AppFlowy Editor). Isso está alinhado com o plano que menciona `appflowy_editor`.
3. **`updatedAt` ausente**: O plano especifica `updatedAt`, mas não está na implementação.

**✅ Conformidade:** Parcialmente conforme. A ausência de `boardId` direto pode ser intencional, mas precisa ser documentada.

---

### 1.4. Attachment

**Plano (plan.md:3078-3095):**
```yaml
class: Attachment
fields:
  id: UuidValue
  cardId: UuidValue
  workspaceId: UuidValue
  uploaderId: UuidValue
  fileName: String
  mimeType: String
  size: int
  storageKey: String
  createdAt: DateTime
  deletedAt: DateTime?
```

**Implementação Atual:**
```yaml
class: Attachment
fields:
  cardId: int  # ❌ DIFERENTE: plano diz UuidValue
  fileName: String ✅
  fileUrl: String  # ❌ DIFERENTE: plano diz storageKey
  fileType: String  # ❌ DIFERENTE: plano diz mimeType
  sizeBytes: int  # ❌ DIFERENTE: plano diz size
  uploadedBy: int  # ❌ DIFERENTE: plano diz uploaderId: UuidValue
  createdAt: DateTime ✅
  deletedAt: DateTime? ✅
```

**⚠️ Problemas Identificados:**
1. **`workspaceId` ausente**: O plano especifica `workspaceId`, mas a implementação não tem. Isso pode ser necessário para controle de acesso.
2. **`storageKey` vs `fileUrl`**: O plano usa `storageKey` (chave no storage), mas a implementação usa `fileUrl` (URL completa). Isso pode ser uma diferença arquitetural importante.
3. **Nomenclatura inconsistente**: `mimeType` vs `fileType`, `size` vs `sizeBytes`, `uploaderId` vs `uploadedBy`.

**✅ Conformidade:** Não conforme. A ausência de `workspaceId` pode ser um problema de segurança.

---

### 1.5. Activity (CardActivity)

**Plano (plan.md:3099-3112):**
```yaml
class: Activity
fields:
  id: UuidValue
  cardId: UuidValue
  actorId: UuidValue
  type: String
  payload: Map<String, dynamic>
  createdAt: DateTime
```

**Implementação Atual:**
```yaml
class: CardActivity
fields:
  cardId: int  # ❌ DIFERENTE: plano diz UuidValue
  userId: int  # ❌ DIFERENTE: plano diz actorId: UuidValue
  type: ActivityType  # ✅ Melhor: enum em vez de String
  details: String?  # ❌ DIFERENTE: plano diz payload: Map<String, dynamic>, implementação usa String (JSON)
  createdAt: DateTime ✅
```

**⚠️ Problemas Identificados:**
1. **`payload` vs `details`**: O plano usa `payload: Map<String, dynamic>`, mas a implementação usa `details: String?` (provavelmente JSON serializado). Isso é uma diferença de tipo de dados.
2. **`actorId` vs `userId`**: Nomenclatura diferente, mas funcionalidade equivalente.

**✅ Conformidade:** Parcialmente conforme. O uso de `String` para `details` em vez de `Map` pode ser uma limitação do Serverpod, mas precisa ser documentado.

---

### 1.6. WorkspaceInvite

**Plano (plan.md:2887-2902):**
```yaml
class: WorkspaceInvite
fields:
  id: UuidValue
  workspaceId: UuidValue
  email: String?
  code: String
  createdBy: UuidValue
  acceptedAt: DateTime?
  revokedAt: DateTime?
  createdAt: DateTime
```

**Implementação Atual:**
```yaml
class: WorkspaceInvite
fields:
  email: String  # ❌ DIFERENTE: plano diz email: String? (opcional)
  code: String ✅
  workspaceId: int  # ❌ DIFERENTE: plano diz UuidValue
  initialPermissions: List<int>  # ✅ EXTRA: não no plano, mas necessário
  expiresAt: DateTime  # ✅ EXTRA: não no plano, mas útil
  createdAt: DateTime ✅
  deletedAt: DateTime?  # ❌ DIFERENTE: plano diz revokedAt: DateTime?
```

**⚠️ Problemas Identificados:**
1. **`email` obrigatório vs opcional**: O plano diz `email: String?` (opcional), mas a implementação usa `email: String` (obrigatório). Segundo o plano (linha 184), o convite **não é vinculado ao e-mail**, então deveria ser opcional.
2. **`revokedAt` vs `deletedAt`**: O plano usa `revokedAt`, mas a implementação usa `deletedAt`. Ambos funcionam, mas a nomenclatura do plano é mais semântica.
3. **`expiresAt` presente**: O plano diz que convites **não expiram** (linha 181), mas a implementação tem `expiresAt`. Isso é uma divergência importante.

**✅ Conformidade:** Não conforme. A presença de `expiresAt` contradiz o plano que diz "não expira".

---

### 1.7. UserPreference

**Plano (plan.md:91-93):**
```yaml
class: UserPreference
fields:
  lastWorkspaceId
  theme
```

**Implementação Atual:**
```yaml
class: UserPreference
fields:
  userInfoId: int ✅
  lastWorkspaceId: int? ✅
  theme: String? ✅
  createdAt: DateTime ✅
  updatedAt: DateTime ✅
```

**✅ Conformidade:** Totalmente conforme.

---

## 2. 🔐 Análise do Fluxo de Autenticação

### 2.1. Cadastro Orgânico (Sign Up)

**Plano (plan.md:97-161):**

**Frontend:**
- Tela de cadastro com inputs: Nome completo, Email, Senha
- Estados: `idle`, `loading`, `error`, `success`
- Validações básicas no frontend

**Backend:**
1. Validação (verifica se email existe)
2. Criação do usuário (`UserInfo`, `UserAuth`, `emailVerified = false`)
3. Criação automática do Workspace
4. Criação de `UserPreference` com `lastWorkspaceId`
5. Confirmação de e-mail (gera código, envia e-mail)

**Implementação Atual:**

**Frontend (`auth_viewmodel.dart`):**
- ✅ Implementa fluxo de 3 etapas: `startRegistration`, `verifyRegistrationCode`, `finishRegistration`
- ✅ Estados de loading e error
- ✅ Integração com Serverpod Auth IDP

**Backend (`server.dart`):**
- ✅ `onAfterAccountCreated` chama `WorkspaceService.createDefaultWorkspace`
- ✅ Workspace criado automaticamente
- ⚠️ **PROBLEMA**: Não cria `UserPreference` automaticamente após criar workspace

**⚠️ Problemas Identificados:**
1. **`UserPreference` não criado**: O plano especifica que `UserPreference` deve ser criado com `lastWorkspaceId` após o cadastro, mas isso não está implementado.
2. **Nome completo não coletado**: O plano especifica que o frontend deve coletar "Nome completo", mas não vejo isso no fluxo de registro atual. O Serverpod Auth 3.x pode estar coletando isso de outra forma.

**✅ Conformidade:** Parcialmente conforme. Falta criar `UserPreference` após criar workspace.

---

### 2.2. Cadastro via Convite

**Plano (plan.md:164-211):**

**Regras:**
- Convite não expira
- Pode ser revogado
- Só pode ser aceito uma vez
- Não é vinculado ao e-mail
- Aceito por quem estiver autenticado no momento do clique

**Rota:** `/invite/{inviteCode}`

**Implementação Atual:**
- ❌ **NÃO IMPLEMENTADO**: Não há endpoint ou rota para aceitar convites
- ❌ **NÃO IMPLEMENTADO**: Não há lógica de validação de convite
- ❌ **NÃO IMPLEMENTADO**: Não há fluxo de aceitação

**✅ Conformidade:** Não implementado.

---

### 2.3. Login (Sign In)

**Plano (plan.md:213-254):**

**Frontend:**
- Tela de login com Email e Senha
- Estados: `idle`, `loading`, `error`, `success`

**Backend:**
- Valida credenciais
- Cria sessão
- Sessão é infinita até logout manual

**Redirecionamento:**
- Se `lastWorkspaceId` existe → redireciona
- Caso contrário → workspace padrão

**E-mail não confirmado:**
- Login permitido
- Banner persistente com ações

**Implementação Atual:**

**Frontend (`auth_viewmodel.dart`):**
- ✅ Implementa `login` com email e senha
- ✅ Estados de loading e error
- ✅ Tratamento de exceções

**Backend:**
- ✅ Serverpod Auth 3.x gerencia sessões automaticamente
- ⚠️ **PROBLEMA**: Não verifica redirecionamento baseado em `lastWorkspaceId`

**✅ Conformidade:** Parcialmente conforme. Falta lógica de redirecionamento baseada em `lastWorkspaceId`.

---

### 2.4. Confirmação de E-mail

**Plano (plan.md:256-280):**

**Frontend:**
- Tela dedicada com input de código
- Estados: `loading`, `error`, `success`

**Backend:**
- Valida código
- Marca `emailVerified = true`
- Mensagens distintas para código inválido/expirado/já usado

**Implementação Atual:**
- ✅ Frontend tem `verification_screen.dart`
- ✅ Backend usa Serverpod Auth 3.x que gerencia isso automaticamente
- ✅ Código de verificação é impresso no console (dev)

**✅ Conformidade:** Conforme.

---

### 2.5. Recuperação de Senha

**Plano (plan.md:283-306):**

**Solicitação:**
- Usuário informa e-mail
- Backend gera token (1h)
- Envia link: `/reset-password?token=XYZ`

**Reset:**
- Frontend: Nova senha (2x)
- Backend: Atualiza senha, invalida token, **invalida todas as sessões do usuário**

**Implementação Atual:**

**Frontend (`auth_viewmodel.dart`):**
- ✅ Implementa fluxo de 3 etapas: `startPasswordReset`, `verifyPasswordResetCode`, `finishPasswordReset`
- ✅ Estados de loading e error

**Backend:**
- ✅ Serverpod Auth 3.x gerencia isso automaticamente
- ⚠️ **VERIFICAR**: Se invalida todas as sessões (comportamento padrão do Serverpod)

**✅ Conformidade:** Conforme (assumindo que Serverpod invalida todas as sessões).

---

## 3. 🏗️ Análise da Arquitetura

### 3.1. Stack Tecnológica

**Plano (plan.md:8-19):**
- Backend: Serverpod (Dart) ✅
- Banco: PostgreSQL ✅
- Frontend: Flutter (Web, Mobile) ✅
- Auth: `serverpod_auth` (Nativo) ✅
- Roteamento: `zenrouter` ✅
- Editor: `appflowy_editor` ⚠️ (não verificado se implementado)
- Drag & Drop: `appflowy_board` ⚠️ (não verificado se implementado)
- Ordenação: LexoRank ✅ (implementado)

**✅ Conformidade:** Parcialmente conforme. 
- ✅ `appflowy_editor`: Mencionado no modelo `Card.descriptionDocument` (JSON do AppFlowy), mas não verificado se a biblioteca está instalada
- ❌ `appflowy_board`: Não encontrado no código

---

### 3.2. Princípios Arquiteturais

**Plano (plan.md:20-26):**
- Client-Server via Serverpod Client ✅
- Real-time via WebSockets (Serverpod Streams) ⚠️ (não verificado se implementado)
- Autenticação via Session Token ✅
- Autorização via RBAC no Backend ✅
- Soft Delete ✅

**✅ Conformidade:** Não implementado. 
- ❌ **Real-time não implementado**: Não há código de Serverpod Streams encontrado no projeto. O plano especifica uso de WebSockets para colaboração em tempo real, mas isso ainda não foi implementado.

---

## 4. 📊 Resumo de Divergências Críticas

### 🔴 Críticas (Precisam ser corrigidas)

1. **WorkspaceInvite.expiresAt**: O plano diz que convites não expiram, mas a implementação tem `expiresAt`. **DECISÃO NECESSÁRIA**: Remover `expiresAt` ou atualizar o plano.

2. **Attachment.workspaceId ausente**: O plano especifica `workspaceId` no Attachment, mas a implementação não tem. Isso pode ser necessário para controle de acesso.

3. **UserPreference não criado no signup**: O plano especifica que `UserPreference` deve ser criado após criar workspace no signup, mas isso não está implementado.

4. **Cadastro via Convite não implementado**: Todo o fluxo de convites está ausente.

5. **Redirecionamento pós-login**: Não verifica `lastWorkspaceId` para redirecionamento.

---

### 🟡 Médias (Podem ser ajustadas ou documentadas)

1. **Nomenclatura inconsistente**: `name` vs `title`, `removedAt` vs `deletedAt`, `mimeType` vs `fileType`, etc.

2. **IDs como `int` vs `UuidValue`**: A implementação usa IDs numéricos em vez de UUIDs. Isso pode ser uma decisão arquitetural válida, mas precisa ser documentada.

3. **Card.boardId ausente**: O card não tem `boardId` direto, apenas via `listId`. Isso pode ser intencional (normalização), mas precisa ser verificado.

4. **Activity.payload vs details**: O plano usa `Map<String, dynamic>`, mas a implementação usa `String?` (JSON). Isso pode ser uma limitação do Serverpod.

---

### 🟢 Menores (Cosméticas ou melhorias)

1. **Campo `isCompleted` no Card**: Não está no plano, mas é útil.
2. **Campo `isTemplate` no Board**: Não está no plano, mas pode ser útil.
3. **Nomenclatura de campos**: Várias diferenças de nomenclatura que não afetam funcionalidade.

---

## 5. ✅ Recomendações

### Prioridade Alta

1. **Decidir sobre WorkspaceInvite.expiresAt**: Se convites não expiram, remover o campo. Se expiram, atualizar o plano.

2. **Implementar criação de UserPreference no signup**: Adicionar lógica em `WorkspaceService.createDefaultWorkspace` ou em `_onAfterAccountCreated`.

3. **Adicionar workspaceId ao Attachment**: Se necessário para controle de acesso, adicionar o campo.

4. **Implementar fluxo de convites**: Criar endpoints e lógica para aceitar convites.

5. **Implementar redirecionamento pós-login**: Verificar `lastWorkspaceId` e redirecionar adequadamente.

### Prioridade Média

1. **Padronizar nomenclatura**: Decidir entre `name`/`title`, `removedAt`/`deletedAt`, etc.

2. **Documentar decisão sobre IDs**: Documentar por que a implementação usa `int` em vez de `UuidValue`.

3. **Verificar real-time**: Confirmar se Serverpod Streams está implementado para real-time.

4. **Verificar AppFlowy**: Confirmar se `appflowy_editor` e `appflowy_board` estão implementados.

### Prioridade Baixa

1. **Adicionar `updatedAt` ao Card**: Se necessário para auditoria.

2. **Revisar campos extras**: Decidir se campos como `isCompleted`, `isTemplate` devem permanecer.

---

## 6. 📝 Conclusão

A implementação está **parcialmente conforme** ao plano. As principais divergências são:

### Funcionalidades Não Implementadas
- ❌ **Fluxo de convites**: Todo o sistema de aceitação de convites está ausente
- ❌ **Real-time**: Serverpod Streams não está implementado para colaboração em tempo real
- ❌ **AppFlowy Board**: Biblioteca de drag & drop não está instalada

### Campos Ausentes ou Divergentes
- ❌ `workspaceId` no Attachment (pode ser necessário para segurança)
- ❌ `role` no WorkspaceMember (plano especifica owner/admin/member, implementação só tem status)
- ❌ Criação de `UserPreference` no signup (não é criado automaticamente)
- ⚠️ `expiresAt` em WorkspaceInvite (plano diz que não expira, mas implementação tem o campo)

### Divergências de Design
- ⚠️ Nomenclatura inconsistente: `name` vs `title`, `removedAt` vs `deletedAt`, etc.
- ⚠️ IDs como `int` vs `UuidValue`: Decisão arquitetural que precisa ser documentada
- ⚠️ `descriptionDocument` vs `description`: Implementação usa JSON do AppFlowy (correto, mas diferente do plano)

### Pontos Positivos
- ✅ Autenticação implementada corretamente com Serverpod Auth 3.x
- ✅ Workspace criado automaticamente no signup
- ✅ Sistema de permissões (RBAC) implementado
- ✅ Soft delete implementado corretamente
- ✅ LexoRank implementado para ordenação

### Próximos Passos Recomendados

**Prioridade Crítica:**
1. Decidir sobre `expiresAt` em convites (remover ou atualizar plano)
2. Implementar criação de `UserPreference` no signup
3. Adicionar `workspaceId` ao Attachment (se necessário para segurança)
4. Implementar fluxo de aceitação de convites
5. Adicionar campo `role` ao WorkspaceMember ou documentar por que não é necessário

**Prioridade Alta:**
1. Implementar real-time com Serverpod Streams
2. Instalar e integrar `appflowy_board` para drag & drop
3. Implementar redirecionamento pós-login baseado em `lastWorkspaceId`

**Prioridade Média:**
1. Padronizar nomenclatura de campos
2. Documentar decisão sobre uso de `int` vs `UuidValue`
3. Adicionar `updatedAt` ao Card se necessário

A maioria das diferenças são cosméticas ou podem ser justificadas por decisões arquiteturais. As críticas precisam ser resolvidas antes de considerar o projeto completo.
