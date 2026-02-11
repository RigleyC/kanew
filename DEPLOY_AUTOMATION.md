# Configurando Deploys Automáticos (Git-based)

Para que o Railway faça deploy automático sempre que você der `git push origin master`, siga estes passos no Dashboard do Railway:

## 1. Conectar o Repositório GitHub

1. Acesse https://railway.app/dashboard
2. Abra o projeto **kanew**
3. Clique em **Settings** (canto superior direito)
4. Em "Git Repository", clique em **Connect** (se ainda não estiver conectado)
5. Selecione o repositório `RigleyC/kanew`

## 2. Configurar o Serviço Backend (`kanew-backend`)

1. Clique no serviço **kanew-backend**
2. Vá na aba **Settings**
3. Encontre a seção **Service Source** (ou "Git")
4. Configure:
   - **Repo:** `RigleyC/kanew`
   - **Branch:** `master`
   - **Trigger:** Ativado (Deploy on push)
   - **Root Directory:** `/` (Deixe vazio ou barra)
   - **Watch Paths:** (Importante para evitar deploys desnecessários)
     ```text
     /kanew_server/**
     /kanew_client/**
     /Dockerfile
     /railway.yaml
     ```

## 3. Configurar o Serviço Web (`kanew-web`)

1. Clique no serviço **kanew-web**
2. Vá na aba **Settings**
3. Encontre a seção **Service Source**
4. Configure:
   - **Repo:** `RigleyC/kanew`
   - **Branch:** `master`
   - **Trigger:** Ativado (Deploy on push)
   - **Root Directory:** `/` (Deixe vazio ou barra)
   - **Watch Paths:**
     ```text
     /kanew_flutter/**
     /kanew_client/**
     ```

## Resumo do Fluxo

1. Você altera código em `kanew_flutter/` e dá push.
2. O Railway detecta mudança apenas no "Watch Path" do web.
3. O Railway inicia deploy **apenas** do serviço `kanew-web`.
4. O serviço `kanew-backend` ignora (pois não houve mudança na pasta dele).

## Dica Adicional

Se você quiser pausar os deploys automáticos temporariamente (ex: fazendo muitos commits pequenos), você pode desativar o "Trigger" nas configurações do serviço e reativar depois.
