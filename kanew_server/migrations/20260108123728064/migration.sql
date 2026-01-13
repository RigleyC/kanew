BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "password_reset_token" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "token" text NOT NULL,
    "expiresAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "password_reset_token_idx" ON "password_reset_token" USING btree ("token");


--
-- MIGRATION VERSION FOR kanew
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('kanew', '20260108123728064', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260108123728064', "timestamp" = now();

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
