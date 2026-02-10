# Use Flutter image to build
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# Copy only pubspecs first to improve Docker layer caching.
# Context must be repo ROOT because we depend on the local package `kanew_client`.
COPY kanew_client/pubspec.yaml kanew_client/pubspec.yaml
COPY kanew_flutter/pubspec.yaml kanew_flutter/pubspec.yaml

WORKDIR /app/kanew_flutter
RUN flutter pub get

# Copy only the required source (avoid sending/building the whole monorepo).
WORKDIR /app
COPY kanew_client/ kanew_client/
COPY kanew_flutter/ kanew_flutter/

# Build the Flutter Web app
WORKDIR /app/kanew_flutter
RUN flutter build web --release --wasm

# Serve with lightweight Python server
FROM python:3-alpine

WORKDIR /app
COPY --from=build /app/kanew_flutter/build/web .
COPY kanew_flutter/server.py ./server.py

CMD ["sh", "-c", "API_URL=\"$API_BASE_URL\"; if [ -n \"$API_URL\" ]; then case \"$API_URL\" in */) ;; *) API_URL=\"$API_URL/\";; esac; mkdir -p assets/assets; printf '{\\n  \"apiUrl\": \"%s\"\\n}\\n' \"$API_URL\" > assets/assets/config.json; fi; python3 server.py"]
