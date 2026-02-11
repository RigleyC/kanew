# UUID v7 Migration - Testing Guide

**Status:** ✅ Migration Complete - Ready for Integration Testing  
**Date:** February 11, 2026  
**Database:** Fully migrated, empty (ready for fresh data)

---

## 🎯 Quick Status Check

### Services Running
```bash
# Check PostgreSQL
docker ps | grep postgres
# Expected: kanew_server-postgres-1, Up X hours

# Check Backend
netstat -ano | findstr ":8080" | findstr "LISTENING"
# Expected: TCP 0.0.0.0:8080 (PID running)

# Check Frontend  
netstat -ano | findstr ":3000" | findstr "LISTENING"
# Expected: TCP 0.0.0.0:3000 (if started)
```

### Current State
- ✅ Backend: Running on http://localhost:8080
- ✅ Frontend: Can be started with `cd kanew_flutter && flutter run -d chrome`
- ✅ Database: Empty, all tables using UUID v7
- ✅ Compilation: 0 errors in both backend and frontend

---

## 📋 Manual Testing Checklist

### Access Points
- **Frontend:** http://localhost:3000 (or auto-assigned port)
- **Backend API:** http://localhost:8080
- **Database:** localhost:8090 (kanew database)

### Test Scenarios (Priority Order)

#### 1. User Registration & Login ✓
**Goal:** Verify auth works with UUID users

**Steps:**
1. Open app at http://localhost:3000
2. Click "Sign Up" / "Criar Conta"
3. Register with email: `uuid-test@example.com`, password: `Test123!`
4. Verify email verification flow
5. Complete login

**Expected Results:**
- User created in `serverpod_user_info` table with UUID `id`
- Login successful, redirected to workspace creation/list

**Database Verification:**
```sql
docker exec kanew_server-postgres-1 psql -U postgres -d kanew -c \
  "SELECT id, email FROM serverpod_user_info ORDER BY created DESC LIMIT 1;"
```
Expected: UUID id (format: `550e8400-e29b-41d4-a716-...`)

---

#### 2. Workspace Creation ⭐ CRITICAL
**Goal:** First real test of UUID generation and insertion

**Steps:**
1. After login, create a new workspace
2. Enter title: "UUID Test Workspace"
3. Optional slug: "uuid-test"
4. Click "Create" / "Criar"

**Expected Results:**
- Workspace created with auto-generated UUID v7 id
- User automatically added as workspace member (owner)
- Redirected to `/w/uuid-test/boards`

**Database Verification:**
```sql
-- Check workspace
docker exec kanew_server-postgres-1 psql -U postgres -d kanew -c \
  "SELECT id, title, slug, \"ownerId\" FROM workspace ORDER BY \"createdAt\" DESC LIMIT 1;"

-- Check workspace member
docker exec kanew_server-postgres-1 psql -U postgres -d kanew -c \
  "SELECT id, \"workspaceId\", \"authUserId\", role, status FROM workspace_member ORDER BY \"joinedAt\" DESC LIMIT 1;"
```

**Success Criteria:**
- ✅ Workspace.id is UUID (not integer)
- ✅ Workspace.ownerId matches user's UUID
- ✅ WorkspaceMember.workspaceId matches workspace UUID
- ✅ WorkspaceMember.authUserId matches user's UUID
- ✅ No errors in browser console
- ✅ No errors in backend logs (`tail kanew_server/server.log`)

---

#### 3. Board Creation
**Goal:** Verify nested entity creation with UUIDs

**Steps:**
1. Inside workspace, click "New Board" / "Novo Quadro"
2. Enter title: "UUID Test Board"
3. Create board

**Expected Results:**
- Board created with UUID id
- Redirected to `/w/uuid-test/b/uuid-test-board`
- Default lists created (To Do, In Progress, Done)

**Database Verification:**
```sql
-- Check board
docker exec kanew_server-postgres-1 psql -U postgres -d kanew -c \
  "SELECT id, title, slug, \"workspaceId\" FROM board ORDER BY \"createdAt\" DESC LIMIT 1;"

-- Check card lists
docker exec kanew_server-postgres-1 psql -U postgres -d kanew -c \
  "SELECT id, title, \"boardId\", \"position\" FROM card_list WHERE \"deletedAt\" IS NULL ORDER BY \"createdAt\" DESC LIMIT 3;"
```

---

#### 4. Card Creation & Movement
**Goal:** Test UUID-based drag-and-drop and routing

**Steps:**
1. In board view, click "Add card" in "To Do" list
2. Enter title: "Test Card 1"
3. Create card
4. Click on card to open detail view
5. Verify URL contains card UUID: `/w/.../b/.../c/550e8400-...`
6. Close detail, drag card to "In Progress" list
7. Verify card moved correctly

**Expected Results:**
- Card created with UUID id
- Card detail route uses UUID (not integer)
- Drag-and-drop updates `card.listId` to new list's UUID
- Card order preserved (rank system)

**Database Verification:**
```sql
-- Check card
docker exec kanew_server-postgres-1 psql -U postgres -d kanew -c \
  "SELECT id, title, \"listId\", rank FROM card WHERE \"deletedAt\" IS NULL ORDER BY \"createdAt\" DESC LIMIT 1;"
```

**Test UUID in URL:**
- Copy card UUID from database
- Manually navigate to `/w/uuid-test/b/uuid-test-board/c/<card-uuid>`
- Should open card detail

---

#### 5. Card Detail Operations
**Goal:** Verify all CRUD operations with UUIDs

**Steps:**
1. Open card detail
2. Edit title: "Updated Test Card"
3. Add description: "Testing UUID migration"
4. Add checklist: "Migration Tests"
   - Add item: "Create card"
   - Add item: "Update card"
   - Check first item
5. Add comment: "UUID test comment"
6. Upload attachment (if available)

**Expected Results:**
- All updates save correctly
- Activities created for each action
- Checklists/items have UUID ids
- Comments have UUID ids
- Attachments have UUID ids

**Database Verification:**
```sql
-- Check checklist
docker exec kanew_server-postgres-1 psql -U postgres -d kanew -c \
  "SELECT id, title, \"cardId\" FROM checklist WHERE \"deletedAt\" IS NULL LIMIT 1;"

-- Check checklist items
docker exec kanew_server-postgres-1 psql -U postgres -d kanew -c \
  "SELECT id, title, \"checklistId\", completed FROM checklist_item WHERE \"deletedAt\" IS NULL LIMIT 2;"

-- Check activities
docker exec kanew_server-postgres-1 psql -U postgres -d kanew -c \
  "SELECT id, type, \"cardId\", \"actorId\" FROM activity ORDER BY \"createdAt\" DESC LIMIT 5;"
```

---

#### 6. Member Invitation
**Goal:** Test UUID-based workspace invitations

**Steps:**
1. In workspace, go to "Members" page
2. Click "Invite Member" / "Convidar Membro"
3. Enter email: `invited-user@example.com`
4. Select permissions (optional)
5. Send invite

**Expected Results:**
- Invite created with UUID id
- `workspace_invite.initialPermissions` is `List<UuidValue>` (if permissions selected)
- Invite link contains workspace UUID

**Database Verification:**
```sql
docker exec kanew_server-postgres-1 psql -U postgres -d kanew -c \
  "SELECT id, email, \"workspaceId\", status FROM workspace_invite ORDER BY \"createdAt\" DESC LIMIT 1;"
```

---

#### 7. Label Management
**Goal:** Verify many-to-many relations with UUIDs

**Steps:**
1. Open card detail
2. Click "Add Label" / "Adicionar Etiqueta"
3. Create new label: "UUID Test" (red color)
4. Assign label to card
5. Remove label from card

**Expected Results:**
- Label created with UUID id
- `card_label` junction table uses UUIDs
- Label assignment/removal works

**Database Verification:**
```sql
-- Check label
docker exec kanew_server-postgres-1 psql -U postgres -d kanew -c \
  "SELECT id, title, color, \"workspaceId\" FROM label WHERE \"deletedAt\" IS NULL LIMIT 1;"

-- Check card-label relationship
docker exec kanew_server-postgres-1 psql -U postgres -d kanew -c \
  "SELECT id, \"cardId\", \"labelId\" FROM card_label WHERE \"deletedAt\" IS NULL LIMIT 5;"
```

---

#### 8. Soft Delete Verification
**Goal:** Ensure soft deletes work with UUIDs

**Steps:**
1. Delete a card (from detail view or board)
2. Delete a checklist
3. Delete a workspace member (if multi-user)

**Expected Results:**
- Records have `deletedAt` timestamp set
- Records no longer appear in UI
- Records still exist in database

**Database Verification:**
```sql
-- Check soft-deleted card
docker exec kanew_server-postgres-1 psql -U postgres -d kanew -c \
  "SELECT id, title, \"deletedAt\", \"deletedBy\" FROM card WHERE \"deletedAt\" IS NOT NULL LIMIT 1;"
```

---

## 🔍 UUID-Specific Checks

### 1. UUID Format Validation
All UUIDs should be version 7 format:
- Pattern: `xxxxxxxx-xxxx-7xxx-xxxx-xxxxxxxxxxxx`
- Version digit: `7` (position 14)

**Check in Database:**
```sql
docker exec kanew_server-postgres-1 psql -U postgres -d kanew -c \
  "SELECT id, substring(id::text from 15 for 1) as version FROM workspace LIMIT 5;"
```
Expected: version = `7`

### 2. UUID Ordering (Time-based)
UUID v7 is time-ordered - newer records should have "greater" UUIDs:

```sql
docker exec kanew_server-postgres-1 psql -U postgres -d kanew -c \
  "SELECT id, \"createdAt\" FROM workspace ORDER BY \"createdAt\" ASC;"
```
Expected: IDs increase as createdAt increases

### 3. No Integer Leakage
Verify NO integer IDs appear in:
- ✅ URLs (should be slugs or UUIDs)
- ✅ API responses (check browser DevTools Network tab)
- ✅ UI display (check card titles, labels don't show IDs)

### 4. Foreign Key Integrity
All foreign keys should reference UUIDs:

```sql
docker exec kanew_server-postgres-1 psql -U postgres -d kanew -c \
  "SELECT 
     c.id as card_id,
     c.\"listId\",
     l.id as actual_list_id,
     c.\"listId\" = l.id as fk_valid
   FROM card c
   JOIN card_list l ON c.\"listId\" = l.id
   WHERE c.\"deletedAt\" IS NULL
   LIMIT 5;"
```
Expected: `fk_valid = t` for all rows

---

## 🐛 Common Issues & Fixes

### Issue: "Column 'id' is type uuid but expression is integer"
**Cause:** Code still using integer IDs  
**Fix:** Search for `id: int` in code, replace with `UuidValue`

### Issue: "UuidValue cannot be assigned to type int"
**Cause:** Variable type mismatch  
**Fix:** Change variable from `int` to `UuidValue`

### Issue: "Invalid UUID format"
**Cause:** Passing integer or invalid string to UuidValue.fromString()  
**Fix:** Ensure input is valid UUID string

### Issue: Card not opening (404 on detail route)
**Cause:** Router not parsing UUID correctly  
**Fix:** Verify route uses `cardUuid` parameter and backend endpoint receives String

### Issue: Database error "function gen_random_uuid_v7() does not exist"
**Cause:** Migration not applied  
**Fix:** 
```bash
cd kanew_server
dart run bin/main.dart --apply-migrations
```

---

## 📊 Success Metrics

The UUID migration is **fully successful** when:

- [x] ✅ Backend compiles (0 errors)
- [x] ✅ Frontend compiles (0 errors)
- [x] ✅ Database schema migrated to UUIDs
- [x] ✅ All tables have UUID primary keys
- [ ] ⏳ User registration creates UUID users
- [ ] ⏳ Workspace creation generates UUID workspace
- [ ] ⏳ Boards/Cards created with UUIDs
- [ ] ⏳ Card detail routes use UUIDs in URL
- [ ] ⏳ Drag-and-drop works with UUID IDs
- [ ] ⏳ Soft deletes work (deletedAt set correctly)
- [ ] ⏳ Member invitations send UUID workspace IDs
- [ ] ⏳ Permissions use List<UuidValue>
- [ ] ⏳ All CRUD operations work end-to-end
- [ ] ⏳ No integer IDs visible in UI or URLs

---

## 🔧 Quick Commands

### Start Services
```bash
# Start backend (if not running)
cd kanew_server
dart run bin/main.dart &

# Start frontend
cd kanew_flutter
flutter run -d chrome --web-port=3000
```

### Check Logs
```bash
# Backend logs
tail -f kanew_server/server.log

# Frontend (in terminal where flutter run is active)
# Logs appear automatically
```

### Database Queries
```bash
# Connect to database
docker exec -it kanew_server-postgres-1 psql -U postgres -d kanew

# Inside psql:
\dt                           # List tables
\d workspace                  # Describe table
SELECT * FROM workspace;      # Query data
\q                            # Quit
```

### Reset Database (if needed)
```bash
cd kanew_server
# Drop and recreate
docker exec kanew_server-postgres-1 psql -U postgres -c "DROP DATABASE kanew;"
docker exec kanew_server-postgres-1 psql -U postgres -c "CREATE DATABASE kanew;"

# Reapply migrations
dart run bin/main.dart --apply-migrations
```

---

## 📝 Notes

### UUID Storage
- Database stores UUIDs in native `uuid` type (16 bytes, efficient)
- Dart represents as `UuidValue` object
- JSON/API serializes as String: `"550e8400-e29b-41d4-a716-446655440000"`

### Performance Considerations
- UUID v7 maintains time-ordering, so B-tree indexes work efficiently
- No performance degradation expected vs auto-increment integers
- Slightly larger storage (16 bytes vs 4-8 bytes for int64)

### Migration Completeness
- ✅ All 16 model files migrated
- ✅ All 13 endpoint files migrated
- ✅ All 4 service files migrated
- ✅ All 12 repository files migrated
- ✅ All 6 controller files migrated
- ✅ Database migration applied successfully
- ✅ Tests updated and compiling

---

## 🎉 Next Steps After Testing

Once all tests pass:

1. **Document any issues found**
   - Create GitHub issues for bugs
   - Update this guide with solutions

2. **Performance testing**
   - Create 100+ workspaces/boards/cards
   - Test pagination with UUIDs
   - Monitor query performance

3. **Consider features**
   - Implement UUID-based webhooks
   - Add UUID to audit logs
   - Expose UUIDs in public API

4. **Production readiness**
   - Backup strategy for UUID data
   - Migration rollback plan (if needed)
   - Update deployment docs

---

**Last Updated:** February 11, 2026  
**Migration Status:** Complete - Integration Testing Phase  
**Backend Process:** PID 59596, Port 8080  
**Database:** kanew_server-postgres-1, Port 8090
