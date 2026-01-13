# Kanew - Backend Server

## Implementação Atual

### 1. Autenticação ✅
- Serverpod Auth 3.x com EmailIdp configurado
- Email de verificação impresso no console (dev)
- Reset de senha disponível
- Workspace criado automaticamente no signup (via `WorkspaceService`)
- `AuthConfig.requireEmailVerification = false` para desenvolvimento

### 2. Banco de Dados ✅
Estrutura completa seguindo plan.md:
- **Core:** `workspace`, `board`, `card_list`, `card`
- **Detalhes:** `attachment`, `card_activity`, `card_label`, `checklist`, `checklist_item`, `comment`, `label_def`
- **Segurança:** `workspace_member`, `workspace_invite`, `member_permission`, `permission`, `password_reset_token`
- Índices únicos configurados (slug global, uuid)
- Soft delete implementado com `deletedAt`
- Relacionamentos foreign key corretos

### 3. Sistema de Permissões (RBAC) ✅ Novo!
**Servi Implementados:**
- `PermissionService` - Gerencia todas as operações de permissão
- `WorkspaceEndpoint` - API completa para gerenciar workspaces

**Permissões Implementadas:**
- `workspace.read` - Ler informações do workspace
- `workspace.invite` - Convidar usuários para workspace
- `workspace.update` - Atualizar configurações do workspace
- `board.read` - Ler quadros no workspace
- `board.create` - Criar novos quadros
- `board.update` - Atualizar quadros e listas
- `board.delete` - Deletar quadros
- `card.read` - Ler cartões
- `card.create` - Criar novos cartões
- `card.update` - Atualizar, mover ou mudar prioridade
- `card.delete` - Arquivar ou deletar cartões

**Features do WorkspaceEndpoint:**
- `getWorkspaces(session)` - Lista todos os workspaces do usuário autenticado
- `getWorkspace(session, slug)` - Busca workspace por slug com verificação de permissão
- `createWorkspace(session, title, slug)` - Cria novo workspace com geração de slug único e verificações
- `updateWorkspace(session, workspaceId, title, slug)` - Atualiza workspace existente
- `deleteWorkspace(session, workspaceId)` - Soft delete de workspace (apenas owner)

**Validação de Segurança:**
- Autenticação obrigatória em todos os métodos
- Verificação de permissões antes de cada operação (usando `PermissionService`)
- Owner pode deletar workspace
- Membros só podem criar boards se tiverem permissão
- Apenas membros com permissão podem deletar boards

### 4. Próximos Passos

1. **Seed de Permissões Inicial**
   - Ao iniciar o servidor, todas as 11 permissões são inseridas automaticamente no banco
   - Isso garante que o sistema RBAC funcione corretamente desde o início
   - Owner de workspace recebe todas as permissões automaticamente

2. **Workspace API**
   - Endpoint completo para CRUD de workspaces
   - Integração com sistema de permissões granular
   - Geração automática de slugs únicos globais

3. **Migração Manual**
   - Devido à ausência do CLI do Serverpod no ambiente, o código foi atualizado manualmente
   - Para executar: `dart run serverpod generate`, use `dart run bin/seed_permissions.dart`
   - O arquivo `bin/seed_permissions.dart` contém a lógica de seed das permissões

### Como Executar

```bash
# Iniciar o servidor (automatiza seeding de permissões)
dart run bin/main.dart

# Em produção, verifique se as permissões já existem antes de rodar
# Você pode executar manualmente o seed:
dart run bin/seed_permissions.dart
```

### Notas de Desenvolvimento

- CLI do Serverpod não disponível neste ambiente
- Implementações foram feitas manualmente seguindo o padrão do Serverpod 3.x
- O endpoint de Workspace foi registrado manualmente em `lib/src/generated/endpoints.dart`
- Para adicionar novos endpoints futuros, é necessário atualizar o arquivo manualmente ou instalar o CLI do Serverpod
