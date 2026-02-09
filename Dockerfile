# Build stage
FROM dart:3.10.8 AS build
WORKDIR /app
COPY kanew_server/ .

# Install dependencies
RUN dart pub get

# Compile the server executable
RUN dart compile exe bin/main.dart -o bin/server

# Final stage - use Alpine for smaller image size
FROM alpine:latest

# Install runtime dependencies for Dart AOT-compiled binaries
# libc6-compat is required for Dart executables on Alpine
RUN apk add --no-cache libc6-compat ca-certificates

# Environment variables
ENV runmode=production
ENV serverid=default
ENV logging=normal
ENV role=monolith

WORKDIR /app

# Copy compiled server executable
COPY --from=build /app/bin/server .

# Copy configuration files and resources
COPY --from=build /app/config/ config/
COPY --from=build /app/web/ web/
COPY --from=build /app/migrations/ migrations/
COPY --from=build /app/lib/src/generated/protocol.yaml lib/src/generated/protocol.yaml

# Copy and configure startup script
COPY kanew_server/start.sh ./start.sh
RUN chmod +x ./start.sh && sed -i 's/\r$//' ./start.sh

# Expose ports
EXPOSE 8080
EXPOSE 8081
EXPOSE 8082

# Start server using the generated startup script
CMD ["./start.sh"]
