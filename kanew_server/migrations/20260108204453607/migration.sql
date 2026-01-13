BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "attachment" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "attachment" (
    "id" bigserial PRIMARY KEY,
    "cardId" bigint NOT NULL,
    "workspaceId" bigint NOT NULL,
    "fileName" text NOT NULL,
    "mimeType" text NOT NULL,
    "size" bigint NOT NULL,
    "storageKey" text NOT NULL,
    "fileUrl" text,
    "uploaderId" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "deletedAt" timestamp without time zone
);

--
-- ACTION DROP TABLE
--
DROP TABLE "card" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "card" (
    "id" bigserial PRIMARY KEY,
    "uuid" uuid NOT NULL,
    "listId" bigint NOT NULL,
    "boardId" bigint NOT NULL,
    "title" text NOT NULL,
    "descriptionDocument" text,
    "priority" text NOT NULL,
    "rank" text NOT NULL,
    "dueDate" timestamp without time zone,
    "isCompleted" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "createdBy" bigint NOT NULL,
    "updatedAt" timestamp without time zone,
    "deletedAt" timestamp without time zone,
    "deletedBy" bigint
);

-- Indexes
CREATE UNIQUE INDEX "card_uuid_idx" ON "card" USING btree ("uuid");

--
-- ACTION DROP TABLE
--
DROP TABLE "card_activity" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "card_activity" (
    "id" bigserial PRIMARY KEY,
    "cardId" bigint NOT NULL,
    "actorId" bigint NOT NULL,
    "type" text NOT NULL,
    "details" text,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION DROP TABLE
--
DROP TABLE "checklist" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "checklist" (
    "id" bigserial PRIMARY KEY,
    "cardId" bigint NOT NULL,
    "title" text NOT NULL,
    "rank" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone,
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
    "id" bigserial PRIMARY KEY,
    "cardId" bigint NOT NULL,
    "authorId" bigint NOT NULL,
    "content" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone,
    "deletedAt" timestamp without time zone
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_preference" (
    "id" bigserial PRIMARY KEY,
    "userInfoId" bigint NOT NULL,
    "lastWorkspaceId" bigint,
    "theme" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "user_info_id_unique_idx" ON "user_preference" USING btree ("userInfoId");

--
-- ACTION DROP TABLE
--
DROP TABLE "workspace_invite" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "workspace_invite" (
    "id" bigserial PRIMARY KEY,
    "email" text,
    "code" text NOT NULL,
    "workspaceId" bigint NOT NULL,
    "createdBy" bigint NOT NULL,
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
    "id" bigserial PRIMARY KEY,
    "userInfoId" bigint NOT NULL,
    "workspaceId" bigint NOT NULL,
    "role" text NOT NULL,
    "status" text NOT NULL,
    "joinedAt" timestamp without time zone NOT NULL,
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
ALTER TABLE ONLY "attachment"
    ADD CONSTRAINT "attachment_fk_1"
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
ALTER TABLE ONLY "checklist"
    ADD CONSTRAINT "checklist_fk_0"
    FOREIGN KEY("cardId")
    REFERENCES "card"("id")
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
    VALUES ('kanew', '20260108204453607', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260108204453607', "timestamp" = now();

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
