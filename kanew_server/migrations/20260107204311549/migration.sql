BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "attachment" (
    "id" bigserial PRIMARY KEY,
    "cardId" bigint NOT NULL,
    "fileName" text NOT NULL,
    "fileUrl" text NOT NULL,
    "fileType" text NOT NULL,
    "sizeBytes" bigint NOT NULL,
    "uploadedBy" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "deletedAt" timestamp without time zone
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "board" (
    "id" bigserial PRIMARY KEY,
    "uuid" uuid NOT NULL,
    "workspaceId" bigint NOT NULL,
    "title" text NOT NULL,
    "slug" text NOT NULL,
    "visibility" text NOT NULL,
    "backgroundUrl" text,
    "isTemplate" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "createdBy" bigint NOT NULL,
    "deletedAt" timestamp without time zone,
    "deletedBy" bigint
);

-- Indexes
CREATE UNIQUE INDEX "board_uuid_idx" ON "board" USING btree ("uuid");
CREATE UNIQUE INDEX "board_slug_idx" ON "board" USING btree ("workspaceId", "slug");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "card" (
    "id" bigserial PRIMARY KEY,
    "uuid" uuid NOT NULL,
    "listId" bigint NOT NULL,
    "title" text NOT NULL,
    "descriptionDocument" text,
    "priority" text NOT NULL,
    "rank" text NOT NULL,
    "dueDate" timestamp without time zone,
    "isCompleted" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "createdBy" bigint NOT NULL,
    "deletedAt" timestamp without time zone,
    "deletedBy" bigint
);

-- Indexes
CREATE UNIQUE INDEX "card_uuid_idx" ON "card" USING btree ("uuid");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "card_activity" (
    "id" bigserial PRIMARY KEY,
    "cardId" bigint NOT NULL,
    "userId" bigint NOT NULL,
    "type" text NOT NULL,
    "details" text,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "card_label" (
    "id" bigserial PRIMARY KEY,
    "cardId" bigint NOT NULL,
    "labelDefId" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "card_label_unique" ON "card_label" USING btree ("cardId", "labelDefId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "card_list" (
    "id" bigserial PRIMARY KEY,
    "uuid" uuid NOT NULL,
    "boardId" bigint NOT NULL,
    "title" text NOT NULL,
    "rank" text NOT NULL,
    "archived" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "deletedAt" timestamp without time zone,
    "deletedBy" bigint
);

-- Indexes
CREATE UNIQUE INDEX "card_list_uuid_idx" ON "card_list" USING btree ("uuid");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "checklist" (
    "id" bigserial PRIMARY KEY,
    "cardId" bigint NOT NULL,
    "title" text NOT NULL,
    "deletedAt" timestamp without time zone
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "checklist_item" (
    "id" bigserial PRIMARY KEY,
    "checklistId" bigint NOT NULL,
    "title" text NOT NULL,
    "isChecked" boolean NOT NULL,
    "rank" text NOT NULL,
    "deletedAt" timestamp without time zone
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "comment" (
    "id" bigserial PRIMARY KEY,
    "cardId" bigint NOT NULL,
    "userId" bigint NOT NULL,
    "text" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone,
    "deletedAt" timestamp without time zone
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "label_def" (
    "id" bigserial PRIMARY KEY,
    "boardId" bigint NOT NULL,
    "name" text NOT NULL,
    "colorHex" text NOT NULL,
    "deletedAt" timestamp without time zone
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "member_permission" (
    "id" bigserial PRIMARY KEY,
    "workspaceMemberId" bigint NOT NULL,
    "permissionId" bigint NOT NULL,
    "scopeBoardId" bigint
);

-- Indexes
CREATE UNIQUE INDEX "mem_perm_unique_idx" ON "member_permission" USING btree ("workspaceMemberId", "permissionId", "scopeBoardId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "permission" (
    "id" bigserial PRIMARY KEY,
    "slug" text NOT NULL,
    "description" text
);

-- Indexes
CREATE UNIQUE INDEX "permission_slug_idx" ON "permission" USING btree ("slug");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "workspace" (
    "id" bigserial PRIMARY KEY,
    "uuid" uuid NOT NULL,
    "title" text NOT NULL,
    "slug" text NOT NULL,
    "ownerId" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "deletedAt" timestamp without time zone,
    "deletedBy" bigint
);

-- Indexes
CREATE UNIQUE INDEX "workspace_uuid_idx" ON "workspace" USING btree ("uuid");
CREATE UNIQUE INDEX "workspace_slug_idx" ON "workspace" USING btree ("slug");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "workspace_invite" (
    "id" bigserial PRIMARY KEY,
    "email" text NOT NULL,
    "code" text NOT NULL,
    "workspaceId" bigint NOT NULL,
    "initialPermissions" json NOT NULL,
    "expiresAt" timestamp without time zone NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "deletedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "workspace_invite_code_idx" ON "workspace_invite" USING btree ("code");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "workspace_member" (
    "id" bigserial PRIMARY KEY,
    "userInfoId" bigint NOT NULL,
    "workspaceId" bigint NOT NULL,
    "joinedAt" timestamp without time zone NOT NULL,
    "status" text NOT NULL,
    "deletedAt" timestamp without time zone,
    "deletedBy" bigint
);

-- Indexes
CREATE UNIQUE INDEX "workspace_member_unique_idx" ON "workspace_member" USING btree ("userInfoId", "workspaceId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "attachment"
    ADD CONSTRAINT "attachment_fk_0"
    FOREIGN KEY("cardId")
    REFERENCES "card"("id")
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
    VALUES ('kanew', '20260107204311549', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260107204311549', "timestamp" = now();

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
    VALUES ('serverpod_auth_idp', '20251208110420531-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110420531-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20251208110412389-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110412389-v3-0-0', "timestamp" = now();


COMMIT;
