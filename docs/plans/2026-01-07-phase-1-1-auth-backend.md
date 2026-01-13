# Phase 1.1: Authentication Backend

> Implemented using official Serverpod 3.x Auth IDP module.

**Goal:** Email/password authentication with auto-workspace creation on organic signup.

---

## Implemented Changes

### Server Configuration

#### [MODIFIED] [server.dart](file:///c:/Users/Rigley/Documents/kanew/kanew_server/lib/server.dart)

Configured `EmailIdpConfigFromPasswords` with:
- `sendRegistrationVerificationCode` - logs verification code (TODO: email service)
- `sendPasswordResetVerificationCode` - logs reset code (TODO: email service)  
- `onAfterAccountCreated` - creates default workspace for organic signups

---

### Auth Endpoint

#### [MODIFIED] [email_idp_endpoint.dart](file:///c:/Users/Rigley/Documents/kanew/kanew_server/lib/src/auth/email_idp_endpoint.dart)

Simple extension of `EmailIdpBaseEndpoint` - Serverpod 3.x handles all auth natively:
- signUp, signIn, verifyEmail, requestPasswordReset, resetPassword

---

### Services

#### [NEW] [workspace_service.dart](file:///c:/Users/Rigley/Documents/kanew/kanew_server/lib/src/services/workspace_service.dart)

`createDefaultWorkspace()` - creates workspace + member on organic signup.

---

### Utilities

#### [NEW] [slug_generator.dart](file:///c:/Users/Rigley/Documents/kanew/kanew_server/lib/src/utils/slug_generator.dart)

Generates unique URL-friendly slugs with collision handling.

---

### Models

#### [NEW] [password_reset_token.spy.yaml](file:///c:/Users/Rigley/Documents/kanew/kanew_server/lib/src/models/password_reset_token.spy.yaml)

For future custom password reset flow if needed.

---

## Configuration Required

Copy `config/passwords.yaml.example` to `config/passwords.yaml` and set:
- `jwtRefreshTokenHashPepper` - 64+ char random string
- `jwtHmacSha512PrivateKey` - 64+ char random string  
- `emailSecretHashPepper` - 32+ char random string

---

## Verification

```bash
# Generate code
serverpod generate  # ✓ Done

# Create migration
serverpod create-migration  # ✓ Created 20260108123728064

# Analyze
dart analyze  # ✓ No errors
```
