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
    "id" bigserial PRIMARY KEY,
    "uuid" uuid NOT NULL,
    "workspaceId" bigint NOT NULL,
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
CREATE UNIQUE INDEX "board_uuid_idx" ON "board" USING btree ("uuid");
CREATE UNIQUE INDEX "board_slug_idx" ON "board" USING btree ("workspaceId", "slug");

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
    "createdBy" uuid NOT NULL,
    "updatedAt" timestamp without time zone,
    "deletedAt" timestamp without time zone,
    "deletedBy" uuid
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
    "actorId" uuid NOT NULL,
    "type" text NOT NULL,
    "details" text,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION ALTER TABLE
--
ALTER TABLE "card_list" DROP COLUMN "deletedBy";
ALTER TABLE "card_list" ADD COLUMN "deletedBy" uuid;
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
    "authorId" uuid NOT NULL,
    "content" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone,
    "deletedAt" timestamp without time zone
);

--
-- ACTION DROP TABLE
--
DROP TABLE "workspace" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "workspace" (
    "id" bigserial PRIMARY KEY,
    "uuid" uuid NOT NULL,
    "title" text NOT NULL,
    "slug" text NOT NULL,
    "ownerId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "deletedAt" timestamp without time zone,
    "deletedBy" uuid
);

-- Indexes
CREATE UNIQUE INDEX "workspace_uuid_idx" ON "workspace" USING btree ("uuid");
CREATE UNIQUE INDEX "workspace_slug_idx" ON "workspace" USING btree ("slug");

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
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "workspaceId" bigint NOT NULL,
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
    VALUES ('kanew', '20260203185233601', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260203185233601', "timestamp" = now();

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
