# Railway Template for Kanew

## Overview

Template para subir o Kanew (Flutter Web + Serverpod) no Railway com:

- `kanew-backend`: Serverpod (Dart) + Postgres
- `kanew-web`: Flutter Web (Dockerfile) servindo estático via `python3 -m http.server`
- `Object Storage Bucket` (Railway): anexos via bucket S3-compatible (presigned URLs)

Observação: Redis é opcional; o `production.yaml` do Serverpod está com `redis.enabled: false`.

## Services

### `kanew-backend`
- Build: `kanew_server/Dockerfile`
- Start: `kanew_server/start.sh` (aplica migrations e faz replace do `%RAILWAY_PUBLIC_DOMAIN%`)
- Requer: Postgres no mesmo projeto/env
- Opcional: Railway Bucket (para anexos)

### `kanew-web`
- Build: `kanew_flutter/Dockerfile`
- Runtime config: grava `assets/assets/config.json` usando `API_BASE_URL` (sem hardcode no build)

## Variáveis (produção)

### `kanew-backend`
Obrigatórias:
- `DATABASE_URL` (use `${{Postgres.DATABASE_URL}}`)
- `SECRET_KEY`, `JWT_SECRET`, `AUTH_TOKEN`

Uploads:
- `MAX_FILE_SIZE`, `ALLOWED_FILE_TYPES`

Bucket (Railway Object Storage) — crie um Bucket e depois configure *referências*:
```bash
OBJECT_STORAGE_BUCKET=${{kanew-bucket.BUCKET}}
OBJECT_STORAGE_ACCESS_KEY_ID=${{kanew-bucket.ACCESS_KEY_ID}}
OBJECT_STORAGE_SECRET_ACCESS_KEY=${{kanew-bucket.SECRET_ACCESS_KEY}}
OBJECT_STORAGE_REGION=${{kanew-bucket.REGION}}
OBJECT_STORAGE_ENDPOINT=${{kanew-bucket.ENDPOINT}}
# Se seu bucket for "path-style" (buckets antigos), habilite:
# OBJECT_STORAGE_FORCE_PATH_STYLE=true
```

### `kanew-web`
- `API_BASE_URL=https://${{kanew-backend.RAILWAY_PUBLIC_DOMAIN}}/`
- `STREAMING_URL=wss://${{kanew-backend.RAILWAY_PUBLIC_DOMAIN}}/streaming`

## Migration Commands

### Database Migration
```bash
# Run migrations
railway run dart run serverpod migrate

# Generate new migration
railway run dart run serverpod generate
```

### Seed Data
```bash
# Seed initial data
railway run dart bin/seed_permissions.dart
```

## Deployment Steps

1. **Install Railway CLI**
   ```bash
   # Install Scoop (if not already installed)
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
   
   # Add Railway bucket and install CLI
   scoop bucket add railway https://github.com/railwayapp/scoop-railway.git
   scoop install railway
   
   # Login to Railway
   railway login
   ```

2. **Create Project**
   ```bash
   railway init
   # Select "Create new project" and name it "kanew"
   ```

3. **Deploy**
   ```bash
   railway up -s kanew-backend
   railway up -s kanew-web
   ```
## Notas para Template

- O backend usa `kanew_server/config/production.yaml` com placeholder `%RAILWAY_PUBLIC_DOMAIN%` (substituído no boot pelo `start.sh`).
- Para bucket, você **precisa** criar o “Storage Bucket” no Railway Canvas e depois setar as variáveis por referência no `kanew-backend`.
