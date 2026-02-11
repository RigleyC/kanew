BEGIN;

--
-- Function: gen_random_uuid_v7()
-- Source: https://gist.github.com/kjmph/5bd772b2c2df145aa645b837da7eca74
-- License: MIT (copyright notice included on the generator source code).
--
create or replace function gen_random_uuid_v7()
returns uuid
as $$
begin
  -- use random v4 uuid as starting point (which has the same variant we need)
  -- then overlay timestamp
  -- then set version 7 by flipping the 2 and 1 bit in the version 4 string
  return encode(
    set_bit(
      set_bit(
        overlay(uuid_send(gen_random_uuid())
                placing substring(int8send(floor(extract(epoch from clock_timestamp()) * 1000)::bigint) from 3)
                from 1 for 6
        ),
        52, 1
      ),
      53, 1
    ),
    'hex')::uuid;
end
$$
language plpgsql
volatile;

--
-- ACTION DROP TABLE
--
DROP TABLE "attachment" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "attachment" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "cardId" uuid NOT NULL,
    "workspaceId" uuid NOT NULL,
    "fileName" text NOT NULL,
    "mimeType" text NOT NULL,
    "size" bigint NOT NULL,
    "storageKey" text NOT NULL,
    "fileUrl" text,
    "uploaderId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "deletedAt" timestamp without time zone
);

--
-- ACTION DROP TABLE
--
DROP TABLE "board" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "board" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "workspaceId" uuid NOT NULL,
    "title" text NOT NULL,
    "slug" text NOT NULL,
    "visibility" text NOT NULL,
    "backgroundUrl" text,
    "isTemplate" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "createdBy" uuid NOT NULL,
    "deletedAt" timestamp without time zone,
    "deletedBy" uuid
);

-- Indexes
CREATE UNIQUE INDEX "board_slug_idx" ON "board" USING btree ("workspaceId", "slug");

--
-- ACTION DROP TABLE
--
DROP TABLE "card" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "card" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "listId" uuid NOT NULL,
    "boardId" uuid NOT NULL,
    "title" text NOT NULL,
    "descriptionDocument" text,
    "priority" text NOT NULL,
    "rank" text NOT NULL,
    "dueDate" timestamp without time zone,
    "isCompleted" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "createdBy" uuid NOT NULL,
    "updatedAt" timestamp without time zone,
    "deletedAt" timestamp without time zone,
    "deletedBy" uuid
);

--
-- ACTION DROP TABLE
--
DROP TABLE "card_activity" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "card_activity" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "cardId" uuid NOT NULL,
    "actorId" uuid NOT NULL,
    "type" text NOT NULL,
    "details" text,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION DROP TABLE
--
DROP TABLE "card_label" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "card_label" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "cardId" uuid NOT NULL,
    "labelDefId" uuid NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "card_label_unique" ON "card_label" USING btree ("cardId", "labelDefId");

--
-- ACTION DROP TABLE
--
DROP TABLE "card_list" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "card_list" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "boardId" uuid NOT NULL,
    "title" text NOT NULL,
    "rank" text NOT NULL,
    "archived" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "deletedAt" timestamp without time zone,
    "deletedBy" uuid
);

--
-- ACTION DROP TABLE
--
DROP TABLE "checklist" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "checklist" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "cardId" uuid NOT NULL,
    "title" text NOT NULL,
    "rank" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone,
    "deletedAt" timestamp without time zone
);

--
-- ACTION DROP TABLE
--
DROP TABLE "checklist_item" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "checklist_item" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "checklistId" uuid NOT NULL,
    "title" text NOT NULL,
    "isChecked" boolean NOT NULL,
    "rank" text NOT NULL,
    "deletedAt" timestamp without time zone
);

--
-- ACTION DROP TABLE
--
DROP TABLE "comment" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "comment" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "cardId" uuid NOT NULL,
    "authorId" uuid NOT NULL,
    "content" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone,
    "deletedAt" timestamp without time zone
);

--
-- ACTION DROP TABLE
--
DROP TABLE "label_def" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "label_def" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "boardId" uuid NOT NULL,
    "name" text NOT NULL,
    "colorHex" text NOT NULL,
    "deletedAt" timestamp without time zone
);

--
-- ACTION DROP TABLE
--
DROP TABLE "member_permission" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "member_permission" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "workspaceMemberId" uuid NOT NULL,
    "permissionId" uuid NOT NULL,
    "scopeBoardId" uuid,
    "isRemoved" boolean NOT NULL DEFAULT false,
    "grantedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "mem_perm_unique_idx" ON "member_permission" USING btree ("workspaceMemberId", "permissionId", "scopeBoardId");

--
-- ACTION DROP TABLE
--
DROP TABLE "password_reset_token" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "password_reset_token" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "token" text NOT NULL,
    "expiresAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "password_reset_token_idx" ON "password_reset_token" USING btree ("token");

--
-- ACTION DROP TABLE
--
DROP TABLE "permission" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "permission" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "slug" text NOT NULL,
    "description" text
);

-- Indexes
CREATE UNIQUE INDEX "permission_slug_idx" ON "permission" USING btree ("slug");

--
-- ACTION DROP TABLE
--
DROP TABLE "user_preference" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_preference" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "lastWorkspaceId" uuid,
    "theme" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "auth_user_id_unique_idx" ON "user_preference" USING btree ("authUserId");

--
-- ACTION DROP TABLE
--
DROP TABLE "workspace" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "workspace" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "title" text NOT NULL,
    "slug" text NOT NULL,
    "ownerId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "deletedAt" timestamp without time zone,
    "deletedBy" uuid
);

-- Indexes
CREATE UNIQUE INDEX "workspace_slug_idx" ON "workspace" USING btree ("slug");

--
-- ACTION DROP TABLE
--
DROP TABLE "workspace_invite" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "workspace_invite" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "email" text,
    "code" text NOT NULL,
    "workspaceId" uuid NOT NULL,
    "createdBy" uuid NOT NULL,
    "initialPermissions" json NOT NULL,
    "acceptedAt" timestamp without time zone,
    "revokedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "workspace_invite_code_idx" ON "workspace_invite" USING btree ("code");

--
-- ACTION DROP TABLE
--
DROP TABLE "workspace_member" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "workspace_member" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "workspaceId" uuid NOT NULL,
    "role" text NOT NULL,
    "status" text NOT NULL,
    "joinedAt" timestamp without time zone NOT NULL,
    "deletedAt" timestamp without time zone,
    "deletedBy" uuid
);

-- Indexes
CREATE UNIQUE INDEX "workspace_member_unique_idx" ON "workspace_member" USING btree ("authUserId", "workspaceId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "attachment"
    ADD CONSTRAINT "attachment_fk_0"
    FOREIGN KEY("cardId")
    REFERENCES "card"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "attachment"
    ADD CONSTRAINT "attachment_fk_1"
    FOREIGN KEY("workspaceId")
    REFERENCES "workspace"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "board"
    ADD CONSTRAINT "board_fk_0"
    FOREIGN KEY("workspaceId")
    REFERENCES "workspace"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "card"
    ADD CONSTRAINT "card_fk_0"
    FOREIGN KEY("listId")
    REFERENCES "card_list"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "card"
    ADD CONSTRAINT "card_fk_1"
    FOREIGN KEY("boardId")
    REFERENCES "board"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "card_activity"
    ADD CONSTRAINT "card_activity_fk_0"
    FOREIGN KEY("cardId")
    REFERENCES "card"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "card_label"
    ADD CONSTRAINT "card_label_fk_0"
    FOREIGN KEY("cardId")
    REFERENCES "card"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "card_label"
    ADD CONSTRAINT "card_label_fk_1"
    FOREIGN KEY("labelDefId")
    REFERENCES "label_def"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "card_list"
    ADD CONSTRAINT "card_list_fk_0"
    FOREIGN KEY("boardId")
    REFERENCES "board"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "checklist"
    ADD CONSTRAINT "checklist_fk_0"
    FOREIGN KEY("cardId")
    REFERENCES "card"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "checklist_item"
    ADD CONSTRAINT "checklist_item_fk_0"
    FOREIGN KEY("checklistId")
    REFERENCES "checklist"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "comment"
    ADD CONSTRAINT "comment_fk_0"
    FOREIGN KEY("cardId")
    REFERENCES "card"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "label_def"
    ADD CONSTRAINT "label_def_fk_0"
    FOREIGN KEY("boardId")
    REFERENCES "board"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "member_permission"
    ADD CONSTRAINT "member_permission_fk_0"
    FOREIGN KEY("workspaceMemberId")
    REFERENCES "workspace_member"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "member_permission"
    ADD CONSTRAINT "member_permission_fk_1"
    FOREIGN KEY("permissionId")
    REFERENCES "permission"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "member_permission"
    ADD CONSTRAINT "member_permission_fk_2"
    FOREIGN KEY("scopeBoardId")
    REFERENCES "board"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "workspace_invite"
    ADD CONSTRAINT "workspace_invite_fk_0"
    FOREIGN KEY("workspaceId")
    REFERENCES "workspace"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "workspace_member"
    ADD CONSTRAINT "workspace_member_fk_0"
    FOREIGN KEY("workspaceId")
    REFERENCES "workspace"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR kanew
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('kanew', '20260210214401152', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260210214401152', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20251208110333922-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110333922-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260109031533194', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260109031533194', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20251208110412389-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110412389-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20250825102351908-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250825102351908-v3-0-0', "timestamp" = now();


COMMIT;
