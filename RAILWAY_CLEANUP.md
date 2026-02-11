# Limpeza de Variáveis RAILPACK no Railway

As seguintes variáveis são resquícios de tentativas anteriores com Railpack e não são mais usadas (o builder atual é DOCKERFILE).

## Variáveis para Remover

### Serviço: kanew-backend
```bash
railway variables delete RAILPACK_BUILDER --service kanew-backend
railway variables delete RAILPACK_BUILD_COMMAND --service kanew-backend
railway variables delete RAILPACK_DOCKERFILE_PATH --service kanew-backend
railway variables delete RAILPACK_ROOT_DIRECTORY --service kanew-backend
railway variables delete RAILPACK_START_COMMAND --service kanew-backend
```

### Serviço: kanew-web
```bash
railway variables delete RAILPACK_BUILD_COMMAND --service kanew-web
railway variables delete RAILPACK_STATIC_FILE_ROOT --service kanew-web
```

## Ou via Railway Dashboard

1. Acesse https://railway.app/project/[seu-projeto-id]
2. Selecione o serviço **kanew-backend**
3. Vá em **Variables**
4. Remova:
   - `RAILPACK_BUILDER`
   - `RAILPACK_BUILD_COMMAND`
   - `RAILPACK_DOCKERFILE_PATH`
   - `RAILPACK_ROOT_DIRECTORY`
   - `RAILPACK_START_COMMAND`

5. Selecione o serviço **kanew-web**
6. Remova:
   - `RAILPACK_BUILD_COMMAND`
   - `RAILPACK_STATIC_FILE_ROOT`

## Configurações de Health Check e Draining

Também configure via Dashboard:

### kanew-backend
- **Health Check Path**: `/health`
- **Health Check Interval**: 30s
- **Health Check Timeout**: 10s
- **Draining Seconds**: 30
- **Overlap Seconds**: 10

### kanew-web
- **Health Check Path**: `/`
- **Health Check Interval**: 30s
- **Health Check Timeout**: 10s
- **Draining Seconds**: 15
- **Overlap Seconds**: 5
