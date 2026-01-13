BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "user_verification" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_verification" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "emailVerified" boolean NOT NULL DEFAULT true,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "user_verification_user_unique" ON "user_verification" USING btree ("userId");


--
-- MIGRATION VERSION FOR kanew
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('kanew', '20260109215657290', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260109215657290', "timestamp" = now();

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
