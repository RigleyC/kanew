# GitHub Actions Secrets Configuration

Este arquivo documenta os secrets necessários para os workflows funcionarem.

## Secrets Necessários

### Para Tests Workflow (tests.yml)

Configure em: `Settings → Secrets and variables → Actions → Repository secrets`

| Secret Name | Descrição | Valor Sugerido |
|---|---|---|
| `TEST_DB_PASSWORD` | Senha do PostgreSQL para testes | Gerar senha forte (min 32 chars) |
| `TEST_REDIS_PASSWORD` | Senha do Redis para testes | Gerar senha forte (min 32 chars) |

**Nota:** Essas senhas são usadas apenas no ambiente de testes do CI/CD. Elas devem ser diferentes das senhas de desenvolvimento local (definidas em `kanew_server/config/passwords.yaml`) e das senhas de produção (definidas no Railway).

## Como Configurar

1. Acesse o repositório no GitHub
2. Vá em **Settings** → **Secrets and variables** → **Actions**
3. Clique em **New repository secret**
4. Adicione cada secret com o nome e valor correspondente

## Gerando Senhas Fortes

Use um gerador de senhas ou execute:

```bash
# Linux/macOS
openssl rand -base64 32

# Windows (PowerShell)
-join ((48..57) + (65..90) + (97..122) | Get-Random -Count 32 | % {[char]$_})
```
