# Use Flutter image to build
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# Copy the entire project to allow access to local dependencies (kanew_client)
# Context must be project ROOT
COPY . .

# Build the Flutter Web app
WORKDIR /app/kanew_flutter
RUN flutter pub get
RUN flutter build web --release

# Serve with lightweight Python server
FROM python:3-alpine

WORKDIR /app
COPY --from=build /app/kanew_flutter/build/web .

CMD ["sh", "-c", "API_URL=\"$API_BASE_URL\"; if [ -n \"$API_URL\" ]; then case \"$API_URL\" in */) ;; *) API_URL=\"$API_URL/\";; esac; mkdir -p assets/assets; printf '{\\n  \"apiUrl\": \"%s\"\\n}\\n' \"$API_URL\" > assets/assets/config.json; fi; PORT=\"${PORT:-8080}\"; python3 -m http.server \"$PORT\""]
