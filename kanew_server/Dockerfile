# Build stage
FROM dart:3.10.8 AS build
WORKDIR /app
COPY . .

# Install dependencies and compile the server executable
RUN dart pub get
RUN dart compile exe bin/main.dart -o bin/server

# Final stage
FROM alpine:latest

# Environment variables
ENV runmode=production
ENV serverid=default
ENV logging=normal
ENV role=monolith

# Install runtime dependencies for Dart AOT-compiled binaries on Alpine
RUN apk add --no-cache libc6-compat ca-certificates

# Copy compiled server executable
COPY --from=build /app/bin/server server

# Copy configuration files and resources
COPY --from=build /app/config/ config/
COPY --from=build /app/web/ web/
COPY --from=build /app/migrations/ migrations/

# This file is required to enable the endpoint log filter in Insights.
COPY --from=build /app/lib/src/generated/protocol.yaml lib/src/generated/protocol.yaml

# Expose ports
EXPOSE 8080
EXPOSE 8081
EXPOSE 8082

# Startup script (applies migrations, then runs server)
COPY start.sh ./start.sh
RUN chmod +x ./start.sh && sed -i 's/\r$//' ./start.sh

CMD ["./start.sh"]
