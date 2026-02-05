# kanew_server

This is the starting point for your Serverpod server.

To run your server, you first need to start Postgres and Redis. It's easiest to do with Docker.

    docker compose up --build --detach

Then you can start the Serverpod server.

    dart bin/main.dart

When you are finished, you can shut down Serverpod with `Ctrl-C`, then stop Postgres and Redis.

    docker compose stop

## Realtime Board Sync

For realtime board updates to work, ensure Redis is enabled in `config/development.yaml`:

```yaml
redis:
  enabled: true
  host: localhost
  port: 8091
```

Make sure Redis is running (via Docker Compose) for the realtime features to broadcast events between connected clients.
