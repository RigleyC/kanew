# Kanew - Open Source Kanban Board

A modern, collaborative Kanban board built with Flutter and Serverpod. Features real-time updates, workspaces, checklists, labels, attachments, and more.

## Features

- **Workspaces & Boards**: Organize your projects with workspaces and multiple boards
- **Cards & Lists**: Drag-and-drop cards between lists with rich card details
- **Checklists**: Add checklists to cards with progress tracking
- **Labels**: Color-coded labels for visual organization
- **Attachments**: Upload files to cards
- **Comments & Activity**: Collaborate with comments and track activity logs
- **Real-time Updates**: Live sync across clients via Redis
- **Cross-Platform**: Web, iOS, Android, macOS, Windows, and Linux

## Tech Stack

- **Frontend**: Flutter 3.x, go_router, Provider, get_it
- **Backend**: Serverpod 3.x (Dart)
- **Database**: PostgreSQL (with pgvector)
- **Cache/Real-time**: Redis
- **Authentication**: Serverpod Auth (Email/Password, OAuth ready)
- **Deployment**: Docker, Railway (recommended)

## Prerequisites

- Dart SDK 3.8+
- Flutter SDK 3.32+
- Docker & Docker Compose
- PostgreSQL 16+ (for local dev)
- Redis 6.2+ (for local dev)

## Project Structure

```
kanew/
├── kanew_flutter/       # Flutter frontend application
├── kanew_server/        # Serverpod backend
├── kanew_client/       # Shared protocol/models
├── docs/               # Documentation and plans
└── README.md           # This file
```

---

## Development Setup

### 1. Start Infrastructure (PostgreSQL & Redis)

```bash
cd kanew_server
docker compose up --build --detach
```

This starts:
- PostgreSQL on port 8090
- Redis on port 8091

### 2. Configure Environment

Copy the example passwords file:

```bash
cp kanew_server/config/passwords.yaml.example kanew_server/config/passwords.yaml
```

Edit with your secrets:
- `postgresPassword`: Database password
- `redisPassword`: Redis password
- `jwtSecret`: Secret for JWT tokens

### 3. Run the Server

```bash
cd kanew_server
dart bin/main.dart --apply-migrations
```

The API server will start on `http://localhost:8080`
- Insights dashboard: `http://localhost:8081`

### 4. Run the Flutter App

```bash
cd kanew_flutter
flutter run -d chrome
```

The app will be available at `http://localhost:port`

---

## Production Deployment

### Option 1: Railway (Recommended)

Railway provides the easiest deployment experience with managed PostgreSQL and Redis.

#### 1. Create Railway Project

```bash
# Install Railway CLI
npm install -g @railway/cli

# Login and create project
railway login
railway init
```

#### 2. Add Database Services

```bash
# Add PostgreSQL
railway add -t postgresql

# Add Redis
railway add -t redis
```

#### 3. Configure Environment Variables

Set these in Railway dashboard or CLI:

```bash
# Required
railway variables set POSTGRES_PASSWORD="your-secure-password"
railway variables set REDIS_PASSWORD="your-secure-password"
railway variables set JWT_SECRET="your-jwt-secret-min-32-chars"

# Database connection (auto-provided by Railway)
# POSTGRES_HOST, POSTGRES_DB, POSTGRES_USER, POSTGRES_PORT
# REDIS_HOST, REDIS_PORT

# API URLs
railway variables set API_URL="https://api.yourdomain.com"
railway variables set WEB_URL="https://yourdomain.com"
```

#### 4. Deploy Server

```bash
cd kanew_server
railway up
```

#### 5. Build and Deploy Flutter Web

```bash
cd kanew_flutter
flutter build web --base-href /app/ --wasm

# Deploy to Railway static service or any static host
# Option A: Deploy as separate Railway service
railway init  # Select "Static" service
cp -r build/web/* <static-service-directory>/

# Option B: Deploy to Firebase Hosting
firebase init hosting
firebase deploy

# Option C: Deploy to Vercel
vercel --prod
```

#### 6. Configure Custom Domains

```bash
railway domain add api.yourdomain.com
railway domain add yourdomain.com
```

Update DNS records to point to Railway's provided IPs.

---

### Option 2: Docker Deployment

Build and run the server as a Docker container:

```bash
cd kanew_server

# Build image
docker build -t kanew-server .

# Run with environment variables
docker run -d \
  --name kanew-server \
  -p 8080:8080 \
  -p 8081:8081 \
  -p 8082:8082 \
  -e runmode=production \
  -e POSTGRES_HOST=your-db-host \
  -e POSTGRES_PASSWORD=your-password \
  -e REDIS_HOST=your-redis-host \
  -e JWT_SECRET=your-secret \
  kanew-server
```

#### Docker Compose Production Setup

```yaml
# docker-compose.prod.yml
services:
  postgres:
    image: pgvector/pgvector:pg16
    environment:
      POSTGRES_USER: kanew
      POSTGRES_DB: kanew
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U kanew"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:6.2.6
    command: redis-server --requirepass ${REDIS_PASSWORD}
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

  server:
    build: ./kanew_server
    ports:
      - "8080:8080"
      - "8081:8081"
      - "8082:8082"
    environment:
      - runmode=production
      - POSTGRES_HOST=postgres
      - REDIS_HOST=redis
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
      - REDIS_PASSWORD=${REDIS_PASSWORD}
      - JWT_SECRET=${JWT_SECRET}
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy

volumes:
  postgres_data:
```

Deploy:

```bash
docker compose -f docker-compose.prod.yml up -d
```

---

### Option 3: Manual Server Deployment

For VPS or bare-metal servers (Ubuntu 22.04+):

#### 1. Install Dependencies

```bash
# Install Dart
wget https://storage.googleapis.com/dart-archive/channels/stable/release/3.8.0/linux_packages/dart_3.8.0-1_amd64.deb
sudo dpkg -i dart_3.8.0-1_amd64.deb

# Install PostgreSQL
sudo apt install postgresql postgresql-contrib

# Install Redis
sudo apt install redis-server

# Install Nginx (for reverse proxy)
sudo apt install nginx
```

#### 2. Configure PostgreSQL

```bash
sudo -u postgres psql

CREATE USER kanew WITH PASSWORD 'your-password';
CREATE DATABASE kanew OWNER kanew;
GRANT ALL PRIVILEGES ON DATABASE kanew TO kanew;
\q
```

#### 3. Configure Redis

Edit `/etc/redis/redis.conf`:

```
requirepass your-redis-password
bind 127.0.0.1
```

#### 4. Deploy Server

```bash
# Clone and build
git clone https://github.com/yourusername/kanew.git
cd kanew/kanew_server
dart pub get
dart compile exe bin/main.dart -o bin/server

# Setup config
cp config/production.yaml.example config/production.yaml
# Edit config/production.yaml with your settings

# Create systemd service
sudo nano /etc/systemd/system/kanew.service
```

```ini
[Unit]
Description=Kanew Server
After=network.target postgresql.service redis-server.service

[Service]
Type=simple
User=www-data
Group=www-data
WorkingDirectory=/opt/kanew
ExecStart=/opt/kanew/bin/server --mode=production
Restart=always
Environment=JWT_SECRET=your-jwt-secret

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl enable kanew
sudo systemctl start kanew
```

#### 5. Configure Nginx

```nginx
server {
    listen 80;
    server_name api.yourdomain.com;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}

server {
    listen 80;
    server_name yourdomain.com;

    # Serve Flutter web build
    root /var/www/kanew;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

---

## Building Flutter Web

The Flutter web app can be deployed separately from the server:

```bash
cd kanew_flutter

# Debug build
flutter build web

# Production build with webAssembly
flutter build web --base-href /app/ --wasm

# Output is in build/web/
```

### Flutter Web Configuration

Update `kanew_flutter/assets/config.json` for production:

```json
{
    "apiUrl": "https://api.yourdomain.com",
    "webUrl": "https://yourdomain.com"
}
```

Or set via environment at build time:

```bash
flutter build web \
  --base-href /app/ \
  --wasm \
  --dart-define=SERVER_URL="https://api.yourdomain.com" \
  --dart-define=WEB_URL="https://yourdomain.com"
```

---

## Database Migrations

When models change, generate and apply migrations:

```bash
# Generate migration (on model changes)
cd kanew_server
serverpod generate

# Apply migrations (auto in dev, manual in prod)
dart bin/main.dart --apply-migrations
```

---

## CI/CD with GitHub Actions

Example workflow for Railway deployment:

```yaml
# .github/workflows/deploy.yml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: dart-lang/setup-dart@v1

      - name: Install Railway CLI
        run: npm install -g @railway/cli

      - name: Generate Serverpod code
        run: |
          cd kanew_server
          dart pub get
          serverpod generate

      - name: Deploy to Railway
        run: railway up
        env:
          RAILWAY_TOKEN: ${{ secrets.RAILWAY_TOKEN }}
          RAILWAY_PROJECT_ID: ${{ secrets.RAILWAY_PROJECT_ID }}
```

---

## Environment Variables Reference

### Server

| Variable | Description | Required |
|----------|-------------|----------|
| `POSTGRES_HOST` | PostgreSQL hostname | Yes |
| `POSTGRES_PORT` | PostgreSQL port (default: 5432) | No |
| `POSTGRES_DB` | Database name | Yes |
| `POSTGRES_USER` | Database user | Yes |
| `POSTGRES_PASSWORD` | Database password | Yes |
| `REDIS_HOST` | Redis hostname | Yes |
| `REDIS_PORT` | Redis port (default: 6379) | No |
| `REDIS_PASSWORD` | Redis password | Yes |
| `JWT_SECRET` | Secret key for JWT tokens (min 32 chars) | Yes |
| `runmode` | Run mode: development/staging/production | No |
| `serverid` | Server identifier | No |

### Flutter Client

| Variable | Description | Required |
|----------|-------------|----------|
| `SERVER_URL` | Backend API URL | No (falls back to config.json) |
| `WEB_URL` | Web app URL | No (falls back to config.json) |

---

## Troubleshooting

### Redis Connection Issues

Ensure Redis is running and password is correct:

```bash
redis-cli ping
# Should return PONG
```

### Database Connection Issues

Check PostgreSQL connection:

```bash
psql -h localhost -U kanew -d kanew
```

### Migration Errors

Reset migrations in development (do NOT in production):

```bash
# Drop and recreate database
psql -U postgres -c "DROP DATABASE kanew"
psql -U postgres -c "CREATE DATABASE kanew"
dart bin/main.dart --apply-migrations
```

---

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feat/my-feature`
3. Make your changes following the architecture in `AGENTS.md`
4. Run tests: `flutter test`
5. Lint: `flutter analyze`
6. Submit a pull request

---

## License

MIT License - feel free to use this project for personal or commercial purposes.

---

## Support

For issues and questions, please open a GitHub issue.
